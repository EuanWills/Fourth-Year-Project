import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.AntPlus;
import Toybox.Timer;
import Toybox.Activity;
using Toybox.Attention;

class RadarInputDelegate extends WatchUi.BehaviorDelegate {

    private var _view as Radar;

    //! Constructor
    //! @param view The app view
    public function initialize(view as Radar) {
        BehaviorDelegate.initialize();
        _view = view;

    }

}

class Radar extends WatchUi.View {

	
	
	var bikeRadar = new AntPlus.BikeRadar(null); //initiates the bike radar sensor via ANT
	var data = false;
	var radarArray = new [8]; //initiate array to hold distance data
	var radarSpeed = new [8];//~ speed data
	var radarTarget = new [8];//~ threat level
	var radarThreatSide = new [8];//~ threat position
	var d = 0;
	var playToneCounter = 0;
//	var myBmp;
	
    function initialize() {
        View.initialize();
       // myBmp=WatchUi.loadResource(Rez.Drawables.car);  //load the bitmap using id in resources
    }	
	
	
	function onTimer() {
		WatchUi.requestUpdate(); //call on update
	}
	
	

    // Load your resources here
    function onLayout(dc as Dc) as Void {  
    
    	dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT); //sets white background
    	dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight()); 
    	var timer = new Timer.Timer();
    	timer.start( method(:onTimer), 50, true );     //makes page refresh every 50 milliseconds
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }
    

    // Update the view
    function onUpdate(dc as Dc) as Void {
    	dc.clear();
    	
    	
    	
    	dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    	dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight()); 
    	//dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);    
    	var radarInfo = bikeRadar.getRadarInfo(); //retreieves all radar information using ANT

 		if(radarInfo){
	     	for(var i = 0; i < 8; i++){ //sets all radar values in relevent array
		    	radarArray[i] = radarInfo[i].range;
		    	radarSpeed[i] = radarInfo[i].speed;
		    	radarTarget[i] = radarInfo[i].threat.toNumber();
		    	radarThreatSide[i] = radarInfo[i].threatSide;
		 	}
		    	
		}	
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawRoundedRectangle(0, (dc.getHeight()*1/2)-35, dc.getWidth(), 70, 20); 		
	//	var drawValues = [1, 2, 3, 4, 5, 6, 7, 8];
		dc.drawText(dc.getWidth()/2, 0, Graphics.FONT_LARGE,"Radar View", Graphics.TEXT_JUSTIFY_CENTER);
	//	var counter = 1;
		for(var i = 0; i < 8; i++){
			if(radarArray[i]>0){ //if there is radar data

				if(radarTarget[i]==2){ //if the threat level is high display red circle
					dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
					if(playToneCounter < 50 && playToneCounter >= 1){
						playToneCounter+=1;
					}else{
						playToneCounter = 0;
					}
					if (Attention has :playTone && playToneCounter == 0) {
   						Attention.playTone(Attention.TONE_LOUD_BEEP);
   						playToneCounter +=1;
					}
				}else if(radarTarget[i]==1){ //otherwise make it yellow
					dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
				}
				var percentageFill = (140-radarArray[i])/140;
				//dc.drawBitmap(dc.getWidth() / 2, dc.getWidth() / 2, myBmp);
				if(radarThreatSide[i] == 0){ //if the threat is directly in front of the radar display circle in middle
					dc.fillCircle(dc.getWidth() / 2, dc.getHeight() / 2, 35*percentageFill);
				}else if(radarThreatSide[i] == 1){ //if right disaply circle right
					dc.fillCircle(4/5 * dc.getWidth(), dc.getHeight() / 2, 35*percentageFill);
				}else{ //if left display circle left
					dc.fillCircle(1/5 * dc.getWidth(), dc.getHeight() / 2, 35*percentageFill);
				}
			

	    	}
				
			
		}

	}
		

   
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
