package{
	
import flash.geom.*
import flash.events.*;

public class ControlBarDefines{

public static var SCRUBBER_H:Number = 40;
public static var SHARE_BTN_W:Number = 32;
public static var SOUND_BTN_W:Number = 32;
public static var BUTTON_OVER_COLOR:String = "C9C6C4";
public static var BORDER_COLOR:String = "444444";
//public static var NORM_BTN_TXT_COLOR:String = "6F6f6f";
public static var NORM_BTN_TXT_COLOR:String = "cccccc";
public static var OVER_BTN_TXT_COLOR:String = "ffffff";

public static var CC_BTN_W:Number = 60;

public static function setColor(_targetToColor, _color:String):void{
	var netColor:ColorTransform = new ColorTransform();
	netColor.color = parseInt("0x" + _color); 
	_targetToColor.transform.colorTransform = netColor;
}


}
}
