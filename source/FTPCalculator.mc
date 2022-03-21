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
	var currentColour = Graphics.COLOR_BLACK;
	var listener =  new MyBikePowerListener(); 
	var bikePower = new AntPlus.BikePower(null);
	var timer = new Timer.Timer();
	var _session as Session?;// set up session variable
	var screenRefreshCount = 0;
	hidden var keys;
	var time = 0;
	var totalPowerOutput = 0;
	var FTP;
	
    function initialize() {
    	timer.start( method(:onTimer), 200, true );     //makes page refresh every 50 milliseconds
        View.initialize();
       	keys = new [26];

    }
    
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
		//WatchUi.onUpdate(dc);
	}
    // Load your resources here


    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    
    	timer = new Timer.Timer();
    	timer.start( method(:onTimer), 1000, true ); 
    }
    
    function HMSConverter(totalSeconds){ //got this fropm forums #
    	totalSeconds = totalSeconds /1000;
    	var hours = (totalSeconds / 3600).toNumber();
		var minutes = ((totalSeconds - hours * 3600) / 60).toNumber();
		var phase;
		if(minutes < 1){
			phase = 0;
		}else if(minutes>=1 and minutes < 3){
			phase = 1;
		}else {
			phase = 2;
		}
		var seconds = totalSeconds - hours * 3600 - minutes * 60;
		var timeString = Lang.format("$1$:$2$:$3$", [hours, minutes, seconds]);
		return [timeString, phase];
    
    }
    
    
    // Update the view
    function onUpdate(dc as Dc) as Void {
    	dc.clear();
    	dc.setColor(currentColour, Graphics.COLOR_TRANSPARENT); //sets background for recovery
    	dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight()); 
    	
    	if (Toybox has :ActivityRecording) {
            // Draw the instructions
            if (!isSessionRecording()) {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "Press Menu to\nStart Recording your FTP", Graphics.TEXT_JUSTIFY_CENTER);
            }else{
               	var activeInfo = Activity.getActivityInfo();
 				dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                time = activeInfo.elapsedTime;
                var timeArray = HMSConverter(time);
                if(bikePower.getCalculatedPower()!=null){
                
                
                	var Cpower = bikePower.getCalculatedPower();		
    				var power = Cpower.power;
    				if(power == null){
    					power = 0;
    				}
    				
    				if(timeArray[1] == 0){
	    				
	    				dc.drawText(dc.getWidth() / 2, dc.getHeight() / 8, Graphics.FONT_MEDIUM, "Warm up for 10 minutes", Graphics.TEXT_JUSTIFY_CENTER);
	                	dc.drawText(dc.getWidth() / 2, dc.getHeight() / 4, Graphics.FONT_MEDIUM, timeArray[0], Graphics.TEXT_JUSTIFY_CENTER);
	                	dc.drawLine(0,dc.getHeight()*1/3, dc.getWidth(),dc.getHeight()*1/3);
	    				dc.drawText(dc.getWidth() / 2, dc.getHeight() * 3/8, Graphics.FONT_MEDIUM, "Power (W)", Graphics.TEXT_JUSTIFY_CENTER);
	    				dc.drawText(dc.getWidth() / 2, dc.getHeight() /2, Graphics.FONT_NUMBER_THAI_HOT, power, Graphics.TEXT_JUSTIFY_CENTER);
    				
    				}else if(timeArray[1] == 1){
    					dc.drawText(dc.getWidth() / 2, dc.getHeight() / 8, Graphics.FONT_MEDIUM, "FTP now recording PUSH!", Graphics.TEXT_JUSTIFY_CENTER);
    					dc.drawText(dc.getWidth() / 2, dc.getHeight() / 4, Graphics.FONT_MEDIUM, timeArray[0], Graphics.TEXT_JUSTIFY_CENTER);
    					dc.drawLine(0,dc.getHeight()*1/3, dc.getWidth(),dc.getHeight()*1/3);
	    				dc.drawText(dc.getWidth() / 2, dc.getHeight() * 3/8, Graphics.FONT_MEDIUM, "Power (W)", Graphics.TEXT_JUSTIFY_CENTER);
	    				dc.drawText(dc.getWidth() / 2, dc.getHeight() /2, Graphics.FONT_NUMBER_THAI_HOT, power, Graphics.TEXT_JUSTIFY_CENTER);
	    				screenRefreshCount +=1;
	    				totalPowerOutput += power;
    				}else if(timeArray[1] == 2){
    					dc.drawText(dc.getWidth() / 2, dc.getHeight() / 8, Graphics.FONT_MEDIUM, "Finished! Your FTP is", Graphics.TEXT_JUSTIFY_CENTER);
    					FTP = totalPowerOutput/screenRefreshCount;
    					dc.drawText(dc.getWidth() / 2, dc.getHeight() /2, Graphics.FONT_NUMBER_THAI_HOT, FTP, Graphics.TEXT_JUSTIFY_CENTER);
    				}
					
                }else if(timeArray[1]!= 2){
                	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                	dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "ANT Connection not \n established please peddle \n or configure ANT device", Graphics.TEXT_JUSTIFY_CENTER);
                	if(timeArray[1] == 1){
                		screenRefreshCount +=1;
                	}
                
                
                }else{
                	dc.drawText(dc.getWidth() / 2, dc.getHeight() / 8, Graphics.FONT_MEDIUM, "Finished! Your FTP is", Graphics.TEXT_JUSTIFY_CENTER);
                	dc.drawText(dc.getWidth() / 2, dc.getHeight() /2, Graphics.FONT_NUMBER_THAI_HOT, FTP, Graphics.TEXT_JUSTIFY_CENTER);
                }
                	
                
                	
		    	
		   }
		}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    

}