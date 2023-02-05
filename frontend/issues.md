# Issues

## React 

* image not update cause by catch

    ```
    // forced update image by sending request use time as param
    const url = new URL(user.icon_url);
    url.searchParams.append("time", moment().unix());
    ```