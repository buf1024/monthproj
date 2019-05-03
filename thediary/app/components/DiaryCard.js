import React, { Component } from 'react'
import {
  View,
  Text,
  Animated
} from 'react-native'
import PropTypes from 'prop-types'
import { RectButton } from 'react-native-gesture-handler'
import Swipeable from 'react-native-gesture-handler/Swipeable'
import MaterialIcon from 'react-native-vector-icons/MaterialIcons'
import EntypoIcon from 'react-native-vector-icons/Entypo'
import moment from 'moment'
import * as util from '../utils'

const AnimatedIcon = Animated.createAnimatedComponent(MaterialIcon)

class SwipeableRow extends Component {

  constructor (props) {
    super(props)
    this._swipeable = null
  }
  onSwipeLeftAction (progress, dragX) {
    const scale = dragX.interpolate({
      inputRange: [0, 80],
      outputRange: [0, 1],
      extrapolate: 'clamp',
    })

    return (
      <RectButton style={{
        flex: 1,
        backgroundColor: '#497AFC'
      }}>
        <AnimatedIcon
          name={"delete-forever"}
          size={30}
          color={'#fff'}
          style={{
            width: 30,
            marginHorizontal: 10,
            transform: [{scale}]
          }}
        >
        </AnimatedIcon>
      </RectButton>
    )
  }
  onPress(type) {
    this.onClose()
    this.props.onClick(type, this.props.diary)
  }

  renderRightAction = (type, icon, color, x, progress, dragX) => {
    const trans = progress.interpolate({
      inputRange: [0, 1],
      outputRange: [x, 0],
      extrapolate: 'clamp',
    });
    const scale = dragX.interpolate({
      inputRange: [-80, 0],
      outputRange: [1, 0],
      extrapolate: 'clamp',
    })

    return (
      <Animated.View style={{
        flex: 1,
        justifyContent: 'center',
        transform: [{ translateX: trans }] }}>
        <RectButton
          style={{
            height: 90,
            backgroundColor: color,
            justifyContent: 'center',
          }}
          onPress={() => this.onPress(type)}>
          <AnimatedIcon
            name={icon}
            style={{
              width: 45,
              height: 45,
              fontSize: 25,
              textAlign: 'center',
              color: '#fff',
              transform: [{scale}]
            }}
          >
          </AnimatedIcon>
        </RectButton>
      </Animated.View>
    )
  }
  onSwipeRightAction (progress, dragX) {
    return (
      <View style={{
        width: 135,
        height: 90,
        flexDirection: 'row' }}>
        {this.renderRightAction('public', 'filter-vintage', '#C8C7CD', 135, progress, dragX)}
        {this.renderRightAction('flag', 'flag', '#ffab00', 90, progress, dragX)}
        {this.renderRightAction('delete', 'delete', '#dd2c00', 45, progress, dragX)}
      </View>    )
  }

  onClose () {
    if (this._swipeable != null) {
      this._swipeable.close()
    }
  }

  render () {
    return (
      <Swipeable
        {...this.props}
        ref={(ref) => this._swipeable = ref}
        friction={2}
        leftThreshold={30}
        rightThreshold={40}
        renderRightActions={(progress, dragX) => this.onSwipeRightAction(progress, dragX)}
      >
        {this.props.children}
      </Swipeable>
    )
  }
}

class DiaryCard extends Component{
  static propTypes = {
    diary: PropTypes.object,
    onClick: PropTypes.func,
  }
  constructor (props) {
    super(props)
  }
  onClick (type) {
    this.props.onClick(type, this.props.diary)
  }

  render () {
    let date = null
    if (this.props.diary) {
      date = moment(this.props.diary.createTime)
    }
    return (
      <View {...this.props} style={{
        margin: 10,
        borderRadius: 5,
        height: 90,
        overflow: 'hidden',
        borderWidth: 1,
        borderColor: 'red',
        backgroundColor: '#fff'
      }}>
        {
          this.props.diary ? (
            <SwipeableRow
              {...this.props}
            >
              <RectButton style={{
                height: 90,
                flexDirection: 'row',
                borderWidth: 1,
                borderColor: 'red',
              }}
                          onPress={() => this.onClick('click')}
              >
                <View style={{
                  width: 75,
                }}>
                  <Text style={{
                    width: 75,
                    fontSize: 30,
                    fontWeight: 'bold',
                    textAlign: 'center'
                  }}>{date.format('DD')}</Text>
                  <Text style={{
                    width: 75,
                    fontSize: 15,
                    textAlign: 'center'
                  }}>{util.getWeek(date)}</Text>
                  <Text style={{
                    width: 75,
                    fontSize: 10,
                    textAlign: 'center'
                  }}>{date.format('HH:mm:ss')}</Text>
                </View>
                <View style={{
                  flex: 1,
                  flexDirection: 'row'
                }}>
                  <View style={{
                    flex: 1
                  }}>
                    <Text numberOfLines={1}
                          style={{
                            margin: 5,
                            fontSize: 14,
                          }}>{this.props.diary.title}</Text>
                    <Text
                      numberOfLines={3}
                      style={{
                        margin: 5,
                        fontSize: 12,
                      }}>实地调研是相对于案头调研而言的，是对在实地进行市场调研活动的统称。在一些情况下，案头调研无法满足调研目的，收集资料不够及时准确时，就需要适时地进行实地调研来解决问题，取得第一手的资料和情报，使调研工作有效顺利地开展。所谓实地调研，就是指对第一手资料的调查活动。</Text>
                  </View>
                  <View style={{
                    marginVertical: 5,
                    marginHorizontal: 3,
                    width: 60,
                    flexDirection: 'row',
                  }}>
                    <MaterialIcon name="lock-outline"
                                  size={15}
                                  color={'#000'}
                                  style={{
                                    width: 20,
                                  }} />
                    <EntypoIcon name="cloud"
                                size={15}
                                color={'#000'}
                                style={{
                                  width: 20,
                                }} />
                    <EntypoIcon name="emoji-happy"
                                size={15}
                                color={'#000'}
                                style={{
                                  width: 20,
                                }} />
                  </View>
                </View>
              </RectButton>
            </SwipeableRow>
          ) : (<View style={{
            flex: 1,
            justifyContent: 'center',
            alignItems: 'center'
          }}>
            <Text style={{
              fontSize: 25
            }}>无日记记录</Text>
          </View>)
        }
      </View>
    )
  }
}

export default DiaryCard
