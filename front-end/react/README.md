# React 16.8 Hook

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