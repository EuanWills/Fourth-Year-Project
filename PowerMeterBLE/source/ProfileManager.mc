
import Toybox.BluetoothLowEnergy;

class ProfileManager {
//need to wait until I get the nordicNrF to specify the profile
//    public const THINGY_CONFIGURATION_SERVICE = BluetoothLowEnergy.longToUuid(0xEF6801009B354933L, 0x9B1052FFA9740042L);

    //public const THINGY_SOUND_SERVICE         = BluetoothLowEnergy.longToUuid(0xEF6805009B354933L, 0x9B1052FFA9740042L);
   // public const SOUND_CONFIG_CHARACTERISTIC  = BluetoothLowEnergy.longToUuid(0xEF6805019B354933L, 0x9B1052FFA9740042L);
   // public const SPEAKER_DATA_CHARACTERISTIC  = BluetoothLowEnergy.longToUuid(0xEF6805029B354933L, 0x9B1052FFA9740042L);
    
    
  //  public const POWER_METER_CYCLING_POWER = BluetoothLowEnergy.longToUuid(0x1818, 0x9B1052FFA9740042L);
    
 //   public const POWER_MEASUREMENT_CHARACTERISTIC = BluetoothLowEnergy.longToUuid(0x2A63, 0x9B1052FFA9740042L);
 
 //	public const POWER_METER_SERVICE					   = BluetoothLowEnergy.longToUuid(0x0000180000001000L, 0x800000805F9B34FBL);
 	public const POWER_METER_SERVICE					   = BluetoothLowEnergy.longToUuid(0x6A3433F4562640E8L, 0xA9B9DBD9ECD2824BL);
// 	public const POWER_METER_SERVICE					   = BluetoothLowEnergy.longToUuid(0x6E400001B5A3F393L, 0xE0A9E50E24DCCA9EL);
 	
 	public const CYCLING_POWER_SERVICE					   = BluetoothLowEnergy.longToUuid(0x0000181800001000L, 0x800000805F9B34FBL);
 	public const CYCLING_POWER_MEASURMENT_CHARACTERISTIC   = BluetoothLowEnergy.longToUuid(0x00002A6300001000L, 0x800000805F9B34FBL);
 	public const CYCLING_POWER_FEATURE_CHARACTERISTIC      = BluetoothLowEnergy.longToUuid(0x00002A6500001000L, 0x800000805F9B34FBL);
 	public const CYCLING_POWER_CP_CHARACTERISTIC           = BluetoothLowEnergy.longToUuid(0x00002A6600001000L, 0x800000805F9B34FBL);
 	
 	
  //  public const POWER_METER_UART_SERVICE		  		   = BluetoothLowEnergy.longToUuid(0x6E400001B5A3F393L, 0xE0A9E50E24DCCA9EL);
   // public const POWER_METER_UART_TX_CHARACTERISTIC		   = BluetoothLowEnergy.longToUuid(0x6E400003B5A3F393L, 0xE0A9E50E24DCCA9EL);
   // public const POWER_METER_UART_RX_CHARACTERISTIC		   = BluetoothLowEnergy.longToUuid(0x6E400002B5A3F393L, 0xE0A9E50E24DCCA9EL);
   // public const POWER_METER_UART_FX_CHARACTERISTIC		   = BluetoothLowEnergy.longToUuid(0x6E400004B5A3F393L, 0xE0A9E50E24DCCA9EL);
    
 //   public const POWER_METER_BATTERY	   = BluetoothLowEnergy.longToUuid(0x180F, 0x9B1052FFA9740042L);

//    private const _uartProfileDef = {
//        :uuid => POWER_METER_UART_SERVICE,
//        :characteristics => [{
//            :uuid => POWER_METER_UART_RX_CHARACTERISTIC
//        }, {
//            :uuid => POWER_METER_UART_TX_CHARACTERISTIC
//        }, {
//            :uuid => POWER_METER_UART_FX_CHARACTERISTIC
//        }]
//    };

    private const _cyclingPowerDef = {
        :uuid => CYCLING_POWER_SERVICE,
        :characteristics => [{
            :uuid => CYCLING_POWER_MEASURMENT_CHARACTERISTIC
        }, {
            :uuid => CYCLING_POWER_FEATURE_CHARACTERISTIC
        }, {
            :uuid => CYCLING_POWER_CP_CHARACTERISTIC
        }]
    };

    //! Register the bluetooth profile
    public function registerProfiles() as Void {
        BluetoothLowEnergy.registerProfile(_cyclingPowerDef);
    }
}