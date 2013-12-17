
package{
	
import flash.utils.describeType;
import flash.geom.*
	
public class Utils{

//Get an XML description of this class
//and return the variable types as XMLList with e4x
public static function showProps(myObj:Object){
	var varList:XMLList = describeType(myObj)..variable;
	trace("myObj: " + myObj);
	for(var i:int; i < varList.length(); i++){
		trace(varList[i].@name+':'+ myObj[varList[i].@name]);
	}
}
public static function setColor(_targetToColor, _color:String):void{
	var newColor:ColorTransform = new ColorTransform();
	newColor.color = parseInt("0x" + _color); 
	_targetToColor.transform.colorTransform = newColor;
}
// Input: seconds
// Output: a formatted string indicating  time like:       mm:ss
public static function getMinSec(secs:Number):String{
	//var myHrs = Math.floor(secs / 3600);
	//secs %= 3600;
	secs = Math.floor(secs);
	var myMins = Math.floor(secs / 60);
	secs %= 60;
	//return((myMins < 10 ? "0" + myMins : myMins) + ":" 
		  // + (secs < 10 ? "0" + secs : secs));
	return((myMins) + ":" 
		   + (secs < 10 ? "0" + secs : secs));
}

}
}

