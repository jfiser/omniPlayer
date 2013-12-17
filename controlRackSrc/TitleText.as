package{

import flash.display.Sprite;
import flash.text.*;
import flash.display.Shape;
import fl.motion.easing.*;
import flash.events.*;
	
public class TitleText extends Sprite{
	
private var docRoot:Object;
private var controlRackMain:ControlRackMain;
private var titleTxt:TextField;
private var titleTxtMask:Shape;
private var firstVideo:Boolean = true;

public function TitleText(_docRoot:Object, _controlRackMain:ControlRackMain){
	docRoot = _docRoot;
	controlRackMain = _controlRackMain;
	this.mouseEnabled = false;
	this.mouseChildren = false;
	addTitleTxt();
	addTitleTxtMask();
	set_xy(controlRackMain.titleTxtStyleObj.xVal, controlRackMain.CONTROL_RACK_BACK_H/2 - titleTxt.height/2);
	docRoot.curTitle.addEventListener("smilLoaded", showTitle);
	docRoot.myTrace(">>>addEventListener(smilLoaded)");
	checkFirstVideo();
}
// This class might not be instantiated in time to listen the first video being loaded. 
// So, for firstVideo, check to see if curTitle is already set. If it is, showTitle
private function checkFirstVideo(){
	if(docRoot.curTitle.displayTitle){
		showTitle(new Event("checkFirstVideo"))
	}
}
private function showTitle(evt:Event){
	// don't switch out title if it's already there	
	if(titleTxt.text == docRoot.curTitle.displayTitle){
		return;
	}
	titleTxt.x = controlRackMain.scrubber.getScrubberWidth() * -1;
	titleTxt.text = docRoot.curTitle.displayTitle;
	TweenLite.to(titleTxt, .5, {x:0, ease:Exponential.easeOut});
	firstVideo = false;
}
private function set_xy(_xVal:Number, _yVal:Number){
	this.x = _xVal;
	this.y = _yVal;
}
private function addTitleTxtMask(){
	titleTxtMask = new Shape();
	this.addChild(titleTxtMask);
	Drawing.drawRect(titleTxtMask, 
				controlRackMain.scrubber.getScrubberWidth() - controlRackMain.titleTxtStyleObj.xVal, titleTxt.height, 
				"00ff00", "00ff00",
				.2, .2,
				90,
				"linear");
	this.mask = titleTxtMask;
}
private function addTitleTxt(){
	var TXTBOX_DIFF:int = 0;
	titleTxt = new TextField();
	this.addChild(titleTxt);
	
	titleTxt.width = controlRackMain.scrubber.getScrubberWidth() - controlRackMain.titleTxtStyleObj.xVal;
	titleTxt.height = (controlRackMain.titleTxtStyleObj.fontSize + TXTBOX_DIFF);
	//titleTxt.border = true
	//titleTxt.autoSize = "center";
	titleTxt.wordWrap = false;
	titleTxt.selectable = false;
	var myFont:Font= new MinionPro();
	titleTxt.embedFonts = true;
	var format = new TextFormat();
	format.leading = 0;
	format.font = myFont.fontName;
	//format.bold = true;
	format.size = controlRackMain.titleTxtStyleObj.fontSize;
	format.align = "left";
	titleTxt.textColor = parseInt("0x" + controlRackMain.titleTxtStyleObj.color); //0x898a8d;
	titleTxt.defaultTextFormat = format;
	titleTxt.text = "0:00";
	//titleTxt.y = controlRackMain.CONTROL_RACK_BACK_H/2 - (FONT_SIZE + TXTBOX_DIFF)/2;
	//titleTxt.y = controlRackMain.CONTROL_RACK_BACK_H/2 - (titleTxt.textHeight)/2;
	trace("titleTxt.height: " + titleTxt.height);
	trace("titleTxt.textHeight: " + titleTxt.textHeight);
	//titleTxt.y = controlRackMain.CONTROL_RACK_BACK_H/2 - titleTxt.height/2;
}


}	
}
