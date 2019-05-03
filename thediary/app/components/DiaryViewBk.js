import React, { Component } from 'react'
import {
  View,
  Text,
  Dimensions,
  Animated,
  Modal,
  WebView,
  Easing,
} from 'react-native'
import PropTypes from 'prop-types'
import { RectButton } from 'react-native-gesture-handler'
import Swipeable from 'react-native-gesture-handler/Swipeable'
import MaterialIcon from 'react-native-vector-icons/MaterialIcons'
import EntypoIcon from 'react-native-vector-icons/Entypo'
import DiaryImage from './DiaryImage'
import DiaryText from './DiaryText'
import DiaryTodo from './DiaryTodo'

class DiaryView extends Component {
  static propTypes = {
    diary: PropTypes.object.isRequired,
    onClose: PropTypes.func.isRequired,
  }
  constructor (props) {
    super(props)
    this.state = {
      _time: new Animated.Value(0),
      mask: true,
      diary: {
        title: '世界是你的也是我的',
        create: '',
        lastEdit: '',
        content: [
          {
            type: 'text',
            content: '这是一个测试',
          }, {
            type: 'text',
            content: '这是一个测试2',
          }, {
            type: 'todo',
            status: 'ongoing',
            content: '进行中的todo',
          }, {
            type: 'todo',
            status: 'done',
            content: '这是一个完成的todo',
          }, {
            type: 'image',
            height: 2960,
            width: 1440,
            format: 'png',
            uri: "content://media/external/images/media/36",
            content: 'uri',
          }, {
            type: 'text',
            content: '这是一个测试2END',
          }],
      },
      text: '这是一个测试2END这是一个测试2END这是一个测试2END这是一个测试2END',
      todo: {
        type: 'todo',
        status: 'done',
        content: '这是一个完成的todo这是一个完成的todo这是一个完成的todo这是一个完成的todo',
      }
    }
  }

  componentDidMount () {
    this.setState({mask: true})
    this.state._time.setValue(0)
//    Animated.timing(this.state._time, {
//      toValue: 1,
//      duration: 3000,
//      easing: Easing.in,
//    }).start()
    Animated.spring(this.state._time, {
      toValue: 1,
      friction: 15,
      tension: 30,
    }).start()
  }
  onClose () {
    this.setState({mask: false})
    this.state._time.setValue(1)
//    Animated.timing(this.state._time, {
//      toValue: 0,
//      duration: 500,
//      easing: Easing,
//    }).start(() => this.props.onClose())
    Animated.spring(this.state._time, {
      toValue: 0,
      friction: 15,
      tension: 30,
    }).start(() => this.props.onClose())
  }
  render () {
    const top = this.state._time.interpolate({
      inputRange: [0, 1],
      outputRange: [(global.height - 60) / 2, 0],
    })
    const left = this.state._time.interpolate({
      inputRange: [0, 1],
      outputRange: [(global.width - 60) / 2, 0],
    })
    const vWidth = this.state._time.interpolate({
      inputRange: [0, 1],
      outputRange: [30, global.width - 60],
    })
    const vHeight = this.state._time.interpolate({
      inputRange: [0, 1],
      outputRange: [30, global.height - 60],
    })
    const opacity = this.state._time.interpolate({
      inputRange: [0, 0.2, 1],
      outputRange: [0, 0.8, 1],
    })
    return (
      <View style={{
        flex: 1,
        position: 'absolute',
        left: 0,
        top: 0,
        transform: [{
          translateY: -70,
        }],
        zIndex: 10000,
      }}>
        {
          this.state.mask? <View style={{
            width: global.width,
            height: global.height + 70,
            backgroundColor: 'rgba(14, 14, 14, 0.4)',
//          borderWidth: 1,
//          borderColor: 'blue',
          }}/> : <View />
        }

        <Animated.View style={{
          width: vWidth,
          height: vHeight,
          opacity,
          margin: 30,
          borderRadius: 20,
          backgroundColor: '#fff',
          position: 'absolute',
          overflow: 'hidden',
          top,
          left,
        }}>
          <View style={{
//            borderWidth: 1,
//            borderColor: 'red',
            backgroundColor: '#FE6667',
            height: 150,
          }}>
            <View style={{
              justifyContent: 'center',
              flexDirection: 'row',
            }}>
              <Text style={{
                height: 25,
                marginTop: 8,
                color: '#fff',
                fontSize: 15,
                textAlign: 'center',
              }}>2019年2月</Text>
              <RectButton
                style={{
                  marginVertical: 5,
                  marginHorizontal: 3,
                  height: 25,
                  width: 25,
                  position: 'absolute',
                  right: 0,
                  top: 0,
                }}
                onPress={() => this.onClose()}
              >
                <MaterialIcon
                  name="close"
                  style={{
                    height: 25,
                    width: 25,
                    fontSize: 20,
                    textAlign: 'center',
                    color: '#fff',
                  }}
                />
              </RectButton>
            </View>
            <View style={{
              flex: 1,
              justifyContent: 'center',
            }}>
              <Text style={{
                color: '#fff',
                fontSize: 55,
                textAlign: 'center',
              }}>30</Text>
              <Text style={{
                color: '#fff',
                fontSize: 15,
                textAlign: 'center',
              }}>星期三 11:40:11</Text>
            </View>
          </View>
          <View style={{
            flex: 1,
          }}>
            {/*<WebView*/}
            {/*originWhitelist={['*']}*/}
            {/*source={{html: '<h1>Hello world</h1>'}}*/}
            {/*/>*/}
            {/*<DiaryImage data={{*/}
            {/*type: 'image',*/}
            {/*format: 'png',*/}
            {/*uri: "content://media/external/images/media/36",*/}
            {/*content: 'uri',*/}
            {/*}}/>*/}
            <DiaryText
              text={this.state.text}
              editable={false}
              onChangeText={(text) => this.setState({text})}
            />
            <DiaryText
              text={this.state.text}
              editable={false}
              onChangeText={(text) => this.setState({text})}
            />
            <DiaryTodo
              todo={this.state.todo}
              editable={true}
              onChangeTodo={(todo) => this.setState({todo})}
            />
          </View>
          <View style={{
//            borderWidth: 1,
//            borderColor: 'red',
            backgroundColor: '#FE6667',
            height: 40,
            flexDirection: 'row',
            justifyContent: 'space-between',
            alignItems: 'center',
          }}>
            <View style={{
              flexDirection: 'row',
              marginLeft: 5,
            }}>
              <MaterialIcon
                name="location-off"
                style={{
                  padding: 3,
                  fontSize: 20,
                  textAlign: 'center',
                  color: '#fff',
                }}
              />
              <Text style={{
                padding: 3,
                color: '#fff',
              }}>无信息</Text>
              <MaterialIcon
                name="wb-sunny"
                style={{
                  padding: 3,
                  fontSize: 20,
                  textAlign: 'center',
                  color: '#fff',
                }}
              />
              <EntypoIcon
                name="emoji-happy"
                style={{
                  padding: 3,
                  fontSize: 20,
                  textAlign: 'center',
                  color: '#fff',
                }}
              />
            </View>
            <RectButton style={{
              marginRight: 5,
            }}>
              <EntypoIcon
                name="edit"
                style={{
                  padding: 3,
                  fontSize: 20,
                  textAlign: 'center',
                  color: '#fff',
                }}
              />
            </RectButton>
          </View>
        </Animated.View>
      </View>
    )
  }
}

export default DiaryView
