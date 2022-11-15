# redux-saga

## Setup


- [files changes example](https://github.com/tsengyushiang/next.js/pull/1/files)

- install packages

    ```
    yarn add react-redux redux-saga immer
    ```
    - redux : global state
    - reduex-saga :  middleware is used for async request
    - immer : work with immutable state in a more convenient way


- 8 files you need to setup for this tutorial

    ```
    .
    └── config
    |   └── configureStore.js
    └── constants
    |   └── demo.js
    └── pages
    |   └── _app.js
    |   └── demo-redux-saga.js (optional it's for demo)
    └── redux
        ├── actions
        |   └── demo.js
        └── reducers
        |   └── demo.js
        |   └── todo.js
        └── sagas
            └── demo.js
            └── todo.js
    ```

- constant

    `./constants/demo.js`
    
    ```javascript
    // dispatch to saga from hook
    export const ACTION_DEMO_ADD = "ACTION_DEMO_ADD";

    // dispatch to redux from saga 'put' effect
    export const ACTION_DEMO_ADD_SUC = "ACTION_DEMO_ADD_SUC";
    ```

- redux-saga

    `./redux/sagas/demo.js` : watch saga dispacth.
    
    ```javascript
    import { takeEvery, put, select } from "redux-saga/effects";
    import { ACTION_DEMO_ADD, ACTION_DEMO_ADD_SUC } from "../../constants/demo";

    let counter = 0;

    function* add({ text }) {
        const { items } = yield select(state => state.demo)
        yield put({
            type: ACTION_DEMO_ADD_SUC,
            payload: [...items, {
                text,
                id: counter++
            }]
        })
    }

    export default [
        takeEvery(ACTION_DEMO_ADD, add)
    ]
    ```

    `./redux/sagas/index.js` : export all sagas to watch at the same time.
    
    ```javascript
    import { all } from "redux-saga/effects"
    import demo from "./demo" // remove this in your app

    export default function* rootSaga() {
        yield all([...demo])
    }
    ```

- reducer

    `./redux/reducers/demo.js` : watch saga's 'put' effect to call reducer with preprocessed data
    
    ```javascript
    import produce from "immer";
    import { ACTION_DEMO_ADD_SUC } from "../../constants/demo";
    const initialState = {
        items: []
    }

    const todo = (state = initialState, action) => produce(state, draft => {
        switch (action.type) {
            case ACTION_DEMO_ADD_SUC:
                draft.items = action.payload;
                break
            default:
                break
        }
    })

    export default todo;
    ```

    `./redux/reducers/index.js` : watch all actions includes sagas' put effect and original redux dispatch
    
    ```javascript
    import { combineReducers } from "redux";
    import demo from "./demo"

    const rootReducer = combineReducers({
        demo
    })

    export default rootReducer;
    ```

- action

    `./redux/actions/demo.js` :  funtion use to dispatch saga or redux depends on  `type`
    
    ```javascript
    import { ACTION_DEMO_ADD } from "../../constants/demo";

    export const demo = (text) => {
        return {
            type: ACTION_DEMO_ADD,
            text
        }
    }
    ```

- store with saga

    `./config/configureStore.js`

    ```javascript
    import { createStore, applyMiddleware } from "redux";
    import createSagaMiddleware from "redux-saga";

    import rootReducer from "../redux/reducers";
    import rootSaga from "../redux/sagas";

    const sagaMiddleware = createSagaMiddleware();

    export default createStore(rootReducer, applyMiddleware(sagaMiddleware));

    sagaMiddleware.run(rootSaga);
    ```

- use store in app

    `./pages/_app.js` : use provider with store

    ```javascript
    import { Provider } from "react-redux";
    import store from "../config/configureStore";

    function MyApp({ Component, pageProps }) {
      return (
        <Provider store={store}>
          <Component {...pageProps} />
        </Provider>
      )
    }
    
    export default MyApp
    ```

- add page for testing `pages/demo-redux-saga.js` and visit http://localhost:3000/demo-redux-saga

    ```javascript
    import { useState } from "react"
    import { useSelector, useDispatch } from "react-redux"
    import { demo } from "../redux/actions/demo"

    const TextInput = () => {
        const [text, setText] = useState("")
        const items = useSelector(state => state.demo)
        const dispatch = useDispatch()

        const onChange = (e) => {
            setText(e.target.value)
        }

        const onClick = () => {
            dispatch(demo(text))
            setText("")
        }

        return <>
            <pre>{JSON.stringify(items, null, 4)}</pre>
            <input type="text" value={text} onChange={onChange} />
            <button onClick={onClick}>add</button>
        </>
    }

    export default function App(){
        return <TextInput/>
    }
    ```

## Flow chart of Load data

```mermaid
sequenceDiagram
       
    Note left of UI: onClick
    par Call Reducer
        UI->>Redux: 1.dispatch(ACTION_LOAD_DATA)
    and Call Redux-saga
        UI->>Redux-saga: 1.dispatch(ACTION_LOAD_DATA)
    end
    
    Redux->>UI: 2.loading=true
    
    opt Need Current State
        Redux-saga-->>+Redux: 3.yield select(state=>state)
        Redux-->>-Redux-saga: 4.data
    end
    
    Redux-saga->>+Server: 5.yield call(api)
    Server-->>-Redux-saga: 6.response
    
    alt SUCCESS
        Redux-saga->>Redux: 7.yield put(ACTION_LOAD_DATA_SUCCESS)
        Redux->>UI: 8.loading=false, data
    else FAIL
        Redux-saga->>Redux: 7.yield put(ACTION_LOAD_DATA_FAIL)
        Redux->>UI: 8.loading=false, error message 
    end

```
