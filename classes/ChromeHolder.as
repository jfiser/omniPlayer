// This class parses the DIV tree for the HTML player's controlRack and 
// also the CSS for the HTML player, to create all of the objects that appear on the 
// controlRack. 

package{


import flash.display.*;
import flash.events.*;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.text.*;
	
public class ChromeHolder extends Sprite{
		
private var docRoot:Main;
private var elementArr:Array = [];
private var styleSheet:StyleSheet;
	
public var level:int = 0;
public var parentStr:String = "root";
public var nameStr:String = "chromeHolder";
	
/*private var divTreeXml:XML = 	
						<div class="controlRack">
							<div class="controlRackBack">
								<div class="titleText"></div>
								<div class="playPauseBtn"></div>
								<div class="divLine"></div>
								<div class="scrubber">
									<div class="scrubberBack"></div>
									<div class="zzz">
										<div class="xxx"></div>
									</div>
									<div class="progressBar"></div>
									<div class="scrubberBar"></div>
								</div>
								<div class="videoTimer"></div>
								<div class="divLine"></div>
								<div class="volumeControl"></div>
								<div class="divLine"></div>
								<div class="fullScreenBtn"></div>
							</div>
						</div>;*/
private var divTreeXml:XML = 
	<div class="chromeHolder">
		<div class="controlRack" plugin="./controlRack.swf"></div>
	</div>

public function ChromeHolder(_docRoot:Main){
	docRoot = _docRoot;
	docRoot.addChild(this);
	elementArr.push(this);
	styleSheet = new StyleSheet();
	loadCssFile();
	//trace("controlRack.controlRackBack.playPauseBtn: " + playPauseBtn.parent);
}
private function loadCssFile(){
	var loader:URLLoader = new URLLoader();
	loader.addEventListener(IOErrorEvent.IO_ERROR, cccLoadErr);
	loader.addEventListener(Event.COMPLETE, cssLoaded);
	loader.load(new URLRequest("controlRack.css"));
}
private function cssLoaded(evt:Event){
	styleSheet = new StyleSheet();	
	//trace("css loaded:" + evt.target.data);
	styleSheet.parseCSS(evt.target.data);
	//trace(">>>>>>>>>>>: " + styleSheet.getStyle(".playPauseBtn:hover").width);
	//trace(styleSheet.getStyle(".controlRackBack").backgroundColor);
	traverseDivTree(divTreeXml.div, 0);
}
private function cccLoadErr(evt:Event){
	trace("Can't load css file");
}
// Recursively traverse the tree to establish the elements of the controlRack
// and the layering (z-index) of elements 
private function traverseDivTree(_xList:XMLList, _level:int){
	//trace(">>>" + _xList.attribute("class"));
	_level++;
	for each(var subList:XML in _xList){
		//if(subList.hasOwnProperty("@class")){
		trace(">>>" + subList.attribute("class") + " - " + _level + " - " + subList.parent().attribute("class"));
		createElement(subList.attribute("class"), subList.attribute("plugin"), _level, subList.parent().attribute("class"));
		traverseDivTree(subList.div as XMLList, _level)
	}
}
// Create the elements, stick them in an array to enable the appropriate parenting 
// of the elements. 
private function createElement(_classStr:String, _pluginStr:String, _level:int, _parentStr:String){
	trace("_pluginStr == false: " + (_pluginStr == false));
	if(_pluginStr){
		var newPluginElem:Plugin = new Plugin(docRoot, 
											_classStr,
											styleSheet,
											//styleSheet.getStyle("." + _classStr), 
											_pluginStr);
		addToChrome(newPluginElem, _parentStr);
		elementArr.push(newPluginElem);
	}
	else{
		var newGraphicElem:GraphicElem = new GraphicElem(docRoot, _level, _classStr, _parentStr, 
											styleSheet.getStyle("." + _classStr),
											styleSheet.getStyle("." + _classStr + ":hover"));
		addToChrome(newGraphicElem, _parentStr);
		elementArr.push(newGraphicElem);
	}
}
// Look for the parent of each element and do the addChild()'s to create the correct 
// layering (z-index) of the elements on the controlRack.
private function addToChrome(_elem:Object, _parentStr:String){
	for(var i:int = 0; i < elementArr.length; i++){
		if(elementArr[i].nameStr == _parentStr){
			elementArr[i].addChild(_elem);
			trace("found parent of: " + _elem.nameStr + " : " + elementArr[i].nameStr);
			//trace("elementArr[i]._elem: " + elementArr[i].controlRackBack);
			break;
		}
	}
}

}
}
