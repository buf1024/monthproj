import {combineReducers} from 'redux'
import * as appAct from '../actions'
import merge from 'lodash/merge'

// 约定 dispatch action 定义为: {action: type, payload: data}
const appInitState = {
  isCameraOn: false,
  user: {},
  setting: {}
}
const app = (state = appInitState, action) => {
  switch (action.type) {
    case appAct.INIT_APP:
      return  merge({}, state, action.payload)
    case appAct.UPDATE_USER:
      return  merge({}, state, action.payload)
    case appAct.UPDATE_SETTING:
      return  merge({}, state, action.payload)
    case appAct.UPDATE_DIARIES:
      return  merge({}, state, action.payload)
    case appAct.UPDATE_INFO:
      return  merge({}, state, action.payload)
  }
  return state
}

export default combineReducers({
  app
})
