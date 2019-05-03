import React, { Component } from 'react'
import { connect } from 'react-redux'
import {
  View,
  Text,
  TextInput,
  Image,
} from 'react-native'
import * as appAct from './../store/actions'
import HeaderNav from './../components/HeaderNav'
import ImagePicker from 'react-native-image-picker'
import { ScrollView, RectButton } from 'react-native-gesture-handler'
import MaterialCommunityIcon from 'react-native-vector-icons/MaterialCommunityIcons'
import * as dbAct from './../store/db'

class MinePage extends Component {
  static navigationOptions = {
    header: <HeaderNav key="MinePage" select="MinePage"/>,
  }

  constructor (props) {
    super(props)

    this.numbers = Array.from(new Array(4), (val, index) => index + 1)
  }

  onSelectImg () {
// More info on all the options is below in the API Reference... just some common use cases shown here
    const options = {
      title: '请选择图片',
      cancelButtonTitle: '取消',
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
    ImagePicker.showImagePicker(options, (response) => {
      this.props.updateInfo({isCameraOn: true})
      console.log('Response = ', response)

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
        const {user} = this.props
        user.image = response.path
        this.updateUser(user)
      }
    })
  }

  updateUser (user) {
    dbAct.updateUser(user)
    this.props.updateUser(user)
  }

  onChangeText (type, text) {
    const {user} = this.props
    if (type === 'name') {
      user.name = text
      this.updateUser(user)
    }
    else if (type === 'motto') {
      user.motto = text
      this.updateUser(user)
    }
  }

  getCount (type, user) {
    let count = 0
//    user.diary.forEach(diary => {
//      if (type === 'word') {
//        count += diary.worldCount
//      }
//      else if (type === 'image') {
//        count += diary.imageCount
//      }
//    })
    return count
  }


  render () {
    const {user} = this.props
    console.log('this.props: %o', this.props)

    return (
      <View {...this.props} style={{}}>
        <View style={{
          flexDirection: 'row',
          alignItems: 'center',
          backgroundColor: '#FE6667',
          height: 90,
        }}>
          <View style={{
            width: 60,
            height: 60,
            borderRadius: 30,
            marginHorizontal: 10,
            overflow: 'hidden',
          }}>
            <RectButton
              onPress={() => this.onSelectImg()}
            >
              <Image style={{
                width: 60,
                height: 60,
                backgroundColor: 'rgba(00, 00, 00, 0.2)',
              }}
                     source={{uri: 'file://' + user.image}}
              />

            </RectButton>
          </View>
          <View style={{
            flex: 1,
            justifyContent: 'center',
          }}>
            <TextInput underlineColorAndroid="transparent"
              //                       returnKeyType="search"
                       value={user.name}
                       onChangeText={(text) => this.onChangeText('name', text)}
                       style={{
                         fontSize: 15,
                         padding: 0,
                         color: '#fff',
                       }}
            />
            <TextInput underlineColorAndroid="transparent"
                       value={user.motto}
                       onChangeText={(text) => this.onChangeText('motto', text)}
                       style={{
                         fontSize: 12,
                         color: '#ccc',
                         padding: 0,
                       }}
            />
          </View>
          <View style={{
            marginHorizontal: 10,
          }}>
            <View>
              <RectButton
              >
                <MaterialCommunityIcon
                  name="bell-outline"
                  style={{
                    height: 30,
                    width: 30,
                    fontSize: 20,
                    textAlign: 'center',
                    color: '#fff',
                  }}/>
              </RectButton>
              {
                user.notification/*.length > 0*/ ? <View style={{
                  height: 16,
                  width: 16,
                  borderRadius: 8,
                  backgroundColor: '#E99709',
                  position: 'absolute',
                  top: -3,
                  left: 12,
                }}>
                  <Text style={{
                    height: 16,
                    width: 16,
                    lineHeight: 16,
                    fontSize: 10,
                    textAlign: 'center',
                    color: '#fff',
                  }}>{user.notification.length}</Text>
                </View> : <View/>
              }
            </View>
            <RectButton
              onPress={() => this.props.navigation.navigate(
                {routeName: 'SettingPage', key: 'SettingPage'})}
            >
              <MaterialCommunityIcon
                name="settings"
                style={{
                  height: 30,
                  width: 30,
                  fontSize: 20,
                  textAlign: 'center',
                  color: '#fff',
                }}/>
            </RectButton>
          </View>
        </View>
        <View style={{
          flexDirection: 'row',
          width: global.width,
//          height: 45,
          borderWidth: 1,
          borderColor: '#ccc',
        }}>
          <View style={{
            flex: 1,
            justifyContent: 'center',
            alignItems: 'center',
            padding: 3,
          }}>
            <Text>{/*user.diary.length*/ 0}</Text>
            <Text>篇</Text>
          </View>
          <View style={{
            flex: 1,
            justifyContent: 'center',
            alignItems: 'center',
            padding: 3,
            borderLeftWidth: 1,
            borderRightWidth: 1,
            borderColor: '#ccc',
          }}>
            <Text>{this.getCount('word', user)}</Text>
            <Text>字</Text>
          </View>
          <View style={{
            flex: 1,
            justifyContent: 'center',
            alignItems: 'center',
            padding: 3,
          }}>
            <Text>{this.getCount('image', user)}</Text>
            <Text>图</Text>
          </View>
        </View>
        <View style={{
          backgroundColor: '#fff',
        }}>
          <ScrollView style={{
            padding: 5,
          }}>
            {
              this.numbers.map(v => {
                return (
                  <View key={v} style={{
                    flexDirection: 'row',
                    justifyContent: 'flex-start',
                    width: 'auto',
                    margin: 5,
                  }}>
                    {
                      this.numbers.map(v => {
                        return (
                          <View key={v} style={{
//                          borderColor: 'red',
//                          borderWidth: 1,
//                          borderRadius: 8,
                            marginHorizontal: 2,
                            flex: 1,
                            justifyContent: 'center',
                            alignItems: 'center',
                            overflow: 'hidden',
                          }}><RectButton key={v} style={{}}>
                            <Image
                              source={require('../assets/images/timg.jpeg')}
                              style={{
                                width: 80,
                                height: 80,
                                backgroundColor: 'rgba(00, 00, 00, 0.2)',
                              }}
                            />
                          </RectButton>
                          </View>)
                      })
                    }
                  </View>
                )
              })
            }
          </ScrollView>
        </View>
      </View>
    )
  }
}

const mapStateToProps = (state) => {
  return {
    user: state.app.user,
  }
}
export default connect(mapStateToProps, {
  updateUser: appAct.updateUser,
  updateInfo: appAct.updateInfo
})(MinePage)
