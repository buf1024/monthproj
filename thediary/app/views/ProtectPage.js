import React, { Component } from 'react'
import {
  View,
  Text,
} from 'react-native'
import { RectButton } from 'react-native-gesture-handler'
import MaterialCommunityIcon
  from 'react-native-vector-icons/MaterialCommunityIcons'
import MaterialIcon from 'react-native-vector-icons/MaterialIcons'
import * as appAct from '../store/actions'
import * as dbAct from '../store/db'
import { connect } from 'react-redux'
import { NavigationActions } from 'react-navigation'

const PASS_NUM = 4

class ProtectPage extends Component {
  static navigationOptions = ({navigation}) => {
    return {
      header: null,
    }
  }

  constructor (props) {
    super(props)

    this.state = {
      input: [],
      confirm: [],
      isConfirm: false,
      feed: [false, false, false, false],
      tips: '',
    }

  }
  updateSetting (setting) {
    dbAct.updateSetting(setting)
    this.props.updateSetting(setting)
  }

  onDone (type, input, confirm) {
    input = input.join('')
    confirm = confirm.join('')
    if (type !== 'reset') {
      console.log('this.props: %o', this.props)
      if (input !== this.props.setting.protect) {
        return '密码不正确'
      }
      this.props.navigation.setParams({type, verify: true})
      this.props.navigation.dispatch(NavigationActions.back({}))
    } else {
      if (input !== confirm) {
        return '密码不一致'
      }
      this.props.setting.protect = input
      this.updateSetting(this.props.setting)
      this.props.navigation.dispatch(NavigationActions.back())
    }
    return ''
  }

  onDel () {
    let {input, confirm, feed} = this.state
    if (this.state.isConfirm) {
      if (confirm.length > 0) {
        confirm.splice(confirm.length - 1, 1)
        feed[confirm.length] = false
      }
    }
    else {
      if (input.length > 0) {
        input.splice(input.length - 1, 1)
        feed[input.length] = false
      }
    }
    this.setState({input, confirm, feed})
  }

  getDot (index) {
    return (
      <View key={index} style={{
        height: 14,
        width: 14,
        borderRadius: 7,
        backgroundColor: '#757575',
        marginHorizontal: 3,
      }}/>
    )
  }

  getUnderscore (index) {
    return (
      <View key={index} style={{
        height: 20,
        width: 20,
        borderBottomWidth: 2,
        borderColor: '#eee',
        marginHorizontal: 3,
      }}/>
    )
  }

  getRow (row) {
    let numbers = Array.from(new Array(3), (val, index) => index + 1 + row * 3)
    return (
      <View style={{
        flexDirection: 'row',
        justifyContent: 'center',
        flexWrap: 'wrap',
      }}>
        {
          numbers.map(val => {
            return (
              <View key={val + row} style={{
                margin: 10,
                borderWidth: 1,
                borderColor: '#eee',
                width: 70,
                height: 70,
                borderRadius: 50,
                overflow: 'hidden',
              }}>
                <RectButton style={{
                  width: 70,
                  height: 70,
                }}
                            onPress={() => this.onPressNumber(val)}
                >
                  <Text style={{
                    width: 70,
                    height: 70,
                    lineHeight: 70,
                    textAlign: 'center',
                    fontSize: 28,
                  }}>{val}</Text>
                </RectButton>
              </View>
            )
          })
        }
      </View>
    )
  }

  getInputFeed () {
    return (<View style={{
      flexDirection: 'row',
      marginTop: 120,
      marginBottom: 60,
    }}>
      {
        this.state.feed.map((isSet, index) => {
          return isSet ? this.getDot(index) : this.getUnderscore(index)
        })
      }
    </View>)
  }

  onPressNumber (number) {
    let {input, confirm, feed, isConfirm, tips} = this.state
    let type = this.props.navigation.getParam('type', 'reset')

    if (input.length < PASS_NUM) {
      tips = ''
      input.push(number)
      feed[input.length - 1] = true
      if (input.length >= PASS_NUM) {
        feed = [false, false, false, false]
        isConfirm = true
        if (type !== 'reset') {
          tips = this.onDone(type, input, confirm)
          input = []
        }
        else {
          tips = '请重新输入密码'
        }
      }
    }
    else {
      if (confirm.length < PASS_NUM) {
        tips = ''
        confirm.push(number)
        feed[confirm.length - 1] = true
        if (confirm.length >= PASS_NUM) {
          tips = this.onDone(type, input, confirm)
          feed = [false, false, false, false]
          isConfirm = false
          input = []
          confirm = []
        }
      }
    }
    this.setState({input, confirm, feed, isConfirm, tips})
  }

  render () {
    const type = this.props.navigation.getParam('type', 'reset')
    console.log('type: ' + type)
    return (
      <View style={{
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, 0.1)',
      }}>
        <View style={{
          flexDirection: 'row',
          backgroundColor: '#FE6667',
          height: 50,
        }}>
          {
            type === 'reset' ? (
              <View style={{
                height: 50,
                marginHorizontal: 5,
                justifyContent: 'center',
              }}>
                <RectButton
                  onPress={() => this.props.navigation.goBack()}
                >
                  <MaterialIcon
                    name="arrow-back"
                    style={{
                      fontSize: 25,
                      textAlign: 'center',
                      color: '#fff',
                    }}
                  />
                </RectButton>
              </View>
            ) : <View />
          }
          <View style={{
            flex: 1,
            height: 50,
            justifyContent: 'center',
            alignItems: 'center',
            width: global.width,
            position: 'absolute',
            top: 0,
            left: 0,
          }}>
            <Text style={{
              color: '#fff',
              textAlign: 'center',
//              fontWeight: 'bold',
              fontSize: 15,
            }}>密码保护</Text>
          </View>
        </View>
        <View style={{
          flex: 1,
          alignItems: 'center',
          backgroundColor: '#fff',
        }}>
          {this.getInputFeed()}
          {this.getRow(0)}
          {this.getRow(1)}
          {this.getRow(2)}
          <RectButton style={{
            marginVertical: 30,
          }}
                      onPress={() => this.onDel()}
          >
            <MaterialCommunityIcon
              name="backspace-outline"
              style={{
                height: 40,
                width: 40,
                fontSize: 30,
                textAlign: 'center',
                color: '#757575',
              }}/>
          </RectButton>
          <View style={{
            justifyContent: 'center',
          }}>
            <Text style={{
              color: '#e66',
            }}>{this.state.tips}</Text>
          </View>
        </View>
      </View>
    )
  }
}
const mapStateToProps = (state) => {
  return {
    setting: state.app.setting,
  }
}

export default connect(mapStateToProps, {
  updateSetting: appAct.updateSetting,
})(ProtectPage)
