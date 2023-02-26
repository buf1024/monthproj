electron-updater 是electron-builder提供的自动更新方案，支持多种渠道进行app更新。

使用方式比较简单，如:

```js
import { autoUpdater } from "electron-updater"

autoUpdater.checkForUpdatesAndNotify()/autoUpdater.checkForUpdates()
```

当然更新过程可以监控，则监听进度事件，如:

```js
autoUpdater.on('checking-for-update', () => {});
autoUpdater.on('update-not-available', e => {});
autoUpdater.on('update-available', e => {});
autoUpdater.on('update-downloaded', info => {});
...
```

可以设置，更新的地址，服务器等，如:

```js
autoUpdater.setFeedURL({
    provider: 'generic',
    url: 'http://localhost:8080/'
  });
```

不过貌似，package.json里面也可以设置:

```json
    "publish": [
      {
        "provider": "generic",
        "url": "http://localhost:8080/"
      }
    ]
```

