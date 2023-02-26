Electron是一个使用 JavaScript、HTML 和 CSS 构建桌面应用程序的框架。为了节约生命，一般使用脚手架[electron-react-boilerplate](https://github.com/electron-react-boilerplate/electron-react-boilerplate)。Electron 继承了来自 Chromium 的多进程架构，包括一个主进程和渲染器进程。

主进程主要是控制应用程序的生命周期和应用窗口管理，前者主要使用`app`来管理，后者则通过`BrowserWindow`。渲染器进程负责网页的渲染，如果浏览器一样。主进程主要是访问本机的资源，渲染器进程则无法访问本机资源。为此，如果要实现两个进程的通讯，那么有两种方式：第一中则是在网页窗口创建之前，加载`preload`脚本，将数据附加于全局变量之中，通过`contextBridge`安全模块实现交互:

```tsx
const { contextBridge } = require('electron')

contextBridge.exposeInMainWorld('myAPI', {
  desktop: true
})
```

然而，实时通讯则更多的是通过第二中，`ipcRenderer`的方式，如:

```ts
// 在主进程中.
const { ipcMain } = require('electron')
ipcMain.on('asynchronous-message', (event, arg) => {
  console.log(arg) // prints "ping"
  event.reply('asynchronous-reply', 'pong')
})

ipcMain.on('synchronous-message', (event, arg) => {
  console.log(arg) // prints "ping"
  event.returnValue = 'pong'
})

//在渲染器进程 (网页) 中。
// 注意: Electron 的 API 在预加载后即可访问，直到上下文隔离被禁用
// 详见： https://www.electronjs.org/docs/tutorial/process-model#preload-scripts
const { ipcRenderer } = require('electron')
console.log(ipcRenderer.sendSync('synchronous-message', 'ping')) // prints "pong"

ipcRenderer.on('asynchronous-reply', (event, arg) => {
  console.log(arg) // prints "pong"
})
ipcRenderer.send('asynchronous-message', 'ping')
```

## 常见的任务



### 主进程 对象

- `app` 应用程序的生命周期
- `nativeTheme` 响应Chromium本地颜色
- `session` 管理web会话
- `ipcMain` ipc通讯，配合渲染器进程`ipcRenderer`使用



