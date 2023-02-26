不同于log4js系列，debug通过环境变量控制日志，使用起来异常简单:

```js
let _debug = require('debug')

let debug = _debug('main:debug')
let info = _debug('main:info')

debug('debug log')
info('info log')
```



运行:

```shell
^_^@]$ DEBUG=main.*,-not_this node a.js
  main:debug debug log +0ms
  main:info info log +0ms
```

