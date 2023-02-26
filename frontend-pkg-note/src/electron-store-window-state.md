下面简单又经常使用的库：

### electron-store

electron-store是持久化用户偏好数据的。使用也及其简单:

```js
const Store = require('electron-store');

const store = new Store();

store.set('unicorn', '🦄');
console.log(store.get('unicorn'));
//=> '🦄'

// Use dot-notation to access nested properties
store.set('foo.bar', true);
console.log(store.get('foo'));
//=> {bar: true}

store.delete('unicorn');
console.log(store.get('unicorn'));
//=> undefined
```

与之类似的还有[electron-settings](https://github.com/nathanbuchar/electron-settings), [electron-storage](https://github.com/electron-userland/electron-json-storage)（推荐:star: ）。

### electron-window-state

electron-window-state是保存windows的最后状态的，使用更加简单:

```js
const windowStateKeeper = require('electron-window-state');
let win;
 
app.on('ready', function () {
  // Load the previous state with fallback to defaults
  let mainWindowState = windowStateKeeper({
    defaultWidth: 1000,
    defaultHeight: 800
  });
 
  // Create the window using the state information
  win = new BrowserWindow({
    'x': mainWindowState.x,
    'y': mainWindowState.y,
    'width': mainWindowState.width,
    'height': mainWindowState.height
  });
 
  // Let us register listeners on the window, so we can update the state
  // automatically (the listeners will be removed when the window is closed)
  // and restore the maximized or full screen state
  mainWindowState.manage(win);
});
```



