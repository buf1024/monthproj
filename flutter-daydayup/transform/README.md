### Transform组件
```dart
Transform({
    Key key,
    @required this.transform,
    this.origin,           // 视觉原点，alignment不为空时，同时作用
    this.alignment,        // 类似origin，提供更方便设置，origin不为空时，同时作用
    this.transformHitTests = true,
    Widget child,
  })
```

`Transform`组件可以进行`diagonal3Values`缩放，`skew`扭曲，`translationValues`移动和`rotationX Y Z`旋转等操作。同时可以提供3d视角功能，更加`origin`和`alignment`提供不同的角度。配合动画，可以实现比较符合物理现实的效果。`Transform`完成这些功能是通过一个叫`Matrix4`的4X4矩阵完成的。具体这些矩阵具体的内容是什么意思，我自己没搞明白。

3D实现是通过设置变换矩阵第3行第2列的值完成的，该值是一个比较小的值，如0.0001等。
```dart
Matrix4.identity()..setEntry(3, 2, v)..rotateY(y),
```