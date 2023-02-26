react-transition-group提供几个简单而又有用的组件去实现过渡效果（当然用css3实现也完全没有任何问题）。主要包括四个组件: `Transition`,  `CSSTransition`, `SwitchTransition`和`TransitionGroup`。


## Transition

`Transition`让你用一种简单的方式去描述组件进入和离开的过渡效果。Transition是和平台紧密相关的，如果追求各个平台的一致性，选择`CSSTransition`为优。Transition的使用主要是定义`默认的状态`，和`4个过渡变化状态`的样式变化。当然，各个过渡状态的变化，也有响应的函数设置。如官网示例：

``` js
import { Transition } from 'react-transition-group';

const duration = 300;

// 默认的状态
const defaultStyle = {
  transition: `opacity ${duration}ms ease-in-out`,
  opacity: 0,
}
// 过渡变化的状态
const transitionStyles = {
  entering: { opacity: 1 },
  entered:  { opacity: 1 },
  exiting:  { opacity: 0 },
  exited:  { opacity: 0 },
};

// children可用函数组件，也可以是React Component。一般用函数组件。
const Fade = ({ in: inProp }) => (
  <Transition in={inProp} timeout={duration}>
    {state => (
      <div style={{
        ...defaultStyle,
        ...transitionStyles[state]
      }}>
        I'm a fade Transition!
      </div>
    )}
  </Transition>
);
```

## CSSTransition

`CSSTransition`与`Transition`唯一不同的是，用css样式来描述过渡效果，如:

```js
function App() {
  const [inProp, setInProp] = useState(false);
  return (
    <div>
      <CSSTransition in={inProp} timeout={200} classNames="my-node">
        <div>
          {"I'll receive my-node-* classes"}
        </div>
      </CSSTransition>
      <button type="button" onClick={() => setInProp(true)}>
        Click to Enter
      </button>
    </div>
  );
}

// 描述过渡状态的样式变化
.my-node-enter {
  opacity: 0;
}
.my-node-enter-active {
  opacity: 1;
  transition: opacity 200ms;
}
.my-node-exit {
  opacity: 1;
}
.my-node-exit-active {
  opacity: 0;
  transition: opacity 200ms;
}
```

## SwitchTransition

`SwitchTransition`是两个元素的切换效果，器子只能是`Transition`或`CSSTransition`。其模式只能是`out-in|in-out`。它是新元素插入时，等旧元素移除，再插入。如:

```html
function App() {
 const [state, setState] = useState(false);
 return (
   <SwitchTransition>
     <CSSTransition
       key={state ? "Goodbye, world!" : "Hello, world!"}
       addEndListener={(node, done) => node.addEventListener("transitionend", done, false)}
       classNames='fade'
     >
       <button onClick={() => setState(state => !state)}>
         {state ? "Goodbye, world!" : "Hello, world!"}
       </button>
     </CSSTransition>
   </SwitchTransition>
 );
}
.fade-enter{
   opacity: 0;
}
.fade-exit{
   opacity: 1;
}
.fade-enter-active{
   opacity: 1;
}
.fade-exit-active{
   opacity: 0;
}
.fade-enter-active,
.fade-exit-active{
   transition: opacity 500ms;
}
```

## TransitionGroup

`TransitionGroup`就是一系列的`Transition`或`CSSTransition`，他们的动画是同时发生的。`TransitionGroup`从当状态管理机的作用。



## 与react-router结合

1. 不能使用react的Switch组件
2. 在Route组件下面使用函数生产react组件，而不是react 组件。

