import React, { Component } from 'react'
import {
  View,
  Text,
  StyleSheet,
  Linking,
  StatusBar,
  Animated,
  Easing
} from 'react-native'
import { ScrollView, RectButton } from 'react-native-gesture-handler'
import MaterialIcon from 'react-native-vector-icons/MaterialIcons'

class AboutPage extends Component {
  static navigationOptions = {
    header: null,
  }
  constructor (props) {
    super(props)
  }

  render () {
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
            }}>关于</Text>
          </View>
        </View>
        <ScrollView>
          <Text style={{
            fontSize: 28,
            height: 50,
            textAlign: 'center',
            margin: 10
          }}>
            About page
          </Text>
        </ScrollView>
      </View>
    )
  }
}


export default AboutPage


