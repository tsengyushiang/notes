# Google Apps Script


## SpreadSheet

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

## Email

- [Document](https://developers.google.com/apps-script/reference/mail/mail-app)

- find thread by subject from my gmail if exists reply it, otherwise send a new mail.

function CheckReplyThenSend(subject,htmlBody){
  var thread = GmailApp.search(`in:anywhere subject:"${subject}" `)[0];

  if (thread){
    thread.reply("", {
      htmlBody: htmlBody,
    });
  }else{
    SendEmailToMe(subject,htmlBody)
  }

  var emailQuotaRemaining = MailApp.getRemainingDailyQuota();
  Logger.log("Remaining email quota: " + emailQuotaRemaining);
}
```

- send email

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
## calendar

- Get subscribed calendar by Id

```
function GetHoliday(){
  // go your calendar and check 'Holidays in Taiwan' is subscribed and copy id from 'Holidays in Taiwan'->setting
  var calendar = CalendarApp.getCalendarById('en.taiwan#holiday@group.v.calendar.google.com');
  Logger.log(calendar);
}
```
