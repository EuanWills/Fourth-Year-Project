import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Graphics as Gfx;

class RadarActivityAppMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :item_1) {
            System.println("Activity Screen");
            WatchUi.pushView(new $.RadarActivity(), new $.RadarActivityDelegate(), WatchUi.SLIDE_UP);
        } else if (item == :item_2) {
            System.println("Radar Screen");
            WatchUi.pushView(new $.Radar(), new $.RadarDelegate(), WatchUi.SLIDE_UP);
        }
    }
    function onUpdate(dc) {
    	dc.clear(); // Clear the display

    // Set a white color for drawing and draw a rectangle
	    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    	dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

    // Draw black text against a white
    // background for the temperature
	    dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
    	dc.drawText(dc.getWidth()/2, 0, Gfx.FONT_XTINY,
        "Test", Gfx.TEXT_JUSTIFY_CENTER);
  }

}