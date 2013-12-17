package{
	
import flash.system.*
import flash.display.*;
import flash.events.*;
import flash.net.NetConnection;
import flash.media.Video;
import flash.net.URLLoader;
import flash.net.URLRequest;
import com.akamai.hd.HDNetStream;
import com.akamai.hd.*;
	
public class AkamaiVideoEngine extends Sprite{
	
private var docRoot:Main;
private var netConnection:NetConnection;
public var hdNetStream:HDNetStream; // public so ctlBtns can access for the progress event
private var video:Video;
public var curState:String = null;  // null, isPaused, isPlaying, videoComplete

public function AkamaiVideoEngine(_docRoot:Main){
	docRoot = _docRoot;
	initPlayer();
}
private function initPlayer(){
	docRoot.myTrace("initPlayer");	
	netConnection = new NetConnection();
	netConnection.connect(null);
	hdNetStream = new HDNetStream(netConnection);
	video = new Video(docRoot.playerSizer.PLAYER_W, docRoot.playerSizer.PLAYER_H);
	video.smoothing = true;
	addChild(video);
	video.attachNetStream(hdNetStream);	
	//setMaxBitrate();
	
	hdNetStream.addEventListener(HDEvent.NET_STATUS, netStatusHandler);
	//hdNetStream.addEventListener(HDEvent.PLAY, onStart);
	hdNetStream.addEventListener(HDEvent.PAUSE, onPause);
	hdNetStream.addEventListener(HDEvent.RESUME, onResume);
	hdNetStream.addEventListener(HDEvent.COMPLETE, onComplete);
	hdNetStream.addEventListener(HDEvent.DEBUG, onDebug);
	hdNetStream.addEventListener(HDEvent.SEEK, seekChange);
	//hdNetStream.addEventListener(HDEvent.METADATA, onMetadata);
	hdNetStream.addEventListener(HDEvent.RENDITION_CHANGE, onRenditionChange);
	//hdNetStream.addEventListener(HDEvent.SWITCH_COMPLETE, onSwitchComplete);
}
private function seekChange(evt:HDEvent){
	
}
private function onPause(evt:HDEvent){
	docRoot.myTrace("onPause");
	if(curState != "videoComplete"){
		//dispatchEvent(new Event("mediaStop"));
		curState = "isPaused";
	}
}
private function onResume(evt:HDEvent){
	docRoot.myTrace("onResume");
	//dispatchEvent(new Event("mediaPlay"));
	curState = "isPlaying";
}
private function onComplete(evt:HDEvent){
	//dispatchEvent(new Event("mediaComplete"));
	curState = "videoComplete";
}
private function onDebug(evt:HDEvent):void{
	//docRoot.myTrace("DEBUG: " + evt.data as String);
}
private function onRenditionChange(evt:HDEvent){
	//saveLastBitrateIndex(evt.data.currentIndex, evt.data.currentKbps);
	//if(session){
		//session.setCurrentBitrate(evt.data.currentKbps);
	//}
	docRoot.myTrace("onRenditionChange index " + evt.data.currentIndex 
					+ " (" + evt.data.currentKbps + " kbps)"
					+ " out of " + (evt.data.maxIndex+1));
}
/*private function onSwitchComplete(evt:HDEvent){
	docRoot.myTrace("onSwitchComplete index: " + evt.data as Number);
}*/
private function netStatusHandler(event:HDEvent):void {
	docRoot.myTrace("NetStatus Event: " + event.data.code);
}
public function playVideo(_resourceUrl:String):void{
	//docRoot.myTrace("!!! USING TEST SMIL FILE - HARDCODE");
	//_resourceUrl = "http://disctest-f.akamaihd.net/z/digmed/hdnet/11/5f/B020JJ_12210111001197_spa_solarsail,800,1500,3500,.f4v.csmil/manifest.f4m";
	//http://customer-f.akamaihd.net/z/file_prefix,100,500,600,.f4v.csmil/manifest.f4m
	
	/*if(_setLastBitrate){
		hdNetStream.startingIndex = lastBitrateIndex;
		docRoot.myTrace("Setting lastBitrateIndex: " + hdNetStream.startingIndex);
	}
	else{
		hdNetStream.startingIndex = 0;
		docRoot.myTrace("Not setting lastBitrateIndex: " + lastBitrateIndex);
	}*/
	
    /*if(session){
		session.cleanup();
	}*/
	docRoot.myTrace("playing");	
	hdNetStream.play(_resourceUrl);
	//docRoot.myTrace("mediaBegin");
	//dispatchEvent(new Event("mediaLoad"));
	//dispatchEvent(new Event("mediaBegin"));
	curState = "isPlaying";
}





}	
}
