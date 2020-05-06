flutter动画大体分两类：一类是被称为隐式动画widget，这类widget继承于`ImplicitlyAnimatedWidget`，通常以`Animated`开头，里面封装了动画属性，通过设置属性，即可实现简单动画效果。另一类，则是手工控制的动画，较为灵活，可以实现比较复杂的自定义动画效果。第一类，可通过查看widget类，即可使用。这里简单说一下第二类。

概括来说，flutter动画包括两个概念(P.S.:这类是自己的理解，和官网稍稍不一样)：
- `AnimationValue` 动画值
  比如`Animated<double>`，范围为0到1之间, `Tween<double>(...)`，自动定义范围值, `CurvedAnimation`，（如非常牛逼的贝塞尔曲线）非线性曲线三大类。

- `AnimationController` 控制器, 控制`AnimationValue`
  控制器可以监听`addListener`和`addStatusListener`,或进行控制。

除此之外，为方便动画编写，flutter已经定义了很多动画效果，可以直接用，也添加一些方便动画编写的widget。

一些简单的动画效果，google的参考[assets-for-api-docs](https://github.com/flutter/assets-for-api-docs) 上面有动画效果的影片，可以参考。如果需要定制贝塞尔曲线，[cubic-bezier](https://cubic-bezier.com/)这个网页可以设置好特定的值，预览效果后，复制值来使用。
```
// linear	匀速的
// decelerate	匀减速
// ease	开始加速，后面减速
// easeIn	开始慢，后面快
// easeOut	开始快，后面慢
// easeInOut	开始慢，然后加速，最后再减速
```

模拟日历翻转效果：
<img src="https://raw.githubusercontent.com/buf1024/monthproj/master/flutter-daydayup/animation/assets/images/calendar.gif" alt="日历翻转" width="25%" height="25%" align="middle" />

模拟卡片翻转效果：
<img src="https://raw.githubusercontent.com/buf1024/monthproj/master/flutter-daydayup/animation/assets/images/card.gif" alt="卡片翻转" width="25%" height="25%" align="middle" />
