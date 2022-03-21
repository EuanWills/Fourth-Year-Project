import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

public enum Button {
    BUTTON_MORE    = "MORE_BUTTONS",
    BUTTON_NO_MORE = "NO_MORE_BUTTONS",
    BUTTON_PUSH    = "PUSH_BUTTONS",
    BUTTON_UNKNOWN = "UNKNOWN_BUTTON"
}

//! Input handler for the detail views
class PowerDelegate extends WatchUi.BehaviorDelegate {
    //! Constructor
    private var _parentView as PowerMeterAntView;
    public function initialize(view as PowerMeterAntView) {
		_parentView = view;
        BehaviorDelegate.initialize();
    }
    
    
    public function onMenu() as Boolean {
        _parentView.menuButtonPressed();
        return false;
    }
    
    public function onKey(evt as KeyEvent) as Boolean {
    	if(!_parentView.isFTPSet()){
	        var key = evt.getKey();
	        var button = getButton(key);
	        return true;
	    }else{
	    	return false;
	    }
    }
    
    private function getButton(key as Key) as Button {
        var buttonBit = getButtonBit(key);
        if (buttonBit == null) {
            return null;
        }else if(buttonBit == System.BUTTON_INPUT_UP){
			_parentView.upKey();
        }else if(buttonBit == System.BUTTON_INPUT_DOWN){
        	_parentView.downKey();
        }else{
        	return null;
        }
    }
    
        private function getButtonBit(key as Key) as ButtonInputs? {
        if (key == KEY_ENTER) {
            return System.BUTTON_INPUT_SELECT;
        } else if (key == KEY_UP) {
            return System.BUTTON_INPUT_UP;
        } else if (key == KEY_DOWN) {
            return System.BUTTON_INPUT_DOWN;
        } else if (key == KEY_MENU) {
            return System.BUTTON_INPUT_MENU;
        }

        return null;
    }

    //! Handle back behavior
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}