# hellodiary
这是模仿电影《你的名字。》(君の名は。)里面的日记应用，react-native编写过相同的应用（不完整）[hellodiary](https://github.com/buf1024/monthproj/tree/master/thediary)，
而这里是flutter实现。为什么写两个一样的东西？为了可对比性，毕竟react native的坑太多。

当然，flutter在学习中，而且用的是很零星的时间，很多东西都不熟悉，使用也不规范，所以错误也难免。

主要技术点，使用的flutter中的bloc设计模式，不过在没全面了解bloc最佳实践之前，就进行了编码，使用的姿态也可能是错的。

按照大神的说法，比如每一个页面都有其自己的bloc，这里为了简单，只使用了一个bloc，所以的页面都共享这个bloc，而且
这个bloc又自带了状态管理，没有使用相应的工具对状态独立出来管理，显得稍微混乱。等等其他。

不过，虽然dart使用起来开始不太适应，不过看久，也慢慢接受，上手还算简单。

~~PS： 由于flutter生态比较小，富文本编辑器没找到相对好用的。找到一个zefyr，可以勉强使用，当有BUG，
虽然不是由于zefyr引入，但作者好像不打算修复。参考修改：~~

~~https://github.com/tdh8316/zefyr/commit/614fa2b34b5e7324851f97108fe7cd9d9fb9757f
packages/zefyr/lib/src/widgets/editable_text.dart~~

```dart
- import 'package:flutter/cupertino.dart';
+ import 'package:flutter/material.dart';

- controls: cupertinoTextSelectionControls,
+ controls: materialTextSelectionControls,
```

### 相关截图
<table>
<tr>
<td><img src="https://raw.githubusercontent.com/buf1024/monthproj/master/hellodiary/assets/images/1.png" /></td>
<td><img src="https://raw.githubusercontent.com/buf1024/monthproj/master/hellodiary/assets/images/2.png" /></td>
<td><img src="https://raw.githubusercontent.com/buf1024/monthproj/master/hellodiary/assets/images/3.png" /></td>
</tr>
<tr>
<td><img src="https://raw.githubusercontent.com/buf1024/monthproj/master/hellodiary/assets/images/4.png" /></td>
<td><img src="https://raw.githubusercontent.com/buf1024/monthproj/master/hellodiary/assets/images/5.png" /></td>
<td><img src="https://raw.githubusercontent.com/buf1024/monthproj/master/hellodiary/assets/images/6.png" /></td>
</tr>
</table>

### 备注
由于flutter相对不稳定，版本的升级，可能导致程序无法编译和运行，当前使用的sdk为:
```
#flutter --version
Flutter 1.12.13+hotfix.8 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 0b8abb4724 (7 weeks ago) • 2020-02-11 11:44:36 -0800
Engine • revision e1e6ced81d
Tools • Dart 2.7.0
```
