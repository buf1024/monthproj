热更新html，实时展示
```js
1. 安装npm包 yarn add livereload http-server
2. package.json 增加
    "client": "npm-run-all --parallel client:*",
    "client:reload-server": "livereload client/",
    "client:static-server": "http-server client/"
	npm-run-all如果不存在，则添加开发依赖
3. 需要自动刷新的html增加：
  <script>
    document.write('<script src="http://' + (location.host || 'localhost').split(':')[0] +
      ':35729/livereload.js?snipver=1"></' + 'script>')
  </script>
```

