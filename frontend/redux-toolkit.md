# Redux Toolkit

## Setup


- Install packages

```
yarn add @reduxjs/toolkit
```

## Slice

- Create actions and reducer by `createSlice`

`redux/common/index.js`

```javascript
import { createSlice } from "@reduxjs/toolkit";

const initialState = {
  data: null,
};

export const commonSlice = createSlice({
  name: "common",
  initialState,
  reducers: {
    setData: (state, action) => {
      state.data = action.payload;
    }
  },
});

export const {
  setData
} = commonSlice.actions;

export default commonSlice.reducer;
```

## Store

- Create store and import reducers

`redux/store.js`

```javascript
import { configureStore } from "@reduxjs/toolkit";

import common from "./common";

const store = configureStore({
  reducer: {
    common,
  },
});

export default store;
```

- Wrapper components with store provider

```javascript
import store from "../redux/store.js";

const ReduxProvider = ({ children }) => {
  return <Provider store={store}>{children}</Provider>;
};

const App = ()=>{
  return (
    <ReduxProvider>
     // something else...
    </ReduxProvider>
  );
}
```

## AsyncThunk

- Fetch api in async Thunk

`redux/common/getData.js`

```javascript
import { createAsyncThunk } from "@reduxjs/toolkit";
import { setError } from "@/redux/error";

const getDataAsyncThunk = createAsyncThunk(
  "common/getData",
  async (payload, { dispatch }) => {
    try {
      const res = await fetch(..., payload);
      return res;
    } catch (error) {
      dispatch(setError(error));
    }
  },
);

export default getDownloadLicenseAsyncThunk;
```

- add thunk to reducers

```javascript
import { createSlice } from "@reduxjs/toolkit";
import getDataAsyncThunk from "./getData";

const initialState = {
  isLoading: false,
  data: null,
};

export const commonSlice = createSlice({
  name: "common",
  initialState,
  reducers: {
    setData: (state, action) => {
      state.data = action.payload;
    }
  },
  extraReducers: (builder) => {
    builder.addCase(getDataAsyncThunk.pending, (state) => {
      state.isLoading = true;
    });
    builder.addCase(getDataAsyncThunk.fulfilled, (state, action) => {
      state.isLoading = false;
      state.data = action.payload.data;
    });
    builder.addCase(getDataAsyncThunk.rejected, (state) => {
      state.isLoading = false;
    });
  },
});

export const {
  setData,
  getData,
} = {
  ...commonSlice.actions,
  getData: getDataAsyncThunk,
};

export default commonSlice.reducer;
```