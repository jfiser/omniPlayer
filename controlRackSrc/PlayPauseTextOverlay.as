package{

import flash.display.Sprite;
import flash.text.*;
import flash.events.*;
import fl.motion.easing.*;
//import com.akamai.net.f4f.hds.AkamaiStreamController;
//import com.akamai.net.f4f.hds.events.AkamaiHDSEvent;	
	
public class PlayPauseTextOverlay extends Sprite{
	
private var docRoot:Object;
private var controlRackMain:ControlRackMain;
private var videoPlayer:Object;

private var txtHolder:Sprite;
private var playPauseTxt:TextField;
private var playPauseTxtBack:TextField;

public function PlayPauseTextOverlay(_docRoot:Object, _controlRackMain:ControlRackMain){
	docRoot = _docRoot;
	controlRackMain = _controlRackMain;
	videoPlayer = _controlRackMain.videoPlayer;
	addListeners();
	addPlayPauseTxt();
	//this.buttonMode = false;	
	//this.mouseEnabled = false;
	//this.mouseChildren = false;
}
public function resize(){
	playPauseTxtBack.width = controlRackMain.playerSizer.PLAYER_W;
	playPauseTxt.width = controlRackMain.playerSizer.PLAYER_W;
	txtHolder.y = controlRackMain.playerSizer.PLAYER_H/2 - txtHolder.height/2;
}
private function addListeners(){
	controlRackMain.upDownHandler.addEventListener("controlRackUp", controlRackUp);
	controlRackMain.upDownHandler.addEventListener("controlRackDown", controlRackDown);
	
	videoPlayer.addEventListener("videoStart", videoStart);
	videoPlayer.addEventListener("videoStop", videoStop);
	videoPlayer.addEventListener("videoPause", videoPause);
	videoPlayer.addEventListener("videoResume", videoResume);
	
	/*docRoot.myTrace("videoPlayer.hdNetStream.netStream: " + videoPlayer.hdNetStream.netStream);
	if(videoPlayer.hdNetStream.netStream){
		netStreamReady(new AkamaiHDSEvent("netStreamReady"));
	}
	else{
		videoPlayer.hdNetStream.addEventListener(AkamaiHDSEvent.NETSTREAM_READY, netStreamReady);
	}*/
}
private function videoStart(evt:Event){
	hidePlayPauseTxt();
}
private function videoStop(evt:Event){
	showPlayPauseTxt("PLAY");
}
private function videoPause(evt:Event){
	showPlayPauseTxt("PLAY");
}
private function videoResume(evt:Event){
	hidePlayPauseTxt();
}

private function controlRackUp(evt:Event){
	if(videoPlayer.nowPlaying()){
		showPlayPauseTxt("PAUSE");
	}
}
private function controlRackDown(evt:Event){
	if(videoPlayer.nowPlaying()){
		hidePlayPauseTxt();
	}
}
/*private function netStreamReady(evt:AkamaiHDSEvent){
	docRoot.myTrace("netStreamReady");	
	videoPlayer.hdNetStream.netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
}*/
private function showPlayPauseTxt(_stateStr:String){
	playPauseTxtBack.text = _stateStr;
	playPauseTxt.text = _stateStr;
	TweenLite.to(txtHolder, .2, {autoAlpha:1, ease:Linear.easeOut});
}
private function hidePlayPauseTxt(){
	TweenLite.to(txtHolder, .2, {autoAlpha:0, ease:Linear.easeOut});
}
private function playPauseTxtClicked(evt:MouseEvent){
	videoPlayer.playPauseToggle(new MouseEvent("playPauseTxtClicked"))
}
private function addPlayPauseTxt(){
	this.alpha = controlRackMain.playPauseTxtOverlayStyleObj.opacity;
	
	txtHolder = new Sprite();
	this.addChild(txtHolder);
	trace("1");
	playPauseTxtBack = addTxtBox("bbbbbb");
	trace("playPauseTxtBack: " + playPauseTxtBack);
	playPauseTxtBack.x += .5;
	playPauseTxtBack.y += .5;
	trace("2");
	playPauseTxt = addTxtBox(controlRackMain.playPauseTxtOverlayStyleObj.color);
	this.addEventListener(MouseEvent.CLICK, playPauseTxtClicked);
	txtHolder.y = controlRackMain.playerSizer.PLAYER_H/2 - txtHolder.height/2;
}
private function addTxtBox(_color:String){
	var TXTBOX_DIFF:Number = 0;
	var _tf = new TextField();
	txtHolder.addChild(_tf);
	//playPauseTxt.mouseEnabled = false;
	
	_tf.width = controlRackMain.playerSizer.PLAYER_W;
	_tf.height = (controlRackMain.playPauseTxtOverlayStyleObj.fontSize + TXTBOX_DIFF);
	//_tf.border = true
	//_tf.autoSize = "center";
	_tf.wordWrap = false;
	_tf.selectable = false;
	var myFont:Font= new MinionPro();
	_tf.embedFonts = true;
	var format = new TextFormat();
	format.font = myFont.fontName;
	format.letterSpacing = -2;
	//format.bold = true;
	format.size = controlRackMain.playPauseTxtOverlayStyleObj.fontSize;
	format.align = "center";
	_tf.textColor = parseInt("0x" + _color);
	_tf.defaultTextFormat = format;
	_tf.text = "PLAY";
	//_tf.y = controlRackMain.playerSizer.PLAYER_H/2 - _tf.height/2;
	return(_tf);
}
/*private function netStatusHandler(event:NetStatusEvent):void {
	switch(event.info.code){
		case "NetConnection.Connect.Success":
			break;
		case "NetStream.Play.Start":
			docRoot.myTrace("NetStream.Play.Start");
			hidePlayPauseTxt();
			//curState = "isPlaying";
			//docRoot.ctlBtns.showPauseBtn("netStreamPlayer");
			break;
		case "NetStream.Play.Stop":
			docRoot.myTrace("NetStream.Play.Stop");
			showPlayPauseTxt("PLAY");
			break;
		case "NetStream.Unpause.Notify":
			docRoot.myTrace("NetStream.Pause.Notify");
			hidePlayPauseTxt();
			//curState = "isPlaying";
			//docRoot.ctlBtns.showPauseBtn("netStreamPlayer");
			break;
		case "NetStream.Pause.Notify":
			docRoot.myTrace("NetStream.Unpause.Notify");
			showPlayPauseTxt("PLAY");
			//curState = "isPaused";
			//docRoot.ctlBtns.showPlayBtn("netStreamPlayer");
			break;
		case "NetStream.Play.Failed":
			docRoot.myTrace("NetStream.Play.Failed");
			break;
		case "NetStream.Play.StreamNotFound":
			docRoot.myTrace("NetStream.Play.StreamNotFound");
			break;
		case "NetStream.Play.Full":
			docRoot.myTrace("NetStream.Play.Full");
			break;
		default:
			//trace("UNHANDLED - event.info.code: " + event.info.code);
			break;
	}
}*/


}	
}
