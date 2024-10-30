# Mailserver

- [reference](https://i12bretro.github.io/tutorials/0779.html)

# Prerequisite

- Domain name and static IP (EC2)
- Docker compose
- [Host Port Forwarding](https://docker-mailserver.github.io/docker-mailserver/latest/config/security/understanding-the-ports/#overview-of-email-ports)

# Quick Setup

- Set `DOMAIN_NAME` to system env by command:

```bash
DOCKER_MAILSERVER_DOMAIN_NAME=ec2-111-111-111-11.ap.aws.com
```

- Create main working directories

```bash
mkdir ~/docker/mailserver/{data,state,logs,config} -p
```

- Run service with docker

```yaml
docker run -d --name=mailserver --hostname="$HOSTNAME" --domainname="$DOCKER_MAILSERVER_DOMAIN_NAME" -p 25:25 -p 143:143 -p 587:587 -p 993:993 -e ENABLE_SPAMASSASSIN=1 -e SPAMASSASSIN_SPAM_TO_INBOX=1 -e ENABLE_CLAMAV=1 -e ENABLE_POSTGREY=1 -e ENABLE_FAIL2BAN=0 -e ENABLE_SASLAUTHD=0 -e ONE_DIR=1 -e TZ=America/New_York -v ~/docker/mailserver/data/:/var/mail/ -v ~/docker/mailserver/state/:/var/mail-state/ -v ~/docker/mailserver/logs/:/var/log/mail/ -v ~/docker/mailserver/config/:/tmp/docker-mailserver/ --restart=unless-stopped mailserver/docker-mailserver
```

- Add admin user

```bash
docker run --rm -e MAIL_USER=admin@$DOCKER_MAILSERVER_DOMAIN_NAME -e MAIL_PASS=admin -it mailserver/docker-mailserver /bin/sh -c 'echo "$MAIL_USER|$(doveadm pw -s SHA512-CRYPT -u $MAIL_USER -p $MAIL_PASS)"' >> ~/docker/mailserver/config/postfix-accounts.cf
```

> Check that the user has been added to the configuration file `~/docker/mailserver/config/postfix-accounts.cf`

# Test

## Web GUI

```bash
sudo docker run -e ROUNDCUBEMAIL_DEFAULT_HOST=$DOCKER_MAILSERVER_DOMAIN_NAME -e ROUNDCUBEMAIL_SMTP_SERVER=$DOCKER_MAILSERVER_DOMAIN_NAME -p 8000:80 -d roundcube/roundcubemail
```

## Node

```javascript
const nodemailer = require("nodemailer");

let transporter = nodemailer.createTransport({
  host: "ec2-122-248-230-39.ap-southeast-1.compute.amazonaws.com",
  port: 587,
  secure: false, // true for 465, false for other ports
  auth: {
    user: "admin@ec2-122-248-230-39.ap-southeast-1.compute.amazonaws.com",
    pass: "admin",
  },
  tls: { rejectUnauthorized: false },
  debug: true,
  logger: true, // Enable logger
});

let mailOptions = {
  from: "admin@ec2-122-248-230-39.ap-southeast-1.compute.amazonaws.com",
  to: "admin@ec2-122-248-230-39.ap-southeast-1.compute.amazonaws.com",
  subject: "Hello ✔",
  text: "Hello world?",
  html: "<b>Hello world?</b>",
};

transporter.verify((error) => {
  if (error) {
    return console.error("verify:", error);
  }

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      return console.error(error);
    }
    console.log("Message sent: %s", info.messageId);
  });
});
```

> Check that received mail is stored in `~/docker/mailserver/data/-/${user}/new`

# Debug

- The mail server log is stored in `~/docker/mailserver/logs/mail.log`
- Check the mail server status with [mxtoolbox](https://mxtoolbox.com/diagnostic.aspx).
- [Temporary mail](https://10minutemail.com/) for receiving testing.
- [Mail-tester](https://www.mail-tester.com/)
- [EC2 Restriction on email sent using port 25](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-resource-limits.html#port-25-throttle)
