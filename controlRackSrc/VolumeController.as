package{

import flash.display.*;
import flash.events.*;
import flash.utils.*;
import flash.geom.*
import fl.motion.easing.*;
import flash.media.*;

public class VolumeController extends Sprite{
	
private var docRoot:Object;
private var controlRackMain:ControlRackMain;
//private var rightSideBtnsHolder:Sprite
private var xLoc:Number;

public var soundBtnHolder:Sprite;
private var speakerBack:Shape;
public var scrubberHolder:Sprite;
private var scrubberBack:Shape; //ScrubberBack; //Loader;
private var soundBarHolder:Sprite;
private var speakerHolderHolder:Sprite;
private var speakerHolder:Sprite;
private var progressBar:Shape; //SoundProgressBar; //Loader;
private var handleHolder:Sprite;
//private var soundHandleLoader:ScrubberHandle; //Loader;
private var soundBarMask:Shape;
private var soundHandleRect:Rectangle
private var isMuted:Boolean = false;
private var handleDragRect:Rectangle;
private var speakerNormHolder:VolumeNorm; //Loader;
private var speakerMuteHolder:VolumeMute; //Loader;
private var soundTrans:SoundTransform;
private var soundTimer:Timer;
private var prevSoundHandle_y:Number;
private var divLine:DivLine;

private var HANDLE_X:Number = -5;
private var HANDLE_Y:Number = 3;
private var SOUND_BAR_H:Number = 85;
private var SOUND_BAR_TOP:Number = 12;
private var SOUND_BAR_BTM:Number = 52;
private var SOUND_SCRUBBER_H:Number = 115;

public var ELEM_W:Number = 40;

public function VolumeController(_docRoot:Object, _controlRackMain:ControlRackMain){
	docRoot = _docRoot;
	controlRackMain = _controlRackMain;
	//xLoc = _xLoc;
	
	//soundTrans = SoundMixer.soundTransform;
	//soundTrans = controlRackMain.videoPlayer.hdNetStream.soundTransform;
	soundTrans = new SoundTransform();
	soundTimer = new Timer(40, 0);
	soundTimer.addEventListener(TimerEvent.TIMER, soundSeek);
	
	addSoundBtnHolder();
	addSoundScrubber();
	addSpeakerBtn();
	addScrubberMask();
	addDivLine();
	set_xy(controlRackMain.volumeBarStyleObj.xVal, 0);
	//if(docRoot._mute){
		//speakerClick(new Event("Mute from page"));
	//}
	//docRoot.freeWheelHandler.addEventListener("fwEventRequestComplete", fwEventRequestComplete);
}
private function addDivLine(){
	divLine = new DivLine(docRoot, 1, controlRackMain.CONTROL_RACK_BACK_H, "ffffff", .5);
	this.addChild(divLine);
}
/*private function fwEventRequestComplete(evt:Event){
	docRoot.myTrace("volumeController - fwEventRequestComplete; seting FW volume: " + soundTrans.volume*100);
	docRoot.freeWheelHandler.setVolume(soundTrans.volume*100);
}*/
public function set_xy(_xLoc:Number, _yLoc:Number){
	this.x = _xLoc;
	this.y = _yLoc;
}
private function addSoundBtnHolder(){
	soundBtnHolder = new Sprite();
	//soundBtnHolder.x = xLoc;
	//soundBtnHolder.x = ControlBarDefines.SHARE_BTN_W;
	//rightSideBtnsHolder.addChild(soundBtnHolder);
	this.addChild(soundBtnHolder);
	//addSoundBtnBack();
	
	soundBtnHolder.buttonMode = true;
	//soundBtnHolder.mouseChildren = false;
	soundBtnHolder.addEventListener(MouseEvent.MOUSE_OVER, speakerOver);
	soundBtnHolder.addEventListener(MouseEvent.MOUSE_OUT, speakerOut);
}
private function addSoundScrubber(){
	scrubberHolder = new Sprite();
	soundBtnHolder.addChild(scrubberHolder);
	scrubberHolder.addEventListener(MouseEvent.CLICK, soundScrubberClick);

	scrubberBack = new Shape(); //ScrubberBack(); //Loader();
	Drawing.drawRect(scrubberBack, 
				 controlRackMain.volumeBarStyleObj.widthPx, 8, 
				 controlRackMain.volumeBarBackStyleObj.bgColor, controlRackMain.volumeBarBackStyleObj.bgColor,
				 controlRackMain.volumeBarBackStyleObj.opacity, controlRackMain.volumeBarBackStyleObj.opacity,
				 90,
				 "linear");
	
	scrubberBack.alpha = .75;
	scrubberHolder.addChild(scrubberBack);
	//soundBackBarLoaded(new Event("Embedded-not-Loaded"));
	scrubberBack.width = controlRackMain.volumeBarStyleObj.widthPx;
	scrubberBack.height = SOUND_SCRUBBER_H;
	//scrubberBack.contentLoaderInfo.addEventListener(Event.INIT, soundBackBarLoaded);
	
	//scrubberHolder.scaleY = -1;
	var progressBarHolder = new Sprite();
	scrubberHolder.addChild(progressBarHolder);
	progressBarHolder.scaleY = -1;
	
	progressBar = new Shape(); //SoundProgressBar();
	Drawing.drawRect(progressBar, 
				 controlRackMain.volumeBarStyleObj.widthPx, 8, 
				 controlRackMain.volumeBarStyleObj.bgColor, controlRackMain.volumeBarStyleObj.bgColor,
				 controlRackMain.volumeBarStyleObj.opacity, controlRackMain.volumeBarStyleObj.opacity,
				 90,
				 "linear");
	
	progressBar.y = SOUND_SCRUBBER_H * -1;
	//ControlBarDefines.setColor(progressBar, "ffcc00");
	progressBar.alpha = .7;
	progressBarHolder.addChild(progressBar);
	
	handleHolder = new Sprite();
	addHandleBack();
	scrubberHolder.addChild(handleHolder); 
	handleHolder.buttonMode = true;
	
	handleHolder.addEventListener(MouseEvent.MOUSE_DOWN, soundHandleStartDrag);
	handleHolder.addEventListener(MouseEvent.MOUSE_UP, soundHandleStopDrag);
	//handleDragRect = new Rectangle(0, 0, SOUND_BAR_W, 0);
	handleDragRect = new Rectangle(0, 0, 0, SOUND_SCRUBBER_H);
	
	setCurVolumeLevel();
	/*if(docRoot._mute){
		speakerClick(new Event("Mute from page"));
	}*/
}
/*private function soundHandleOver(evt:Event){
	//handleLoader.visible = true;
	TweenLite.to(soundHandleLoader, .7, {autoAlpha:1, ease:Exponential.easeOut});
}
private function soundHandleOut(evt:Event){
	//handleLoader.visible = false;
	TweenLite.to(soundHandleLoader, .7, {autoAlpha:0, ease:Exponential.easeOut});
}*/
public function addHandleBack(){
	var handleBack = new Shape();
	//var back_w:Number = 55;
	handleHolder.addChild(handleBack);
	//handleBack.x = back_w/-2;
	Drawing.drawRect(handleBack, 
				 controlRackMain.volumeBarStyleObj.widthPx, 8, 
				 "ff0000", "ff0000",
				 0, 0,
				 90,
				 "linear");
}
private function addSpeakerBtn(){
	speakerHolderHolder = new Sprite();
	soundBtnHolder.addChild(speakerHolderHolder);
	addSpeakerBack();
	speakerHolder = new Sprite();
	speakerHolder.mouseChildren = false;
	speakerHolderHolder.addChild(speakerHolder);
	//ControlBarDefines.setColor(speakerHolder, ControlBarDefines.NORM_BTN_TXT_COLOR);
	Utils.setColor(speakerHolder, controlRackMain.volumeBarIconStyleObj.bgColor)
	
	speakerNormHolder = new VolumeNorm(); //Loader();
	//Utils.setColor(speakerNormHolder, controlRackMain.volumeBarIconStyleObj.bgColor)
	speakerHolder.addChild(speakerNormHolder);

	speakerMuteHolder = new VolumeMute(); //Loader();
	//Utils.setColor(speakerMuteHolder, controlRackMain.volumeBarIconStyleObj.bgColor)
	speakerMuteHolder.visible = false;
	speakerHolder.addChild(speakerMuteHolder);
	speakerHolder.x = controlRackMain.volumeBarStyleObj.widthPx/2 - speakerHolder.width/2;
	speakerHolder.y = controlRackMain.CONTROL_RACK_BACK_H/2 - speakerHolder.height/2;
	
	speakerHolderHolder.addEventListener(MouseEvent.CLICK, speakerClick);
}
private function addSpeakerBack(){
	speakerBack = new Shape();
	//btnBack.y = speakerHolder.y * -1;
	speakerHolderHolder.addChild(speakerBack);
	Drawing.drawRect(speakerBack, 
				 controlRackMain.volumeBarStyleObj.widthPx, controlRackMain.CONTROL_RACK_BACK_H, 
				 "000000", "000000",
				 0, 0,
				 90,
				 "linear");
	//soundBtnHolder.visible = true;
}
private function speakerOver(evt:Event){
	//ControlBarDefines.setColor(speakerHolder, ControlBarDefines.OVER_BTN_TXT_COLOR);
	//ControlBarDefines.setColor(soundBtnBack, controlRackMain.styleObj.btnOverColor);
	TweenLite.to(scrubberHolder, .5, {y:SOUND_SCRUBBER_H * -1, ease:Exponential.easeOut});
}
private function speakerOut(evt:Event){
	//ControlBarDefines.setColor(speakerHolder, ControlBarDefines.NORM_BTN_TXT_COLOR);
	//ControlBarDefines.setColor(soundBtnBack, "000000");
	TweenLite.to(scrubberHolder, .5, {y:0, ease:Exponential.easeOut});
}
private function speakerClick(evt:Event){
	docRoot.myTrace("speakerClick");
	var tweenTime:Number = .5;
	if(isMuted){
		speakerNormHolder.visible = true;
		speakerMuteHolder.visible = false;
		isMuted = false;
		//soundSeek(new Event("speakerClick"));
		tweenProgressBar(prevSoundHandle_y);
	}
	else{
		prevSoundHandle_y = handleHolder.y;
		speakerNormHolder.visible = false;
		speakerMuteHolder.visible = true;
		isMuted = true;
		soundTrans.volume = 0;
		//SoundMixer.soundTransform = soundTrans;
		//controlRackMain.videoPlayer.hdNetStream.soundTransform = soundTrans;
		docRoot.soundTransform = soundTrans;
		//docRoot.freeWheelHandler.setVolume(0);
		tweenProgressBar(SOUND_SCRUBBER_H);
	}
	speakerHolder.dispatchEvent(new Event(isMuted ? "onMute" : "onUnMute"));
}
public function soundSeek(evt:Event){
	progressBar.height = SOUND_SCRUBBER_H - handleHolder.y;
	//var myVol = handleHolder.y / SOUND_SCRUBBER_H;
	var myVol = progressBar.height / SOUND_SCRUBBER_H;
	soundTrans.volume = myVol;
	//SoundMixer.soundTransform = soundTrans;
	//controlRackMain.videoPlayer.hdNetStream.soundTransform = soundTrans;
	docRoot.soundTransform = soundTrans;
	//docRoot.freeWheelHandler.setVolume(myVol*100);
}
private function tweenProgressBar(_yLoc:Number){
	var tweenTime:Number = .5;
	//TweenLite.to(handleHolder, tweenTime, {y:_yLoc, ease:Exponential.easeOut});
	handleHolder.y = _yLoc;
	TweenLite.to(progressBar, tweenTime, {height:SOUND_SCRUBBER_H - _yLoc, ease:Exponential.easeOut, 
				 							onComplete:mySoundSeek});
}
private function mySoundSeek(){
	soundSeek(new Event("unMute"));
}
private function addScrubberMask(){
	var scrubberMask = new Shape();
	scrubberMask.y = SOUND_SCRUBBER_H * -1;
	soundBtnHolder.addChild(scrubberMask);
	Drawing.drawRect(scrubberMask, 
				 controlRackMain.volumeBarStyleObj.widthPx, SOUND_SCRUBBER_H, 
				 "00ff00", "00ff00",
				 .4, .4,
				 90,
				 "linear");
	 scrubberHolder.mask = scrubberMask;
}
public function getEnd_xLoc(){
	return(soundBtnHolder.x + soundBtnHolder.width);
}
public function setCurVolumeLevel(){
	handleHolder.y = 0; //soundTrans.volume * SOUND_SCRUBBER_H;
	soundSeek(new Event("Current Level"));
}
private function soundScrubberClick(evt:Event){
	speakerNormHolder.visible = true;
	speakerMuteHolder.visible = false;
	isMuted = false;
	
	tweenProgressBar(scrubberHolder.mouseY);
	//handleHolder.y = SOUND_SCRUBBER_H - scrubberHolder.mouseY;
	//soundSeek(new Event("scrubberClick"))
}
public function muteSound(){
	soundTrans.volume = 0;
	//SoundMixer.soundTransform = soundTrans;
	//controlRackMain.videoPlayer.hdNetStream.soundTransform = soundTrans;
	//controlRackMain.videoPlayer.soundTransform = soundTrans;
	docRoot.soundTransform = soundTrans;
}
private function soundHandleStartDrag(evt:Event){
	//soundHandle.startDrag(false, soundHandle._x, SOUND_BAR_BTM, soundHandle._x, SOUND_BAR_TOP);
	speakerNormHolder.visible = true;
	speakerMuteHolder.visible = false;
	isMuted = false;
	soundTimer.start();
	handleHolder.startDrag(false, handleDragRect);
	handleHolder.stage.addEventListener(MouseEvent.MOUSE_UP, soundHandleStopDrag);
}
private function soundHandleStopDrag(evt:Event){
	soundTimer.stop();
	handleHolder.stopDrag();
	handleHolder.stage.removeEventListener(MouseEvent.MOUSE_UP, soundHandleStopDrag);
}
public function getPrevSoundHandlePercent(){
	return(prevSoundHandle_y / SOUND_SCRUBBER_H);
}
}
}
