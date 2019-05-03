import React, { Component } from 'react'
import { connect } from 'react-redux'
import {
  View,
  Text,
  Switch,
  Animated,
  Image,
  Easing,
} from 'react-native'
import { RectButton } from 'react-native-gesture-handler'
import MaterialIcon from 'react-native-vector-icons/MaterialIcons'
import MaterialCommunityIcons
  from 'react-native-vector-icons/MaterialCommunityIcons'
import * as themeAct from '../theme'
import * as appAct from '../store/actions'
import * as dbAct from '../store/db'
import ImagePicker from 'react-native-image-picker'
import { NavigationActions } from 'react-navigation'

class SettingPage extends Component {

  static navigationOptions = {
    header: null,
  }

  constructor (props) {
    super(props)

    this.state = {
      syncing: false,
      _loading: new Animated.Value(0),
    }
  }
  updateSetting (setting) {
    dbAct.updateSetting(setting)
    this.props.updateSetting(setting)
  }

  onChangeTheme (theme) {
    console.log('onpress ' + theme)
    this.props.setting.theme = theme
    this.updateSetting(this.props.setting)
  }

  getThemes () {
    const themes = themeAct.getThemes()
    return themes.map(theme => {
      return (<View key={theme.name} style={{
        margin: 2,
        width: 50,
        height: 35,
        borderRadius: 3,
        backgroundColor: theme.theme,
        overflow: 'hidden',
      }}>
        {
          this.props.setting.theme === theme.name ?
            <View style={{
              position: 'absolute',
              height: '100%',
              width: '100%',
              backgroundColor: 'rgba(0, 0, 0, 0)',
            }}>
              <MaterialIcon
                name="check"
                style={{
                  height: '100%',
                  fontSize: 30,
                  textAlign: 'center',
                  color: '#fff',
                }}
              />
            </View> : <View/>
        }
        {
          this.props.setting.theme === theme.name ? <View/> :
            <RectButton
              style={{
                height: '100%',
                width: '100%',
              }}
              onPress={() => this.onChangeTheme(theme.name)}
            />
        }
      </View>)
    })
  }

  onChangeBackground () {
    const options = {
      title: '请选择背景图片',
      cancelButtonTitle: '取消',
      takePhotoButtonTitle: '拍照',
      chooseFromLibraryButtonTitle: '从相册选择',
      storageOptions: {
        skipBackup: true,
        path: 'images',
      },
    }
    this.props.updateInfo({isCameraOn: true})
    ImagePicker.showImagePicker(options, (response) => {
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
        this.props.setting.background = response.path
        this.updateSetting(this.props.setting)
      }
    })
  }

  onProtect (protect) {
    if (protect) {
      this.props.navigation.dispatch(
        NavigationActions.navigate({
          routeName: 'ProtectPage', key: 'ProtectPage', params: {type: 'reset'}
        }))
    }
    else {
      this.props.setting.protect = ''
      this.updateSetting(this.props.setting)
    }
  }

  onAutosync () {
    this.props.setting.autoSync = !this.props.setting.autoSync
    this.updateSetting(this.props.setting)
  }

  showLoading (loading) {
    if (loading) {
      this.state._loading.setValue(0)
      Animated.timing(this.state._loading, {
        toValue: 1,
        duration: 1000,
        easing: Easing.linear
      }).start(() => this.showLoading(this.state.syncing))
    }
  }
  onSync () {
    if (this.state.syncing) {
      return
    }

    this.setState({syncing: true})
    this.showLoading(true)

    setTimeout(() => this.setState({syncing: false}), 10000)
  }

  onLogin () {

  }

  render () {
    console.log('setting props: %o', this.props)
    let rotateZ = null
    if (this.state.syncing) {
      rotateZ = this.state._loading.interpolate({
        inputRange: [0, 0.5, 1],
        outputRange: ['0deg', '180deg', '360deg'],
      })
    }
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
                name="close"
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
            }}>设置</Text>
          </View>
        </View>
        <View>
          <View style={{
            flexDirection: 'row',
            justifyContent: 'space-between',
            backgroundColor: '#fff',
            marginTop: 15,
          }}>
            <Text style={{
              color: '#757575',
              padding: 15,
            }}>主题</Text>
            <View style={{
              flexDirection: 'row',
              justifyContent: 'flex-end',
              alignItems: 'center',
              marginHorizontal: 10,
            }}>
              {this.getThemes()}
            </View>
          </View>
          <View style={{
            flexDirection: 'row',
            justifyContent: 'space-between',
            backgroundColor: '#fff',
            marginTop: 15,
          }}>
            <Text style={{
              color: '#757575',
              padding: 15,
            }}>背景</Text>
            <View style={{
              marginVertical: 5,
              marginHorizontal: 10,
              width: 45,
              height: 45,
              borderRadius: 3,
              overflow: 'hidden',
            }}>
              <RectButton
                onPress={() => this.onChangeBackground()}
              >
                {
                  this.props.setting.background !== '' && this.props.setting.background !== undefined ?
                    <Image style={{
                      width: 45,
                      height: 45,
                      backgroundColor: 'rgba(00, 00, 00, 0.2)',
                    }}
                           source={{uri: 'file://' + this.props.setting.background}}

                    /> : <View style={{
                      width: 45,
                      height: 45,
                      backgroundColor: 'rgba(00, 00, 00, 0.2)',
                    }} />
                }

              </RectButton>
            </View>
          </View>
          <View style={{
            flexDirection: 'row',
            justifyContent: 'space-between',
            backgroundColor: '#fff',
            marginTop: 15,
          }}>
            <Text style={{
              color: '#757575',
              padding: 15,
            }}>密码保护</Text>
            <Switch style={{
              marginHorizontal: 10,
            }}
                    value={this.props.setting.protect !== ''}
                    onValueChange={(protect) => this.onProtect(protect)}
            />
          </View>
          {
            this.props.isLogin ? (
              <View style={{
                flexDirection: 'row',
                justifyContent: 'space-between',
                backgroundColor: '#fff',
                marginTop: 15,
              }}>
                <Text style={{
                  color: '#757575',
                  padding: 15,
                }}>自动同步</Text>
                <Switch style={{
                  marginHorizontal: 10,
                }}
                        value={this.props.setting.autoSync}
                        onValueChange={() => this.onAutosync()}
                />
              </View>
            ) : <View/>
          }
          {
            this.props.isLogin ? (
              <View style={{
                flexDirection: 'row',
                justifyContent: 'space-between',
                backgroundColor: '#fff',
                marginTop: 15,
              }}>
                <RectButton style={{
                  flex: 1,
                }}
                            onPress={() => this.onSync()}
                >
                  <Text style={{
                    color: '#757575',
                    padding: 15,
                  }}>立刻同步</Text>
                </RectButton>
                {
                  this.state.syncing ? (
                    <Animated.View style={{
                      justifyContent: 'center',
                      alignItems: 'center',
                      marginHorizontal: 10,
                      transform: [{
                        rotateZ
                      }]
                    }}>
                      <MaterialCommunityIcons
                        name="loading"
                        style={{
                          fontSize: 25,
                          textAlign: 'center',
                          color: '#e66',
                        }}
                      />
                    </Animated.View>
                  ) : <View />
                }
              </View>
            ) : <View/>
          }
          <View style={{
            flexDirection: 'row',
            justifyContent: 'space-between',
            backgroundColor: '#fff',
            marginTop: 15,
          }}>
            <RectButton
              style={{
                flex: 1,
                flexDirection: 'row',
                justifyContent: 'space-between',
              }}

              onPress={() =>
                this.props.navigation.dispatch(
                  NavigationActions.navigate({
                    routeName: 'AboutPage', key: 'AboutPage'}
                  ))
                }
            >
              <Text style={{
                color: '#757575',
                padding: 15,
              }}>关于</Text>
              <View style={{
                justifyContent: 'center',
                alignItems: 'center',
                marginHorizontal: 10,
              }}>
                <MaterialCommunityIcons
                  name="chevron-right"
                  style={{
                    fontSize: 30,
                    textAlign: 'center',
                    color: '#000',
                  }}
                />
              </View>
            </RectButton>
          </View>
          <View style={{
            flexDirection: 'row',
            backgroundColor: '#fff',
            marginTop: 60,
          }}>
            <RectButton style={{
              flex: 1,
              justifyContent: 'center',
              alignItems: 'center',
            }}
                        onPress={() => this.onLogin()}
            >
              <Text style={{
                color: '#FE6667',
                padding: 15,
              }}>{this.props.isLogin ? '退出登录' : '注册/登录'}</Text>
            </RectButton>
          </View>
        </View>

      </View>
    )
  }
}

const mapStateToProps = (state) => {
  return {
    isLogin: state.app.user.isLogin,
    setting: state.app.setting,
  }
}

export default connect(mapStateToProps, {
  updateSetting: appAct.updateSetting,
  updateInfo: appAct.updateInfo
})(SettingPage)
