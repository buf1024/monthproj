create-react-app是官方的脚手架app。

提供0 webpacke的最基本使用方式（当然实际上怎么可能不接触webpack, Babel, ESLint这些？）：
```
# npx的使用方式参考阮一峰文章: http://www.ruanyifeng.com/blog/2019/02/npx.html
npx create-react-app my-app

# 可以知道模板, 如使用typescript:
npx create-react-app my-app --template typescript

# 如开始时忘记添加typescript，后面可以继续添加，如:
yarn add typescript @types/node @types/react @types/react-dom @types/jest

```

诚然，谁不接触webpack, Babel, ESLint等等这些工具呢。所以提供命令释放这些默认的配置文件让你修改:
```
yarn eject
```
需要注意，此步不可逆。不过create-react-app说，你如果不熟悉这些，你根本不要eject。不过我想，了解细节还是必须，这样你才自由。

不过，对应常用的功能，create-react-app，通过内部的配置，基本可以设定，如果不需要深入了解，其实也是够的了。