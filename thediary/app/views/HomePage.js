import React, { Component } from 'react'
import {
  View,
  Text,
  ImageBackground,
} from 'react-native'
import {ScrollView } from 'react-native-gesture-handler'
import { NavigationEvents } from 'react-navigation'
import HeaderNav from './../components/HeaderNav'
import Footer from './../components/Footer'
import DiaryCard from './../components/DiaryCard'
import DiaryView from './../components/DiaryView'
import * as appAct from '../store/actions'
import { connect } from 'react-redux'
import * as dbAct from '../store/db'
import * as util from '../utils'
import moment from 'moment/moment'

class HomePage extends Component {
  static navigationOptions = {
    header: <HeaderNav key="HomePage" select="HomePage"/>,
  }
  constructor (props) {
    super(props)
    this.state = {
      showDiary: null,
      monthView: [],
      diaries: [],
    }
  }

  onClick(type, diary) {
    console.log(`type:${type}, diary: %o`, diary)
    if (type === 'click') {
      this.setState({showDiary: diary})
    } else if (type === 'delete') {
      dbAct.deleteDiary(diary)
      this.setState({monthView: []})
    }
  }

  getDiaries () {
    return dbAct.getDiaries(this.props.user, undefined, undefined, 'createTime', true)
  }

  componentDidMount () {

  }
  onNaviFocus() {
    let diaries = this.getDiaries()
    this.setState({diaries})
  }

  showMonth(createTime) {
    createTime = moment(createTime)
    let mothStr = createTime.format('YYYY-MM')
    if (this.state.monthView.includes(mothStr)) {
      return false;
    }
    this.state.monthView.push(mothStr)
    return true
  }
  onEdit(diary) {
    console.log('onEdit')
    this.setState({showDiary: null})
    this.props.navigation.navigate({
      routeName: 'DiaryEditPage',
      key: 'DiaryEditPage',
      params: {diary}
    })
  }
  render () {
    const {setting} = this.props
    return (
      <View style={{
        flex: 1,
      }}>
        <NavigationEvents
          onDidFocus={() => this.onNaviFocus()}
        />
        <ImageBackground
          source={{uri: 'file://' + setting.background}}
          style={{
            width: global.width,
            height: global.height - 80,
          }}
        >
          <ScrollView>
            {
              this.state.diaries.length > 0 ? this.state.diaries.map(diary => {
                return <View key={diary.id}>
                    {
                      this.showMonth(diary.createTime) ? <Text style={{
                        marginHorizontal: 10,
                        fontSize: 25,
                        color: '#fff',
                      }}>{util.getDateStr(moment(diary.createTime))}</Text> : <View />
                    }

                  <DiaryCard
                    diary={diary}
                    onClick={(type, diary) => this.onClick(type, diary)}
                  />
                </View>
              }) : <DiaryCard/>
            }
          </ScrollView>
        </ImageBackground>
        <Footer count={this.state.diaries.length}/>
        {
          this.state.showDiary !== null ?
            <DiaryView
              visible={this.state.showDiary !== null}
              diary={this.state.showDiary}
              onClose={() => this.setState({showDiary: null})}
              onEdit={(diary) => this.onEdit(diary)}
            /> : <View />
        }
      </View>
    )
  }
}
const mapStateToProps = (state) => {
  return {
    user: state.app.user,
    setting: state.app.setting,
  }
}

export default connect(mapStateToProps, {
  updateInfo: appAct.updateInfo
})(HomePage)

