package{

import flash.display.Sprite;
	
public class DivLine extends Sprite{
	
private var docRoot:Object;
private var controlRackMain:ControlRackMain;
private var thickness:Number;
private var hVal:Number;
private var color:String;
private var myAlpha:Number;
	
public function DivLine(_docRoot:Object, _thickness:Number, _hVal:Number, _color:String, _myAlpha:Number){
	docRoot = _docRoot;
	//controlRackMain = _controlRackMain;
	thickness = _thickness;
	hVal = _hVal;
	color = _color;
	myAlpha = _myAlpha;
	addDivLine();
}
private function addDivLine(){
	this.graphics.lineStyle(thickness, parseInt("0x" + color), myAlpha);
	this.graphics.moveTo(0, 0);
	this.graphics.lineTo(0, hVal);
}

}
}
