using Toybox.Graphics;
using Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Timer;
import Toybox.Lang;
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
	var _session as Session?;                                        // set up session variable

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
    	
    	//for(i = 0; i<100; i++){
    	//	View.onUpdate();
    	//}
    }
//    function onPosition(info){
//    	if (Toybox has :ActivityRecording) {
//            if (!isSessionRecording()) {
//                startRecording();
//            }
//        }
//        
//        
// 
//    }
    
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
    	var timer = new Timer.Timer();
    	timer.start( method(:onTimer), 1000, true ); 
    	
    }
    
//    function onHide(){
//        if (Toybox has :ActivityRecording) {
//            if (isSessionRecording()) {
//                stopRecording();
//            }
//        }
//    }
    
    function onUpdate(dc as Dc) as Void {
    	dc.clear();
    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    	dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
    	if (Toybox has :ActivityRecording) {
            // Draw the instructions
            if (!isSessionRecording()) {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_WHITE);
                dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "Press Menu to\nStart Recording", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            }else{
            
               	var activeInfo = Activity.getActivityInfo();
		    	heartRate = activeInfo.currentHeartRate;
		    	currentSpeed = activeInfo.currentSpeed;
		    	caloriesBurned = activeInfo.calories;
		        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
		        dc.drawText(
		        dc.getWidth() / 6,                      // gets the width of the device and divides by 2
		        dc.getHeight() / 6,                     // gets the height of the device and divides by 2
		        Graphics.FONT_SMALL,                    // sets the font size
		        "Speed",                          // the String to display
		        Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
		                );
		        dc.drawText(
		        dc.getWidth() / 4,                      // gets the width of the device and divides by 2
		        dc.getHeight() / 4,                     // gets the height of the device and divides by 2
		        Graphics.FONT_SMALL,                    // sets the font size
		        currentSpeed,                          // the String to display
		        Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
		                );
		
		        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
		        dc.drawText(
		        dc.getWidth() - dc.getWidth() / 3,                      // gets the width of the device and divides by 2
		        dc.getHeight() / 6,                     // gets the height of the device and divides by 2
		        Graphics.FONT_SMALL,                    // sets the font size
		        "Heart rate",                          // the String to display
		        Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
		                );
		        
		        
		        dc.drawText(
		        dc.getWidth() - dc.getWidth() / 4,                      // gets the width of the device and divides by 2
		        dc.getHeight() / 4,                     // gets the height of the device and divides by 2
		        Graphics.FONT_SMALL,                    // sets the font size
		        heartRate,                          // the String to display
		        Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
		                );
		                
		                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
		        dc.drawText(
		        dc.getWidth() - dc.getWidth() / 3,                      // gets the width of the device and divides by 2
		        dc.getHeight() - dc.getHeight() / 3,                     // gets the height of the device and divides by 2
		        Graphics.FONT_SMALL,                    // sets the font size
		        "Calroies",                          // the String to display
		        Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
		                );
		        
		        
		        dc.drawText(
		        dc.getWidth() - dc.getWidth() / 4,                      // gets the width of the device and divides by 2
		        dc.getHeight() - dc.getHeight() / 4,                     // gets the height of the device and divides by 2
		        Graphics.FONT_SMALL,                    // sets the font size
		        caloriesBurned,                          // the String to display
		        Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
		                );
		            
            }
       	}
      
 

    }
    
    
}