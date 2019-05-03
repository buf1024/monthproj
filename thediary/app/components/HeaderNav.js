import React, { Component } from 'react'
import {
  View,
  Text,
  Animated,
} from 'react-native'
import {
  RectButton,
} from 'react-native-gesture-handler'
import PropTypes from 'prop-types'
import {withNavigation} from 'react-navigation'

class Header extends Component {
  static propTypes = {
    select: PropTypes.string.isRequired,
    onChange: PropTypes.func,
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

  onPress (select) {
    if (this.props.select !== select) {
      console.log('nv:%o', {routeName: select, key: select})
      this.props.navigation.navigate({routeName: select, key: select})
    }
  }

  getButton (key, value) {
    return (<RectButton
      style={{
        width: 100,
        height: 28,
        backgroundColor: this.props.select === key ? '#FE6667' : '#eee',
      }}
      onPress={() => this.onPress(key)}
    >
      <Text style={{
        width: 90,
        height: 28,
        lineHeight: 28,
        textAlign: 'center',
      }}>{value}</Text>
    </RectButton>)
  }

  render () {
    return (
      <View style={{
        height: 70,
        width: global.width,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#ccc',
        overflow: 'hidden',
        zIndex: 0,
      }}>
        <View style={{
          flexDirection: 'row',
          justifyContent: 'center',
          alignItems: 'center',
          borderWidth: 1,
          borderColor: 'red',
          borderRadius: 5,
          overflow: 'hidden',
//          transform: [
//            {
//              scale,
//            }],
        }}>
          {this.getButton('HomePage', '浏览')}
          <View style={{
            borderLeftWidth: 1,
            borderLeftColor: 'red',
            borderRightWidth: 1,
            borderRightColor: 'red',
          }}>
            {this.getButton('DiaryPage', '日记')}
          </View>
          {this.getButton('MinePage', '我')}
        </View>
      </View>
    )
  }
}

export default withNavigation(Header)
