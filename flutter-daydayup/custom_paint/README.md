如果要实现一个比较复杂或者基础组件难以通过组合实现的组件，通常需要`Canvas`（画布，几乎所有UI框架都提供`canvas`对象，提供类似的api）。

### `CustomPaint`组件自绘
flutter实现自绘组件的一种方式，是通过`CustomPaint`组件实现的。`CustomPaint`提供2D的画布`Canvas`，要实现自绘，需要提供画笔`CustomPainter`。`CustomPainter`是抽象类，所以要实现自绘，需实现`CustomPainter`的接口。
```dart
const CustomPaint({
    Key key,
    this.painter,     // 画笔，CustomPaint
    this.foregroundPainter, // 画笔，CustomPaint
    this.size = Size.zero,
    this.isComplex = false,
    this.willChange = false,
    Widget child,
  })

// 实现画笔
class MyTickerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 自绘逻辑
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
```
通常，为了防止`CustomPaint`组件溢出自定义区域，`CustomPaint`组件经常使用`ClipRect`组件包裹，如果`CustomPaint`有child(child参数不为空)，通常情况下都会将子节点包裹在`RepaintBoundary`组件中，以提高性能。所以，使用`CustomPaint`的结构为：
```dart
ClipRect(
  child: CustomPaint(
    size: Size(320, 120),
    painter: MyTickerPainter(),
  ),
),
```
要想自绘得心应手，必不可少的熟练掌握`Canvas`和`Path`的使用。示例：
![优惠券](https://raw.githubusercontent.com/buf1024/monthproj/master/flutter-daydayup/custom_paint/assets/images/custom_paint.jpg)

与之类似的组件有`ClipXX`，剪裁组件，提供`ShapeBorder`，边框修饰（剪裁），属性的组件。

### `ShapeBorder`属性
`Material`等很多组件都有该属性
```dart
// ShapeBorder 内部实现的组件有
// BeveledRectangleBorder -> 方形斜切角边框
// BoxBorder(抽象类) -> Border/BorderDirectional -> 边框装饰
// CircleBorder -> 圆形边框
// ContinuousRectangleBorder ->  圆角边框，比RoundedRectangleBorder更圆滑，幅度更小
// InputBorder(抽象类) -> OutlineInputBorder/UnderlineInputBorder -> 4边框、下边框
// RoundedRectangleBorder  ->  圆角边框
// StadiumBorder -> 圆角边框, 类似于ContinuousRectangleBorder和RoundedRectangleBorder，只是圆角大小根据组件大小已经设好
```
当以上内部实现的`ShapeBorder`不能实现自己所需功能时，`ShapeBorder`提供自定义选项：
```dart
// 需注意的是，如果重写paint，将paint在子组件之上(可能覆盖子组件)
class MyShapeBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    // 内边框
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    // 外边框
    return null;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    // 重绘
  }

  @override
  ShapeBorder scale(double t) {
    // 缩放
    return null;
  }
}
```
![电池](https://raw.githubusercontent.com/buf1024/monthproj/master/flutter-daydayup/custom_paint/assets/images/battery.jpg)

### `ClipXX`，剪裁组件
剪裁组件通过剪裁外边框实现特殊形状，剪裁区域可以通过 `clipper`指定，可通过实现 `CustomClipper<Rect>`抽象类提供自定义剪裁
```dart
// ClipRect -> 方形剪裁，通常和Align一起使用
// ClipRRect -> 圆角剪裁
// ClipOval -> 椭圆剪裁
// ClipPath -> 路径剪裁（较为耗时）

```

如果以上剪裁方式都不能实现特殊的形状，那么通过`CustomPaint`则可以实现各类的形状。
