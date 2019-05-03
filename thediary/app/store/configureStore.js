import { createStore, applyMiddleware } from 'redux'
import rootReducer from './reducers'

const middleWares = []

const configureStore = (/*initialState*/) => {
  let store = createStore(
    rootReducer,
    //initialState,
    //compose(applyMiddleware(...middlewares))
    applyMiddleware(...middleWares)
  )

  global.store = store

  return store
}

export default configureStore
