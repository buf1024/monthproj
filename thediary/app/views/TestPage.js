import React, { Component } from 'react'
import {
  View
} from 'react-native'

import {RectButton} from 'react-native-gesture-handler'
import Header from '../components/Header'
import DiaryCard from '../components/DiaryCard'
import Footer from '../components/Footer'
import DiaryView from '../components/DiaryView'
import DiaryCal from '../components/DiaryCal'
import ModalTest from '../components/ModalTest'

export default class TestPage extends Component{

  constructor (props) {
    super(props)
  }

  render () {
    return (
      <View style={{
        flex: 1
      }}>
        {/*<Header />*/}
        {/*<DiaryCard />*/}
        {/*<Footer />*/}
        {/*<DiaryView diary={{}} onClose={() => console.log('on dialog close')}/>*/}
        {/*<DiaryCal />*/}
        <ModalTest />
      </View>
    )
  }
}
