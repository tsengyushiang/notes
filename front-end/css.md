# CSS

## Debug

- pseudo-class styles
  - [reference](https://stackoverflow.com/questions/6767278/how-can-i-see-the-styles-attached-to-hover-and-other-pseudo-classes-in-firebug)
  - right click `Force state` of the elemnt in `F12 elements tab`

## @media

- [reference](https://www.w3schools.com/cssref/css3_pr_mediaquery.php)

    ```
    /* widht smaller than 400px*/
    body {
        background-color: lightblue;
    }

     /* width between 400px and 800px*/
    @media screen and (min-width: 400px) {
        body {
            background-color: lightgreen;
        }
    }

     /* width bigger than 800px*/
    @media screen and (min-width: 800px) {
        body {
            background-color: lavender;
        }
    }
    ```
## Clip-path

- [web editor](https://bennettfeely.com/clippy/)
- [reference](https://segmentfault.com/a/1190000023301221)

## Flex

- [reference](https://www.casper.tw/css/2017/07/21/css-flex/)

- RWD from 2 column to 1 column

    ```css
    .item {
      width: 50%;
      height: 300px; /* Should be removed. Only for demonstration */
    }

    .container{
      display:flex;
      flex-direction:row;
      flex-wrap:wrap;
    }

    /* Responsive layout - makes the two columns stack on top of each other instead of next to each other */
    @media screen and (max-width: 600px) {
      .item {
        width: 100%;
      }
    }
    ```

## Grid

- fixed size items

    ```css
    .grid-container {
      display: grid;
      grid-template-columns: auto auto auto;    /*display 3column*/
      justify-content:center;                   /*make items close to each others and align center*/
      justify-content:left;                    /*make items close to each others and align left*/
    }
    .grid-item {
       /* sort fixed size item with grid*/
      width:100px;
      height:100px;
      word-wrap: break-word /*handle text overflow*/
    }
    ```

- items fit Grid

    ```css
    .grid-container {
      width:500px;
      height:300px;
      display: grid;
      grid-template-columns: auto auto auto;    /*display 3column*/
      margin: auto;                             /* align center*/
    }
    .grid-item {
       /* sort fixed size item with grid*/
      width: 100%;
      height: 100%;
      background-size: 100% 100%;               /* make background image fit elemnt*/
      background-image: url('https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png');
    }
    ```

## Animations

- isLoading

    ```css
    .isLoading {
      background: linear-gradient(90deg, #a4a4a4 25%, #c4c4c4 50%, #a4a4a4 75%);
      background-size: 400% 100%;
        animation: moveBackground 1.5s ease-in infinite;
    }

    @keyframes moveBackground {
        0% {
            background-position: 0% 0%;
        }
        100% {
            background-position: 100% 0%;
        }
    }
    ```

## Input 

- no outline

    ```css
    input[type=text] {
      background-color: transparent;
      border: none;
    }

    input[type=text]:focus {
        outline: none;
    }
    ```

- no typing line

  ```css
  input[type=text] {
    color: transparent;
    text-shadow: 0 0 0 #2196f3;

    &:focus {
        outline: none;
    }
  }
  ```

## Div

- keep div ratio when size change

    ```css
    .container{
      position: relative;
      width: 100%;
      padding-top: 24%; / 1024width:250height Aspect Ratio, >100% also works /
    }
    .div{
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
    }
    ```

## Text

- align text to center
    
    - [refernece](https://shinyu0430.github.io/2021/09/21/maxwidthminwidthfitcontent/)

    ```css
    .wrapper {
      width: fit-content;
      margin: auto;
    }
    ```

## Mouse

- disabel mouse event

    ```css
    pointer-event : none;

    /*default*/
    pointer-event : auto;
    ```

## Before/After

- content 
    
    - [reference](https://ithelp.ithome.com.tw/articles/10197087)
    ```Ccs
    div:before {
        content: "+";
        content: url(w3css.gif);
    }
    ```


## Pure CSS DropDown Menu

- [Demo](https://codepen.io/tsengyushiang-the-typescripter/pen/jOKymaR)
- css

```
.open{
  width:24px;
  height:24px;
  text-align: center;
  border:black 1px solid;
}
.open:after{
  content: '\276F';
}
#focusDetector:focus-within .open{
  transform: rotate(90deg);
  pointer-events:none;
}

#closeButton{
  width:24px;
  height:24px;
  background:red;
  text-align: center;
  width:100%;
}
#closeButton:after{
  content: "\00d7";
}

#focusDetector:focus-within #dropDownMenu{
  display:flex;
}
#dropDownMenu{
  display:none;
  flex-direction:column;
  width: fit-content;
  background:gray;
}

#itemsWrapper{
  background:yellow;
}

.item{
  padding:10px
}
```
- HTML

```
<div id="focusDetector">
  <div class="open" tabIndex="0"></div>
  <div id="dropDownMenu">
    <div id="closeButton"></div>
    <div id=itemsWrapper tabIndex="0">
      <div class="item">Home</div>
      <div class="item">Blog</div>
      <div class="item">FAQ</div>
      <div class="item">Login</div>
    </div>
  </div>
</div>
```
