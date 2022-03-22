using Toybox.Graphics;
using Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Timer;
using Toybox.Lang;
using Toybox.ActivityMonitor;
using Toybox.System;
using Toybox.ActivityRecording;
import Toybox.Sensor;


class BaseInputDelegate extends WatchUi.BehaviorDelegate {

    private var _view as RadarActivity;

    //! Constructor
    //! @param view The app view
    public function initialize(view as RadarActivity) {
        BehaviorDelegate.initialize();
        _view = view;
        

    }

    //! On menu event, start/stop recording
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        if (Toybox has :ActivityRecording) {
            if (!_view.isSessionRecording()) {
                _view.startRecording();
            } else {
                _view.stopRecording();
            }
        }
        return true;
    }
}


class RadarActivity extends WatchUi.View {
	var currentSpeed = 0;
	var caloriesBurned = 0;
	var heartRate = 0;
	var distance = 0;
	var time = 0;
	var _session as Session?;// set up session variable
	var minutes = 0;
	var hours = 0;                                        
	var clockTime = "";
	var speedMPH;
	var distanceKm;
	var hr;
	var timer = new Timer.Timer();
	var power = 0;
	
    function initialize() {
    	var i;
    	Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE,Sensor.SENSOR_BIKESPEED]);
    	//Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    	View.initialize();
       	if (Toybox has :ActivityRecording) {
            if (!isSessionRecording()) {
                startRecording();
            }
        }
    }
    
        //! Stop the recording if necessary
    public function stopRecording() as Void {
        if ((Toybox has :ActivityRecording) && isSessionRecording()) {
            _session.stop();
            _session.save();
            _session = null;
            WatchUi.requestUpdate();
        }
    }

    public function isSessionRecording() as Boolean {
        return (_session != null) && _session.isRecording();
    }
    //! Start recording a session
    public function startRecording() as Void {
        _session = ActivityRecording.createSession({          // set up recording session
	                 :name=>"Biking",                              // set session name
	                 :sport=>ActivityRecording.SPORT_GENERIC,       // set sport type
	                 :subSport=>ActivityRecording.SUB_SPORT_GENERIC // set sub sport type
	           });
        _session.start();
        WatchUi.requestUpdate();
    }
    
    	
	function onTimer() {
		WatchUi.requestUpdate();
	}
	
    
    function onShow(){
    	timer = new Timer.Timer();
    	timer.start( method(:onTimer), 1000, true ); 
    	
    }
    
    function onHide(){
        if (Toybox has :ActivityRecording) {
            if (isSessionRecording()) {
                stopRecording();
            }
        }
        timer.stop();
    }

    function HMSConverter(totalSeconds){ //got this fropm forums #
    	totalSeconds = totalSeconds /1000;
    	var hours = (totalSeconds / 3600).toNumber();
		var minutes = ((totalSeconds - hours * 3600) / 60).toNumber();
		var seconds = totalSeconds - hours * 3600 - minutes * 60;
		var timeString = Lang.format("$1$:$2$:$3$", [hours, minutes, seconds]);
		return timeString;
    
    }
    
    function MPStoMPH(speed){
    	return speed * 2.2369;
    }
    
    function metersToKm(distance){
    	return distance / 1000;
    
    }
    
    function drawValues(position, dc as Dc, text, value){ 
    
    
    	var width;
    	var firstHeight;
    	var secondHeight;
    	if(position == 0){//top left
    		width = dc.getWidth() *1/4;
    		firstHeight = dc.getHeight() *1/8;
    		secondHeight = dc.getHeight() *1/4;
    	}else if(position == 1){ //top right
    		width = dc.getWidth() *3/4;
    		firstHeight = dc.getHeight() *1/8;
    		secondHeight = dc.getHeight() *1/4;
    	}else if(position == 2){ //middle left
    		width = dc.getWidth() *1/4;
    		firstHeight = dc.getHeight() *3/8;
    		secondHeight = dc.getHeight() *5/8;
    	}else if(position == 3){ //middle right
    		width = dc.getWidth() *3/4;
    	   	firstHeight = dc.getHeight() *3/8;
    		secondHeight = dc.getHeight() *5/8;
    	}else{ //bottom
			width = dc.getWidth() /2;
			firstHeight = dc.getHeight() *3/4;
    		secondHeight = dc.getHeight() *7/8;
    	}
    
    	dc.drawText(
		    width,                      // gets the width of the device and divides by 2
		    firstHeight,                     // gets the height of the device and divides by 2
		    Graphics.FONT_MEDIUM,                    // sets the font size
		    text,                          // the String to display#
		    Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
		            );
		dc.drawText(
		    width,                      // gets the width of the device and divides by 2
		    secondHeight,                     // gets the height of the device and divides by 2
		    Graphics.FONT_LARGE,                    // sets the font size
		    value,                          // the String to display
		    Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
		            );
    }
    
    
    function onUpdate(dc as Dc) as Void {
    	dc.clear();
    	dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    	dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
    	if (Toybox has :ActivityRecording) {
            // Draw the instructions
            if (!isSessionRecording()) {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_WHITE);
                dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "Press Menu to\nStart Recording", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            }else{
            	
               	var activeInfo = Activity.getActivityInfo();
		    	//heartRate = activeInfo.currentHeartRate; //dont think you can display this...
		    	currentSpeed = activeInfo.currentSpeed; //converts mps to mph
		    	distance = activeInfo.elapsedDistance; //convert meters to km
		    	time = activeInfo.elapsedTime; //convert milliseconds to seconds
		    	caloriesBurned = activeInfo.calories;
		    	power = activeInfo.currentPower;
		    	
		    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		    	
		    	dc.drawLine(dc.getWidth()/2,0, dc.getWidth()/2,dc.getHeight()*3/4);
		    	dc.drawLine(0,dc.getHeight()*3/8, dc.getWidth(), dc.getHeight()*3/8);
		    	dc.drawLine(0,dc.getHeight()*3/4, dc.getWidth(), dc.getHeight()*3/4);
		    	
		    	
//		    	currentSpeed = currentSpeed * 2.2369;
//		    	distance = distance / 1000;
//		    	time = time / 1000;
//		    	
				

		    	var timeString = HMSConverter(time);
		    	if(currentSpeed != null){
		    		speedMPH = MPStoMPH(currentSpeed);
		    		speedMPH = speedMPH.format("%.2f");
		    	}
		        if(distance != null && distance != 0){
		        	distanceKm = metersToKm(distance);
		      		distanceKm = distanceKm.format("%.2f");
		      	}  
		        
		        drawValues(0, dc, "Distance (km)", distanceKm);
		        drawValues(1, dc, "Speed (mph)", speedMPH);
		        drawValues(2, dc, "Elapsed \n Time", timeString);
		        drawValues(3, dc, "Calories \n Burned", caloriesBurned);
		        drawValues(4, dc, "Power (W)", power);

		            
            }
       	}
      
 

    }
    
    
}