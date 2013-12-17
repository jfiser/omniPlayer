package{

import flash.display.Sprite;
import flash.text.*;
import flash.events.*;
//import com.akamai.net.f4f.hds.AkamaiStreamController;
//import com.akamai.net.f4f.hds.events.AkamaiHDSEvent;	
	
public class VideoTimer extends Sprite{
	
private var docRoot:Object;
private var controlRackMain:ControlRackMain;
private var timerTxt:TextField;
private var videoPlayer:Object;

public function VideoTimer(_docRoot:Object, _controlRackMain:ControlRackMain){
	docRoot = _docRoot;
	controlRackMain = _controlRackMain;
	videoPlayer = controlRackMain.videoPlayer;
	addTimerTxt();
	controlRackMain.videoPlayer.addEventListener("onProgress", onProgress);
	set_xy(controlRackMain.videoTimerStyleObj.xVal, 0); 
}
private function onProgress(evt:Event){
	//var secsLeft:int = Math.floor((videoPlayer.hdNetStream.duration - videoPlayer.hdNetStream.time));
	var secsLeft:int = Math.floor((videoPlayer.getDuration() - videoPlayer.getPosition()));
	//trace(">>>: " + Math.floor((videoPlayer.hdNetStream.duration - videoPlayer.hdNetStream.time)) as String);
	if(secsLeft >= 1){
		timerTxt.text = Utils.getMinSec(secsLeft);
	}
	else{
		timerTxt.text = "0:00";
	}
}
public function set_xy(_xLoc:Number, _yLoc:Number){
	this.x = _xLoc;
	this.y = _yLoc;
}
public function verticalAlignTextField(tf: TextField): void {
    tf.y += Math.round((tf.height - tf.textHeight) / 2);
}
private function addTimerTxt(){
	var TXTBOX_DIFF:int = 0;
	timerTxt = new TextField();
	this.addChild(timerTxt);
	
	timerTxt.width = controlRackMain.videoTimerStyleObj.widthPx;
	timerTxt.height = (controlRackMain.videoTimerStyleObj.fontSize + TXTBOX_DIFF);
	//timerTxt.border = true
	//timerTxt.autoSize = "center";
	timerTxt.wordWrap = false;
	timerTxt.selectable = false;
	var myFont:Font= new MinionPro();
	timerTxt.embedFonts = true;
	var format = new TextFormat();
	format.leading = 0;
	format.font = myFont.fontName;
	//format.bold = true;
	format.size = controlRackMain.videoTimerStyleObj.fontSize; 
	format.align = "center";
	timerTxt.textColor = parseInt("0x" + controlRackMain.videoTimerStyleObj.color); //0x898a8d;
	timerTxt.defaultTextFormat = format;
	timerTxt.text = "0:00";
	timerTxt.y = controlRackMain.CONTROL_RACK_BACK_H/2 - timerTxt.height/2;
}


}	
}
