package{

/*
This is the class that loads the plugins specified in the divTree as seen below . In the case below, the plugin 
is called "./controlRack.swf":
	
private var divTreeXml:XML = 
	<div class="chromeHolder">
		<div class="controlRack" plugin="./controlRack.swf"></div>
	</div>

When the plugin loads, this class calls a method that MUST be present in all plugins called: "initPlugin"
We use initPlugin to pass everything the plugin needs to be able to affect the video player:
	
1. docRoot - reference to the root (stage) of the video player
2. docRoot.chromeHolder - reference to the sprite that the plugin will be attached to in the order and with the 
child / parent relationship described in the divTree.
3. docRoot.akamaiVideoEngine - a reference to the video Player wrapper. This gives the plugin complete control over the video player
You can access all properties and methods of the AkamaiStreamController.hdNetStream - which is found in this library:
import com.akamai.net.f4f.hds.AkamaiStreamController;
all properties and methods can be seen in the docs for AkamaiStreamController in the docs downloaded with the HDCore library.
4. styleSheet - the complete stylesheet for all components. This is used to size, locate and style the plugins. 
5. docRoot.playerSizer - For responsive design, this class contains the real-time dimensions of the video 
player "window". You'll have to implement a class to listen to the resize event and resize your plugin 
component appropriately.
*/

	
	
import flash.display.*;
import flash.events.*;
import flash.net.*;
import flash.text.*;
	
public class Plugin extends Sprite{
	
private var docRoot:Main;
private var swfLoader:Loader;
//public var swfIsLoaded:Boolean = false;
public var pluginSwf:Object;
private var swfUrl:String;
public var nameStr:String;
private var styleSheet:StyleSheet;
	
public function Plugin(_docRoot:Main, _nameStr:String, _styleSheet:StyleSheet, _swfUrl:String){ 
	docRoot = _docRoot;
	nameStr = _nameStr;
	styleSheet = _styleSheet;
	swfUrl = _swfUrl;
	
	docRoot.myTrace("swfUrl: " + swfUrl);
	docRoot.chromeHolder.addChild(this);
	//addRect();
	loadSwf(swfUrl);
}
// When plugin loads, call the REQUIRED method "initPlugin" - pass the references the plugin needs
private function swfLoaded(evt:Event){
	docRoot.myTrace("swfLoaded: " + evt.target.content);
	pluginSwf = evt.target.content;
	//this.addChild(pluginSwf);
	pluginSwf.initPlugin(docRoot, docRoot.chromeHolder, docRoot.videoEngine, styleSheet, docRoot.playerSizer);
	//swfIsLoaded = true;
	//dispatchEvent(new Event("swfLoaded"));
}
private function loadSwf(_swfUrl:String){				
	//var myUrl = "file:///C|/Flash/VPP_Player/osmf_mirror/closedCaption/closedCaptionHandler.swf";
	//var myUrl:String = docRoot.mediaDomain + "/"
			//+ "shared/swf/video-players/browser-cache/indefinite/closedCaptionHandler.swf";
	//var myUrl = "closedCaptionHandler.swf";
	
	docRoot.myTrace("Loading plugin swf: " + _swfUrl);
	swfLoader = new Loader();
	swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadSwfError);
	swfLoader.contentLoaderInfo.addEventListener(Event.INIT, swfLoaded);
	swfLoader.load(new URLRequest(swfUrl));
}
private function loadSwfError(evt:Event){
	docRoot.myTrace("Can't load file: " + swfUrl);
}


}
}
