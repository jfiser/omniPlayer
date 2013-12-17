 

package{
	
import flash.events.*;
import flash.net.*;
import flash.external.ExternalInterface;
import flash.utils.describeType;

public class PageCommunicator{
	
private var docRoot:Main;

function PageCommunicator(_docRoot:Main){
	docRoot = _docRoot;
	//docRoot.bcPlayer.addEventListener("mediaBegin", sendClipStartEvent);
	//docRoot.ctlBtns.addEventListener("playlistComplete", playlistComplete);
	setJavaScriptCallbacks();
}
private function setJavaScriptCallbacks(){
	docRoot.myTrace("pageCommunicator setJavaScriptCallbacks()");
	if(ExternalInterface.available){
		try{
			ExternalInterface.addCallback("startPlay", startPlay_fromPage);
			ExternalInterface.addCallback("pausePlayerAndHaltAd", pausePlayerAndHaltAd_fromPage);
		}
		catch(err){
			docRoot.myTrace("addCallback startPlay: Cannot access ExternalInterface from this page");
		}
	}
}
public function setListeners(){
	// Old events kept in for legacy pages
	docRoot.addEventListener("videoCued", sendClipStartEvent);
	docRoot.bcPlayer.addEventListener("mediaBegin", videoPlaying);
	docRoot.bcPlayer.addEventListener("mediaPlay", videoPlaying);
	docRoot.freeWheelHandler.addEventListener("adStart", videoPlaying);
	docRoot.ctlBtns.addEventListener("playlistComplete", playlistComplete);
	// Triton call
	docRoot.bcPlayer.addEventListener("mediaComplete", tritonVideoComplete);
	docRoot.freeWheelHandler.addEventListener("adStart", tritonAdStart);
	
	// New events for API to page
	//if(docRoot.configXmlObj.usePageCommunicateApi == "true"){
		docRoot.freeWheelHandler.addEventListener("adStart", fireEventToPage);
		docRoot.freeWheelHandler.addEventListener("adComplete", fireEventToPage);
		docRoot.bcPlayer.addEventListener("mediaBegin", fireEventToPage);
		docRoot.bcPlayer.addEventListener("mediaLoad", fireEventToPage);
		docRoot.bcPlayer.addEventListener("mediaComplete", fireEventToPage);
		docRoot.bcPlayer.addEventListener("mediaStop", fireEventToPage);
		docRoot.bcPlayer.addEventListener("mediaPlay", fireEventToPage);
		docRoot.bcPlayer.addEventListener("mediaSeek", fireEventToPage);
		docRoot.ctlBtns.addEventListener("showPostRollScreen", fireEventToPage);
		docRoot.ctlBtns.addEventListener("seekStart", fireEventToPage);
		
		docRoot.ctlBtns.addEventListener("ctlBtnsUp", fireEventToPage);
		docRoot.ctlBtns.addEventListener("ctlBtnsDown", fireEventToPage);
		// Social media
		docRoot.ctlBtns.shareBtnControl.addEventListener("facebookBtnClick", fireEventToPage);
		docRoot.ctlBtns.shareBtnControl.addEventListener("twitterBtnClick", fireEventToPage);
		docRoot.ctlBtns.shareBtnControl.addEventListener("EmbedCodeBtnClick", fireEventToPage);
		
		
	//}
	// set up the callbacks so page can call funcs
	if(ExternalInterface.available){
		try{
			ExternalInterface.addCallback("pauseVideo", pause_fromPage);
			ExternalInterface.addCallback("resumeVideo", resume_fromPage);
			ExternalInterface.addCallback("gotoTime", gotoTime_fromPage);
			ExternalInterface.addCallback("playClip", playClip_fromPage);
		}
		catch(err){
			docRoot.myTrace("addCallback playClip: Cannot access ExternalInterface from this page");
		}
	}
	else{
		docRoot.myTrace("addCallback playClip: Cannot access ExternalInterface from this page");
	}
}
private function tritonAdStart(evt:Event){
	if(docRoot.curTitle.durationForm != "LongForm"){
		return;
	}
	docRoot.myTrace("tritonAdStart");
	var retVal:Boolean;
	retVal = ExternalInterface.call("DDM.loyalty.trackEvent",
						   "adStarted",
						   docRoot.curTitle.durationForm == "ShortForm" ? "short" : "long",
						   docRoot.curTitle.vapURL);
	docRoot.myTrace("tritonAdStart retVal: " + retVal);
}
private function tritonVideoComplete(evt:Event){
	docRoot.myTrace("tritonVideoComplete");
	var retVal:Boolean;
	retVal = ExternalInterface.call("DDM.loyalty.trackEvent",
						   "videoCompleted",
						   docRoot.curTitle.durationForm == "ShortForm" ? "short" : "long",
						   docRoot.curTitle.vapURL);
	docRoot.myTrace("tritonVideoComplete retVal: " + retVal);
}
public function playClip_fromPage(_refId:String){
	docRoot.myTrace("playClip_fromPage: " + _refId + " ; curState: " + docRoot.bcPlayer.curState);
	if(docRoot.bcPlayer.curState == "videoComplete"){
		if(docRoot.screenSwapper.finHandler.finShowing){
			docRoot.screenSwapper.finHandler.hideFin();
		}
		docRoot.ctlBtns.setCtlBtnsUpDown();
	}
	var _referenceId = docRoot.playlist.setIndxUsingRefId(_refId);
	// wait for ad to complete if ad is running - if not - just play the clip
	if(!docRoot.freeWheelHandler.adRunning || !docRoot.waitForAdsToComplete){
		docRoot.cueNextVideo(null, docRoot.playlist.getCurClipObject(), "playlistClicked");
	}
	else{
		docRoot.freeWheelHandler.setWaitingForAdToComplete(true);
	}
}
public function pause_fromPage(){
	docRoot.myTrace("pause_fromPage: " + docRoot.bcPlayer.curState);
	if(docRoot.freeWheelHandler.adRunning){
		docRoot.freeWheelHandler.handlePlayBtn();
	}
	else
	if(docRoot.bcPlayer.curState == "isPlaying"){
		docRoot.bcPlayer.pause();
	}
}
public function resume_fromPage(){
	docRoot.myTrace("resume_fromPage: " + docRoot.bcPlayer.curState);
	if(docRoot.bcPlayer.curState == "isPaused"){
		docRoot.bcPlayer.resume();
	}
}
public function gotoTime_fromPage(_refId:String, _secs:Number){
	docRoot.myTrace("gotoTime_fromPage: " + _secs);
	docRoot.bcPlayer.seek(_secs);
}

public function fireEventToPage(evt){
	if(ExternalInterface.available){
		try{
			switch(evt.type){
				case "ctlBtnsUp": 
					ExternalInterface.call("DDM.video.player.mouseOverPlayer", createClipObject_new()); 
					break;
				case "ctlBtnsDown": 
					ExternalInterface.call("DDM.video.player.mouseOffPlayer", createClipObject_new()); 
					break;
				case "adStart": 
					ExternalInterface.call("DDM.video.player.adStart", createClipObject_new()); 
					break;
				case "adComplete": 
					ExternalInterface.call("DDM.video.player.adEnded", createClipObject_new()); 
					break;
				case "mediaLoad": 
					ExternalInterface.call("DDM.video.player.loadStart", createClipObject_new()); 
					break;
				case "mediaBegin": 
					ExternalInterface.call("DDM.video.player.clipStart", createClipObject_new()); 
					break;
				case "mediaComplete": 
					ExternalInterface.call("DDM.video.player.clipEnded", createClipObject_new()); 
					break;
				case "mediaStop": 
					ExternalInterface.call("DDM.video.player.paused", createClipObject_new()); 
					break;
				case "mediaPlay": 
					//ExternalInterface.call("DDM.video.player.playing", docRoot.curTitle.referenceId);
					ExternalInterface.call("DDM.video.player.playing", createClipObject_new()); 
					break;
				case "mediaSeek": 
					ExternalInterface.call("DDM.video.player.seeked", createClipObject_new(), 
										   								evt.position); 
					break;
				case "showPostRollScreen": 
					ExternalInterface.call("DDM.video.player.postRoll", createClipObject_new()); 
					break;
				case "seekStart": 
					ExternalInterface.call("DDM.video.player.seeking", createClipObject_new()); 
					break;
				case "shareBtnClick": 
					ExternalInterface.call("DDM.video.player.shareClick", createClipObject_new()); 
					break;
				// Social events
				case "facebookBtnClick": 
					ExternalInterface.call("DDM.video.player.shareClick", "facebook-share", createClipObject_new()); 
					break;
				case "twitterBtnClick": 
					ExternalInterface.call("DDM.video.player.shareClick", "twitter-share", createClipObject_new()); 
					break;
				case "EmbedCodeBtnClick": 
					ExternalInterface.call("DDM.video.player.shareClick", "video-snag", createClipObject_new()); 
					break;
			}
		}
		catch(err){
			docRoot.myTrace(evt.type + ": Cannot access ExternalInterface from this page");
		}
	}
}
public function videoPlaying(evt:Event){
	docRoot.myTrace("videoPlaying call to page");
	if(ExternalInterface.available){
		try{
			ExternalInterface.call("videoPlaying");
		}
		catch(err){
			docRoot.myTrace("videoPlaying: Cannot access ExternalInterface from this page");
		}
	}
}
// This can occur when the Player is in a DRL. The Player would be in an _autoStart=no state
public function startPlay_fromPage(){
	// if freewheelHandler exists - that means startPlayer has already been called.
	// Don't accept any call to startPlay from page
	if(docRoot.freeWheelHandler){
		return;
	}
	docRoot.myTrace("startPlay_fromPage received from page");
	if(docRoot.screenSwapper.startScreenHandler){
		docRoot.screenSwapper.startScreenHandler.startScreenClick(new Event("startPlay_fromPage"));
	}
}
public function pausePlayerAndHaltAd_fromPage(){
	docRoot.myTrace("pausePlayerAndHaltAd_fromPage received from page");
	if(docRoot.freeWheelHandler && docRoot.freeWheelHandler.adRunning){
		docRoot.freeWheelHandler.stopCurSlot(true); // true means _adStoppedByPage
		docRoot.ctlBtns.showControls();
		docRoot.screenSwapper.swapScreens(docRoot.screenSwapper.startScreenHandler.startScreenHolder);
	}
	else
	if(docRoot.bcPlayer && docRoot.bcPlayer.curState == "isPlaying"){
		docRoot.ctlBtns.pauseBtnClick(new Event("pausePlayerAndHaltAd_fromPage"));
	}
}
public function videoComplete(){
	var noMoreVideos:Boolean = true;
	if(docRoot.screenSwapper.finHandler.continuousPlayHandler
	   			&& !docRoot.screenSwapper.finHandler.continuousPlayHandler.allClipsDone()){
		noMoreVideos = false;
	}
	if(ExternalInterface.available){ 
		try{
			ExternalInterface.call("videoComplete", noMoreVideos);
		}
		catch(err){
			docRoot.myTrace("videoComplete: Cannot access ExternalInterface from this page");
		}
	}
}
public function playerReady(){
	if(ExternalInterface.available){
		try{
			ExternalInterface.call("playerReady");
		}
		catch(err){
			docRoot.myTrace("playerReady: Cannot access ExternalInterface from this page");
		}
	}
}
private function sendClipStartEvent(evt:Event){
	docRoot.myTrace("mediaBegin event sent to page");
	if(ExternalInterface.available){
		try{
			ExternalInterface.call("clipNowPlaying", createClipObject_new());
		}
		catch(err){
			docRoot.myTrace("clipNowPlayingAndNextClip: Cannot access ExternalInterface from this page");
		}
	}
}
private function playlistComplete(evt:Event){
	docRoot.myTrace("playlistComplete event sent to page");
	if(docRoot.configXmlObj.tellPageClipNowPlaying == "clipNowPlayingAndNextClip"){
		if(ExternalInterface.available){
			try{
				ExternalInterface.call("clipNowPlayingAndNextClip", 
											   null, 
											   "", 
											   "");
			}
			catch(err){
				docRoot.myTrace("clipNowPlayingAndNextClip: Cannot access ExternalInterface from this page");
			}
		}
	}
	else{
		if(ExternalInterface.available){
			try{
				ExternalInterface.call("clipNowPlaying", null);
			}
			catch(err){
				docRoot.myTrace("clipNowPlaying: Cannot access ExternalInterface from this page");
			}
		}
	}
}
/*private function sendAdStartEvent(evt:Event){
	if(ExternalInterface.available){
		try{
			ExternalInterface.call("clipNowPlaying", createClipObject());
		}
		catch(err){
			docRoot.myTrace("clipNowPlaying: Cannot access ExternalInterface from this page");
		}
	}
}*/
private function getVideoOwner(){
	if(docRoot._playerApplication == "hsw"){
		return(PlayerUtils.getTagValue(docRoot.curTitle.tags, "name"));
	}
	else{
		return(PlayerUtils.getTagValue(docRoot.curTitle.tags, "network"));
	}
}

private function createClipObject_new(){
	var obj:Object = new Object;
	obj.clipRefId = docRoot.curTitle.referenceId;
	obj.contentId = docRoot.curTitle.contentId;
	obj.networkId = docRoot.curTitle.networkId;
	obj.fullyQualifiedURL = docRoot.curTitle.vapURL;
	obj.episodeTitle = docRoot.curTitle.episodeTitle;
	if(docRoot.paramObj._DDMAPI == "1.2.5"){
		obj.durationForm = (docRoot.curTitle.durationForm == "ShortForm" ? "short" : "long");
	}
	else{
		obj.durationForm = docRoot.curTitle.durationForm;
	}
	obj.duration = docRoot.curTitle.duration;
	obj.programTitle = docRoot.curTitle.programTitle;
	obj.aspectRatio = docRoot.curTitle.aspectRatio;
	obj.videoCaption = docRoot.curTitle.shortDescription;
	obj.thumbnailURL = docRoot.curTitle.thumbnailURL;
	obj.videoStillURL = docRoot.curTitle.videoStillURL;
	obj.taxonomyShowTitle = docRoot.curTitle.taxonomyShowTitle;
	obj.srtUrl = docRoot.curTitle.srtUrl;
	if(docRoot.isPlaylist){
		obj.playlistClip = "playlist";
	}
	else
	if(docRoot.curTitle == docRoot.firstTitle){
		obj.playlistClip = "initial";
	}
	else{
		obj.playlistClip = "related";
	}
	return(obj);
}
/*private function createClipObject(){
	var obj:Object = new Object;
	obj.playlistName = docRoot._playlistName;
	obj.showName = docRoot._seriesId;
	obj.clipLength = docRoot.curTitle.duration;
	obj.clipName = docRoot.curTitle.displayName;
	obj.clipId = docRoot.curTitle.id;
	obj.clipRefId = docRoot.curTitle.referenceId;
	obj.contentId = docRoot.curTitle.contentId;
	obj.playerName = docRoot.getCurrentPlayerUse(docRoot.curTitle);
	obj.domain = PlayerUtils.getDomain(docRoot._myURL);
	obj.videoOwner = getVideoOwner();
	if(docRoot.configXmlObj.getAdFromPage == "true"){
		obj.adName = PlayerUtils.getFileNameFromUrl(docRoot._adUrl);
	}
	else{
		obj.adName = docRoot.freeWheelHandler.getAdId();
	}
	
	if(docRoot.isPlaylist){
		obj.playlistClip = "playlist";
	}
	else
	if(docRoot.curTitle == docRoot.firstTitle){
		obj.playlistClip = "initial";
	}
	else{
		obj.playlistClip = "related";
	}
	return(obj);
}*/
}
}
