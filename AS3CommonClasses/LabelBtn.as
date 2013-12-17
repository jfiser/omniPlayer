

package{
	
import flash.display.*;
import flash.text.*;

public class LabelBtn extends Sprite{
	
public var btnBack:Sprite;
public var txtBox:TextField;
private var fontName:String;
private var fontSize:Number;
private var btnWidthAdjust:Number; // use for margins on non-absolute width btns
private var absolute_w:Number; // if not set to 0, use this as the absolute width
private var absolute_h:Number; // if not set to 0, use this as the absolute width
private var fontColor:String;
private var labelTxt:String;
private var btnColor1:String;
private var btnColor2:String;
private var gradientType:String;
private var btnBackAlpha:Number;
public var btnShape:Shape;
private var embedded:Boolean;
private var isButton:Boolean;
private var frameColor:String = "999999";
//private var holder:Sprite;
function LabelBtn(_btnColor1:String, _btnColor2:String, _gradientType:String, _btnBackAlpha:Number,
				  			_fontName:String, _fontSize:Number, _fontColor:String, _labelTxt:String, 
				  			_btnWidthAdjust:Number, _embedded:Boolean, 
							_isButton:Boolean, 
							_absolute_w:Number, _absolute_h:Number){
	//holder = _holder;
	btnColor1 = _btnColor1;
	btnColor2 = _btnColor2;
	gradientType = _gradientType;
	btnBackAlpha = _btnBackAlpha;
	fontName = _fontName;
	fontSize = _fontSize;
	fontColor = _fontColor;
	labelTxt = _labelTxt;
	embedded = _embedded;
	isButton = _isButton;
	absolute_w = _absolute_w;
	absolute_h = _absolute_h;
	
	btnWidthAdjust = _btnWidthAdjust;
	addTxt();
}
public function redrawBtn(btnBackColor:String, btnBackAlpha:Number, txtColor:String){
	var wVal = absolute_w != 0 ? absolute_w : txtBox.width + btnWidthAdjust*2;
	
	btnShape.graphics.clear();
	/*Drawing.drawRect(btnShape, 
				 wVal, txtBox.height, 
				 btnBackColor, btnBackColor,
				 1, 1,
				 90,
				 "linear");*/
	Drawing.drawCustomRect(btnShape, 
				wVal, txtBox.height,
				btnBackColor, btnBackColor,
				btnBackAlpha, btnBackAlpha, 
				"radial", 90,
				0, 0,
				frameColor, frameColor, frameColor, frameColor,
				//"000000", "000000", "000000", "000000",
				0, 0, 0, 0,
				null)
	
	btnBack.alpha = btnBackAlpha;

	txtBox.textColor = parseInt("0x" + txtColor); //0xffffff;
}
// btnWidthAdjust is used if you have an arrow or something to the right of the txtBox
private function drawBtn(){
	btnBack = new Sprite();
	this.addChild(btnBack);
	btnShape = new Shape();
	btnBack.addChild(btnShape);
	this.addChild(txtBox);
	var wVal = absolute_w != 0 ? absolute_w : txtBox.width + btnWidthAdjust*2;
	var hVal = absolute_h != 0 ? absolute_h : txtBox.height;
	trace("wVal: " + wVal);
	Drawing.drawCustomRect(btnShape, 
				wVal, hVal,
				btnColor1, btnColor2,
				btnBackAlpha, btnBackAlpha,
				gradientType, 90,
				0, 0,
				frameColor, frameColor, frameColor, frameColor,
				//"000000", "000000", "000000", "000000",
				0, 0, 0, 0,
				null)
	btnBack.alpha = btnBackAlpha;
	if(isButton)
		this.buttonMode = true; 
}
private function adjustTxtBoxForMargin(){
	var wVal = absolute_w != 0 ? absolute_w : txtBox.width;
	var hVal = absolute_h != 0 ? absolute_h : txtBox.height;
	txtBox.x += (wVal - txtBox.width)/2;
	txtBox.y += (hVal - txtBox.height)/2;
}
private function addTxt(){
	txtBox = new TextField();
	txtBox.mouseEnabled = false;
	txtBox.selectable = false;
	txtBox.autoSize = TextFieldAutoSize.LEFT;
	//txtBox.border = true
	txtBox.embedFonts = embedded;
	var format = new TextFormat();
	format.font = fontName;
	format.size = fontSize;
	txtBox.textColor = parseInt("0x" + fontColor); //0xffffff;
	txtBox.defaultTextFormat = format;
	txtBox.text = labelTxt;
	drawBtn();
	adjustTxtBoxForMargin();
}
	
}
}