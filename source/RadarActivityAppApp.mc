import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Position;
class RadarActivityAppApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    	
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    	Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new RadarActivityAppView(), new RadarActivityAppDelegate() ] as Array<Views or InputDelegates>;
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }
    
    function onPosition(info as Info) as Void{
    }

}

function getApp() as RadarActivityAppApp {
    return Application.getApp() as RadarActivityAppApp;
}