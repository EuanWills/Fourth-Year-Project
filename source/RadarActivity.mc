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
    	Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE,Sensor.SENSOR_BIKESPEED]); //enables relevent sensors
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

	//!session recording getter
    public function isSessionRecording() as Boolean {
        return (_session != null) && _session.isRecording();
    }
    
    //! Start recording a session
    public function startRecording() as Void {
        _session = ActivityRecording.createSession({               // set up recording session
	                 :name=>"Biking",                              // set session name
	                 :sport=>ActivityRecording.SPORT_CYCLING,      // set sport type
	                 :subSport=>ActivityRecording.SUB_SPORT_ROAD   // set sub sport type
	           });
        _session.start();
        WatchUi.requestUpdate();
    }
    
    	
	function onTimer() {
		WatchUi.requestUpdate();
	}
	
    
    function onShow(){
    	timer.start( method(:onTimer), 1000, true ); //refresh every 1000 milliseconds
    	
    }
    
    function onHide(){
        if (Toybox has :ActivityRecording) {
            if (isSessionRecording()) {
                stopRecording();
            }
        }
        timer.stop();
    }

	//! converts basline seconds varible into hh:mm:ss format,
    //! this is a standard funciton
    function HMSConverter(totalSeconds){ 
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
    	}else{ //middle right
    		width = dc.getWidth() *3/4;
    	   	firstHeight = dc.getHeight() *3/8;
    		secondHeight = dc.getHeight() *5/8;
    	}
    
    	dc.drawText(
		    width,                      			 // gets width from if function
		    firstHeight,                     		 // gets lable height from if funciton
		    Graphics.FONT_MEDIUM,                    // sets the font size
		    text,                         			 // the String to display
		    Graphics.TEXT_JUSTIFY_CENTER             // sets the justification for the text
		            );
		dc.drawText(
		    width,                     
		    secondHeight,                   	     // gets activity info height from if funciton
		    Graphics.FONT_LARGE,               
		    value,                        
		    Graphics.TEXT_JUSTIFY_CENTER           
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
		    	
		    	currentSpeed = activeInfo.currentSpeed; 
		    	distance = activeInfo.elapsedDistance; 
		    	time = activeInfo.elapsedTime; //convert milliseconds to seconds
		    	caloriesBurned = activeInfo.calories;
		    	
		    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		    	
		    	//draws seperating lines
		    	dc.drawLine(dc.getWidth()/2,0, dc.getWidth()/2,dc.getHeight()*3/4);
		    	dc.drawLine(0,dc.getHeight()*3/8, dc.getWidth(), dc.getHeight()*3/8);
		    	dc.drawLine(0,dc.getHeight()*3/4, dc.getWidth(), dc.getHeight()*3/4);

		    	var timeString = HMSConverter(time);
		    	if(currentSpeed != null){
		    		speedMPH = MPStoMPH(currentSpeed); //converts mps to mph
		    		speedMPH = speedMPH.format("%.2f");
		    	}

		        if(distance != null && distance != 0){
		        	distanceKm = metersToKm(distance); //convert meters to km
		      		distanceKm = distanceKm.format("%.2f");
		      	}  
		      	

		    	    
		        drawValues(0, dc, "Distance (km)", distanceKm); 		//draws distance
		        drawValues(1, dc, "Speed (mph)", speedMPH);     		//draws speed
		        drawValues(2, dc, "Elapsed \n Time", timeString);		//draws elapsed time
		        drawValues(3, dc, "Calories \n Burned", caloriesBurned);//draws claories burned

		        dc.drawText(
		    		dc.getWidth() *1/2,                      // sets width
		    		dc.getHeight() *7/9,                     // sets height
		    		Graphics.FONT_LARGE,                    // sets the font size
		    		"Activity Page",                          // the String to display
		    		Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
		        );    
            }
       	}

    }
    
    
}