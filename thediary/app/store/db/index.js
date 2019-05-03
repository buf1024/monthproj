import * as schema from './schema'
import * as appAct from './../actions'
import * as util from './../../utils'
import Realm from 'realm'
import moment from 'moment'
import merge from 'lodash/merge'

const DEF_SETTING = '___the_diary_default_setting_fake___'
const DEF_USER = '___the_diary_default_user_fake___'

let realm = null
export const opendb = () => {
  realm = new Realm({
    schema: [
      schema.Paragraph,
      schema.Diary,
      schema.Notification,
      schema.Setting,
      schema.User,
    ],
    schemaVersion: 1,
    readOnly: false,
  })

  let users = realm.objects('User')
  if (users.length === 0) {
    realm.write(() => {
      let user = {
        id: DEF_USER,
        name: '你的名字',
        motto: '记录记忆那无法的忘却!',
        image: '',
        isLogin: false,
        token: '',
      }
      let setting =  {
          id: DEF_SETTING,
          userId: DEF_USER,
          theme: 'defaultTheme',
          background: '',
          protect: '',
          isAutoSync: false,
      }
      user = realm.create('User', user, true)
      setting = realm.create('Setting', setting, true)
      for (let i = 0; i<10; i++) {
        let diary = {
          id: 'test_diary_' + i,
          userId: DEF_USER,
          title: '测试日记标题-' + i,
          createTime: new Date(),
          updateTime: new Date(),
        }
        realm.create('Diary', diary, true)
      }
      for (let i = 11; i<20; i++) {
        let diary = {
          id: 'test_diary_' + i,
          userId: DEF_USER,
          title: '测试日记标题-' + i,
          mood: 'smile',
          weather: 'sun',
          content: [{
            id: 'paragid' + i,
            type: 'text',
            content: `${i}这是一个content${i}\n${i}这是一个content${i}${i}这是一个content${i}${i}这是一个content${i}${i}这是一个content${i}`
          },{
            id: 'paragid' + i + 1,
            type: 'text',
            content: `${i}这是一个content${i}\n${i}这是一个content${i}${i}这是一个content${i}${i}这是一个content${i}${i}这是一个content${i}`
          },{

            id: 'paragid' + i + 2,
            type: 'todo',
            content: `${i}这是一个todo done的`,
            meta: '{"status": "done"}',
          },{
            id: 'paragid' + i + 3,
            type: 'todo',
            content: `${i}这是一个todo ongoing的`,
            meta: '{"status": "ongoing"}',
          },{
            id: 'paragid' + 4,
            type: 'text',
            content: `${i}这是一个content${i}\n${i}这是一个content${i}${i}这是一个content${i}${i}这是一个content${i}${i}这是一个content${i}`
          },],
          createTime: moment().add(i - 10, 'months').toDate(),
          updateTime: moment().add(i - 10, 'months').toDate(),
        }
        realm.create('Diary', diary, true)
      }
//      let diaries = realm.objects('Diary').
//        filtered('userId = $0', DEF_USER).
//        sorted('createTime', true)

      global.store.dispatch(appAct.initApp(util.realm2obj(user),
        util.realm2obj(setting)))

    })
  } else {
    users = realm.objects('User').filtered('isLogin = $0', true)
    if (users.length === 0) {
      users = realm.objects('User').
        filtered('id = $0', DEF_USER)
    }
    let settings = realm.objects('Setting').
      filtered('userId = $0', users[0].id)
//    let diaries = realm.objects('Diary').
//      filtered('userId = $0', DEF_USER).
//      sorted('createTime', true)

    global.store.dispatch(appAct.initApp(util.realm2obj(users[0]),
      util.realm2obj(settings[0])))
  }
}

export const updateUser = (user) => {
//  let userObj = realm.objects('User').filtered('id = $0', user.id)[0]
//  realm.write(() => {
//    userObj.name = user.name
//    userObj.motto = user.motto
//    userObj.image = user.image
//    userObj.isLogin = user.isLogin
//    userObj.token = user.token
//  })
  realm.write(() => {
    realm.create('User', user, true)
  })
}

export const updateSetting = (setting) => {
//  let settingObj = realm.objects('Setting').filtered('id = $0', setting.id)[0]
//  realm.write(() => {
//    settingObj.userId = setting.userId
//    settingObj.theme = setting.theme
//    settingObj.background = setting.background
//    settingObj.protect = setting.protect
//    settingObj.isAutoSync = setting.isAutoSync
//  })
  realm.write(() => {
    realm.create('Setting', setting, true)
  })
}

export const getDiaries = (user, dateStart, dateEnd, orderKey, orderDesc, limitStart, limitEnd) => {
  let diaries = []
  if (dateStart !== undefined && dateEnd !== undefined) {
    diaries = realm.objects('Diary').
      filtered('userId = $0 AND createTime >= $1 AND createTime < $2',
        user.id, dateStart, dateEnd)
  } else {
    diaries = realm.objects('Diary').filtered('userId = $0', user.id)
  }

  if (diaries.length > 0) {
    if (orderKey !== undefined) {
      if (orderDesc === undefined) {
        orderDesc = false
      }
      diaries = diaries.sorted(orderKey, orderDesc)
    }
    if (limitStart !== undefined) {
      if (limitEnd === -1 || limitEnd === undefined || limitEnd <= limitStart) {
        limitEnd = diaries.length
      }
      diaries = diaries.slice(limitStart, limitEnd)
    }
  }
  return diaries
}

export const deleteDiary = (diary) => {
  realm.write(() =>{
    realm.delete(diary)
  })
}

export const updateDiary = (diary) => {
  realm.write(() =>{
    try {
      realm.create('Diary', diary, true)
    } catch (e) {
      console.log('e: %o', e)
    }
//    let dbDiaries = realm.objects('Diary').filtered('id = $0', diary.id)
//    let dbDiary = null
//    if (dbDiaries.length === 0) {
//      dbDiary = realm.create('Diary', diary, true)
//    } else {
//      dbDiary = dbDiaries[0]
//
//      dbDiary.title = diary.title
//      dbDiary.createTime = diary.createTime
//      dbDiary.updateTime = new Date()
//      dbDiary.location = diary.location
//      dbDiary.mood = diary.mood
//      dbDiary.weather = diary.weather
//
//      dbDiary.worldCount = diary.worldCount
//      dbDiary.imageCount = diary.imageCount
//
//      dbDiary.isSync = diary.isSync !== undefined ? diary.isSync : false
//      dbDiary.isFlag = diary.isFlag !== undefined ? diary.isFlag : false
//      dbDiary.isTrash = diary.isTrash !== undefined ? diary.isTrash : false
//      dbDiary.isPublic = diary.isPublic !== undefined ? diary.isPublic : false
//    }
//    diary.content.forEach(p => {
//      p.diary = dbDiary
//      realm.create('Paragraph', p, true)
//    })
  })
}



