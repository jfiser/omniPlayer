package{
	
import flash.display.*;
import flash.events.*;

public class ControlRackBack extends Sprite{
	
private var docRoot:Object;
private var controlRackMain:ControlRackMain;
private var backShape:Shape;
private var hVal:Number;

public function ControlRackBack(_docRoot:Object, _controlRackMain:ControlRackMain){
	docRoot = _docRoot;
	controlRackMain = _controlRackMain;
	set_xy();
	// set starting hVal (height) - this might change on resize
	hVal = controlRackMain.controlRackBackStyleObj.heightPx;
	drawBacking();
}
private function set_xy(){
	this.x = controlRackMain.controlRackBackStyleObj.xVal;
	this.y = controlRackMain.controlRackBackStyleObj.yVal;
}
public function resize(){
	this.width = controlRackMain.playerSizer.PLAYER_W;
	//this.y = controlRackMain.playerSizer.PLAYER_H - hVal;
	trace("controlRackMain.playerSizer.PLAYER_H: " + controlRackMain.playerSizer.PLAYER_H);
}
private function drawBacking(){
	backShape = new Shape();
	this.addChild(backShape);
	trace("hVal: " + hVal);
	Drawing.drawRect(backShape, 
				 controlRackMain.playerSizer.PLAYER_W, hVal, 
				 controlRackMain.controlRackBackStyleObj.bgColor, controlRackMain.controlRackBackStyleObj.bgColor,
				 controlRackMain.controlRackBackStyleObj.opacity, controlRackMain.controlRackBackStyleObj.opacity,
				 90,
				 "linear");
}

}
}
