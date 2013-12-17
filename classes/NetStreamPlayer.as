
package{
import flash.display.*;
import flash.events.*;
import flash.media.Video;
import flash.net.*;
import flash.utils.*;


public class NetStreamPlayer extends MovieClip{
private var netStreamHolder:DynamicMovie;
private var myNetConnection:NetConnection;
private var myNetStream:NetStream;
private var myDuration:Number;
private var docRoot:Main;
private var curVideoUrl:String;
private var video:Video;
public var curState:String = "inactive";

public function NetStreamPlayer(_docRoot:Main){
	docRoot = _docRoot;
	
	setConnection();
}
public function getDuration(){
	//return(myNetStream.duration);
	return(myDuration);
}
public function getPosition(){
	return(myNetStream.time);
}
//public function onProgress(evt:AkamaiHDSEvent){
	//dispatchEvent(new Event("onProgress"));
//}
public function seek(_secs:Number){
	myNetStream.seek(_secs);
}
public function nowPlaying(){
	return(curState == "isPlaying");
}
public function playPauseToggle(evt:MouseEvent){
	if(curState == "inactive" || curState == "isStopped"){
		myNetStream.play(curVideoUrl);
	}
	else
	if(curState != "isPlaying"){
		myNetStream.resume();
	}
	else{
		myNetStream.pause();
	}
}
private function setConnection(){
	myNetConnection = new NetConnection();
	myNetConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
	myNetConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	myNetConnection.connect(null);
}
private function connectStream():void {
	//netStreamHolderHolder = new Sprite();
	//netStreamHolder = new DynamicMovie();
	// ctlBtns is at the top - addChild just below ctlBtns
	//netStreamHolderHolder.addChild(netStreamHolder);
	
	myNetStream = new NetStream(myNetConnection);
	myNetStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
	myNetStream.client = this; //new CustomClient();
	video = new Video(docRoot.playerSizer.PLAYER_W, docRoot.playerSizer.PLAYER_H);
	video.attachNetStream(myNetStream);
	addChild(video);
	trace("connectStream complete");
}
public function playVideo(_videoUrl){
	docRoot.myTrace("playVideo: " + _videoUrl);
	curVideoUrl = _videoUrl;
	myNetStream.play(_videoUrl);
}
private function startProgressEvents(){
	addEventListener(Event.ENTER_FRAME, dispatchProgressEvents);
}
private function stopProgressEvents(){
	removeEventListener(Event.ENTER_FRAME, dispatchProgressEvents);
}
private function dispatchProgressEvents(evt:Event){
	dispatchEvent(new Event("onProgress"));
}
private function netStatusHandler(event:NetStatusEvent):void {
	switch(event.info.code){
		case "NetConnection.Connect.Success":
			trace("NetConnection.Connect.Success");
			myNetConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connectStream();
			break;
		case "NetStream.Play.Start":
			docRoot.myTrace("NetStream.Play.Start");
			dispatchEvent(new Event("videoStart"));
			startProgressEvents();
			//hidePlayPauseTxt();
			curState = "isPlaying";
			//docRoot.ctlBtns.showPauseBtn("netStreamPlayer");
			break;
		case "NetStream.Play.Stop":
			docRoot.myTrace("NetStream.Play.Stop");
			dispatchEvent(new Event("videoStop"));
			stopProgressEvents();
			curState = "isStopped";
			//showPlayPauseTxt("PLAY");
			break;
		case "NetStream.Unpause.Notify":
			docRoot.myTrace("NetStream.Pause.Notify");
			dispatchEvent(new Event("videoPause"));
			startProgressEvents();
			//hidePlayPauseTxt();
			curState = "isPlaying";
			//docRoot.ctlBtns.showPauseBtn("netStreamPlayer");
			break;
		case "NetStream.Pause.Notify":
			docRoot.myTrace("NetStream.Unpause.Notify");
			dispatchEvent(new Event("videoResume"));
			stopProgressEvents();
			//showPlayPauseTxt("PLAY");
			curState = "isPaused";
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
}
/*
private function netStatusHandler(event:NetStatusEvent):void {
	switch(event.info.code){
		case "NetConnection.Connect.Success":
			trace("NetConnection.Connect.Success");
			myNetConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connectStream(videoUrl);
			//playVideo(_videoUrl, "billboard");
			break;
		case "NetStream.Play.Start":
			trace("NetStream.Play.Start");
			docRoot.myTrace("NetStream.Play.Start");
			curState = "isPlaying";
			break;
		case "NetStream.Play.Stop":
			docRoot.myTrace("NetStream.Play.Stop");
			netStreamComplete("adSuccess");
			break;
		case "NetStream.Unpause.Notify":
			docRoot.myTrace("NetStream.Pause.Notify");
			curState = "isPlaying";
			docRoot.ctlBtns.showPauseBtn("netStreamPlayer");
			break;
		case "NetStream.Pause.Notify":
			docRoot.myTrace("NetStream.Unpause.Notify");
			curState = "isPaused";
			docRoot.ctlBtns.showPlayBtn("netStreamPlayer");
			break;
		case "NetStream.Play.Failed":
			trace("NetStream.Play.Failed");
			break;
		case "NetStream.Play.StreamNotFound":
			docRoot.myTrace("NetStream.Play.StreamNotFound");
			video.clear();
			trace("NetStream.Play.StreamNotFound");
			//netStreamHolder.visible = false;
			hideNetStreamPlayer();
			videoComplete("adFailure");
			//docRoot.adHandler.myAdComplete("StreamNotFound");
			break;
		case "NetStream.Play.Full":
			docRoot.myTrace("NetStream.Play.Full");
			break;
		default:
			trace("UNHANDLED - event.info.code: " + event.info.code);
			break;
	}
}*/
private function securityErrorHandler(event:SecurityErrorEvent):void {
	trace("securityErrorHandler: " + event);
}
public function onMetaData(info:Object):void {
	docRoot.myTrace("metadata:" 
					+ "\n\tduration=" + info.duration 
					+ "\n\twidth=" + info.width 
					+ "\n\theight=" + info.height 
					+ "\n\tframerate=" + info.framerate);
	myDuration = Math.floor(info.duration);
}
public function onXMPData(info:Object):void{ 
	//trace("onXMPData: " + info.creatorTool); 
	docRoot.myTrace("onXMPData: " + info); 
}
public function onCuePoint(info:Object):void {
	trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
}
public function onPlayStatus(info:Object):void{ 
	trace("onPlayStatus");
}
/*public function netStreamComplete(reason:String){
	docRoot.myTrace("netStreamComplete: reason - " + reason);
	if(video != null)
		video.clear();
	if(myNetStream != null)
		myNetStream.close();
}*/



}
}
