# thediary
这是模仿电影《你的名字。》(君の名は。)里面的日记应用，编写的目的单纯是为了避免长时间不编写react native而造成技术上的生疏，没有特殊的含义。

这不是完整版，也不打算编写完整（生成部分功能apk, [thediary.apk](https://github.com/buf1024/monthproj/raw/master/thediary/release/thediary.apk)）。这也不是react native的最佳实践，存在不少不可预料的缺陷。  

react native开始开发是很快的，但总是会遇到各种各样的小问题，当然这些问题都可能找到答案，但有时遇到的太多也是很烦人，特别是那些大多数情况下在debug模式没问题，在release模式下重现，调试找问题及其麻烦，当然有可能是使用方式的不规范造成的。所以，费事，而且需要比较深的功底。

单从这个应用来说，release模式存在的很大的两个问题：
1. 在某些机型下，调用一个简单函数仅仅是***进入***函数体莫名其妙耗时22秒左右(通过adb logcat加日志查看)。有时停止不操作页面，应用主动退出。 adb logcat提示out of memory。
2. 停止操作，莫名其妙直接退出，adb logcat查看收到`signal 11 (SIGSEGV)`，

这不是说不使用react native，自己使用过react native编写的应用上线的工作良好，而且目前也有很多公司使用react native。只是想说，应用react native，需要谨慎评估使用的各种依赖库，和规范各种使用方式。

也因此，尝试新的替代品 -- 比如flutter。

### 相关截图
<table>
<tr>
<td><img src="https://raw.githubusercontent.com/buf1024/monthproj/master/thediary/ui/thediary1.png" /></td>
<td><img src="https://raw.githubusercontent.com/buf1024/monthproj/master/thediary/ui/thediary2.png" /></td>
<td><img src="https://raw.githubusercontent.com/buf1024/monthproj/master/thediary/ui/thediary3.png" /></td>
</tr>
<tr>
<td><img src="https://raw.githubusercontent.com/buf1024/monthproj/master/thediary/ui/thediary4.png" /></td>
<td><img src="https://raw.githubusercontent.com/buf1024/monthproj/master/thediary/ui/thediary5.png" /></td>
</tr>
</table>


