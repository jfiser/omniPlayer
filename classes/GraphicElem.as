package{

import flash.display.*;
import flash.events.*;
import flash.net.*;
	
public class GraphicElem extends Sprite{
	
private var docRoot:Main;
public var level:int;
public var parentStr:String;
public var popupHolder:Sprite;
private var btnFaceHolder:Sprite;
private var btnBacking:Shape;
private var btnFaceHolderNorm:Sprite;
private var btnFaceHolderHover:Sprite;
private var btnFaceNorm:Sprite;
private var btnFaceHover:Sprite;
private var bgShapeNorm:Shape; // the background vector's normal state
private var bgShapeHover:Shape; // the background vector's mouseOver state
private var bgImageLoaderNorm:Loader;
private var bgImageLoaderHover:Loader;
private var btnFaceMask:Shape;
//private var styleObj:Object;
public var nameStr:String;
private var cssStyleObj:Object = {};
private var cssStyleObjHover:Object = {};
public var flashStyleObj:Object = {};
public var flashStyleObjHover:Object = {};

public function GraphicElem(_docRoot:Main, _level:int, _classStr:String, _parentStr:String, 
														_cssStyleObj:Object, _cssStyleObjHover:Object){
	docRoot = _docRoot;
	level = _level;
	nameStr = _classStr;
	parentStr = _parentStr;
	cssStyleObj = _cssStyleObj;
	cssStyleObjHover = _cssStyleObjHover;
	renderElement();														
}
// stack all of the pieces that make up an element: background shapes (normal and mouseOver)
// background image, text and mask the entire element.
// Make sure though, that the btn can have a popup - don't mask over that part.
private function addLayers(){
	popupHolder = new Sprite();
	addChild(popupHolder);
	btnFaceHolder = new Sprite();
	addChild(btnFaceHolder);
	
	btnBacking = new Shape();
	btnFaceHolder.addChild(btnBacking);
	
	// Here's the normal look of the btn
	btnFaceHolderNorm = new Sprite();
	btnFaceHolder.addChild(btnFaceHolderNorm);
	bgShapeNorm = new Shape();
	btnFaceHolderNorm.addChild(bgShapeNorm);
	bgImageLoaderNorm = new Loader();
	btnFaceHolderNorm.addChild(bgImageLoaderNorm);
	
	// Here's the mouseOver look of the btn (start off invisible)
	btnFaceHolderHover = new Sprite()
	btnFaceHolderHover.visible = false;
	btnFaceHolder.addChild(btnFaceHolderHover);
	bgShapeHover = new Shape();
	btnFaceHolderHover.addChild(bgShapeHover);
	bgImageLoaderHover = new Loader();
	btnFaceHolderHover.addChild(bgImageLoaderHover);
	
	// Now mask the btnFace
	btnFaceMask = new Shape();
	btnFaceHolder.addChild(btnFaceMask);
}
private function addBacking(){
	Drawing.drawRect(btnBacking, 
						flashStyleObj.widthPx, flashStyleObj.heightPx,
						"0000ff", "0000ff",
						0, 0,
						0,
						"linear")
}
private function addMask(){
	Drawing.drawRect(btnFaceMask, 
						flashStyleObj.widthPx, flashStyleObj.heightPx,
						"0000ff", "0000ff",
						1, 1,
						0,
						"linear")
	btnFaceHolder.mask = btnFaceMask;
}
public function renderElement(){
	addLayers();	
	flashStyleObj = StyleSetter.setProperties(cssStyleObj);
	flashStyleObjHover = StyleSetter.setProperties(cssStyleObjHover);
	set_xy();
	
	addBacking();
	
	renderBgShape(bgShapeNorm, flashStyleObj);
	renderBgShape(bgShapeHover, flashStyleObjHover);
	
	// load the background images (norm and hover) if present
	if(flashStyleObj.bgImage){ 
		addBgImage(bgImageLoaderNorm, flashStyleObj.bgImage);
	}
	if(flashStyleObjHover.bgImage){
		addBgImage(bgImageLoaderHover, flashStyleObjHover.bgImage);
	}
	
	addMask();
	trace("ControlRackBack");
	addListeners();
}
private function addListeners(){
	btnFaceHolder.mouseChildren = false;	
	btnFaceHolder.addEventListener(MouseEvent.MOUSE_OVER, btnFaceOver);
	btnFaceHolder.addEventListener(MouseEvent.MOUSE_OUT, btnFaceOut);
}
private function btnFaceOver(evt:MouseEvent){
	btnFaceHolderHover.visible = true;
	btnFaceHolderNorm.visible = false;
}
private function btnFaceOut(evt:MouseEvent){
	btnFaceHolderNorm.visible = true;
	btnFaceHolderHover.visible = false;
}
private function addBgImage(_loader:Loader, _imageUrl:String){
	_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bgImageLoadError);
	_loader.contentLoaderInfo.addEventListener(Event.INIT, bgImageLoaded);
	_loader.load(new URLRequest(_imageUrl));
}
private function bgImageLoadError(evt:IOErrorEvent){
	
}
private function bgImageLoaded(evt:Event){
	
}
private function set_xy(){
	this.x = flashStyleObj.xVal;
	this.y = flashStyleObj.yVal;
}
private function renderBgShape(_shape:Shape, _styleObj:Object){
	Drawing.drawCustomRect(_shape, 
				//55, 222,
				_styleObj.widthPx, _styleObj.heightPx,
				//"333333", "eeeeee",
				_styleObj.bgColor, _styleObj.bgColor,
				//1, 1, 
				_styleObj.opacity, _styleObj.opacity, 
				"linear", 0,
				_styleObj.borderWidth, 1,
				//"333333", "333333", "333333", "333333", 
				_styleObj.borderColor, _styleObj.borderColor, _styleObj.borderColor, _styleObj.borderColor,
				0, 0, 0, 0,
				null)
}


}
}
