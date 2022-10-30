# Global storage 

## Redux

- reference : https://chentsulin.github.io/redux/docs/basics/Reducers.html
- create `action`

  ```
  export function addTodo(text) {
    return { type: ADD_TODO, text }
  }
  ```

- create `reducer`

  reducer always return new value instead of modification.
  
  ```
  import { combineReducers } from 'redux'

  function visibilityFilter(state = SHOW_ALL, action) {
    switch (action.type) {
      case SET_VISIBILITY_FILTER:
        return action.filter
      default:
        return state
    }
  }

  function todos(state = [], action) {
    switch (action.type) {
      case ADD_TODO:
        return [
          ...state,
          {
            text: action.text,
            completed: false
          }
        ]
      default:
        return state
    }
  }

  const todoApp = combineReducers({
    visibilityFilter,
    todos
  })

  export default todoApp
  ```

- create `store`
  ```
  import { Provider } from 'react-redux'
  import { createStore } from 'redux'
  import todoApp from './reducers'
  import App from './components/App'

  let store = createStore(todoApp)

  render(
    <Provider store={store}>
      <App />
    </Provider>,
    document.getElementById('root')
  )
  ```
- dispatch Action
  ```
  // 記錄初始 state
  console.log(store.getState())

  // 每次 state 變更，就記錄它
  // 記得 subscribe() 會回傳一個用來撤銷 listener 的 function
  let unsubscribe = store.subscribe(() =>
    console.log(store.getState())
  )

  // Dispatch 一些 action
  store.dispatch(addTodo('Learn about actions'))
  store.dispatch(setVisibilityFilter(VisibilityFilters.SHOW_COMPLETED))

  // 停止監聽 state 的更新
  unsubscribe()
  ```

## React Redux with Hooks

- `npm install --save react-redux`
- Redux component: parse store to props `todos` and `onTodoClick` in following example.
  ```
  import { connect } from 'react-redux'
  import { toggleTodo } from '../actions'

  const TodoList = ({ todos, onTodoClick }) => (...)

  const mapStateToProps = (state) => {
    return {
      todos: state.todos
    }
  }

  const mapDispatchToProps = (dispatch) => {
    return {
      onTodoClick: (id) => {
        dispatch(toggleTodo(id))
      }
    }
  }

  const VisibleTodoList = connect(
    mapStateToProps,
    mapDispatchToProps
  )(TodoList)

  export default VisibleTodoList
  ```

- Hooks :
  - reference https://ithelp.ithome.com.tw/articles/10251966
  - use `useDispatch` instead of `mapStateToDispatch`
  - use `useSelector` instead of `mapStateToProps`
  - use `useCallback` to aviod redundant rerender
  - use `useStore` can get store object, but component will not automatically update if the store state changes.

  ```
  import React, { useCallback } from 'react'
  import { useDispatch, useSelector} from 'react-redux'

  export const CounterComponent = () => {
    const counter = useSelector(state => state.counter)
    const dispatch = useDispatch();

    // use useCallback to aviod redundant rerender
    const incrementHandler = useCallback(
    () => dispatch({ type: 'INCREMENTHANDLER' }),
    [dispatch]
    );
    
    return (
      <div>
        <span>{counter}</span>
        <button onClick={() => incrementHandler )}>
          Increment counter
        </button>
      </div>
    )
  }
  ```

## React Context Hook

- variable to update components
    -  `useContext` cross components

        `ThreeContextType.ts`
        ```
        export interface ThreeContextType
        {   
            url: string;
            setUrl: ( value: string ) => void;   
        };

        const ThreeContext = React.createContext<ThreeContextType | undefined>( {
            url: "",
            setUrl: () => { },
        } )
        ```

        `App.ts`
        ```
        function App()
        {
            const [ url, setUrl ] = React.useState( "" );
            const defaultValue: ThreeContextType = { url, setUrl}

            return (            
                <div className="App">
                    <TopMenu />
                    <ThreeContext.Provider value={ defaultValue }>
                        <PropertyMenu />
                        <ThreeCanvas />
                    </ThreeContext.Provider>
                </div>
            );
        }
        ```

        `PropertyMenu.ts`
        ```
        const {url, setUrl } = useContext( ThreeContext );
        ```

    -  `useState` in component


