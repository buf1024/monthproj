dotenv通过文件.env把变量添加到process.env中。

使用：

```js
const db = require('db')
db.connect({
  host: process.env.DB_HOST,
  username: process.env.DB_USER,
  password: process.env.DB_PASS
})

// .env内容
// DB_HOST=localhost
// DB_USER=root
// DB_PASS=s1mpl3
```

