export const realm2obj = (realm, schema) => {
  let obj = {}
  Object.entries(realm).forEach(([key, value]) => {
    if (schema === undefined || schema !== 'Diary') {
      if (key === 'diary') {
        return
      }
      obj = {...obj, [key]: value}
    } else {
      let content = []
      if (key === 'content') {
        value.forEach(v => {
          content.push(realm2obj(v))
        })
        obj = {...obj, [key]: content}
      } else {
        obj = {...obj, [key]: value}
      }
    }
  })
  return obj
}

export const getWeek = (date) => {
  switch (date.weekday()) {
    case 0:
      return '星期天'
    case 1:
      return '星期一'
    case 2:
      return '星期二'
    case 3:
      return '星期三'
    case 4:
      return '星期四'
    case 5:
      return '星期五'
    case 6:
      return '星期六'
  }
  return ''
}

export const getDateStr = (date) => {
  const table = {
    0: '零',
    1: '一',
    2: '二',
    3: '三',
    4: '四',
    5: '五',
    6: '六',
    7: '七',
    8: '八',
    9: '九',
    10: '十',
    11: '十一',
    12: '十二',
  }
//  let year = date.year()
  let month = date.month() + 1
//  let yearStr = ''
//  while (year > 0) {
//    yearStr = table[year % 10] + yearStr
//    year = parseInt(year / 10)
//  }
  let monthStr = table[month]

//  return `${yearStr}年${monthStr}月`
  return `${monthStr}月`
}


