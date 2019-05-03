import React, { Component } from 'react'
import {
  View,
  Text,
  Alert,
} from 'react-native'
import { Calendar } from 'react-native-calendars'
import {
  RectButton,
  FlingGestureHandler,
  Directions,
  State,
} from 'react-native-gesture-handler'
import moment from 'moment'
import MaterialCommunityIcons from 'react-native-vector-icons/MaterialCommunityIcons'
import { connect } from 'react-redux'
import merge from 'lodash/merge'
import * as appAct from '../store/actions'
import * as dbAct from '../store/db'
import PropTypes from 'prop-types'
import * as util from '../utils'


class DiaryCal extends Component {

  static propTypes = {
    currentDate: PropTypes.object.isRequired,
    markedDates: PropTypes.object.isRequired,
    onDayChange: PropTypes.func.isRequired,
  }
  constructor (props) {
    super(props)
    this.state = {
      show: 'calendar-range',
      icon: 'calendar-blank',
      today: moment(),
    }
  }


  onSwitchView () {
    if (this.state.show === 'calendar-range') {
      this.setState({show: 'calendar-blank', icon: 'calendar-range'})
    } else {
      this.setState({show: 'calendar-range', icon: 'calendar-blank'})
    }
  }
  onSwitchToday () {
    if (this.state.today.format('YYYY-MM-DD') !== this.props.currentDate.format('YYYY-MM-DD')) {
      this.props.onDayChange(moment(this.state.today))
    }
  }
  onDayPress (day) {
    this.props.onDayChange(moment(day.dateString))
  }

  render () {
    return (
      <View style={{
        width: global.width,
        backgroundColor: '#fff',
      }}>
        {
          this.state.show === 'calendar-range' ? (
            <Calendar
              style={{
//                height: 270,
              }}
              // Initially visible month. Default = Date()
              current={this.props.currentDate.format('YYYY-MM-DD')}
              // Minimum date that can be selected, dates before minDate will be grayed out. Default = undefined
//              minDate={'2012-05-10'}
              // Maximum date that can be selected, dates after maxDate will be grayed out. Default = undefined
              //          maxDate={'2012-05-30'}
              // Handler which gets executed on day press. Default = undefined
              onDayPress={(day) => this.onDayPress(day)}
              // Handler which gets executed on day long press. Default = undefined
              onDayLongPress={(day) => {console.log('selected day', day)}}
              // Month format in calendar-range title. Formatting values: http://arshaw.com/xdate/#Formatting
              monthFormat={'yyyy-MM'}
              // Handler which gets executed when visible month changes in calendar-range. Default = undefined
              onMonthChange={(day) => this.onDayPress(day)}
              // Hide month navigation arrows. Default = false
//              hideArrows={false}
              // Replace default arrows with custom ones (direction can be 'left' or 'right')
              //          renderArrow={(direction) => (<Arrow />)}
              // Do not show days of other months in month page. Default = false
//              hideExtraDays={false}
              // If hideArrows=false and hideExtraDays=false do not switch month when tapping on greyed out
              // day from another month that is visible in calendar-range page. Default = false
//              disableMonthChange={false}
              // If firstDay=1 week starts from Monday. Note that dayNames and dayNamesShort should still start from Sunday.
              firstDay={1}
              // Hide day names. Default = false
              hideDayNames={true}
              // Show week numbers to the left. Default = false
              showWeekNumbers={false}
              // Handler which gets executed when press arrow icon left. It receive a callback can go back month
              onPressArrowLeft={substractMonth => substractMonth()}
              // Handler which gets executed when press arrow icon left. It receive a callback can go next month
              onPressArrowRight={addMonth => addMonth()}
              markedDates={
                merge({}, this.props.markedDates)
              }
            />
          ) : (
            <View style={{
              height: 270,
            }}>
              <FlingGestureHandler
                direction={Directions.RIGHT | Directions.LEFT}
                onHandlerStateChange={(e) => {
                  if (e.nativeEvent.state === State.ACTIVE) {

                    console.log('nativeEvent: %o', e.nativeEvent)
                    Alert.alert('I\'m flinged!')
                  }
                }}>
                <View style={{
                  backgroundColor: '#FE6667',
                  justifyContent: 'center',
                  height: 270,
                }}>
                  <Text style={{
                    height: 50,
                    marginTop: 20,
                    color: '#fff',
                    fontSize: 35,
                    textAlign: 'center',
                  }}>{this.props.currentDate.month() + 1}月</Text>
                  <Text style={{
                    color: '#fff',
                    fontSize: 90,
                    textAlign: 'center',
                  }}>{this.props.currentDate.format('DD')}</Text>
                  <Text style={{
                    color: '#fff',
                    fontSize: 35,
                    textAlign: 'center',
                  }}>{util.getWeek(this.props.currentDate)}</Text>
                </View>
              </FlingGestureHandler>
            </View>
          )
        }
        <View  style={{
//          alignSelf: 'flex-end',
          flexDirection: 'row',
          marginVertical: 10,
          marginHorizontal: 20,
          justifyContent: 'space-between'
        }}>
        <RectButton style={{
          alignSelf: 'flex-start',
//          marginVertical: 10,
//          marginHorizontal: 20,
        }}
                    onPress={() => this.onSwitchToday()}
        >
          <MaterialCommunityIcons
            name="calendar-today"
            style={{
              height: 20,
              width: 20,
              fontSize: 22,
              textAlign: 'center',
              color: 'red',
            }}
          />
        </RectButton>
          <RectButton style={{
            alignSelf: 'flex-end',
//            marginVertical: 10,
//            marginHorizontal: 20,
          }}
                      onPress={() => this.onSwitchView()}
          >
            <MaterialCommunityIcons
              name={this.state.icon}
              style={{
                height: 20,
                width: 20,
                fontSize: 22,
                textAlign: 'center',
                color: 'red',
              }}
            />
          </RectButton>
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
export default connect(mapStateToProps)(DiaryCal)
