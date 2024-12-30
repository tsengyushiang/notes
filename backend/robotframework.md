# Robot Framework

## Quick start


### Set Up Environment and Start CLI

To start, set up the environment and launch the Robot Framework CLI with Docker:
```
sudo docker run -it --rm -w /app -v ./:/app marketsquare/robotframework-browser bash
```

### Add Script for Webpage Screenshot

Create a script called `snapshot.robot` with the following content:
```
*** Settings ***
Library  Browser

*** Variables ***
${URL}    https://fingerprintjs.github.io/BotD/main/

*** Test Cases ***
Open Google and Take Snapshot
    New Browser    chromium    headless=True
    New Page    ${URL}
    Take Screenshot    snapshot
    Close Browser
```

### Run the Script

To execute the script, run the following command:
```
robot ./snapshot.robot
```
The screenshot will be saved in the `./browser/screenshot` directory.