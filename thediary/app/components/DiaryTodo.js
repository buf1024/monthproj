import React, { Component } from 'react'
import {
  View,
  TextInput,
  Dimensions,
  Animated,
  WebView,
  Easing,
} from 'react-native'
import PropTypes from 'prop-types'

import { RectButton } from 'react-native-gesture-handler'
import EntypoIcon from 'react-native-vector-icons/Entypo'

class DiaryTodo extends Component {
  static propTypes = {
    todo: PropTypes.object.isRequired,
    editable: PropTypes.bool,
    onTodoChange: PropTypes.func,
    onTodoDelete: PropTypes.func,
    onFocus: PropTypes.func,
  }

  constructor (props) {
    super(props)

    this.textInput = null

  }
  focus () {
    if (this.textInput) {
      this.textInput.focus()
      let pos = this.props.todo.content.length
      this.textInput.setNativeProps({ selection:{ start: pos, end: pos } })
    }
  }
  onPress () {
    if (this.props.editable ) {
      let meta = JSON.parse(this.props.todo.meta)
      meta.status = meta.status === 'done' ? 'ongoing' : 'done'
      this.props.onTodoChange(this.props.todo, this.props.todo.content, JSON.stringify(meta))
    }
  }
  onKeyPress(keyValue) {
    if (keyValue === 'Backspace') {
      if (this.props.todo.content === '') {
        this.props.onTodoDelete(this.props.todo)
      }
    }
  }
  onFocus() {
    if (this.props.onFocus) {
      this.props.onFocus(this.props.todo)
    }
  }
  render () {
    let meta = JSON.parse(this.props.todo.meta)
    let textDecorationLine = meta.status === 'done' ? 'line-through' : 'none'
    return (
      <View {...this.props} style={{
        marginHorizontal: 10,
        marginVertical: 3,
        flexDirection: 'row',
      }}>
        <View style={{
          justifyContent: 'center',
          alignItems: 'center',
        }}>
          <View style={{
            width: 18,
            height: 18,
            borderRadius: 9,
            borderWidth: 1,
            borderColor: '#777',
            backgroundColor: '#fff',
          }}>
            <RectButton
              onPress={() => this.onPress()}>
              {
                meta.status === 'done' ?
                  <EntypoIcon
                    name="check"
                    style={{
                      padding: 0,
                      fontSize: 14,
                      textAlign: 'center',
                      color: 'red',
                    }}
                  /> : <View style={{
                    width: 18,
                    height: 18,
                  }}/>
              }
            </RectButton>
          </View>
        </View>
        <View style={{
          justifyContent: 'center',
          alignItems: 'center',
          marginHorizontal: 5,
        }}>

          <TextInput
            key={textDecorationLine} // textDecorationLine react-native 加上了就无法去掉
            style={{
              padding: 0,
              textAlignVertical: 'center',
              color: '#757575',
              fontSize: 14,
              textDecorationLine,}}
            ref={ref => this.textInput = ref}
            blurOnSubmit
            underlineColorAndroid="transparent"
            multiline
            editable={this.props.editable}
            onChangeText={(text) => this.props.onTodoChange ?
              this.props.onTodoChange(this.props.todo, text, this.props.todo.meta): {}}
            onKeyPress={({ nativeEvent: { key: keyValue }}) => this.props.onTodoDelete ?
              this.onKeyPress(keyValue) : {}}
            onFocus={() => this.props.onFocus ? this.onFocus() : {}}
          >{this.props.todo.content}</TextInput>
        </View>
      </View>
    )
  }
}

export default DiaryTodo
