import React, { Component } from 'react'
import { connect } from 'react-redux'
import {
  View,
  Text,
  Keyboard,
  TextInput,
  TouchableOpacity,
} from 'react-native'
import { ScrollView } from 'react-native-gesture-handler'
import { NavigationEvents } from 'react-navigation'
import MaterialIcon from 'react-native-vector-icons/MaterialIcons'
import FontAwesome5 from 'react-native-vector-icons/FontAwesome5'
import Popover from 'react-native-popover-view'
import * as util from '../utils'
import uuid from 'uuid/v1'
import DiaryImage from './../components/DiaryImage'
import DiaryText from './../components/DiaryText'
import DiaryTodo from './../components/DiaryTodo'
import ImagePicker from 'react-native-image-picker'
import moment from 'moment'
import * as appAct from '../store/actions'
import * as dbAct from '../store/db'
import merge from 'lodash/merge'

class DiaryEditPage extends Component {

  static navigationOptions = {
    header: null,
  }

  constructor (props) {
    super(props)

    this.state = {
      isModified: false,
      diary: {content: [{id: uuid(), type: 'text', content: ''}]},
      keyboard: 'hide',
      focusIndex: -1,
      showWeather: false,
      showEmoji: false,
    }
  }

  onSave () {
    if (this.state.isModified) {
      let diary = merge({}, this.state.diary)
      diary.content.forEach(d => {
        if (d._ref !== undefined) {
          delete d['_ref']
        }
      })
      dbAct.updateDiary(diary)
      this.setState({isModified: false})
    }
  }
  insertItem(paragraph) {

//    console.log('state: %o', this.state)

    let {content} = this.state.diary
    let focusIndex = this.state.focusIndex
    console.log('done insertItem')

    if (focusIndex === -1) {
      focusIndex = content.length - 1
    }
    let focusParagraph = content[focusIndex]
    if (focusParagraph.type === 'text' && focusParagraph.content === '') {
      content.splice(focusIndex, 1, paragraph)
    } else {
      content.splice(focusIndex + 1, 0, paragraph)
    }
    console.log('done insertItem')
    this.insertTail()
  }
  insertTail() {
    let {content} = this.state.diary
    let paragraph = content[content.length -1]
    if (paragraph.type !== 'text') {
      content.push({id: uuid(), type: 'text', content: ''})
    }
  }
  onAddTodo() {
    let meta = {status: 'ongoing'}
    let paragraph = {id: uuid(), type: 'todo', content: '', meta: JSON.stringify(meta)}
    this.insertItem(paragraph)
    this.setState({isModified: true, diary: this.state.diary, focusIndex: -1})
  }
  onAddImg () {
    const options = {
      title: '请选择图片',
      cancelButtonTitle: 'push取消',
      takePhotoButtonTitle: '拍照',
      chooseFromLibraryButtonTitle: '从相册选择',
      storageOptions: {
        skipBackup: true,
        path: 'images',
      },
    }

    /**
     * The first arg is the options object for customization (it can also be null or omitted for default options),
     * The second arg is the callback which sends object: response (more info in the API Reference)
     */
    console.log('adding image')
    ImagePicker.showImagePicker(options, (response) => {
      console.log('done image')
      this.props.updateInfo({isCameraOn: true})
      if (response.didCancel) {
        console.log('User cancelled image picker')
      }
      else if (response.error) {
        console.log('ImagePicker Error: ', response.error)
      }
      else if (response.customButton) {
        console.log('User tapped custom button: ', response.customButton)
      }
      else {
        let meta = {
          fileSize: response.fileSize,
          height: response.height,
          latitude: response.latitude,
          longitude: response.longitude,
          path: response.path,
          timestamp: response.timestamp,
          type: response.type,
          width: response.width
        }
        console.log('done imagexx2')
        let paragraph = {id: uuid(), type: 'image', content: response.path, meta: JSON.stringify(meta)}
        console.log('done iyyyymagexx2')
        this.insertItem(paragraph)

//        let {content} = this.state.diary
//        let focusIndex = this.state.focusIndex
//        console.log('done insertItem')
//
//        if (focusIndex === -1) {
//          focusIndex = content.length - 1
//        }
//        let focusParagraph = content[focusIndex]
//        if (focusParagraph.type === 'text' && focusParagraph.content === '') {
//          content.splice(focusIndex, 1, paragraph)
//        } else {
//          content.splice(focusIndex + 1, 0, paragraph)
//        }
//        console.log('done insertItem')
//        this.insertTail()
        this.setState({isModified: true, diary: this.state.diary, focusIndex: -1})
        console.log('done image2')

      }
    })
  }

  onTitleChange (text) {
    let {diary} = this.state
    diary.title = text
    this.setState({isModified: true, diary})
  }

  onKeyboard (type) {
    this.setState({keyboard: type})
  }

  hideKeyboard() {
    this.setState({keyboard: 'hide'})
    Keyboard.dismiss()
  }

  componentDidMount () {
    this.keyboardDidShowListener = Keyboard.addListener(
      'keyboardDidShow',
      () => this.onKeyboard('show'),
    )
    this.keyboardDidHideListener = Keyboard.addListener(
      'keyboardDidHide',
      () => this.onKeyboard('hide'),
    )

    let diary = this.props.navigation.getParam('diary', null)

    if (diary === null) {
      diary = {
        userId: this.props.user.id,
        title: '',
        content: [{id: uuid(), type: 'text', content: ''}],
        createTime: new Date(),
        updateTime: new Date(),
        mood: 'smile'
      }
    } else {
      diary = util.realm2obj(diary, 'Diary')
    }
    this.setState({diary})
  }

  componentWillUnmount () {
    this.keyboardDidShowListener.remove()
    this.keyboardDidHideListener.remove()
  }

  onTextChange (diaryText, text) {
    diaryText.content = text
    this.setState({isModified: true, diary: this.state.diary})
  }

  onTextDelete (diaryText) {
    let {content} = this.state.diary
    let index = content.findIndex(paragraph => paragraph.id === diaryText.id)
    if (index >= 0 && content.length > 1) {
      content.splice(index, 1)
      if (index === 0) {
        content[index]._ref.focus()
      }
      else {
        content[index - 1]._ref.focus()
      }
      this.setState({isModified: true, diary: this.state.diary})
    }
    this.insertTail()
  }

  onTodoChange (diaryTodo, text, meta) {
    diaryTodo.content = text
    diaryTodo.meta = meta
    this.setState({isModified: true, diary: this.state.diary})
  }

  onTodoDelete (diaryTodo) {
    let {content} = this.state.diary
    let index = content.findIndex(paragraph => paragraph.id === diaryTodo.id)
    if (index >= 0) {
      content.splice(index, 1)
      if (index === 0) {
        content[index]._ref.focus()
      }
      else {
        content[index - 1]._ref.focus()
      }
      this.setState({isModified: true, diary: this.state.diary})
    }
    this.insertTail()
  }
  onImageDelete(diaryImage) {
    let {content} = this.state.diary
    let index = content.findIndex(paragraph => paragraph.id === diaryImage.id)
    if (index >= 0) {
      content.splice(index, 1)
      this.setState({focusIndex: -1, isModified: true, diary: this.state.diary})
    }
    this.insertTail()
  }
  onRef (ref, paragraph) {
    paragraph._ref = ref
  }
  onFocus(diaryItem) {
    let {content} = this.state.diary
    console.log('ii%o', diaryItem)
    for (let i=0; i<content.length; i++) {
      if (content[i].id === diaryItem.id) {
        this.setState({focusIndex: i})
        return
      }
    }
  }
  getContent () {
    let content = this.state.diary.content
    return content.map(paragraph => {
      switch (paragraph.type) {
        case 'todo':
          return <DiaryTodo
            ref={ref => this.onRef(ref, paragraph)}
            key={paragraph.id}
            todo={paragraph}
            editable={true}
            onTodoChange={(diaryTodo, text, meta) => this.onTodoChange(
              diaryTodo, text, meta)}
            onTodoDelete={(diaryTodo) => this.onTodoDelete(diaryTodo)}
            onFocus={(diaryTodo) => this.onFocus(diaryTodo)}
          />
        case 'image':
          return <DiaryImage
            ref={ref => this.onRef(ref, paragraph)}
            key={paragraph.id}
            image={paragraph}
            editable={true}
            onDelete={(diaryImage) => this.onImageDelete(diaryImage)}
          />
        case 'text':
          return <DiaryText
            ref={ref => this.onRef(ref, paragraph)}
            key={paragraph.id}
            text={paragraph}
            editable={true}
            onTextChange={(diaryText, text) => this.onTextChange(diaryText,
              text)}
            onTextDelete={(diaryText) => this.onTextDelete(diaryText)}
            onFocus={(diaryText) => this.onFocus(diaryText)}
          />
      }
    })
  }

  onChangeWeather(w) {
    let {diary} = this.state
    diary.weather = w
    this.setState({diary, showWeather: false})
  }
  getWeather() {
    let weathcer = ['cloud', 'cloud-rain', 'cloud-showers-heavy',
                    'cloud-sun', 'cloud-sun-rain', 'sun', 'snowflake']
    return <Popover
      isVisible={this.state.showWeather}
      fromView={this.weatherDOM}
      placement={'top'}
      arrowStyle={{backgroundColor: 'rgba(00, 00, 00, 0.5)'}}
      onClose={() => this.setState({ showWeather: false })}
      popoverStyle={{
        flexDirection: 'row',
        backgroundColor: 'rgba(00, 00, 00, 0.5)',
        paddingVertical: 5,
      }}
    >
      {
        weathcer.map(w => {
          return (<TouchableOpacity
            key={w}
            style={{
              justifyContent: 'center',
              alignItems: 'center',
              marginHorizontal: 5,
            }}
            onPress={() => this.onChangeWeather(w)}
          >
            <FontAwesome5 name={w}
                          style={{
                            fontSize: 25,
                            textAlign: 'center',
                            color: '#fff',
                          }}/>
          </TouchableOpacity>)
        })
      }
    </Popover>
  }
  onChangeEmoji(e) {
    let {diary} = this.state
    diary.mood = e
    this.setState({diary, showEmoji: false})
  }
  getEmoji() {
    let emoji = ['angry', 'frown', 'grin', 'smile', 'sad-cry', 'meh']
    return (
      <Popover
        isVisible={this.state.showEmoji}
        fromView={this.emojiDOM}
        placement={'top'}
        arrowStyle={{backgroundColor: 'rgba(00, 00, 00, 0.5)'}}
        onClose={() => this.setState({ showEmoji: false })}
        popoverStyle={{
          flexDirection: 'row',
          backgroundColor: 'rgba(00, 00, 00, 0.5)',
          paddingVertical: 5,
        }}
      >
        {
          emoji.map(e => {
            return (<TouchableOpacity
              key={e}
              style={{
                justifyContent: 'center',
                alignItems: 'center',
                marginHorizontal: 5,
              }}
              onPress={() => this.onChangeEmoji(e)}
            >
              <FontAwesome5 name={e}
                            style={{
                              fontSize: 25,
                              textAlign: 'center',
                              color: '#fff',
                            }}/>
            </TouchableOpacity>)
          })
        }
      </Popover>
    )
  }
  render () {
    return (
      <View style={{
        flex: 1,
//        backgroundColor: 'rgba(0, 0, 0, 0.1)',
      }}>
        <View style={{
          flexDirection: 'row',
          justifyContent: 'space-between',
          backgroundColor: '#FE6667',
          height: 50,
        }}>
          <View style={{
            height: 50,
            marginHorizontal: 5,
            justifyContent: 'center',
          }}>
            <TouchableOpacity
              onPress={() => this.props.navigation.goBack()}
            >
              <MaterialIcon
                name="close"
                style={{
                  fontSize: 25,
                  textAlign: 'center',
                  color: '#fff',
                }}
              />
            </TouchableOpacity>
          </View>
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
            }}>{moment(this.state.diary.createTime).format('YYYY-MM-DD')}</Text>
          </View>
          <View style={{
            height: 50,
            marginHorizontal: 5,
            justifyContent: 'center',
          }}>
            <TouchableOpacity
              onPress={() => this.onSave()}
            >
              <Text
                style={{
                  fontSize: 15,
                  textAlign: 'center',
                  color: '#fff',
                }}
              >{this.state.isModified ? '保存' : '已保存'}</Text>
            </TouchableOpacity>
          </View>
        </View>
        <TextInput
          style={{
            margin: 5,
            padding: 5,
            textAlignVertical: 'center',
            color: '#757575',
            fontSize: 15,
            borderBottomWidth: 1,
            borderColor: '#ccc',
          }}
          underlineColorAndroid="transparent"
          placeholder={'标题'}
          onChangeText={(text) => this.onTitleChange(text)}
        >{this.state.diary.title}</TextInput>
        <ScrollView style={{
          flex: 1,
        }}>
          {
            this.getContent()
          }
        </ScrollView>
        <View style={{
          flexDirection: 'row',
          justifyContent: 'space-between',
          backgroundColor: '#FE6667',
          height: 45,
          paddingRight: 10,
        }}>
          <View style={{
            height: 45,
            marginHorizontal: 15,
            justifyContent: 'center',
          }}>
            {
              this.state.keyboard === 'show' ? <TouchableOpacity
                onPress={() => this.hideKeyboard()}
              >
                <FontAwesome5 name="chevron-down"
                            style={{
                              fontSize: 25,
                              textAlign: 'center',
                              color: '#fff',
                            }}/>
              </TouchableOpacity> : <View />
            }

          </View>
          <View style={{
            flex: 1,
            flexDirection: 'row',
            justifyContent: 'flex-end',
          }}>
            <View style={{
              height: 45,
              marginHorizontal: 5,
              justifyContent: 'center',
            }}>
              <TouchableOpacity
                onPress={() => this.onAddImg()}
              >
                <FontAwesome5 name="image"
                            style={{
                              fontSize: 25,
                              textAlign: 'center',
                              color: '#fff',
                            }}/>
              </TouchableOpacity>
            </View>
            <View style={{
              height: 45,
              marginHorizontal: 5,
              justifyContent: 'center',
            }}>
              <TouchableOpacity
                onPress={() => this.onAddTodo()}
              >
                <FontAwesome5 name="check-square"
                            style={{
                              fontSize: 25,
                              textAlign: 'center',
                              color: '#fff',
                            }}/>
              </TouchableOpacity>
            </View>
            <View style={{
              height: 45,
              marginHorizontal: 5,
              justifyContent: 'center',
            }}>
              <TouchableOpacity
                onPress={() => this.setState({showEmoji: true})}
                ref={ref => this.emojiDOM = ref}
              >
                <FontAwesome5 name={this.state.diary.mood}
                            style={{
                              fontSize: 25,
                              textAlign: 'center',
                              color: '#fff',
                            }}/>
              </TouchableOpacity>
            </View>
            <View style={{
              height: 45,
              marginHorizontal: 5,
              justifyContent: 'center',
            }}>
              <TouchableOpacity
                onPress={() => this.setState({showWeather: true})}
                ref={ref => this.weatherDOM = ref}
              >
                <FontAwesome5 name={this.state.diary.weather}
                            style={{
                              fontSize: 25,
                              textAlign: 'center',
                              color: '#fff',
                            }}/>
              </TouchableOpacity>
            </View>
          </View>
        </View>
        {
          this.getWeather()
        }
        {
          this.getEmoji()
        }
      </View>
    )
  }
}

const mapStateToProps = (state) => {
  return {
//    diaries: state.app.diaries,
    user: state.app.user,
  }
}

export default connect(mapStateToProps, {
  updateInfo: appAct.updateInfo
})(DiaryEditPage)
