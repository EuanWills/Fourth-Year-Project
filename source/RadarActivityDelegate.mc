import Toybox.Lang;
import Toybox.WatchUi;

//! Input handler for the detail views
class RadarActivityDelegate extends WatchUi.BehaviorDelegate {
    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Handle back behavior
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}