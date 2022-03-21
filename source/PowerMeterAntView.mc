import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.AntPlus;
import Toybox.Activity;
import Toybox.Lang;

class PowerInputDelegate extends WatchUi.BehaviorDelegate {

    private var _view as PowerMeterANTView;

    //! Constructor
    //! @param view The app view
    public function initialize(view as Radar) {
        BehaviorDelegate.initialize();
        _view = view;

    }

}


class PowerMeterAntView extends WatchUi.View {
	var currentColour = Graphics.COLOR_BLACK;
	var listener =  new MyBikePowerListener(); 
	var bikePower = new AntPlus.BikePower(null);
	var FTPSet = false;
	var FTP = 150.0;
	
    function initialize() {
        var timer = new Timer.Timer();
    	timer.start( method(:onTimer), 200, true );     //makes page refresh every 50 milliseconds
        View.initialize();
       		
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
    }
    
    public function selectButtonPressed() as Void{
		FTP -=10;
		System.println(FTP);
	}
	
	public function upKey(){
		FTP +=5;
		System.println(FTP);
		return FTP;
	}
	
	public function downKey(){
		FTP -=5;
		System.println(FTP);
		return FTP;
	}
	
	public function menuButtonPressed() as Void{
		FTPSet = true;
	}
    
    public function isFTPSet(){
    	if(FTPSet){
    		return true;
    	}else{
    		return false;
    	}
    }
    function drawPowerIndicator(dc as DC, max ,min, power, message){
    	dc.setColor(currentColour, Graphics.COLOR_TRANSPARENT);//fill screen with colour representing zone
    	dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight()); 
    	
    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT); //create progress bar
    	dc.fillRoundedRectangle(0, dc.getHeight()*3/4, dc.getWidth(), 20, 10); 
    	//draw zone indication text
    	dc.drawText(dc.getWidth()/2, dc.getHeight()/4, Graphics.FONT_LARGE, message, Graphics.TEXT_JUSTIFY_CENTER);
    	
    	power = power - min;
    	max = max - min;
    	
    	var width = power.toFloat()/max; //have to convert to float so that it doesnt get rounded to 0
    	dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    	dc.fillRoundedRectangle((dc.getWidth()*width)-7, dc.getHeight()*3/4, 15, 20, 10); //draw progess indicator
    	

    
    }
    

    // Update the view
    function onUpdate(dc as Dc) as Void {
    	dc.clear();
    	dc.setColor(currentColour, Graphics.COLOR_TRANSPARENT); //sets background for recovery
    	dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
    	if(FTPSet){
    		if(bikePower.getCalculatedPower()!=null){
	    		var Cpower = bikePower.getCalculatedPower();		
	    		var power = Cpower.power;
	    		
	    		if(power == null){
	    			power = 0;
	    		}
	    		if(power < FTP*0.55){
	    			currentColour = Graphics.COLOR_LT_GRAY;
	    			//dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT); //sets background for recovery
	    			drawPowerIndicator(dc, FTP*0.54, 0.0, power, "Zone 1");
	    		}else if(power >=0.55*FTP and power <=0.75*FTP){
	    			currentColour = Graphics.COLOR_GREEN;
	    			drawPowerIndicator(dc, FTP*0.75, FTP*0.55, power, "Zone 2");
	    			//dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT); //endurance
	    		}else if(power >=0.76*FTP and power <=0.87*FTP){
	    			currentColour = Graphics.COLOR_DK_GREEN;
	    			drawPowerIndicator(dc, FTP*0.87, FTP*0.76, power, "Zone 3");
	    			//dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT); //tempo
	    			
	    		}else if(power >=0.88*FTP and power <=0.94*FTP){
	    			currentColour = Graphics.COLOR_DK_BLUE;
	    			drawPowerIndicator(dc, FTP*0.94, FTP*0.88, power, "Zone 4");
	    			//dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT); //Sweet Spot
	    		}else if(power >= 0.95*FTP and power <= 1.05*FTP){
	    			currentColour = Graphics.COLOR_PURPLE;
	    			drawPowerIndicator(dc, FTP*1.05, FTP*0.95, power, "Zone 5");
	    			//dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT); //Threshold
	    			
	    		}else if(power >=1.06*FTP and power <1.20*FTP){
	    			currentColour = Graphics.COLOR_RED;
	    			drawPowerIndicator(dc, FTP*1.20, FTP*1.06, power, "Zone 6");
	    			//dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT); //V02 Max
	    			
	    		}else{
	    			currentColour = Graphics.COLOR_DK_RED;
	    			drawPowerIndicator(dc, FTP*2.0, FTP*1.20, power, "Zone 7");
	    			//dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);//Anaerobic Capacity
	    			
	    		}
	    		
	    		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
	    		dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_NUMBER_THAI_HOT, power, Graphics.TEXT_JUSTIFY_CENTER);   		
	    		//dc.drawRectangle(0, dc.getHeight()*3/4, dc.getWidth()*3/4, 20); 
    		}else{
    			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    			dc.drawText(dc.getWidth()/2, dc.getHeight()*1/5, Graphics.FONT_LARGE, "Connection Lost \n please peddle\n to re-establish", Graphics.TEXT_JUSTIFY_CENTER);
    	
    		}
    	}else{
    	
    		dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
    		dc.drawText(dc.getWidth()/2, dc.getHeight()*1/6, Graphics.FONT_MEDIUM, "Please specify your FTP\n by using the up/down\n buttons. When finished hold\n the menu button" , Graphics.TEXT_JUSTIFY_CENTER);
    		dc.drawText(dc.getWidth()*2/5, dc.getHeight()*3/5, Graphics.FONT_LARGE, "FTP: " , Graphics.TEXT_JUSTIFY_CENTER); 
    		dc.drawText(dc.getWidth()*3/5, dc.getHeight()*3/5, Graphics.FONT_LARGE, FTP.toNumber() , Graphics.TEXT_JUSTIFY_CENTER);
    	} 
    	
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    
    function onHide() as Void {
    }

}
