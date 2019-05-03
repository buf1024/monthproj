export const Paragraph = {
  name: 'Paragraph',
  primaryKey: 'id',
  properties: {
    id: 'string',
    diary: {type: 'linkingObjects', objectType: 'Diary', property: 'content'},
    type: 'string',
    content: 'string',
    meta: 'string?'
  }
}
export const Diary = {
  name: 'Diary',
  primaryKey: 'id',
  properties: {
    id: 'string',
//    user: {type: 'linkingObjects', objectType: 'User', property: 'diary'},
    userId: 'string',
    title: 'string',
    content: 'Paragraph[]',
    createTime: 'date',
    updateTime: 'date',
    location: 'string?',
    mood: 'string?',
    weather: 'string?',
    worldCount: {type: 'int', default: 0},
    imageCount: {type: 'int', default: 0},
    isSync: {type: 'bool', default: false},
    isFlag: {type: 'bool', default: false},
    isTrash: {type: 'bool', default: false},
    isPublic: {type: 'bool', default: false},
  }
}

export const Notification = {
  name: 'Notification',
  primaryKey: 'id',
  properties: {
    id: 'string',
//    user: {type: 'linkingObjects', objectType: 'User', property: 'notification'},
    userId: 'string?',
    type: 'string',
    content: 'string',
    receiveTime: 'date',
    isRead: {type: 'bool', default: false},
    isTrash: {type: 'bool', default: false}
  }
}

export const Setting = {
  name: 'Setting',
  primaryKey: 'id',
  properties: {
    id: 'string',
//    user: {type: 'linkingObjects', objectType: 'User', property: 'setting'},
    userId: 'string',
    theme: 'string?',
    background: 'string?',
    protect: {type: 'string', default: ''},
    isAutoSync: {type: 'bool', default: false},
  }
}
export const User = {
  name: 'User',
  primaryKey: 'id',
  properties: {
    id: 'string',
    name: 'string',
    motto: 'string',
    image: 'string',
    isLogin: 'bool',
    token: 'string?',
//    notification: 'Notification[]',
//    setting: 'Setting',
//    diary: 'Diary[]',
  }
}

