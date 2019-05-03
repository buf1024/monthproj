import React, { Component } from 'react'
import {
  View,
  Text,
  TouchableOpacity,
  Animated,
  WebView,
  Image,
} from 'react-native'
import {
  RectButton,
  LongPressGestureHandler,
  State,
} from 'react-native-gesture-handler'
import PropTypes from 'prop-types'
import Popover from 'react-native-popover-view'


class DiaryImage extends Component {

  static propTypes = {
    image: PropTypes.object.isRequired,
    editable: PropTypes.bool,
    onDelete: PropTypes.func
  }

  constructor (props) {
    super(props)

    this.state = {
      showPopover: false
    }

    this.doublePress = React.createRef()
  }

  getHeight (meta) {
    let width = this.getWidth()
    let height = 0
    let jsMeta = JSON.parse(meta)
    if (jsMeta.width < width) {
      width = meta.width
      height = meta.height

      return height
    }
    height = jsMeta.height * (width / jsMeta.width)

    return height
  }
  getWidth () {
    if (this.props.editable) {
      return global.width - 20
    } else {
      return global.width - 80
    }
  }
  focus () {
    console.log('image focus')
  }
  onDoublePress (event) {
    if (event.nativeEvent.state === State.ACTIVE) {
      console.log("I'm being pressed for so long")
      this.setState({showPopover: true})
    }
  }
  onPress() {
    console.log("I'm being pressed");
  }
  onDelete() {
    if (this.props.onDelete) {
      this.props.onDelete(this.props.image)
      this.setState({showPopover: false})
    }
  }
  render () {
    return (
      <View style={{
        width: global.width,
        marginVertical: 5,
        marginHorizontal: 10,
//        justifyContent: 'center',
//        alignItems: 'center',
      }}>
          <LongPressGestureHandler
            onHandlerStateChange={(event) => this.onDoublePress(event)}
            minDurationMs={500}
            ref={this.doublePress}
          >
            <RectButton
              style={{
//                justifyContent: 'center',
//                alignItems: 'center',
              }}
              waitFor={this.doublePress}
              onPress={() => this.onPress()}
            >
              <Image style={{
                height: this.getHeight(this.props.image.meta),
                width: this.getWidth(),
              }}
                     ref={ref => this.image = ref}
                     source={{uri: 'file://' + this.props.image.content}}
              />
            </RectButton>
          </LongPressGestureHandler>
        {
          this.props.onDelete ? <Popover
            isVisible={this.state.showPopover}
            fromView={this.image}
            //          placement={'top'}
            arrowStyle={{backgroundColor: '#fff'}}
            onClose={() => this.setState({ showPopover: false })}
          >
            <TouchableOpacity
              style={{
                justifyContent: 'center',
                alignItems: 'center',
              }}
              onPress={() => this.onDelete()}
            >
              <Text style={{padding: 3, fontSize: 18}}>删除</Text>
            </TouchableOpacity>
          </Popover> : <View />
        }

      </View>
    )
  }
}

export default DiaryImage
