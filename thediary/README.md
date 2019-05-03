# thediary
这不是react native的最佳实践，存在不可以预料的缺陷。  

本来为了避免react native生疏，而进行的训练，以为写的多了自然也熟练。但react native时不时会踩些不可以预料的坑，大多数情况下在debug模式没问题，在release模式下重现。所以没有继续写下去。

release模式存在的两个大坑：
1. 在某些机型下，调用一个简单函数仅仅是***进入***函数体莫名其妙耗时22秒左右(通过adb logcat加日志查看)。有时停止不操作页面，应用主动退出。 adb logcat提示out of memory。
2. 停止操作，莫名其妙直接退出，adb logcat查看收到`signal 11 (SIGSEGV)`，

公开是为了可能得到高人指点，感谢：~


