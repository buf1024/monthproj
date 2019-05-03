import React, { Component } from 'react'
import {
  View,
  Text,
  Dimensions,
  Animated,
} from 'react-native'
import {
  RectButton,
} from 'react-native-gesture-handler'
import PropTypes from 'prop-types'
import MaterialIcon from 'react-native-vector-icons/MaterialIcons'

class Footer extends Component {
  static propTypes = {
    count: PropTypes.number.isRequired,
    onAddDiary: PropTypes.func
  }
  constructor (props) {
    super(props)
    this.state = {
      _spring: new Animated.Value(0),
    }
  }

  componentDidMount () {
    this.state._spring.setValue(0)
    Animated.spring(this.state._spring, {
      toValue: 1,
      friction: 15,
      tension: 30,
    }).start()
  }

  render () {
    const scale = this.state._spring
    return (
      <View style={{
        height: 80,
        width: global.width,
        backgroundColor: '#fff',
        justifyContent: 'space-between',
//        overflow: 'hidden',
//        transform: [
//          {
//            scale,
//          }],
      }}>
        <View style={{
          flexDirection: 'row',
          justifyContent: 'space-between',
          height: 80,
          padding: 10,
        }}
        >
          <View style={{
            flexDirection: 'row',
            justifyContent: 'flex-start',
            height: 80,
          }}>
            <RectButton>
              <MaterialIcon
                name="location-off"
                style={{
                  height: 25,
                  width: 25,
                  fontSize: 25,
                  textAlign: 'center',
                  color: 'red',
                }}
              />
            </RectButton>
            <Text>无信息</Text>
            <MaterialIcon
              name="wb-sunny"
              style={{
                height: 25,
                width: 25,
                fontSize: 25,
                textAlign: 'center',
                color: 'red',
              }}
            />
          </View>
            <Text style={{
              textAlign: 'center'
            }}>{this.props.count} 篇</Text>
        </View>
        <View style={{
          height: 80,
          padding: 10,
          width: 25,
          position: 'absolute',
          top: 0,
          flexDirection: 'row',
          alignSelf: 'center',
        }}>
          <RectButton style={{
            flex: 1,
          }}>
            <MaterialIcon
              name="add-circle-outline"
              style={{
                height: 25,
                width: 25,
                fontSize: 25,
                textAlign: 'center',
                color: 'red',
              }}
            />
          </RectButton>
        </View>
      </View>
    )
  }
}

export default Footer
