
package{
	
import flash.events.*;
import flash.display.*;
import flash.net.*;
import flash.text.*
import flash.system.*;

public class FontHandler extends EventDispatcher{
	
private var docRoot:Object; 
private var ccMain:ClosedCaptionMain; 
private var fontLoader:Loader;
public var fontObjArr:Array = [];
public var fontNameArray:Array = [];
private var curFontObj:Object;

public function FontHandler(_docRoot:Object, _ccMain:ClosedCaptionMain){
	docRoot = _docRoot;
	ccMain = _ccMain;
	//var myUrl:String = "fontSwfList_local.json";
	
	var myUrl:String = docRoot.awsStaticDomain
				+ "fonts/fontSwfList.json"
	
	//var myUrl:String = docRoot.mediaDomain + "/"
			//+ "shared/swf/video-players/monetized/fonts/fontSwfList.json";
	loadFontSwfList(myUrl);
}
private function loadFontSwfList(_fontListUrl:String){
	var loader:URLLoader = new URLLoader();
	loader.addEventListener(Event.COMPLETE, fontListLoaded);
	loader.addEventListener(IOErrorEvent.IO_ERROR, fontListLoadError);
	loader.load(new URLRequest(_fontListUrl));
}	
/*private function loadFontSwfList(){
	var fontListLoader = new Loader();
	fontListLoader.contentLoaderInfo.addEventListener(Event.INIT, fontListLoaded);
	fontListLoader.load(new URLRequest("fontSwfList.json"));
}*/
private function fontListLoadError(evt:ErrorEvent){
	docRoot.myTrace("Error loading: " + "fontSwfList.json");
}
private function fontListLoaded(evt:Event){
	docRoot.myTrace("fontListLoaded");
	fontObjArr = JSON.decode(evt.target.data);
	fontObjArr.sortOn("fontName");
	for(var i:uint = 0; i < fontObjArr.length; i++){
		fontNameArray[i] = fontObjArr[i].fontName;
	}
	dispatchEvent(new Event("fontListLoaded"));
}
public function loadFont(_fontName:String){
	fontLoader = new Loader();
	fontLoader.contentLoaderInfo.addEventListener(Event.INIT, fontLoaded);
	for(var i:uint = 0; i < fontObjArr.length; i++){
		if(fontObjArr[i].fontName == _fontName){
			docRoot.myTrace("found font: " + _fontName);
			curFontObj = fontObjArr[i];
			fontLoader.load(new URLRequest(docRoot.awsStaticDomain + fontObjArr[i].fontUrl));
			break;
		}
	}
}
private function fontLoaded(evt:Event){
	docRoot.myTrace("fontLoaded");
    var domain:ApplicationDomain = fontLoader.contentLoaderInfo.applicationDomain;
	var FontClass:Class = Class(domain.getDefinition(curFontObj.fontName));
    Font.registerFont(FontClass);
	
	var myFont:Font = new FontClass();
	var format = new TextFormat();
	format.font = myFont.fontName;
	ccMain.srtHandler.ccTxt.setTextFormat(format);
	ccMain.srtHandler.ccTxt.defaultTextFormat = format;
	ccMain.srtHandler.ccTxtShadow.setTextFormat(format);
	ccMain.srtHandler.ccTxtShadow.defaultTextFormat = format;

	dispatchEvent(new Event("fontReady"));
}
/*private function fontsLoaded(evt:Event){
	docRoot.myTrace("fontsLoaded");
    var domain:ApplicationDomain = fontLoader.contentLoaderInfo.applicationDomain;
	
	var FontClass:Class = Class(domain.getDefinition(docRoot.configXmlObj.thumbsFontClass));
    Font.registerFont(FontClass);
	
	FontClass = Class(domain.getDefinition(docRoot.configXmlObj.thumbsDescFontClass));
    Font.registerFont(FontClass);
	
	FontClass = Class(domain.getDefinition(docRoot.configXmlObj.nowPlayingTitleFontClass));
    Font.registerFont(FontClass);
	
	FontClass = Class(domain.getDefinition(docRoot.configXmlObj.nowPlayingDescFontClass));
    Font.registerFont(FontClass);
	
	dispatchEvent(new Event("fontsReady"));
}*/


}
}
