
import React, {Component} from 'react'
import { Provider } from 'react-redux'
import { Dimensions } from 'react-native'
import configureStore from './app/store/configureStore'
import Router from './app/Router'
import * as dbAct from './app/store/db'

const store = configureStore()
dbAct.opendb()

console.disableYellowBox = true

const window = Dimensions.get('window')
global.width = window.width
global.height = window.height

export default class App extends Component {
  constructor (props) {
    super(props)
  }
  render() {
    return (
      <Provider store={store}>
        <Router />
      </Provider>
    )
  }
}
