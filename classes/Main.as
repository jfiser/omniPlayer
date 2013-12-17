package{

import flash.display.*;
import flash.events.*;
	
public class Main extends Sprite{

public var noAdMode:Boolean = false;
public var myTracer:PlayerTracer;
public var myTrace:Function;
public var curTitle:Title;
public var playerHolder:Sprite;
public var videoEngine:MovieClip;
public var videoEngineLoader:VideoEngineLoader;
public var playerSizer:PlayerSizer;
public var chromeHolder:ChromeHolder;
//public var videoDataHandler:VideoDataHandler;
public var videoObj:Object;
public var paramObj:Object;

public var maskHolder:Sprite;
public var devLevel:String = "IDE" // "IDE", "LOCAL_BROWSER", "PROD"

public function Main(){
	setTracer();
	myTrace("devLevel: " + devLevel);
	paramObj = (devLevel == "IDE" ? ParamHandler : this.loaderInfo.parameters);
	addPlayerHolder();
	playerSizer = new PlayerSizer(this);
	chooseVideoEngine();
	//addVideoDataHandler();
	addChromeHolder();
	addMaskHolder();
	//akamaiVideoEngine.playVideo(
		//"http://ngs-vh.akamaihd.net/NG_Magazine/628/751/Feature-Marcus-Bleasdale-MASTER_ipad-,1640__679812,1240,840,.mp4.csmil/manifest.f4m");
}
// determine whether we need to load the akamai engine (250K) or if we can just use native NetStream
private function chooseVideoEngine(){
	
	videoObj = JSON2.decode(paramObj._videoJson);
	
	curTitle = new Title(this);
	
	if(videoObj.playlist_url && videoObj.playlist_url.indexOf("http://") != -1){
		var videoEngineUrl:String = (devLevel == "IDE" ? "./akamaiHDS.swf" : this.loaderInfo.parameters._videoEngineUrl);
		videoEngineLoader = new VideoEngineLoader(this, videoEngineUrl, playerHolder);
		curTitle.loadSmil(videoObj.playlist_url + "&manifest=f4m");
	}
	else
	if(videoObj.mp4_url && videoObj.mp4_url.indexOf("http://") != -1){
		videoEngine = new NetStreamPlayer(this);
		playerHolder.addChild(videoEngine);
		videoEngine.playVideo(videoObj.mp4_url);
	}
}
// load the chrome for the Player - controlRack, etc
private function addChromeHolder(){
	if(!paramObj.chromeUrl || paramObj.chromeUrl.indexOf("http://") == -1){
		return;  // no chrome
	}
	chromeHolder = new ChromeHolder(this);
	addChild(chromeHolder);
}
private function addPlayerHolder(){
	playerHolder = new Sprite();
	addChild(playerHolder);
	playerHolder.addEventListener(MouseEvent.CLICK, playerHolderClick);
}
private function playerHolderClick(evt:MouseEvent){
	trace("playerHolderClick")	
	videoEngine.playPauseToggle(new MouseEvent("playerHolderClick"));
}
private function addMaskHolder(){
	maskHolder = new Sprite();
	addChild(maskHolder);
	maskHolder.mouseEnabled = false;
	maskHolder.mouseChildren = false;
}
private function setTracer(){
	myTracer = new PlayerTracer(this, "video", "130917_1321"); 
	myTrace = myTracer.myTrace;
	myTracer.setKeyListener();
}


}
}
