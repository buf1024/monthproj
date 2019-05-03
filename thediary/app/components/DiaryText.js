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

class DiaryText extends Component {
  static propTypes = {
    text: PropTypes.object.isRequired,
    editable: PropTypes.bool,
    onTextChange: PropTypes.func,
    onTextDelete: PropTypes.func,
    onFocus: PropTypes.func,
  }

  constructor (props) {
    super(props)
    this.textInput = null
  }
  focus () {
    if (this.textInput) {
      this.textInput.focus()
      let pos = this.props.text.content.length
      this.textInput.setNativeProps({ selection:{ start: pos, end: pos } })
    }
  }
  onFocus() {
    if (this.props.onFocus) {
      this.props.onFocus(this.props.text)
    }
  }
  onKeyPress(keyValue) {
    if (keyValue === 'Backspace') {
      if (this.props.text.content === '') {
        this.props.onTextDelete(this.props.text)
      }
    }
  }
  render () {
    return (
      <View {...this.props} style={{
        marginHorizontal: 10,
        marginVertical: 3,
      }}>
        <TextInput
          style={{
            padding: 0,
            textAlignVertical: 'center',
            fontSize: 16,
            flex: 1
          }}
          ref={ref => this.textInput = ref}
          blurOnSubmit
          underlineColorAndroid="transparent"
          multiline
          editable={this.props.editable}
          onChangeText={(text) => this.props.onTextChange ?
            this.props.onTextChange(this.props.text, text) : {}}
          onKeyPress={({ nativeEvent: { key: keyValue }}) => this.props.onTextDelete ?
            this.onKeyPress(keyValue) : {}}
          onFocus={() => this.props.onFocus ? this.onFocus() : {}}
        >{this.props.text.content}</TextInput>
      </View>
    )
  }
}

export default DiaryText
