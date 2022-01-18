//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.System;

class DeviceManager {
    private var _profileManager as ProfileManager;
    private var _device as Device?;
//    private var _soundService as Service?;
    private var _feature as Characteristic?;
//    private var _speakerData as Characteristic?;
//    private var _configComplete as Boolean = false;
    private var _cycleService as Service?;
    private var _powerMeterData as Characteristic;
 //   private var _sampleInProgress as Boolean = false;

    //! Constructor
    //! @param bleDelegate The BLE delegate
    //! @param profileManager The profile manager
    public function initialize(bleDelegate as PowerMeterBLEDelegate, profileManager as ProfileManager) {
        _device = null;

        bleDelegate.notifyScanResult(self);
        bleDelegate.notifyConnection(self);
        bleDelegate.notifyCharWrite(self);

        _profileManager = profileManager;
    }

    //! Start BLE scanning
    public function start() as Void {
        BluetoothLowEnergy.setScanState(BluetoothLowEnergy.SCAN_STATE_SCANNING);
    }

    //! Process scan result
    //! @param scanResult The scan result
    public function procScanResult(scanResult as ScanResult) as Void {
        // Pair the first Thingy we see with good RSSI
        if (scanResult.getRssi() > -60) {
            BluetoothLowEnergy.setScanState(BluetoothLowEnergy.SCAN_STATE_OFF);
            BluetoothLowEnergy.pairDevice(scanResult);
        }
    }

    //! Process a new device connection
    //! @param device The device that was connected
    public function procConnection(device as Device) as Void {
    	System.println("Hello");
        if (device.isConnected()) {
            _device = device;
            startRead();
        } else {
            _device = null;
        }
    }
    //this is important
    private function startRead() as Void {
        System.println("Start Read");
        var device = _device;
        if (device != null) {
        	_cycleService = device.getService(_profileManager.CYCLING_POWER_SERVICE);
            var cycleService = _cycleService;
            if (cycleService != null) {
                _feature = cycleService.getCharacteristic(_profileManager.CYCLING_POWER_FEATURE_CHARACTERISTIC);
                _powerMeterData = cycleService.getCharacteristic(_profileManager.CYCLING_POWER_MEASURMENT_CHARACTERISTIC);
            }
            System.println(_powerMeterData);
            System.println("reached this area");
        }
	}        
        // Put the speaker into Sample Mode
//        _configComplete = false;
//        var config = _config;
//        if (config != null) {
//            config.requestWrite([0x03, 0x01]b, {:writeType => BluetoothLowEnergy.WRITE_TYPE_WITH_RESPONSE});
//        }
//    }

    //! Handle the completion of a write operation on a characteristic
    //! @param char The characteristic that was written
    //! @param status The result of the operation
    public function procCharWrite(char as Characteristic, status as Status) as Void {
        System.println("Proc Write: (" + char.getUuid() + ") - " + status);


    }


}
