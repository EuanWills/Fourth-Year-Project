import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Graphics as Gfx;

class RadarActivityAppMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :item_1) { 		  //activity menu item
            System.println("Activity Screen");
            WatchUi.pushView(new $.RadarActivity(), new $.RadarActivityDelegate(), WatchUi.SLIDE_UP);
        } else if (item == :item_2) { //radar menu item
            System.println("Radar Screen");
            WatchUi.pushView(new $.Radar(), new $.RadarDelegate(), WatchUi.SLIDE_UP);
        } else if(item == :item_3){   //power meter screen menu item
        	System.println("Power Meter Screen");
        	var pm = new $.PowerMeterAntView();
        	var del = new $.PowerDelegate(pm);
        	WatchUi.pushView(pm, del, WatchUi.SLIDE_UP);
        } else if(item == :item_4){	   //FTP Calculator menu item
        	System.println("FTP Calculator");
        	var ftp = new $.FTPCalculator();
        	var delegate = new $.FTPDelegate(ftp);
        	WatchUi.pushView(ftp, delegate, WatchUi.SLIDE_UP);
        }
    }


}