# Spread Sheet API

## Sample Data

| name  | dept      | lunchTime | salary | hireDate   | age | isSenior | seniorityStartTime  |
|-------|-----------|-----------|-------:|------------|-----|----------|---------------------|
| John  | Eng       | 12:00:00  |   1000 | 2005-03-19 | 35  | TRUE     | 2007-12-02 15:56:00 |
| Dave  | Eng       | 12:00:00  |    500 | 2006-04-19 | 27  | FALSE    | null                |
| Sally | Eng       | 13:00:00  |    600 | 2005-10-10 | 30  | FALSE    | null                |
| Ben   | Sales     | 12:00:00  |    400 | 2002-10-10 | 32  | TRUE     | 2005-03-09 12:30:00 |
| Dana  | Sales     | 12:00:00  |    350 | 2004-09-08 | 25  | FALSE    | null                |
| Mike  | Marketing | 13:00:00  |    800 | 2005-01-10 | 24  | TRUE     | 2007-12-30 14:40:00 |

## Data Parser

- Converts text from api response to array.

```javascript
const mapText2Array = (sheets) => {
  if (!sheets) return null;

  const sheetsPattern =
    /google\.visualization\.Query\.setResponse\(([\s\S\w]+)\)/;
  const sheetJson = sheets.match(sheetsPattern);

  if (!sheetJson || !sheetJson[1]) {
    console.log("Failed to match Google Sheets response pattern");
    return null;
  }

  try {
    const sheetData = JSON.parse(sheetJson[1]).table.rows;
    const sheetRows = sheetData.map((row) => row.c.map((col) => col.v))

    return sheetRows;
  } catch (err) {
    console.log("Error parsing JSON from Google Sheets");
    return null;
  }
};
```

## APIs

- Get text from spread sheet with `GET https://docs.google.com/spreadsheets/d/${sheet_id}/gviz/tq?tqx=out:json`

```javascript
await fetch("https://docs.google.com/spreadsheets/d/12-XhOC8wCcLsKHYcoY-E3N-hKqPjw2xaZKUNlntod2s/gviz/tq?tqx=out:json").then(data=>data.text()).then(mapText2Array);
```

- Add [Query Langauge](https://developers.google.com/chart/interactive/docs/querylanguage ) with query stirng `tq=${encodeURIComponent("select *")}`

```javascript
await fetch(`https://docs.google.com/spreadsheets/d/12-XhOC8wCcLsKHYcoY-E3N-hKqPjw2xaZKUNlntod2s/gviz/tq?tq=${encodeURIComponent("where F > 30")}`).then(data=>data.text()).then(mapText2Array)
```