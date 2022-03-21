import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

//! Input handler for the detail views
class FTPDelegate extends WatchUi.BehaviorDelegate {
    //! Constructor
    private var _parentView as FTPCalculator;
    public function initialize(view as FTPCalculator) {
    	_parentView = view;
        BehaviorDelegate.initialize();
    }

    //! Handle back behavior
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
    
        //! Handle a physical button being pressed and released
    //! @param evt The key event that occurred
    //! @return true if handled, false otherwise
    public function onKey(evt as KeyEvent) as Boolean {
		
        return true;
    }

    //! Handle a physical button being pressed
    //! @param evt The key event that occurred
    //! @return true if handled, false otherwise
    public function onKeyPressed(evt as KeyEvent) as Boolean {
		_parentView.buttonPressed();
        return true;
    }

    //! Handle a physical button being released
    //! @param evt The key event that occurred
    //! @return true if handled, false otherwise
    public function onKeyReleased(evt as KeyEvent) as Boolean {
        return true;
    }

}
