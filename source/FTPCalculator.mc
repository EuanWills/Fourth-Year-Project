import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.AntPlus;
import Toybox.Activity;
import Toybox.Lang;

class FTPInputDelegate extends WatchUi.BehaviorDelegate {

    private var _view as FTPCalculator;
	
    //! Constructor
    //! @param view The app view
    public function initialize(view as FTPCalculator) {
        BehaviorDelegate.initialize();
        _view = view;
        

    }

}


class FTPCalculator extends WatchUi.View {
	var currentColour = Graphics.COLOR_BLACK; //sets inital page colour to black
	var listener =  new MyBikePowerListener();  //sets up ANT listener
	var bikePower = new AntPlus.BikePower(null); //initates the ANT device
	var timer = new Timer.Timer();
	var _session as Session?;
	var screenRefreshCount = 0; 
	var time = 0;
	var totalPowerOutput = 0;
	var FTP;
	
    function initialize() {
        View.initialize();

    }
    //! once the menu button held initate the timer
	public function buttonPressed() as Void{ 
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

	//! Check to see if session is recording
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
    
    //! If user backs out page
    function onHide(){
        if (Toybox has :ActivityRecording) {
            if (isSessionRecording()) {
                stopRecording();
            }
        }
        timer.stop();
    }
    
    
	function onTimer() {
		WatchUi.requestUpdate(); //call on update
	}
    
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    
    	timer = new Timer.Timer();
    	timer.start( method(:onTimer), 200, true );  //refresh every 200 milliseconds
    }
    
    //! converts basline seconds varible into hh:mm:ss format,
    //! this is a standard funciton
    function HMSConverter(totalSeconds){ 
    	totalSeconds = totalSeconds /1000;
    	var hours = (totalSeconds / 3600).toNumber();
		var minutes = ((totalSeconds - hours * 3600) / 60).toNumber();
		var phase;
		if(minutes < 10){
			phase = 0; //warmup
		}else if(minutes>=10 and minutes < 30){
			phase = 1; //record FTP
		}else {
			phase = 2; //show calculated FTP
		} 
		var seconds = totalSeconds - hours * 3600 - minutes * 60;
		var timeString = Lang.format("$1$:$2$:$3$", [hours, minutes, seconds]);
		return [timeString, phase];
    
    }
    //! draws values that appear on screen for warmup and recording phases
    function drawValues(dc as Dc, lable, time, power){ 
	   	dc.drawText(dc.getWidth() / 2, dc.getHeight() / 8, Graphics.FONT_MEDIUM, lable, Graphics.TEXT_JUSTIFY_CENTER); //text at top of screen
	   	dc.drawText(dc.getWidth() / 2, dc.getHeight() / 4, Graphics.FONT_MEDIUM, time, Graphics.TEXT_JUSTIFY_CENTER);  //elapsed time
	   	dc.drawLine(0,dc.getHeight()*1/3, dc.getWidth(),dc.getHeight()*1/3); 
	   	dc.drawText(dc.getWidth() / 2, dc.getHeight() * 3/8, Graphics.FONT_MEDIUM, "Power (W)", Graphics.TEXT_JUSTIFY_CENTER);
	   	dc.drawText(dc.getWidth() / 2, dc.getHeight() /2, Graphics.FONT_NUMBER_THAI_HOT, power, Graphics.TEXT_JUSTIFY_CENTER); //power output
    }
    
    // Update the view
    function onUpdate(dc as Dc) as Void {
    	dc.clear();
    	dc.setColor(currentColour, Graphics.COLOR_TRANSPARENT); //sets background colour
    	dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight()); 
    	
    	if (Toybox has :ActivityRecording) {
            if (!isSessionRecording()) {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "Press Menu to\nStart Recording your FTP", Graphics.TEXT_JUSTIFY_CENTER);
            }else{
               	var activeInfo = Activity.getActivityInfo(); //gets activity info from recording
 				dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                time = activeInfo.elapsedTime;
                var timeArray = HMSConverter(time);
                
                if(bikePower.getCalculatedPower()!=null){   //if power recieved from ANT device       
                	var Cpower = bikePower.getCalculatedPower();		
    				var power = Cpower.power;
    				if(power == null){
    					power = 0;
    				}
    				
    				if(timeArray[1] == 0){ //warm up stage (<10 minutes)
	    				
	    				drawValues(dc, "Warm up for 10 minutes", timeArray[0], power);
    				
    				}else if(timeArray[1] == 1){ //FTP recording (<30 and >10 minutes)
    				
	    				drawValues(dc, "FTP now recording PUSH!", timeArray[0], power);
	    				screenRefreshCount +=1; 
	    				totalPowerOutput += power; 
	    				
    				}else if(timeArray[1] == 2){ //completed >30 minutes
    				
    					dc.drawText(dc.getWidth() / 2, dc.getHeight() / 8, Graphics.FONT_MEDIUM, "Finished! Your FTP is", Graphics.TEXT_JUSTIFY_CENTER);
    					FTP = totalPowerOutput/screenRefreshCount;
    					dc.drawText(dc.getWidth() / 2, dc.getHeight() /2, Graphics.FONT_NUMBER_THAI_HOT, FTP, Graphics.TEXT_JUSTIFY_CENTER);
    					
    				}
					
                }else if(timeArray[1]!= 2){ //deals with ANT connection being dropped
                	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                	dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "ANT Connection not \n established please peddle \n or configure ANT device", Graphics.TEXT_JUSTIFY_CENTER);
                	if(timeArray[1] == 1){
                		screenRefreshCount +=1;
                	}
                
                
                }else{ //contunies to display completed FTP
                	dc.drawText(dc.getWidth() / 2, dc.getHeight() / 8, Graphics.FONT_MEDIUM, "Finished! Your FTP is", Graphics.TEXT_JUSTIFY_CENTER);
                	dc.drawText(dc.getWidth() / 2, dc.getHeight() /2, Graphics.FONT_NUMBER_THAI_HOT, FTP, Graphics.TEXT_JUSTIFY_CENTER);
                }
                	
                
                	
		    	
		   }
		}
    }

    

}