# Fourth-Year-Project

### Code description

FTPCalculator - class which records and displays a users FTP using the Assomia power meter
FTP Delegate - input handler assosiated with the FTPCalculator class

MyBikePowerListener - listener for power meter
MyBikeRadarListener - listener for radar sensor

PowerMeterANTView - class which displays FTP zone informaiton using the Assomia power meter
PowerDelegate - input handeler assosiated with the Power Meter class

Radar - Class which connects to and displays radar info
RadarDelegate - input handeler assosiated with the Radar class

RadarActivity - Class which displays activity informaiton
RadarActivityDelegate - input handeler assosiated with the Activity Class

RadarActivityAppApp - Class that sets up the whole applicaiton
RadarActivityAppDelegate - input handler for front page

RadarActivityAppMenuDelegate - Class that deals with the menu selection process

### Set-up

To run this project please download the Monkey C SDK (Software Development Kit) and follow the instructions for adding the Monkey C extention to Visual Studio via the following link:
https://developer.garmin.com/connect-iq/sdk/

After that run the application in simulation, here you can traverse the app and simulate activity data to view what the Activity page would look like in motion:

![image](https://user-images.githubusercontent.com/59978449/160699946-55e6d65b-0278-464c-a6b1-d0931e6b80d4.png)

Unfortunatley ANT communication cannot be simulated, you need to run the application on a Garmin device to do so. Therefore, the FTP calculator, power meter and radar pages cannot be displayed properly in simulation.

### Requirements

* Monkey C SDK
* Tested on Windows 10
