import React, { Component } from 'react'
import { connect } from 'react-redux'
import { AppState } from 'react-native'
import {
  createStackNavigator,
  createAppContainer,
  NavigationActions,
} from 'react-navigation'

import AboutPage from './views/AboutPage'
import AnimatedPage from './views/AnimatedPage'
import ProtectPage from './views/ProtectPage'
import MinePage from './views/MinePage'
import HomePage from './views/HomePage'
import DiaryPage from './views/DiaryPage'
import SettingPage from './views/SettingPage'
import MainPage from './views/MainPage'
import DiaryEditPage from './views/DiaryEditPage'
import TestPage from './views/TestPage'
import * as appAct from './store/actions'

const Router = createStackNavigator({
  AboutPage: {screen: AboutPage},
  AnimatedPage: {screen: AnimatedPage},
  ProtectPage: {screen: ProtectPage},
  MinePage: {screen: MinePage},
  SettingPage: {screen: SettingPage},
  MainPage: {screen: MainPage},
  HomePage: {screen: HomePage},
  DiaryPage: {screen: DiaryPage},
  DiaryEditPage: {screen: DiaryEditPage},
  TestPage: {screen: TestPage},
}, {
  initialRouteKey: 'HomePage',
  initialRouteName: 'HomePage',
  navigationOptions: {
//    header: null,
    gesturesEnabled: true,
  },
  headerMode: 'float',
  headerTransitionPreset: 'fade-in-place',
})

class Navigator extends Component {
  static router = {
    ...Router.router,
    getStateForAction: (action, lastState) => {
      if (action.type === 'Navigation/BACK') {
        console.log('back')
        const route = lastState.routes[lastState.index]
        if (route.key === 'ProtectPage' &&
          route.params !== undefined &&
          route.params.type === 'protect' && !route.params.verify) {
          console.log('prevent back')
          return {...lastState}
        }
      }
      return Router.router.getStateForAction(action, lastState)
    },
  }
  constructor (props) {
    super(props)

    this.state = {
      appState: AppState.currentState
    }
  }

  onAppStateChange (nextAppState) {
    if (this.state.appState.match(/inactive|background/) && nextAppState === 'active') {
      if (!this.props.isCameraOn && this.props.protect !== undefined && this.props.protect !== '') {
        const protectAction = NavigationActions.navigate({
          routeName: 'ProtectPage',
          key: 'ProtectPage',
          params: {type: 'protect'}
        })
        this.props.navigation.dispatch(protectAction)
      }
      this.props.updateInfo({isCameraOn: false})
    }
    this.setState({appState: nextAppState});
  }
  componentDidMount () {
    AppState.addEventListener('change', (nextAppState) => this.onAppStateChange(nextAppState))
  }
  componentWillUnmount() {
    AppState.removeEventListener('change', (nextAppState) => this.onAppStateChange(nextAppState));
  }
  render() {
    return (
        <Router {...this.props} />
    )
  }
}
const mapStateToProps = (state) => {
  return {
    isCameraOn: state.app.isCameraOn,
    protect: state.app.setting.protect
  }
}

//export default createAppContainer(connect(mapStateToProps)(Navigator))

export default createAppContainer(connect(mapStateToProps, {
  updateInfo: appAct.updateInfo
})(Navigator))
