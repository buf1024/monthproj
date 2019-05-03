import React, { Component } from 'react'
import {
  View,
  Text,
  Modal,
  TouchableOpacity,
  Dimensions
} from 'react-native'

import { RectButton } from 'react-native-gesture-handler'

const {width, height} = Dimensions.get('window')

class DiaryView extends Component {

  constructor (props) {
    super(props)
    this.state = {
      visible: true,
    }
  }

  onClose () {
    console.log('onClose')
    this.setState({visible: false})
  }
  onDismiss () {
    console.log('onDismiss')
  }
  render () {
    return (
      <Modal
        visible={this.state.visible}
        transparent={true}
        onDismiss={() => this.onDismiss()}
        animationType={'fade'}
      >
        {
          this.state.visible? <View style={{
            width: width,
            height: height,
            backgroundColor: 'rgba(14, 14, 14, 0.4)',
          }}/> : <View />
        }

        <View style={{
          width: width - 60,
          height: height - 60,
          margin: 30,
          borderRadius: 20,
          backgroundColor: '#fff',
          position: 'absolute',
          overflow: 'hidden',
          top: 0,
          left: 0,
          justifyContent: 'center',
          alignItems: 'center'
        }}>
          <TouchableOpacity
            style={{
              width: 100,
              height: 60,
              borderRadius: 5,
              backgroundColor: '#FE6667',
              marginVertical: 20,
            }}
            onPress={() => this.onClose()}
          >
            <Text style={{
              color: '#fff',
              textAlign: 'center'
            }}>TouchableOpacity Close</Text>
          </TouchableOpacity>
          <RectButton
            style={{
              width: 100,
              height: 60,
              borderRadius: 5,
              backgroundColor: '#FE6667',
            }}
            onPress={() => this.onClose()}
          >
            <Text style={{
              textAlign: 'center',
              color: '#fff'
            }}>RectButton Close</Text>
          </RectButton>
        </View>
      </Modal>
    )
  }
}

export default DiaryView
