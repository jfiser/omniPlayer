package{

import flash.events.*;
import flash.display.Sprite;
import flash.display.Shape;
//import com.akamai.net.f4f.hds.AkamaiStreamController;
//import com.akamai.net.f4f.hds.events.AkamaiHDSEvent;	
	
public class Scrubber extends Sprite{
	
private var docRoot:Object;
private var controlRackMain:ControlRackMain;
private var scrubberBack:Shape;
private var progressBar:Shape;
private var videoPlayer:Object;

public function Scrubber(_docRoot:Object, _controlRackMain:ControlRackMain, _videoPlayer:Object){
	docRoot = _docRoot;
	controlRackMain = _controlRackMain;
	videoPlayer = _videoPlayer;
	addScrubber(); // scrubberBack and progressBar
	setListeners();
}
private function setListeners(){
	videoPlayer.addEventListener("onProgress", onProgress);
	this.addEventListener(MouseEvent.CLICK, scrubberClicked);
}

private function scrubberClicked(evt:MouseEvent){
	var secs = 	this.stage.mouseX / scrubberBack.width * videoPlayer.getDuration();
	//videoPlayer.hdNetStream.seek(secs);
	videoPlayer.seek(secs);
}
private function onProgress(evt:Event){
	setProgressBarWidth();
}
private function setProgressBarWidth(){
	progressBar.width = videoPlayer.getPosition() / videoPlayer.getDuration() * scrubberBack.width;
}
public function getScrubberWidth(){
	return(controlRackMain.playerSizer.PLAYER_W 
			- controlRackMain.rightSideBtnsHolder.width
			- controlRackMain.scrubberBarStyleObj.marginRight
			- controlRackMain.scrubberBarStyleObj.marginLeft);
}
public function resize(){
	scrubberBack.width = getScrubberWidth();
	setProgressBarWidth();
}
private function addScrubber(){
	scrubberBack = new Shape();
	addChild(scrubberBack);
	Drawing.drawRect(scrubberBack, 
					getScrubberWidth(), controlRackMain.CONTROL_RACK_BACK_H, 
					"0000ff", "0000ff",
					0, 0,
					90,
					"linear");
	progressBar = new Shape();
	addChild(progressBar);
	Drawing.drawRect(progressBar, 
					1, controlRackMain.CONTROL_RACK_BACK_H, 
					controlRackMain.scrubberBarStyleObj.bgColor, controlRackMain.scrubberBarStyleObj.bgColor,
					controlRackMain.scrubberBarStyleObj.opacity, controlRackMain.scrubberBarStyleObj.opacity,
					90,
				 "linear");

}


}	
}
