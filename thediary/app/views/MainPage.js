import React, { Component } from 'react'
import {
  View,
  Text,
  Dimensions,
  Animated,
  WebView,
  Easing,
} from 'react-native'
import { RectButton } from 'react-native-gesture-handler'
import MaterialCommunityIcon from 'react-native-vector-icons/MaterialCommunityIcons'

import Header from './../components/Header'
import HomePage from './HomePage'
import DiaryPage from './DiaryPage'
import MinePage from './MinePage'

class MainPage extends Component {

  constructor (props) {
    super(props)

    this.state = {
      page: 'HomePage'
    }


    this.pages = {
      HomePage: <HomePage  key={'HomePage'} />,
      DiaryPage: <DiaryPage key={'DiaryPage'} />,
      MinePage: <MinePage  key={'MinePage'} />
    }
  }
  onChangePage (page) {
    this.setState({page})
  }

  render () {
    return (
      <View style={{
        flex: 1,
      }}>
        <Header
          onChange={(page) => this.onChangePage(page)}
        />
        {
          this.pages[this.state.page]
        }
      </View>
    )
  }
}

export default MainPage

