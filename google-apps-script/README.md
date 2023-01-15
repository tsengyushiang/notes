# Google Apps Script


## Read Public Google Sheet

- [Document](https://developers.google.com/apps-script/reference/spreadsheet/spreadsheet-app)

```
function ReadSpreadSheetById(id) {
  var ss = SpreadsheetApp.openById(id);
  var sheet = ss.getSheets()[0]
  var data = sheet.getDataRange().getValues()

  return {
    name:ss.getName(),
    url:ss.getUrl(),
    sheetName:sheet.getName(),
    data
  }
}
```

## Send Email

- [Document](https://developers.google.com/apps-script/reference/mail/mail-app)

```
function SendEmailToMe(title,htmlBody){
    const myEmail = Session.getActiveUser().getEmail();
    MailApp.sendEmail({
        to: myEmail, 
        subject: title,
        htmlBody
    });
}
```