

/****************************
Author: Joel Fiser

Use this class to trace within a SWF
1. You need to have VScrollBar in your classPath
2. Put the following 2 lines in docRoot as properties:

public var myTracer:Tracer;
public var myTrace:Function;

3. Then put the following 2 lines in the docRoot constructor or init func

myTracer = new Tracer(this, "video"); 
myTrace = myTracer.myTrace; // this is just so you don't have to type docRoot.myTracer.myTrace

// "this" is docRoot; "video" is the application. Used to set up specific funcs in the tracer
// choices are "video" or "none"

Then, anywhere in the code (where you can access docRoot) you can trace by doing this:

docRoot.myTrace("here's a var: " + myVar);
*****************************/


package{
	
import flash.display.*;
import flash.ui.*;
import flash.events.*
import flash.text.*
import flash.geom.*
import flash.utils.*;
import com.akamai.hd.*;

public class PlayerTracer{
	
private var appVersion:String = "1.21"; // set this so you can see which version you're looking at
private var reason;
private var myTracer:Sprite;
private var topHolderHolder:Sprite;
private var topHolder:Sprite;
private var dragRect:Rectangle;
private var topBack:Shape;
private var sizerHolder:Sprite;
private var sizerBack:Shape;
private var backHolder:Sprite;
private var backShape:Shape;
private var clearBtn:Sprite;
private var noAdBtn:Sprite;
private var noAdBtnArt:Shape;
private var traceTxt:TextField;
private var versionTxt:TextField;
private var bitrateTxt:TextField;
private var spyBtn:Sprite;
private var spyInputTxt:TextField;
private var spyTxtHolder:Sprite;
private var spyBackHolder:Sprite;
private var classArr:Array;
private var myCode:Number;
private var sb:VScrollBar;
private var myMask:Sprite;
private var docRoot:Main;
private var lineNum:Number = 1;
private var sizerTimer:Timer = new Timer(20, 0);
private var tracerAddedToStage:Boolean = false;
public var etbToolAvailable:Boolean = false;
private var TOP_H:Number = 20;
private var SIZER_W:Number = 11;
private var SIZER_H:Number = 11;
private var MARGIN_W:Number = 4;
private var SPY_TXT_H:Number = 20;
private var START_X:Number = 230;
private var START_Y:Number = 100;
private var START_W:Number = 200;
private var START_H:Number = 50;

function PlayerTracer(_docRoot:Main, _reason:String, _version:String){
	docRoot = _docRoot;
	reason = _reason;
	appVersion = _version;
	//docRoot.stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
	//GlobalStage.stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
	myCode = 0;
	
	myTracer = new Sprite();
	myTracer.x = START_X;
	myTracer.y = START_Y;
	addBack();
	addTxtBox();
	addMask();
	addTop();
	//addScrollBar();
	//addSizer();
	//setTopBehaviors();
	//setSizerBehaviors();
	//addSpyInputTxt();
	//addGoSpyBtn();
	//sizeIt(new Event("init"));
}
public function setKeyListener(){
	docRoot.stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
}
public function setClassArr(_classArr:Array){
	classArr = _classArr;
}
private function addTracerToDisplay(){
	sizerTimer.addEventListener(TimerEvent.TIMER, sizeIt);
	docRoot.addChild(myTracer);
	// wait til we addChild(myTracer) to add the scrollBar so the scrollBar can 
	// access stage to listen for mouseEvents
	addScrollBar(); 
	addSizer();
	setTopBehaviors();
	setSizerBehaviors();
	addSpyInputTxt();
	addGoSpyBtn();
	sizeIt(new Event("init"));
	//GlobalStage.stage.addChild(myTracer);
	tracerAddedToStage = true;
}
public function myTrace(str){
	var stayOnBtm:Boolean = true;
	var beginIndex, endIndex:Number;
	beginIndex = traceTxt.selectionBeginIndex;
	endIndex = traceTxt.selectionEndIndex;
	if(beginIndex != endIndex){ // some text has been selected
		stayOnBtm = false;
	}
	//traceTxt.text += str + '\n';
	traceTxt.appendText(lineNum++ + '. ' + str + '\n');
	//traceTxt.htmlText += str + '\n';
	if(tracerAddedToStage){
		sb.sbResize();
		// keep tailing unless some text is selected
		if(stayOnBtm){
			sb.stayOnBtm();
		}
		else{
			traceTxt.setSelection(beginIndex, endIndex);
		}
	}
	if(!docRoot.devLevel || docRoot.devLevel == "IDE"){
		trace(str);
	}
}
private function setTopBehaviors(){
	topHolder.addEventListener(MouseEvent.MOUSE_DOWN, topStartDrag);
	topHolder.addEventListener(MouseEvent.MOUSE_UP, topStopDrag);
	topHolder.addEventListener(MouseEvent.DOUBLE_CLICK, tracerDisappears);
}
private function tracerDisappears(evt:Event){
	myTracer.visible = false;
	//docRoot.bcPlayer.hdNetStream.removeEventListener(HDEvent.PROGRESS, showBitrate); 
}
private function topStartDrag(evt:Event){
	myTracer.startDrag();
}
private function topStopDrag(evt:Event){
	myTracer.stopDrag();
}
private function setSizerBehaviors(){
	sizerHolder.addEventListener(MouseEvent.MOUSE_DOWN, sizerStartDrag);
	sizerHolder.addEventListener(MouseEvent.MOUSE_UP, sizerStopDrag);
}
private function sizeIt(evt:Event){
	topBack.width = sizerHolder.x + SIZER_W;
	traceTxt.width = sizerHolder.x + SIZER_W - sb.HANDLE_W;
	//traceTxt.height = sizerHolder.y + SIZER_H;
	myMask.width = sizerHolder.x + SIZER_W - sb.HANDLE_W;
	myMask.height = sizerHolder.y + SIZER_H;
	//sb.sbResize(traceTxt.height, 
				//myMask.height, 
				//myMask.width, 
				//Math.abs(traceTxt.y / traceTxt.height), 
				//traceTxt.height + traceTxt.y);
	sb.sbResize(); 
	drawBack(sizerHolder.x + SIZER_W, sizerHolder.y + SIZER_H);
	spyBackHolder.width = topBack.width;
	spyInputTxt.width = topBack.width - spyBtn.width;
	spyBtn.x = topBack.width - spyBtn.width;
	//myTrace(docRoot.adHandler["adRunning"]);
}
private function sizerStartDrag(evt:Event){
	sizerHolder.startDrag();
	sizerTimer.start();
}
private function sizerStopDrag(evt:Event){
	sizerTimer.stop();
	sizerHolder.stopDrag();
	sizeIt(new Event("stopDrag"));
}
private function setNoAdMode(evt:Event){
	if(docRoot.noAdMode){
		docRoot.noAdMode = false;
		Drawing.drawArrow(noAdBtnArt, 
						15, // width
						.8, // how "long" the arrow point is 1 is pretty pointy .7 is approx equalateral
						0, // like a clock: 0 points to 12:00, 90 points to 3:00, etc
						"00c133", // fill Color
						1, // fill alpha
						2, 1, // frameSize / frame Alpha
						"ffffff",
						null);
	}
	else{
		docRoot.noAdMode = true;
		Drawing.drawArrow(noAdBtnArt, 
						15, // width
						.8, // how "long" the arrow point is 1 is pretty pointy .7 is approx equalateral
						0, // like a clock: 0 points to 12:00, 90 points to 3:00, etc
						"ff0000", // fill Color
						1, // fill alpha
						2, 1, // frameSize / frame Alpha
						"ffffff",
						null);
	}
	//showSpyVar();
}
private function playClip_spy(_clipId:Number){
	//docRoot.myTracer.myTrace("playClip_js");
	//if(docRoot.ctlBtns.myState == "videoComplete"){
		//docRoot.finHandler.hideFin();
		//docRoot.ctlBtns.setCtlBtnsUpDown();
	//}
	//docRoot.getVideoAsynch(_clipId, "id", "playClip_spy");
}
private function showSpyVar(evt:Event){
	if(spyInputTxt.text.indexOf(":") != -1){
		playClip_spy(spyInputTxt.text.split(":")[1]);
		return;
	}
	var instance:String;
	var varName:String;
	if(spyInputTxt.text.indexOf(".") == -1){
		instance = "docRoot";
		varName = spyInputTxt.text;
	}
	else{
		var arr = spyInputTxt.text.split(".");
		instance = arr[0];
		var found:Boolean = false;
		varName = spyInputTxt.text.substr(spyInputTxt.text.indexOf(".") + 1);
	}
	trace("TURTL");
	for(var i:Number = 0; i < classArr.length; i++){
		if(classArr[i].instanceName == instance){
			trace("FOUND");
			myTrace(classArr[i].instance.mySpy(varName, "555zxz"));
			found = true;
			break;
		}
	}
	if(!found){
		myTrace("Can't locate an instance of: " + instance);
		myTrace("Enter an instance and a variable like this: instance.variable");
	}
}
private function addNoAdBtn(){
	var wVal:Number = 14;
	var hVal:Number = 14;
	noAdBtn = new Sprite();
	noAdBtn.x = clearBtn.x + clearBtn.width;
	//noAdBtn.y = hVal + 2;
	noAdBtn.buttonMode = true;
	topHolderHolder.addChild(noAdBtn);
	
	var noAdBtnBack = new Shape();
	noAdBtnBack.alpha = 0;
	noAdBtn.addChild(noAdBtnBack);
	noAdBtnBack.graphics.beginFill(0xff0000);
	noAdBtnBack.graphics.drawRect(0, 0, TOP_H, TOP_H);
	
	noAdBtnArt = new Shape();
	noAdBtn.addChild(noAdBtnArt);
	Drawing.drawArrow(noAdBtnArt, 
						15, // width
						.8, // how "long" the arrow point is 1 is pretty pointy .7 is approx equalateral
						0, // like a clock: 0 points to 12:00, 90 points to 3:00, etc
						"00c133", // fill Color
						1, // fill alpha
						2, 1, // frameSize / frame Alpha
						"ffffff",
						null);
	
	noAdBtnArt.x = TOP_H/2 - hVal/2;
	noAdBtnArt.y = 15;
	
	noAdBtn.addEventListener(MouseEvent.MOUSE_DOWN, setNoAdMode);
}
private function addClearBtn(){
	var wVal:Number = 13;
	var hVal:Number = 13;
	clearBtn = new Sprite();
	clearBtn.x = versionTxt.width + 10;
	clearBtn.buttonMode = true;
	topHolderHolder.addChild(clearBtn);
	
	var clearBtnBack = new Shape();
	clearBtnBack.alpha = 0;
	clearBtn.addChild(clearBtnBack);
	clearBtnBack.graphics.beginFill(0xff0000);
	clearBtnBack.graphics.drawRect(0, 0, TOP_H, TOP_H);
	
	var clearBtnArt = new Shape();
	clearBtn.addChild(clearBtnArt);
	clearBtnArt.graphics.lineStyle(2, 0xffffff, 1);
	clearBtnArt.graphics.beginFill(0xff9500);
	clearBtnArt.graphics.drawCircle(hVal/2, hVal/2, hVal/2);
	clearBtnArt.graphics.endFill();
	clearBtnArt.x = TOP_H/2 - hVal/2;
	clearBtnArt.y = TOP_H/2 - hVal/2;
	
	clearBtn.addEventListener(MouseEvent.MOUSE_DOWN, clearTxtBox);
}
private function clearTxtBox(evt:Event){
	traceTxt.text = "";
	sb.sbResize();
}
private function addVersionTxt(){	
	versionTxt = new TextField();
	versionTxt.mouseEnabled = false;
	topHolderHolder.addChild(versionTxt);
	//traceTxt.width = 50;
	versionTxt.height = TOP_H;
	versionTxt.autoSize = TextFieldAutoSize.LEFT;
	versionTxt.selectable = false;
	var format = new TextFormat();
	format.font = "_sans";
	format.size = 12;
	versionTxt.textColor = parseInt("0x" + "ffffff"); //0xffffff;
	versionTxt.defaultTextFormat = format;
	versionTxt.text = appVersion;
}
private function addTop(){
	topHolderHolder = new Sprite();
	topHolderHolder.y = (TOP_H + SPY_TXT_H) * -1;
	myTracer.addChild(topHolderHolder);
	topHolder = new Sprite();
	topHolder.doubleClickEnabled = true;
	topHolderHolder.addChild(topHolder);
	topBack = new Shape();
	topHolder.addChild(topBack);
	Drawing.drawRect(topBack, 
				 START_W, TOP_H, 
				 "0077ff", "333333",
				 1, 1,
				 90,
				 "linear");
	addVersionTxt();
	addClearBtn();
	if(reason.toLowerCase() == "video"){
		addNoAdBtn();
	}
	//addBitrateTxt();
}
private function addSizer(){
	sizerHolder = new Sprite();
	sizerHolder.buttonMode = true;
	sizerHolder.y = START_H - SIZER_H;
	sizerHolder.x = START_W - SIZER_W;
	myTracer.addChild(sizerHolder);
	sizerBack = new Shape();
	sizerHolder.addChild(sizerBack);
	//sizerBack.graphics.lineStyle(0, 0xffffff, 1);
	Drawing.drawRect(sizerBack, 
				 SIZER_W, SIZER_H, 
				 "00c133", "00c133",
				 1, 1,
				 90,
				 "linear");
}
private function drawBack(wVal:Number, hVal:Number){
	backHolder.width = wVal;
	backHolder.height = hVal;
	/*Drawing.drawRect(backShape, 
				 wVal, hVal, 
				 "bbccaa", "aaccbb",
				 1, 1,
				 90,
				 "linear");*/
}
private function addBack(){
	backHolder = new Sprite();
	myTracer.addChild(backHolder);
	backShape = new Shape();
	backHolder.addChild(backShape);
	//drawBack(START_W, START_H);
	Drawing.drawRect(backShape, 
				 START_W, START_H, 
				 "eeeeee", "eeeeee",
				 1, 1,
				 90,
				 "linear");
}
private function addMask(){
	myMask = new Sprite();
	myTracer.addChild(myMask);
	myMask.graphics.beginFill(0x0000ff);
	myMask.graphics.drawRect(0, 0, START_W, START_H);
	myMask.alpha = .3;
	traceTxt.mask = myMask;
}
//VScrollBar(_attachToObj:Object, moveObj:Object, maskObj)
private function addScrollBar(){
	sb = new VScrollBar(myTracer, traceTxt, myMask);
}
private function addGoSpyBtn(){
	var wVal:Number = 14;
	var hVal:Number = 14;
	spyBtn = new Sprite();
	spyBtn.x = topBack.width - wVal;
	//noAdBtn.y = hVal + 2;
	spyBtn.buttonMode = true;
	spyTxtHolder.addChild(spyBtn);
	
	var spyBtnBack = new Shape();
	spyBtnBack.alpha = 1;
	spyBtn.addChild(spyBtnBack);
	spyBtnBack.graphics.lineStyle(1, 0x000000, 1);
	spyBtnBack.graphics.beginFill(0xa56784);
	spyBtnBack.graphics.drawRect(0, 0, TOP_H, TOP_H);
	
	var spyBtnArt = new Shape();
	spyBtn.addChild(spyBtnArt);
	Drawing.drawArrow(spyBtnArt, 
						15, // width
						.8, // how "long" the arrow point is 1 is pretty pointy .7 is approx equalateral
						90, // like a clock: 0 points to 12:00, 90 points to 3:00, etc
						"34cdf2", // fill Color
						1, // fill alpha
						2, 1, // frameSize / frame Alpha
						"ffffff",
						null);
	
	spyBtnArt.x = TOP_H/2 - hVal/2 +2;
	spyBtnArt.y = 3;
	
	spyBtn.addEventListener(MouseEvent.MOUSE_DOWN, showSpyVar);
}
private function addSpyBack(){
	spyBackHolder = new Sprite();
	spyTxtHolder.addChild(spyBackHolder);
	var backShape = new Shape();
	spyBackHolder.addChild(backShape);
	//drawBack(START_W, START_H);
	Drawing.drawRect(backShape, 
				 topHolder.width, SPY_TXT_H, 
				 "ffd1d0", "ffd1d0",
				 1, 1,
				 90,
				 "linear");
}
private function addSpyInputTxt(){	
	spyTxtHolder = new Sprite();
	myTracer.addChild(spyTxtHolder);
	spyTxtHolder.x = 0;
	spyTxtHolder.y = SPY_TXT_H * -1;
	addSpyBack();
	spyInputTxt = new TextField();
	spyTxtHolder.addChild(spyInputTxt);
	spyInputTxt.width = topHolder.width;
	spyInputTxt.height = SPY_TXT_H;
	spyInputTxt.type = TextFieldType.INPUT;
	spyInputTxt.border = true;
	//traceTxt.background = true;
	//traceTxt.selectable = false;
	//addChild(traceTxt);
	//traceTxt.embedFonts = true;
	var format = new TextFormat();
	format.font = "_sans";
	format.size = 12;
	format.align = "center";
	spyInputTxt.defaultTextFormat = format;
	spyInputTxt.text = "instanceName.variable or id:clipid";
	spyInputTxt.addEventListener(KeyboardEvent.KEY_DOWN, mySubmit);
}
private function mySubmit(evt:KeyboardEvent){
	if (evt.keyCode == Keyboard.ENTER){
		showSpyVar(new Event("ENTER submit"));
		trace("enter");
	}
}
private function addTxtBox(){	
	//myTracer = new Sprite();
	//myTracer.x = START_X;
	//myTracer.y = START_Y;
	//addBack();
	traceTxt = new TextField();
	myTracer.addChild(traceTxt);
	traceTxt.width = START_W;
	//traceTxt.height = START_H;
	traceTxt.autoSize = TextFieldAutoSize.LEFT;
	traceTxt.alwaysShowSelection = true;
	//traceTxt.border = true;
	//traceTxt.background = true;
	//traceTxt.selectable = false;
	//addChild(traceTxt);
	//traceTxt.embedFonts = true;
	//traceTxt.html = true;
	traceTxt.wordWrap = true;
	var format = new TextFormat();
	format.font = "_sans";
	format.size = 12;
	//traceTxt.textColor = parseInt("0x" + styleObj.descripFontColor); //0xffffff;
	//traceTxt.defaultTextFormat = format;
}
private function addBitrateTxt(){	
	myTrace("addBitrateTxt");
	bitrateTxt = new TextField();
	bitrateTxt.border = true;
	bitrateTxt.background = true;
	bitrateTxt.backgroundColor = 0xffffff;
	bitrateTxt.mouseEnabled = false;
	topHolderHolder.addChild(bitrateTxt);
	bitrateTxt.x = noAdBtn.x + noAdBtn.width + 20;
	bitrateTxt.width = 30;
	bitrateTxt.height = TOP_H;
	bitrateTxt.autoSize = TextFieldAutoSize.LEFT;
	bitrateTxt.selectable = false;
	var format = new TextFormat();
	format.font = "_sans";
	format.size = 12;
	bitrateTxt.textColor = 0x000000;
	bitrateTxt.defaultTextFormat = format;
	//bitrateTxt.text = appVersion;
}
//private function showBitrate(evt:HDEvent){
	//myTrace("showBitrate");
	//var br:Number = Math.floor(docRoot.bcPlayer.hdNetStream.averagePlaybackBitsPerSecond)
	//bitrateTxt.text = docRoot.bcPlayer.hdNetStream.averagePlaybackBitsPerSecond;
//}
private function reportKeyDown(event:KeyboardEvent){
	switch(event.keyCode)
	{
		case Keyboard.UP:
			myCode = 1;
			break;
		case Keyboard.RIGHT:
			if(myCode == 1)
				myCode = 2;
			else
				myCode = 0;
			break;
		case Keyboard.DOWN:
			if(myCode == 2)
				myCode = 3;
			else
				myCode = 0;
			break;
		case Keyboard.LEFT:
			if(myCode == 3){
				//_global.toolBoxMode = true;
				if(!tracerAddedToStage){
					addTracerToDisplay();
				}
				else{
					myTracer.visible = true;
				}
				//showPlayerStats();
			}
			else
				myCode = 0;
			break;
		default: // not a key we're looking for - do nothing
			myCode = 0;
			return;
	} 
}

}
}