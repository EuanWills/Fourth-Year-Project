import Toybox.Lang;
import Toybox.WatchUi;

class RadarActivityAppDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new RadarActivityAppMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}