class Constants {
  static const HOST = 'http://127.0.0.1:16888';
  static const FLASH_NEWS_URL = '/appserv/api/news/getNewsFlashList';
  static const DATA_NEWS_URL = '/appserv/api/news/getNewsDataList';

  static const BEGIN_ROW = 0;
  static const ROW_COUNT = 10;
}

enum PageType {
  FlashNews,
  DataNews,
  FavNews
}

/**
 服务器随时会关闭，备份api接口

// /appserv/api/news/getNewsFlashList
{
  "errNum": "99999",
  "errMsg": "success",
  "retData":
  [
    {
      "id": 1325046,
      "importance": 1,
      "influence": "利多金银",
      "level": 0,
      "mark": null,
      "previous": "170.00",
      "actual": "195.00",
      "forecast": "",
      "revised": "174.00",
      "push_status": 0,
      "related_assets": null,
      "remark": null,
      "stars": 2,
      "timestamp": 1555491600,
      "title": "2月季调后贸易帐(亿欧元)",
      "accurate_flag": 0,
      "calendar_type": null,
      "category_id": 0,
      "country": "欧元区",
      "currency": "EUR",
      "description": null,
      "event_row_id": null,
      "flagURL": null,
      "ticker": null,
      "subscribe_status": 0,
      "news_time": "2019-04-17 17:00:00",
      "news_type": "data"
    },
  ]
}

//    /appserv/api/news/getNewsDataList
{
  "errNum": "99999",
  "errMsg": "success",
  "retData": [
    {
      "content": "【Uber自动驾驶部门获软银丰田等10亿美元注资】注资后Uber先进技术集团（Advanced Technologies Group）的估值达到72.5亿美元。根据协议，软银将通过其愿景基金向优步自动驾驶部门注资3.33亿美元，丰田和日本汽车零部件供应商电装公司将联合注资6.67亿美元。",
      "score": 1,
      "symbols": "[]",
      "time": "2019-04-19 08:51:00",
      "timestamp": "565786023EB4D942E8127E9146357063"
    },
  ]
}
*/
