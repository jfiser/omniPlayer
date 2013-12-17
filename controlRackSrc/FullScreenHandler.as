package{

import flash.display.*;
import flash.events.*;
	
public class FullScreenHandler extends Sprite{
	
private var docRoot:Object;
private var controlRackMain:ControlRackMain;
private var videoPlayer:Object;
private var backing:Shape;
private var iconHolder:Sprite;
private var fullScreenIcon:FullScreenIcon;
private var divLine:DivLine;

public function FullScreenHandler(_docRoot:Object, _controlRackMain:ControlRackMain){
	docRoot = _docRoot;
	controlRackMain = _controlRackMain;
	videoPlayer = controlRackMain.videoPlayer;
	
	addButton();
	addDivLine();
	set_xy(controlRackMain.fullScreenBtnStyleObj.xVal, 0); 
	setListeners();
}
private function addDivLine(){
	divLine = new DivLine(docRoot, 1, controlRackMain.CONTROL_RACK_BACK_H, "ffffff", .5);
	this.addChild(divLine);
}
private function setListeners(){
	this.addEventListener(MouseEvent.CLICK, fullScreenBtnClick);
	docRoot.stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenEventHandler );
	this.buttonMode = true;
}
private function fullScreenEventHandler(evt:FullScreenEvent){
	
}
public function fullScreenBtnClick(evt:Event){
	trace("clicked");
	if(stage.displayState == StageDisplayState.FULL_SCREEN){
		docRoot.stage.displayState = StageDisplayState.NORMAL;
	}
	else{
		docRoot.stage.displayState = StageDisplayState.FULL_SCREEN;
	}
}
private function addButton(){
	backing = new Shape();
	this.addChild(backing);
	Drawing.drawRect(backing, 
				 controlRackMain.fullScreenBtnStyleObj.widthPx, controlRackMain.CONTROL_RACK_BACK_H, 
				 "0000ff", "0000ff",
				 0, 0,
				 90,
				 "linear");
	iconHolder = new Sprite();
	fullScreenIcon = new FullScreenIcon();
	iconHolder.addChild(fullScreenIcon);
	iconHolder.x = controlRackMain.fullScreenBtnStyleObj.widthPx/2 - iconHolder.width/2;
	iconHolder.y = controlRackMain.CONTROL_RACK_BACK_H/2 - iconHolder.height/2;
	this.addChild(iconHolder);
	
}
public function set_xy(_xLoc:Number, _yLoc:Number){
	this.x = _xLoc;
	this.y = _yLoc;
}


}	
}
