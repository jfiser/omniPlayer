package
{
import com.akamai.net.f4f.hds.AkamaiStreamController;
import com.akamai.net.f4f.hds.events.AkamaiHDSEvent;

import flash.display.*;
import flash.media.Video;
import flash.events.*;
import flash.system.*;

public class AkamaiHDS extends MovieClip{
//private var MEDIA:String = "http://multiplatform-f.akamaihd.net/z/multi/april11/hdworld/hdworld_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,1280x720_1900_m,1280x720_2500_m,1280x720_3500_m,.mp4.csmil/manifest.f4m";
public var hdNetStream:AkamaiStreamController;
private var docRoot:Object;

public function AkamaiHDS(){
	flash.system.Security.allowDomain("*");
}
public function initVideoEngine(_docRoot:Object){
	docRoot = _docRoot;
	hdNetStream = new AkamaiStreamController();
	
	hdNetStream.addEventListener(AkamaiHDSEvent.NETSTREAM_READY, onNetStreamReady);
	hdNetStream.addEventListener(AkamaiHDSEvent.SWITCH_REQUESTED, switchRequested);
	hdNetStream.addEventListener(AkamaiHDSEvent.SWITCH_COMPLETE, switchComplete);
	hdNetStream.addEventListener(AkamaiHDSEvent.PROGRESS, onProgress);
	hdNetStream.addEventListener(AkamaiHDSEvent.NETSTREAM_READY, netStreamReady);
}
public function getDuration(){
	return(hdNetStream.duration);
}
public function getPosition(){
	return(hdNetStream.time);
}
public function onProgress(evt:AkamaiHDSEvent){
	dispatchEvent(new Event("onProgress"));
}
public function seek(_secs:Number){
	hdNetStream.seek(_secs);
}
public function nowPlaying(){
	return(hdNetStream.isPlaying);
}
private function onNetStreamReady(evt:AkamaiHDSEvent):void{
	docRoot.myTrace("In AkamaiVideoEngine - netStreamReady");	
	var video:Video = new Video(docRoot.playerSizer.PLAYER_W, docRoot.playerSizer.PLAYER_H);
	video.attachNetStream(hdNetStream.netStream);
	addChild(video);
	//docRoot.playerHolder.addEventListener(MouseEvent.CLICK, playPauseToggle);
}
public function playPauseToggle(evt:MouseEvent){
	if(hdNetStream.isPaused){
		hdNetStream.resume();
	}
	else{
		hdNetStream.pause();
	}
}
public function playVideo(_resourceUrl:String):void{
	hdNetStream.startingIndex = 1;
	hdNetStream.play(_resourceUrl);
}
private function switchRequested(evt:AkamaiHDSEvent){
	docRoot.myTrace("switchRequested index " + evt.data.targetIndex 
					+ " (" + evt.data.streamName + " kbps)"
					+ "firstPlay: " + evt.data.firstPlay);
}
private function switchComplete(evt:AkamaiHDSEvent){
	docRoot.myTrace("switchComplete index " + evt.data.renderingIndex 
					+ " (" + evt.data.renderingBitrate + " kbps)");
}
private function netStreamReady(evt:AkamaiHDSEvent){
	docRoot.myTrace("netStreamReady");	
	hdNetStream.netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
}
private function netStatusHandler(event:NetStatusEvent):void {
	switch(event.info.code){
		case "NetConnection.Connect.Success":
			break;
		case "NetStream.Play.Start":
			docRoot.myTrace("NetStream.Play.Start");
			dispatchEvent(new Event("videoStart"));
			//hidePlayPauseTxt();
			//curState = "isPlaying";
			//docRoot.ctlBtns.showPauseBtn("netStreamPlayer");
			break;
		case "NetStream.Play.Stop":
			docRoot.myTrace("NetStream.Play.Stop");
			dispatchEvent(new Event("videoStop"));
			//showPlayPauseTxt("PLAY");
			break;
		case "NetStream.Unpause.Notify":
			docRoot.myTrace("NetStream.Pause.Notify");
			dispatchEvent(new Event("videoPause"));
			//hidePlayPauseTxt();
			//curState = "isPlaying";
			//docRoot.ctlBtns.showPauseBtn("netStreamPlayer");
			break;
		case "NetStream.Pause.Notify":
			docRoot.myTrace("NetStream.Unpause.Notify");
			dispatchEvent(new Event("videoResume"));
			//showPlayPauseTxt("PLAY");
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
}

}
}