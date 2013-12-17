
package{
	
class WebTrace{
private var __tstTxt:MovieClip; // Main MC holds everything. Use the weird name so it doesn't conflict with something in the host code.
private var tstTxt:MovieClip; // Holds text, eMask
private var grabber:MovieClip; // 
private var myTxt:TextField; // main textField
private var eMask:MovieClip; // 
private var XitBtn:MovieClip; // 
private var txtHolder:MovieClip; // 
private var grabberHolder:MovieClip;
private var brSizer:MovieClip; // btm rt sizer
private var scrollBar:VScrollBar2;
private var wVal:Number;
private var hVal:Number;
private var xVal:Number;
private var yVal:Number;
private var myCol1:String;
private var txtColStr:String;
private var txtCol:Number;
private var txtRollOverCol:String;
private var XitRollOverCol:String;
private var grabber_w:Number;
private var grabber_h:Number;
private var margin:Number;
private docRoot:Object
function WebTrace(_docRoot:Object, _wVal:Number, _hVal:Number, _xVal:Number, _yVal:Number){
	docRoot = _docRoot;
	wVal = _wVal == undefined ? 200 : _wVal;
	hVal = _hVal == undefined ? 200 : _hVal;
	xVal = _xVal == undefined ? 10 : _xVal;
	yVal = _yVal == undefined ? 10 : _yVal;
	myCol1 = "000000";
	txtColStr = "ffffff";
	txtCol = parseInt("ffffff", 16);
	txtRollOverCol = "00ffff";
	XitRollOverCol = "ffff00";
	grabber_w = 100;
	grabber_h = 25;
	margin = 5;
	mkBack();
	mkGrabber();
	mkTextField();
	//mkMask(); // for use with scrollBar
	mkExitBtn();
	mkSizer();
	//addScrollBar();
	//sbResize();
}
/*private function sbResize(){
	var moveMc = txtHolder;
	var holderMc = txtHolder;
	var maskMc = eMask;
	moveMc.y = 0;
	// total_h, show_h, xEnd, custom_h, scrollType, bar2LaneRatio, view_h, moveMC_y
	scrollBar.sbResize(moveMc.height, 
					maskMc.height, 
					maskMc.width, 
					0, 
					"resize",
					Math.abs(moveMc.y - maskMc.y) / holderMc.height, 
					holderMc.height + moveMc.y,
					0);
}
//attachToMC, moveMC, total_h, show_h, xEnd, yVal, depth
private function addScrollBar(){
	trace("txtHolder.height: " + txtHolder.height);
	trace("eMask.height: " + eMask.height);
	scrollBar = new VScrollBar2(__tstTxt, 
								txtHolder,
								txtHolder.height,
								eMask.height,
								eMask.width, 
								0, 
								1000);
	scrollBar.sbType = "norm";
	scrollBar.arrowDist = 15;
}*/
private function doSizer(self, sizer){
	self.wVal = sizer.x + sizer.width;
	self.hVal = sizer.y + sizer.height;
	Drawing.drawRect(self.tstTxt, 
			self.wVal, self.hVal, 
			"ffffff", "ffffff", 
			100, 100, 
			"solid", 0,
			1, 100,
			"ff0000", "ff0000", "ff0000", "ff0000",
			0,0,0,0,
			null);
	self.myTxt.width = self.wVal - self.margin*2; 
	self.myTxt.height = self.hVal - self.grabberHolder.height - self.margin*2
	self.grabberHolder.x = self.wVal - self.grabberHolder.width;
}
private function mkSizer(){
	var self = this;
	brSizer = tstTxt.createEmptyMovieClip("eMask", tstTxt.getNextHighestDepth());
	Drawing.drawRect(brSizer, 
				10, 10, 
				"0000ff", "0000ff", 
				100, 100, 
				"solid", 0,
				1, 100,
				"999999", "999999", "999999", "999999",
				0,0,0,0,
				null);
	brSizer.x = tstTxt.width - brSizer.width;
	brSizer.y = tstTxt.height - brSizer.height;
	brSizer.onPress = function(){
		this.startDrag();
		this.sizeId = setInterval(self.doSizer, 10, self, this);
	}
	brSizer.onRelease = brSizer.onReleaseOutside = function(){
		this.stopDrag();
		clearInterval(this.sizeId);
	}
}
private function mkMask(){
	eMask = tstTxt.createEmptyMovieClip("eMask", tstTxt.getNextHighestDepth());
	Drawing.drawRect(eMask, wVal - margin*2, hVal - grabber.height - margin*2, 
				 		"0000ff", "0000ff", 
						33, 33, 
						"solid", 0,
						1, 100,
						"999999", "999999", "999999", "999999",
						0,0,0,0,
						null);
	//tstTxt.setMask(eMask);	
	eMask.x = margin
	eMask.y = grabber.height + margin
}
private function mkBack(){
	__tstTxt = _root.createEmptyMovieClip("__tstTxt", 100000);
	__tstTxt.x = xVal;
	__tstTxt.y = yVal;
	tstTxt = __tstTxt.createEmptyMovieClip("tstTxt", __tstTxt.getNextHighestDepth());
	Drawing.drawRect(tstTxt, wVal, hVal, 
				 		"ffffff", "ffffff", 
						100, 100, 
						"solid", 0,
						1, 100,
						"ff0000", "ff0000", "ff0000", "ff0000",
						0,0,0,0,
						null);
}
private function mkGrabber(){
	grabberHolder = __tstTxt.createEmptyMovieClip("grabberHolder", __tstTxt.getNextHighestDepth());
	grabber = grabberHolder.createEmptyMovieClip("grabber", grabberHolder.getNextHighestDepth());
	Drawing.drawRect(grabber, grabber_w, grabber_h, 
				 		"ff0000", "550000", 
						100, 100, 
						"linear", 90,
						0, 100,
						"999999", "999999", "999999", "999999",
						0,0,0,11,
						null);
	grabberHolder.x = wVal - grabber.width;
	grabber.onPress = function(){
		this._parent._parent.startDrag();
	}
	grabber.onRelease = 
	grabber.onReleaseOutside = function(){
		this._parent._parent.stopDrag();
	}
}
private function mkTextField(){
	var format:TextFormat = new TextFormat();
	txtHolder = tstTxt.createEmptyMovieClip("txtHolder", tstTxt.getNextHighestDepth());
	myTxt = txtHolder.createTextField("myTxt", txtHolder.getNextHighestDepth(), 
									margin, 
									grabber.height + margin, 
									wVal - margin*2, 
									hVal - grabber.height - margin*2);
	myTxt.border = true;
	//myTxt.autoSize = true;
	myTxt.multiline = true;
	myTxt.wordWrap = true;
	format.font = "_sans";
	myTxt.setNewTextFormat(format);								
}
private function mkExitBtn(){
	var self = this;
	var format:TextFormat = new TextFormat();
	XitBtn = grabberHolder.createEmptyMovieClip("XitBtn", grabberHolder.getNextHighestDepth());
	Drawing.drawOval(XitBtn, 
						18, 18, 
				 		myCol1, myCol1, 
						100, 100, 
						"solid", 90,
						3, txtColStr, 100,
						null);
	XitBtn.x = grabber.width - XitBtn.width;
	XitBtn.y = 10;
	var XitBtnTxt = XitBtn.createTextField("XitBtnTxt", XitBtn.getNextHighestDepth(), 
									-5, 
									-10, 
									17, 
									12 + 6);
	XitBtnTxt.selectable = false;
	//XitBtnTxt.border = true;
	//XitBtnTxt.borderColor = 0xffffff;// = true;
	format.bold = true;
	XitBtnTxt.textColor = txtCol;
	XitBtnTxt.setNewTextFormat(format);								
	XitBtnTxt.text = "-";
	XitBtn.onRollOver = function(){
		this.XitBtnTxt.textColor = self.XitRollOverCol;
		Drawing.drawOval(this, 
						18, 18, 
				 		self.txtColStr, self.txtColStr, 
						100, 100, 
						"solid", 90,
						3, self.txtRollOverCol, 100,
						null);
	}
	XitBtn.onRollOut = function(){
		this.XitBtnTxt.textColor = self.txtCol;
		Drawing.drawOval(this, 
						18, 18, 
				 		self.myCol1, self.myCol1, 
						100, 100, 
						"solid", 90,
						3, self.txtColStr, 100,
						null);
	}
	XitBtn.myState = "open";
	XitBtn.onRelease = function(){
		if(this.myState == "open"){
			this._parent._parent.tstTxt._visible = false;
			this.XitBtnTxt.text = "+";
			this.myState = "closed"
		}
		else{
			this._parent._parent.tstTxt._visible = true;
			this.XitBtnTxt.text = "-";
			this.myState = "open"
		}
	}
	
}
public function myTrace(str){
	//_level0.tstTxt._visible = true;
	_root.__tstTxt.tstTxt.txtHolder.myTxt.text += str + "\n";
}

}
}