## 水波纹

水波纹的实现本质上是非常简单的动画和自绘组件的运用。

这里用两种实现方式（具体是实现方式多样），两种方式都是运用到了二次贝塞尔曲线的，原理较为简单。

第一种方式，在容器的左右两侧，分别设置两点，分别为二次贝塞尔曲线的开始点和结束点，取开始和中间某点为控制点。简单实现效果如下：

<img src="https://raw.githubusercontent.com/buf1024/monthproj/master/flutter-daydayup/wave_paint/assets/images/wave.gif" alt="水波纹" width="20%" height="20%"/>

第一种方式，预先画好水波纹，左右相对有一定的容器溢出，然后对画好的水波纹进行左右移动动画控制，看起来就是运动的。简单实现效果如下：

<img src="https://raw.githubusercontent.com/buf1024/monthproj/master/flutter-daydayup/wave_paint/assets/images/wave2.gif" alt="水波纹" width="20%" height="20%"/>
