import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wang_finance/constants.dart';
import 'package:wang_finance/net_utils.dart';
import 'package:wang_finance/db.dart';

class NewsPage extends StatefulWidget {
  final PageType pageType;

  NewsPage({Key key, @required this.pageType}) : super(key: key);

  @override
  State createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int beginRow = Constants.BEGIN_ROW;
  int currentRow = Constants.BEGIN_ROW;
  int rowCount = Constants.ROW_COUNT;
  bool loading = true;
  bool loadingMore = false;
  List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>();
  List<Map<String, dynamic>> favList = List<Map<String, dynamic>>();

  ScrollController _scrollController = ScrollController();
  Map<PageType, IndexedWidgetBuilder> _rowFun =
      Map<PageType, IndexedWidgetBuilder>();

  bool isFav(String newsId) {
    var index = favList.indexWhere((elm) {
      return elm['news_id'] == newsId;
    });

    debugPrint('index=$index');
    return index != -1;
  }

  void delFav(String newsId) {
    var index = favList.indexWhere((elm) {
      return elm['news_id'] == newsId;
    });
    if (index >= 0) {
      AppDb.instance()
          .delFav(favList[index]['id'])
          .then((dynamic _) => _getFav());
    }
  }

  void addFav(Map<String, dynamic> data, PageType type) {
    var newsTime = PageType.FlashNews == type
        ? (DateTime.parse(data['time']).millisecondsSinceEpoch / 1000)
            .truncate()
        : data['timestamp'];
    var newsId =
        PageType.FlashNews == type ? data['timestamp'] : data['id'].toString();

    var news = json.encode(data);

    AppDb.instance()
        .insertFav(newsTime, type.index, newsId, news)
        .then((dynamic _) => _getFav());
  }

  Function onFavPress(Map<String, dynamic> data, PageType type) {
    return () {
      bool isFavNews = data['isFavNews'];

      if (isFavNews) {
        var newsId = PageType.FlashNews == type
            ? data['timestamp']
            : data['id'].toString();

        delFav(newsId);

        return;
      }

      addFav(data, type);
    };
  }

  Widget _loadingMoreWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('加载更多数据...  '),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _flashWidget(BuildContext context, Map<String, dynamic> data) {
    var isFavNews = isFav(data['timestamp']);
    data['isFavNews'] = isFavNews;
    return InkWell(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 120),
        child: Card(
          margin: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${data["time"]}',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Center(
                      child: IconButton(
                          icon: Icon(isFavNews
                              ? Icons.favorite
                              : Icons.favorite_border),
                          color: Colors.red[300],
                          onPressed: onFavPress(data, PageType.FlashNews)),
                    ),
                    Expanded(
                      child: Text(
                        '${data["content"]}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => debugPrint('ontap'),
    );
  }

  Widget _rowFlashWidget(BuildContext context, int index) {
    if (index >= dataList.length) {
      return _loadingMoreWidget(context);
    }
    return _flashWidget(context, dataList[index]);
  }

  Widget _dataWidget(BuildContext context, Map<String, dynamic> data) {
    var isFavNews = isFav(data['id'].toString());
    data['isFavNews'] = isFavNews;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 134.0),
      child: Card(
        margin: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.network(data['logo']),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data['title'],
                              ),
                              Text(
                                '${DateTime.fromMillisecondsSinceEpoch((data["timestamp"] as int) * 1000)}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: (int stars) {
                          List<Widget> ws = List<Widget>();
                          for (var i = 0; i < 5; i++) {
                            if (i < stars) {
                              ws.add(Icon(
                                Icons.star,
                                color: Colors.yellow[800],
                                size: 20,
                              ));
                            } else {
                              ws.add(Icon(
                                Icons.star_border,
                                size: 20,
                              ));
                            }
                          }
                          return ws;
                        }(data['stars'] as int),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 35,
                    width: 80,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                          child: Text(
                        data['influence'],
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: data['influence'].toString().contains('利多')
                                ? Colors.red[600]
                                : (data['influence'].toString().contains('利空')
                                    ? Colors.green[600]
                                    : Colors.black)),
                      )),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  Center(
                    child: IconButton(
                        icon: Icon(
                            isFavNews ? Icons.favorite : Icons.favorite_border),
                        color: Colors.red[300],
                        onPressed: onFavPress(data, PageType.DataNews)),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
//                                border: Border(
//                                  left: BorderSide(),
//                                  top: BorderSide(),
//                                  bottom: BorderSide(),
//                                ),
                                  ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('前值'),
                                    Text(data['previous'])
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
//                                border: Border(
//                                  left: BorderSide(),
//                                  right: BorderSide(),
//                                ),
                                  ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('预测值'),
                                    Text(data['forecast'])
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: DecoratedBox(
                                decoration: BoxDecoration(
//                                  border: Border(
//                                    right: BorderSide(),
//                                    top: BorderSide(),
//                                    bottom: BorderSide(),
//                                  ),
                                    ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text('实际值'),
                                      Text(data['actual'])
                                    ],
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowDataWidget(BuildContext context, int index) {
    if (index >= dataList.length) {
      return _loadingMoreWidget(context);
    }
    return _dataWidget(context, dataList[index]);
  }

  Widget _rowFavWidget(BuildContext context, int index) {
    var data = json.decode(favList[index]['news']);
    if (favList[index]['news_type'] == PageType.FlashNews.index) {
      return _flashWidget(context, data);
    }
    return _dataWidget(context, data);
  }

  Widget _sepWidget(BuildContext context, int index) {
    return Divider(
      height: 1.0,
    );
  }

  void _getNews([bool loadMore = false]) async {
    try {
      var resp;
      var startRow = loadMore ? currentRow + 1 : beginRow;
      switch (widget.pageType) {
        case PageType.FlashNews:
          resp = await NetUtils.post(
              '${Constants.HOST}${Constants.FLASH_NEWS_URL}',
              params: {'beginRow': startRow, 'rowCount': rowCount});
          break;
        case PageType.DataNews:
          resp = await NetUtils.post(
              '${Constants.HOST}${Constants.DATA_NEWS_URL}',
              params: {'beginRow': startRow, 'rowCount': rowCount});
          break;
        case PageType.FavNews:
          return;
      }

      var map = json.decode(resp) as Map<String, dynamic>;

      if (map['errNum'] == '99999') {
        var list = map['retData'];
        var addMore = false;
        list.forEach((e) {
          var index = dataList.indexWhere((test) {
            switch (widget.pageType) {
              case PageType.FlashNews:
                return test['timestamp'] == e['timestamp'];
                break;
              case PageType.DataNews:
                return test['id'] == e['id'];
                break;
              case PageType.FavNews:
                break;
            }
          });
          if (index == -1) {
            addMore = true;
            dataList.add(e);
          }
        });
        if (addMore) {
          dataList.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
            switch (widget.pageType) {
              case PageType.FlashNews:
                var at = DateTime.parse(a['time']).millisecondsSinceEpoch;
                var bt = DateTime.parse(b['time']).millisecondsSinceEpoch;
                if (at == bt) {
                  return 0;
                }
                return at < bt ? 1 : -1;
                break;
              case PageType.DataNews:
                if (a['timestamp'] == b['timestamp']) {
                  return 0;
                }
                return a['timestamp'] < b['timestamp'] ? 1 : 0;
                break;
              case PageType.FavNews:
                break;
            }
          });
        }
      }
      setState(() {
        if (loadMore) {
          loadingMore = false;
          currentRow = startRow;
        } else {
          loading = false;
        }
      });
    } catch (e) {
      debugPrint('e=$e');
      showDialog(
          context: this.context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('获取信息异常'),
              content: Text('获取远程资讯异常信息!'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('关闭')),
              ],
            );
          });
      setState(() => loadMore ? loadingMore = false : loading = false);
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        _onPullUp();
      }
    });

    _rowFun[PageType.FlashNews] = _rowFlashWidget;
    _rowFun[PageType.DataNews] = _rowDataWidget;
    _rowFun[PageType.FavNews] = _rowFavWidget;

    if (widget.pageType != PageType.FavNews) {
      _getNews();
    } else {
      loading = false;
    }
    _getFav();
  }

  void _getFav() {
    AppDb.instance().getFav().then((e) {
      setState(() {
        favList = e == null ? List<Map<String, dynamic>>() : e;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: loading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '数据加载中...',
                      style: TextStyle(color: Colors.grey[700]),
                    )
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _onPullDown,
                child: ListView.separated(
                  controller: _scrollController,
                  itemBuilder: _rowFun[widget.pageType],
                  separatorBuilder: _sepWidget,
                  itemCount: widget.pageType != PageType.FavNews
                      ? (dataList.length + (loadingMore ? 1 : 0))
                      : (favList != null ? favList.length : 0),
                ),
              ));
  }

  Future<Null> _onPullDown() async {
    _getNews();
    debugPrint('_onPullDown');
  }

  Future<Null> _onPullUp() async {
    debugPrint('_onPullUp');

    if (widget.pageType == PageType.FavNews) {
      return;
    }

    if (loadingMore) {
      return;
    }
    loadingMore = true;
    _getNews(true);
  }
}
