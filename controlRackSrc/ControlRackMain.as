package{
	
import flash.display.*;
import flash.system.*;
import flash.text.*;
//import com.akamai.net.f4f.hds.AkamaiStreamController;
//import com.akamai.net.f4f.hds.events.AkamaiHDSEvent;	

public class ControlRackMain extends Sprite{
	
private var docRoot:Object; // A reference to the root stage object
private var chromeHolder:Sprite // This is the Sprite you'll addChild to - to display the plugin graphics
public var rightSideBtnsHolder:Sprite;
// videoPlayer.hdNetStream is the actual AkamaiStreamController object. You can access all methods and properties
// like this: videoPlayer.hdNetStream.play() or videoPlayer.hdNetStream.isPaused, etc - see man pages for all methods and props 
public var videoPlayer:Object; 
public var styleSheet:StyleSheet;
public var playerSizer:Object;
private var elemArr:Array = [];
public var controlRackBack:ControlRackBack;
public var playPauseTextOverlay:PlayPauseTextOverlay;
public var titleText:TitleText;
public var scrubber:Scrubber;
public var videoTimer:VideoTimer;
public var volumeController:VolumeController;
public var fullScreenHandler:FullScreenHandler;
public var resizer:Resizer;
public var controlRackMask:Shape;
public var upDownHandler:UpDownHandler;
	
public var controlRackBackStyleObj:Object;
public var scrubberBarStyleObj:Object;
public var videoTimerStyleObj:Object;
public var volumeBarBackStyleObj:Object;
public var volumeBarStyleObj:Object;
public var volumeBarIconStyleObj:Object;
public var fullScreenBtnStyleObj:Object;
public var playPauseTxtOverlayStyleObj:Object;
public var titleTxtStyleObj:Object;

public var CONTROL_RACK_BACK_H:Number;

public function ControlRackMain(){
	flash.system.Security.allowDomain("*");
}
public function initPlugin(_docRoot:Object, _chromeHolder:Sprite, _videoPlayer:Object, _styleSheet:StyleSheet, _playerSizer:Object){
	docRoot = _docRoot;
	chromeHolder = _chromeHolder;
	videoPlayer = _videoPlayer; 
	styleSheet = _styleSheet;
	playerSizer = _playerSizer;
	
	resizer = new Resizer(docRoot, this, playerSizer);
	setStyles();
	//set_xy();
	
	//chromeHolder.addChild(this);
	rightSideBtnsHolder = new Sprite();
	
	controlRackBack = new ControlRackBack(docRoot, this);
	elemArr.push(controlRackBack);
	this.addChild(controlRackBack);
	
	scrubber = new Scrubber(docRoot, this, videoPlayer);
	elemArr.push(scrubber);
	this.addChild(scrubber);
	
	//----------------------------
	
	// when we resize, only the rightSideBtnsHolder will move - left or right
	//rightSideBtnsHolder.y = 200;
	
	videoTimer = new VideoTimer(docRoot, this);
	elemArr.push(videoTimer);
	rightSideBtnsHolder.addChild(videoTimer);
	
	volumeController = new VolumeController(docRoot, this);
	elemArr.push(volumeController);
	rightSideBtnsHolder.addChild(volumeController);
	trace(volumeController);
	
	fullScreenHandler = new FullScreenHandler(docRoot, this);
	elemArr.push(fullScreenHandler);
	rightSideBtnsHolder.addChild(fullScreenHandler);
	// add rightSideBtnsHolder last - so it's on top of scrubber
	this.addChild(rightSideBtnsHolder);
	// we don't know the width of scrubber until we know the width of rightSideBtns
	// so - wait until now to set it
	scrubber.resize();
	set_xy();
	addControlRackMask();
	upDownHandler = new UpDownHandler(docRoot, this, playerSizer);
	docRoot.myTrace("ControlRack version: 130926_1403");  
	
	// titleText sits on top of scrubber. We need to know how wide rightSideBtnHolders is to size it.
	// So - add it after rightSideBtnsHolder is set
	titleText = new TitleText(docRoot, this);
	elemArr.push(titleText);
	this.addChild(titleText);
	
	addPlayPauseTextOverlay();
	// Add the controlRack (this) to chromeHolder last - so playPauseTextOverlay is behind  the controlRack
	chromeHolder.addChild(this);
	this.mouseEnabled = false;
}
private function addPlayPauseTextOverlay(){
	playPauseTextOverlay = new PlayPauseTextOverlay(docRoot, this);
	chromeHolder.addChild(playPauseTextOverlay);
	//chromeHolder.mouseChildren = false;
	//playPauseTextOverlay.mouseEnabled = false;
	playPauseTextOverlay.mouseChildren = false;
}
public function set_xy(){
	this.x = 0;
	this.y = playerSizer.PLAYER_H - controlRackBackStyleObj.heightPx;
	rightSideBtnsHolder.x = playerSizer.PLAYER_W - rightSideBtnsHolder.width;
}
// translate each CSS style into a normal Flash Object
private function setStyles(){
	controlRackBackStyleObj = StyleSetter.setProperties(styleSheet.getStyle(".controlRackBack"));
	scrubberBarStyleObj = StyleSetter.setProperties(styleSheet.getStyle(".scrubberBar"));
	videoTimerStyleObj = StyleSetter.setProperties(styleSheet.getStyle(".videoTimer"));
	volumeBarBackStyleObj = StyleSetter.setProperties(styleSheet.getStyle(".volumeBarBack"));
	volumeBarStyleObj = StyleSetter.setProperties(styleSheet.getStyle(".volumeBar"));
	volumeBarIconStyleObj = StyleSetter.setProperties(styleSheet.getStyle(".volumeBarIcon"));
	fullScreenBtnStyleObj = StyleSetter.setProperties(styleSheet.getStyle(".fullScreenBtn"));
	playPauseTxtOverlayStyleObj = StyleSetter.setProperties(styleSheet.getStyle(".playPauseTxtOverlay"));
	titleTxtStyleObj = StyleSetter.setProperties(styleSheet.getStyle(".titleTxtOnScrubber"));
	
	CONTROL_RACK_BACK_H = controlRackBackStyleObj.heightPx;
}
// Create a mask the shape of the video window - so when the controlRack hides, you can't see it.
// You must only mask the lugin you make - not the main SWF. That way, other plugins can do the same and you won't 
// unintentionally mask other plugins.
private function addControlRackMask(){
	controlRackMask = new Shape();
	docRoot.maskHolder.addChild(controlRackMask);
	Drawing.drawRect(controlRackMask, 
					playerSizer.PLAYER_W, playerSizer.PLAYER_H, 
					"00ff00", "00ff00",
					.2, .2,
					90,
					"linear");
	this.mask = controlRackMask;
}
/*private function addDivLine(_xLoc){
	var divLine = divLineArr[divLineArr.length] = new DivLine();
	divLine.x = _xLoc;
	divLine.height = ControlBarDefines.SCRUBBER_H;
	divLine.alpha = .25;
	rightSideHolder.addChild(divLine);
}*/



}
}
