package{

/*

	
	
*/

	
	
import flash.display.*;
import flash.events.*;
import flash.net.*;
import flash.text.*;
	
public class VideoEngineLoader extends Sprite{
	
private var docRoot:Main;
private var swfLoader:Loader;
//public var swfIsLoaded:Boolean = false;
public var pluginSwf:Object;
private var swfUrl:String;
public var nameStr:String;
private var styleSheet:StyleSheet;
	private var playerHolder:Sprite;
	
public function VideoEngineLoader(_docRoot:Main, _swfUrl:String, _playerHolder:Sprite){ 
	docRoot = _docRoot;
	swfUrl = _swfUrl;
	playerHolder = _playerHolder;
	
	docRoot.myTrace("videoEngineLoader: " + swfUrl);
	loadSwf(swfUrl);
}
// When plugin loads, call the REQUIRED method "initPlugin" - pass the references the plugin needs
private function swfLoaded(evt:Event){
	docRoot.myTrace("swfLoaded: " + evt.target.content);
	docRoot.videoEngine = evt.target.content;
	playerHolder.addChild(docRoot.videoEngine);
	docRoot.videoEngine.initVideoEngine(docRoot);
	//dispatchEvent(new Event("swfLoaded"));
}
private function loadSwf(_swfUrl:String){				
	//var myUrl = "file:///C|/Flash/VPP_Player/osmf_mirror/closedCaption/closedCaptionHandler.swf";
	//var myUrl:String = docRoot.mediaDomain + "/"
			//+ "shared/swf/video-players/browser-cache/indefinite/closedCaptionHandler.swf";
	//var myUrl = "closedCaptionHandler.swf";
	
	docRoot.myTrace("Loading videoEngine swf: " + _swfUrl);
	swfLoader = new Loader();
	swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadSwfError);
	swfLoader.contentLoaderInfo.addEventListener(Event.INIT, swfLoaded);
	swfLoader.load(new URLRequest(swfUrl));
}
private function loadSwfError(evt:Event){
	docRoot.myTrace("Can't load videoEngine file: " + swfUrl);
}


}
}
