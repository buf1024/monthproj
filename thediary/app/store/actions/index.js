import * as utils from './utils'

export const INIT_APP = 'INIT_APP'
export const initApp = (user, setting) => utils.action(INIT_APP, {payload: {user, setting}})

export const UPDATE_USER = 'UPDATE_USER'
export const updateUser = (user) => utils.action(UPDATE_USER, {payload: {user}})

export const UPDATE_SETTING = 'UPDATE_SETTING'
export const updateSetting = (setting) => utils.action(UPDATE_SETTING, {payload: {setting}})

export const UPDATE_DIARIES = 'UPDATE_DIARIES'
export const updateDiaries = (diaries) => utils.action(UPDATE_DIARIES, {payload: {diaries}})


export const UPDATE_INFO = 'UPDATE_INFO'
export const updateInfo = (payload) => utils.action(UPDATE_INFO, {payload})
