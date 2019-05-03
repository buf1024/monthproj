import React, { Component } from 'react'
import {
  View,
  ImageBackground,
  Dimensions,
  Animated,
  WebView,
  Easing,
} from 'react-native'
import { NavigationEvents } from 'react-navigation'
import {ScrollView, RectButton } from 'react-native-gesture-handler'
import HeaderNav from './../components/HeaderNav'
import DiaryView from './../components/DiaryView'
import DiaryCard from './../components/DiaryCard'
import DiaryCal from './../components/DiaryCal'
import { connect } from 'react-redux'
import moment from 'moment/moment'
import * as dbAct from '../store/db'

class DiaryPage extends Component {
  static navigationOptions = {
    header: <HeaderNav key="DiaryPage" select="DiaryPage"/>,
  }
  constructor (props) {
    super(props)

    this.state = {
      showDiary: null,
      currentDate: moment(),
      lastDate: moment().subtract(1, 'months'),
      markedDates: {[moment().format('YYYY-MM-DD')]: {selected: true, selectedColor: '#ee6666'}},
      diaries: [],
    }
  }

  onClick(type, diary) {
    console.log(`type:${type}, diary: %o`, diary)
    if (type === 'click') {
      this.setState({showDiary: diary})
    }
  }
  onDayPress (day) {
    let currentDate = moment(day)
    let lastDate = moment(this.state.currentDate)

    let diaries = this.state.diaries
    let markedDates = this.state.markedDates
    if (day.format('YYYY-MM-DD') !== lastDate.format('YYYY-MM-DD')) {
      diaries = this.getDiaries(currentDate)
      markedDates = this.getMarkedDates(lastDate, currentDate)
    }
    this.setState({diaries, markedDates, currentDate, lastDate})
  }

  getMarkedDates (lastDate, currentDate) {
    let formatKey = currentDate.format('YYYY-MM-DD')
    let markedDates = this.state.markedDates
    Object.keys(markedDates).forEach((k) => {
      markedDates[k].selected = false
    })
    if (markedDates[formatKey] !== undefined) {
      markedDates[formatKey] = {...markedDates[formatKey], selected: true, selectedColor: '#ee6666'}
    } else {
      markedDates[formatKey] = {selected: true, selectedColor: '#ee6666'}
    }

    if (lastDate.year() === currentDate.year() &&
      lastDate.month() === currentDate.month()) {
      return markedDates
    }

    return this.getMonthMarks(currentDate, markedDates)
  }

  getMonthMarks (monthDate, markedDates) {
    let dateStart = moment(monthDate.format('YYYY-MM-01')).toDate()
    let dateEnd = moment(dateStart).add(1, 'months').toDate()

    let marks = dbAct.getDiaries(this.props.user, dateStart, dateEnd)
    marks.forEach(d => {
      let key = moment(d.createTime).format('YYYY-MM-DD')
      if (markedDates[key]) {
        markedDates[key].marked = true
      } else {
        markedDates[key] = {marked: true}
      }
    })
    return markedDates
  }

  getDiaries (currentDate) {
    currentDate = moment(currentDate.format('YYYY-MM-DD'))
    let dateStart = moment(currentDate).toDate()
    let dateEnd = moment(currentDate).add(1, 'days').toDate()

    return dbAct.getDiaries(this.props.user, dateStart, dateEnd, 'createTime')
  }

  componentDidMount () {
    let diaries = this.getDiaries(this.state.currentDate)
    let markedDates = this.getMarkedDates(this.state.lastDate, this.state.currentDate)

    this.setState({diaries, markedDates})
  }

  render () {
    const {setting} = this.props
    return (
      <View style={{
        flex: 1,
      }}>

        {/*<HeaderNav key="DiaryPage" select="DiaryPage"/>*/}
        <ImageBackground
          source={{uri: 'file://' + setting.background}}
          style={{
            width: global.width,
            height: global.height,
          }}
        >
          <DiaryCal currentDate={this.state.currentDate}
                    markedDates={this.state.markedDates}
                    onDayChange={(day) => this.onDayPress(day)}
          />
          <ScrollView>
            {
              this.state.diaries.length > 0 ? this.state.diaries.map(diary => {
                return <DiaryCard
                  key={diary.id}
                  diary={diary}
                  onClick={(type, diary) => this.onClick(type, diary)}
                />
              }) : <DiaryCard />
            }
          </ScrollView>
        </ImageBackground>
        {
          this.state.showDiary !== null ?
            <DiaryView
              visible={this.state.showDiary !== null}
              diary={this.state.showDiary}
              onClose={() => this.setState({showDiary: null})}
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

export default connect(mapStateToProps)(DiaryPage)
