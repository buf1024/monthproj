import React, { Component } from 'react'
import {
  View,
  TouchableOpacity,
  Text,
  Animated,
  Easing,
  Image,
  Dimensions,
} from 'react-native'

const WIDTH = Dimensions.get('window').width

class Timing extends Component {

  constructor (props) {
    super(props)
    this.state = {
      opacity: new Animated.Value(1),
    }
  }

  animated () {
    this.state.opacity.setValue(1)
    Animated.timing(this.state.opacity, {
      toValue: 0,
      duration: 3000,
      easing: Easing.linear,
    }).start(() => this.animated())
  }

  componentDidMount () {
    this.animated()
  }

  render () {
    return (
      <Animated.View style={{
        width: 200,
        height: 200,
        opacity: this.state.opacity,
      }}>
        <Image style={{
          width: 200,
          height: 200,
        }} source={require('../assets/images/timg.jpeg')}/>
      </Animated.View>
    )
  }
}

class Interpolate extends Component {
  constructor (props) {
    super(props)
    this.state = {
      value: new Animated.Value(0),
    }
  }

  animated () {
    this.state.value.setValue(0)
    Animated.timing(this.state.value, {
      toValue: 1,
      duration: 3000,
      easing: Easing.in,
    }).start(() => this.animated())
  }

  componentDidMount () {
    this.animated()
  }

  render () {
    const rotateZ = this.state.value.interpolate({
      inputRange: [0, 1],
      outputRange: ['360deg', '0deg'],
    })
    const rotateX = this.state.value.interpolate({
      inputRange: [0, 0.25, 0.5, 0.75, 1],
      outputRange: ['0deg', '90deg', '180deg', '270deg', '360deg'],
    })
    const rotateY = this.state.value.interpolate({
      inputRange: [0, 0.25, 0.5, 0.75, 1],
      outputRange: ['0deg', '90deg', '180deg', '270deg', '360deg'],
    })
    return (
      <View>
        <Animated.View style={{
          width: 100,
          height: 100,
          transform: [{rotateZ}],
        }}>
          <Image style={{
            width: 100,
            height: 100,
          }} source={require('../assets/images/out_loading_image.png')}/>
        </Animated.View>

        <Animated.View style={{
          marginTop: 20,
          width: 200,
          height: 200,
          transform: [{rotateY}],
        }}>
          <Image style={{
            width: 200,
            height: 200,
          }} source={require('../assets/images/timg.jpeg')}/>
        </Animated.View>

        <Animated.View style={{
          marginTop: 20,
          width: 200,
          height: 200,
          transform: [{rotateX}],
        }}>
          <Image style={{
            width: 200,
            height: 200,
          }} source={require('../assets/images/timg.jpeg')}/>
        </Animated.View>

      </View>
    )
  }
}

class Spring extends Component {

  constructor (props) {
    super(props)
    this.state = {
      value: new Animated.Value(0),
    }
  }

  animated () {
    this.state.value.setValue(0)
    Animated.spring(this.state.value, {
      toValue: 1,
      friction: 2,
      tension: 10,
    }).start(() => this.animated())
  }

  componentDidMount () {
    this.animated()
  }

  render () {
    return (
      <Animated.View style={{
        width: 282,
        height: 51,
        transform: [{scale: this.state.value}],
      }}>
        <Image style={{
          width: 282,
          height: 51,
        }} source={require('../assets/images/appstore_comment_image.png')}/>
      </Animated.View>
    )
  }
}

class Decay extends Component {

  constructor (props) {
    super(props)
    this.state = {
      value: new Animated.ValueXY({x: 0, y: 0}),
    }
  }

  animated () {
    this.state.value.setValue({x: 0, y: 0})
    Animated.decay(this.state.value, {
      velocity: 5,
      deceleration: 0.9,
    }).start()
  }

  componentDidMount () {
    this.animated()
  }

  render () {
    return (
      <Animated.View style={{
        width: 100,
        height: 100,
        transform: [
          {translateX: this.state.value.x},
          {translateY: this.state.value.y}],
      }}>
        <Image style={{
          width: 100,
          height: 100,
        }} source={require('../assets/images/timg.jpeg')}/>
      </Animated.View>
    )
  }
}

class Parallel extends Component {

  constructor (props) {
    super(props)
    this.state = {
      dogOpacity: new Animated.Value(0),
      dogAcc: new Animated.Value(0),
    }
  }

  animated () {
    this.state.dogOpacity.setValue(0)
    this.state.dogAcc.setValue(0)

    Animated.parallel([
      Animated.timing(this.state.dogOpacity, {
        toValue: 1,
        duration: 1000,
      }),
      Animated.timing(this.state.dogAcc, {
        toValue: 1,
        duration: 2000,
        easing: Easing.linear,
      }),
    ]).start()
  }

  componentDidMount () {
    this.animated()
  }

  render () {
    const dogOpacity = this.state.dogOpacity.interpolate({
      inputRange: [0, 0.2, 0.4, 0.6, 0.8, 1],
      outputRange: [0, 1, 0, 1, 0, 1],
    })
    const neckTop = this.state.dogAcc.interpolate({
      inputRange: [0, 1],
      outputRange: [250, 135],
    })
    const glassLeft = this.state.dogAcc.interpolate({
      inputRange: [0, 1],
      outputRange: [-120, 127],
    })
    const glassRotateZ = this.state.dogAcc.interpolate({
      inputRange: [0, 1],
      outputRange: ['0deg', '360deg'],
    })
    return (
      <View>
        <Animated.View style={{
          width: 375,
          height: 240,
          opacity: dogOpacity,
        }}>
          <Image style={{
            width: 375,
            height: 240,
          }} source={require('../assets/images/dog.jpg')}/>
        </Animated.View>
        <Animated.View style={{
          width: 250,
          height: 100,
          position: 'absolute',
          top: neckTop,
          left: 93,
        }}>
          <Image style={{
            width: 250,
            height: 100,
          }} source={require('../assets/images/necklace.jpg')}/>
        </Animated.View>
        <Animated.View style={{
          width: 120,
          height: 25,
          position: 'absolute',
          top: 58,
          left: glassLeft,
          transform: [{
            rotateZ: glassRotateZ
          }]
        }}>
          <Image style={{
            width: 120,
            height: 25,
          }} source={require('../assets/images/glasses.png')}/>
        </Animated.View>
      </View>
    )
  }
}

export default class AnimatedDemo extends Component {

  constructor (props) {
    super(props)

    this.demos = {
      Timing: <Timing key="Timing"/>,
      Interpolate: <Interpolate key="Interpolate"/>,
      Spring: <Spring key="Spring"/>,
      Decay: <Decay key="Decay"/>,
      Parallel: <Parallel key="Parallel" />
    }
    this.state = {
      select: 'Timing',
    }
  }

  onPress (select) {
    if (this.state.select !== select) {
      this.setState({select})
    }
  }

  render () {
    return (
      <View style={{
        flex: 1,
      }}>
        {
          this.demos[this.state.select]
        }
        <View style={{
          borderTopWidth: 1,
          borderTopColor: '#ccc',
          position: 'absolute',
          width: WIDTH,
          padding: 3,
          bottom: 0,
          flex: 1,
          flexDirection: 'row',
          flexWrap: 'wrap',
          justifyContent: 'center',
          alignItems: 'center',
        }}>
          {
            Object.keys(this.demos).map((v) => {
              return <TouchableOpacity
                style={{
                  margin: 2,
                  padding: 8,
                  border: 1,
                  borderColor: '#eee',
                  backgroundColor: '#253137',
                  height: 30,
                  borderRadius: 5,
                }}
                key={v} onPress={() => this.onPress(v)}>
                <Text style={{
                  fontSize: 14,
                  height: 14,
                  lineHeight: 14,
                  textAlign: 'center',
                  color: '#f0f0f0',
                }}>{v}</Text>
              </TouchableOpacity>
            })
          }
        </View>
      </View>
    )
  }
}
