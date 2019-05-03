import React, { Component } from 'react'
import {
  View,
  Text,
  Dimensions,
  Animated,
  Modal,
  Easing,
  TouchableOpacity
} from 'react-native'
import PropTypes from 'prop-types'
import { RectButton, ScrollView } from 'react-native-gesture-handler'
import MaterialIcon from 'react-native-vector-icons/MaterialIcons'
import EntypoIcon from 'react-native-vector-icons/Entypo'
import DiaryImage from './DiaryImage'
import DiaryText from './DiaryText'
import DiaryTodo from './DiaryTodo'
import moment from 'moment'
import * as util from '../utils'


class DiaryView extends Component {
  static propTypes = {
    visible: PropTypes.bool.isRequired,
    diary: PropTypes.object.isRequired,
    onClose: PropTypes.func.isRequired,
    onEdit: PropTypes.func.isRequired,
  }
  constructor (props) {
    super(props)
    this.state = {
    }
  }
  getContent () {
    let content = this.props.diary.content
    if (content != null && content.length > 0) {
      return content.map(paragraph => {
        switch (paragraph.type) {
          case 'todo':
            return <DiaryTodo
              key={paragraph.id}
              todo={paragraph}
              editable={false}
            />
          case 'image':
            return <DiaryImage
              key={paragraph.id}
              image={paragraph}
              editable={false}
            />
          case 'text':
            return <DiaryText
              key={paragraph.id}
              text={paragraph}
              editable={false}
            />
        }
      })
    } else {
      return <View />
    }
  }
  onClose () {
    this.props.onClose()
  }
  onEdit () {
    this.props.onEdit(this.props.diary)
  }
  render () {
    const createTime = moment(this.props.diary.createTime)
    return (
      <Modal
        visible={this.props.visible}
        transparent={true}
        animationType={'slide'}
        onRequestClose={() => this.onClose()}
      >
        {
          this.props.visible? <View style={{
            width: global.width,
            height: global.height + 100, // ? 不解+100
            backgroundColor: 'rgba(14, 14, 14, 0.4)',
          }}/> : <View />
        }

        <View style={{
          width: global.width - 60,
          height: global.height - 60,
          margin: 30,
          borderRadius: 20,
          backgroundColor: '#fff',
          position: 'absolute',
          overflow: 'hidden',
          top: 0,
          left: 0,
        }}>
          <View style={{
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
              }}>{createTime.format('YYYY年MM月')}</Text>
              <TouchableOpacity
                activeOpacity={0.1}
                style={{
                  marginVertical: 5,
                  marginHorizontal: 5,
                  height: 30,
                  width: 30,
                  position: 'absolute',
                  right: 0,
                  top: 0,
                }}
                onPress={() => this.onClose()}
              >
              <MaterialIcon
                name="close"
                style={{
                  height: 30,
                  width: 30,
                  fontSize: 28,
                  textAlign: 'center',
                  color: '#fff',
                }}
              />
              </TouchableOpacity>
            </View>
            <View style={{
              flex: 1,
              justifyContent: 'center',
            }}>
              <Text style={{
                color: '#fff',
                fontSize: 55,
                textAlign: 'center',
              }}>{createTime.format('DD')}</Text>
              <Text style={{
                color: '#fff',
                fontSize: 15,
                textAlign: 'center',
              }}>{util.getWeek(createTime) + ' ' + createTime.format('HH:mm:ss')}</Text>
            </View>
          </View>
          <View style={{
            flex: 1,
          }}>
            <Text
              style={{
                marginHorizontal: 10,
                marginVertical: 3,
                fontSize: 20,
              }}
            >{this.props.diary.title}</Text>
            <ScrollView>
              {
                this.getContent()
              }
            </ScrollView>
          </View>
          <View style={{
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
            <TouchableOpacity style={{
              marginRight: 5,
            }}
                        onPress={() => this.onEdit()}
            >
              <EntypoIcon
                name="edit"
                style={{
                  padding: 3,
                  fontSize: 20,
                  textAlign: 'center',
                  color: '#fff',
                }}
              />
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    )
  }
}

export default DiaryView
