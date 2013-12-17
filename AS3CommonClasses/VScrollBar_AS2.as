
	
	
class VScrollBar{
	
public var sb:MovieClip;
private var textureLines:MovieClip;
private var _arrowDist:Number;
private var _scrollArr:Array;
private var _sbType:String;
private var _yVal:Number;
private var _yOffset:Number;
//private var moveMC:MovieClip;

function VScrollBar(attachToMC, moveMC, total_h, show_h, xEnd, yVal, depth){
	var owner:VScrollBar = this; // need this because of function scope 
	sb = attachToMC.attachMovie("Vscroller", "Vscroller"+depth, depth);
	sb.moveMC = moveMC;
	_yVal = yVal;
		// start distance the scrollBar's _y is from  moveMC._y (often is 0)
	_yOffset = moveMC == null ? 0 : moveMC._y - yVal; 
	sb.scrollHandle.useHandCursor = false;
	sb.scrollLane.useHandCursor = false;
	sb._y = yVal + sb.scrollArrowBtm._height;
	sbResize(total_h, show_h, xEnd, 0, null);
	
	var mouseListener:Object = new Object();
	mouseListener.onMouseWheel = function(delta){
		if(!owner.sb._visible)
			return;
		//delta *= 2;
		if(owner.sb.scrollHandle._y - delta < 0)
			owner.sb.scrollHandle._y = 0;
		else
		if(owner.sb.scrollHandle._y - delta > owner.sb.scrollLane._height - owner.sb.scrollHandle._height)
			owner.sb.scrollHandle._y = owner.sb.scrollLane._height - owner.sb.scrollHandle._height;
		else
			owner.sb.scrollHandle._y -= delta;
		owner.startV_Scroll(owner.sb, owner._scrollArr, owner._sbType);
	}
	Mouse.addListener(mouseListener);

	
	function arrowPressed(arrowBtn, func){
		clearInterval(arrowBtn.sbArrowID); // clear the interval tha started this func
		if(arrowBtn.pressed){ // now see if we need to rapid fire the scroller
			clearInterval(arrowBtn.rapidID);
			arrowBtn.rapidID = setInterval(func, 40, arrowBtn._parent);
		}
	}
	function sbArrowDn(sb){
		var dist = owner._arrowDist * (sb.scrollHandle._height / sb.scrollLane._height) * sb.ratio;
		if(sb.scrollHandle._y + sb.scrollHandle._height + dist > sb.scrollLane._height)
			sb.scrollHandle._y = sb.scrollLane._height - sb.scrollHandle._height;
		else
			sb.scrollHandle._y += dist;
		owner.startV_Scroll(sb, owner._scrollArr, owner._sbType);
	}
	function sbArrowUp(sb){
		var dist = owner._arrowDist * (sb.scrollHandle._height / sb.scrollLane._height) * sb.ratio;
		if(sb.scrollHandle._y - dist < 0)
			sb.scrollHandle._y = 0;
		else
			sb.scrollHandle._y -= dist;
		owner.startV_Scroll(sb, owner._scrollArr, owner._sbType);
	}
	sb.scrollHandle.onPress = function(){
		this.startDrag(false, 0, 0, 0, this._parent.scrollLane._height - this._height);
		this.onMouseMove = function(){
			updateAfterEvent();
		}
		clearInterval(this.scrollID);
		this.scrollID = setInterval(owner.startV_Scroll, 30, this._parent, 
													owner._scrollArr, owner._sbType); 
	}
	sb.scrollHandle.onRelease = 
	sb.scrollHandle.onReleaseOutside = function(){
		this.stopDrag();
		this.onMouseMove = undefined;
		clearInterval(this.scrollID);
		// need this because startDrag always rounds down - fix that here
		if(this._y == Math.floor(this._parent.scrollLane._height - this._height)){
			this._y = this._parent.scrollLane._height - this._height;
			//owner.startV_Scroll(this._parent, owner._scrollArr, owner._sbType);
		}
		else
		if(this._y == 0){
			this._parent.moveMC._y = owner._yOffset;
		}
		owner.startV_Scroll(this._parent, owner._scrollArr, owner._sbType);
	}
	sb.scrollLane.onPress = function(){
		if(this._parent._ymouse > this._parent.scrollHandle._y) // click below handle
			if(this._parent.scrollHandle._height < // handle_h < available space to go down
		   						this._height - 
								(this._parent.scrollHandle._y + this._parent.scrollHandle._height))  
				this._parent.scrollHandle._y += this._parent.scrollHandle._height;
			else // handle_h > available space to go down - go to bottom
				this._parent.scrollHandle._y = this._height - this._parent.scrollHandle._height;
		else  // click above handle
			if(this._parent.scrollHandle._height < this._parent.scrollHandle._y)// handle_h < available space to go up
				this._parent.scrollHandle._y -= this._parent.scrollHandle._height;
			else // handle_h > available space to go up - go to top
				this._parent.scrollHandle._y = 0;
		owner.startV_Scroll(this._parent, owner._scrollArr, owner._sbType);
	}
	sb.scrollArrowBtm.onPress = function(){
		sbArrowDn(this._parent);
		clearInterval(this.sbArrowID);
		this.sbArrowID = setInterval(arrowPressed, 300, this, sbArrowDn);
		this.pressed = true;
	}
	sb.scrollArrowBtm.onRelease = 
	sb.scrollArrowBtm.onReleaseOutside = function(){
		this.pressed = false;
		clearInterval(this.sbArrowID);
		clearInterval(this.rapidID);
	}
	sb.scrollArrowTop.onPress = function(){
		sbArrowUp(this._parent);
		clearInterval(this.sbArrowID);
		this.sbArrowID = setInterval(arrowPressed, 300, this, sbArrowUp);
		this.pressed = true;
	}
	sb.scrollArrowTop.onRelease = 
	sb.scrollArrowTop.onReleaseOutside = function(){
		this.pressed = false;
		clearInterval(this.sbArrowID);
		clearInterval(this.rapidID);
	}
}
public function set arrowDist(dist:Number):Void{
	_arrowDist = dist;
}
public function set scrollArr(arr:Array):Void{
	_scrollArr = arr;
}
public function set sbType(str:String):Void{
	_sbType = str;
}
// custom_h is used to customize ht. of scrollBar 
// view_h is viewable area of content
// moveMC_y is yVal of content - any yOffset
public function sbResize(total_h, show_h, xEnd, custom_h, scrollType, bar2LaneRatio,
												view_h, moveMC_y){
	sb.scroll_y = 0;
	var arrow_h = sb.scrollArrowBtm._height * 2 + custom_h; // allow for arrow btns
	sb.ratio = (show_h - arrow_h) / show_h;
	sb.scrollLane._height = show_h * sb.ratio;
	sb.scrollHandle._height = (show_h / total_h * show_h) * sb.ratio; 
	/*sb.scrollHandle.textureLines._visible = 
					sb.scrollHandle.textureLines._height < sb.scrollHandle.scrollHandle2._height+20;
	sb.scrollHandle.textureLines._y = sb.scrollHandle.scrollHandle2._height / 2;*/
	sb.scrollArrowBtm._y = sb.scrollLane._height + sb.scrollArrowBtm._height;
	sb.arrowHiLiteBtm._y = sb.scrollLane._height + 0.5;
	if(total_h > show_h)
		sb._visible = true;
	else
		sb._visible = false;
	
	if(scrollType == "resize"){ // scroll changing due to resize of window (mask)
		sb.scrollHandle._y = sb.scrollLane._height * bar2LaneRatio;
		sb.scroll_y = sb.scrollHandle._y;
	}
	else // don't put scroll back to top after showFolder() stay where u were
	if(scrollType == "rem")
		startV_Scroll(sb);
	else{ // handle goes back to top
		sb.scrollHandle._y = 0;
		//sb.handleLoc = 0;
	}
	sb._x = xEnd - sb._width;
	//this._y = yEnd - this._height; // after we put scrollHandle back or sb._height is too big
	
	//var yOffset = _yVal - sb.moveMC._y; // distance the scrollBar's _y is from begin of moveMC._y (often is 0)
	// when scrollBar is at very btm of scrollLane and resizing to increase height we must pull the content down
	// with the resizer. 
	if(sb.scrollHandle._y > 0 && show_h > view_h && moveMC_y < _yOffset){
		sb.scrollHandle._y = sb.scrollLane._height - sb.scrollHandle._height;
		startV_Scroll(sb, this._scrollArr, this._sbType);
	}
}

function startV_Scroll(sb, scrollArr, sbType){
	var i, j, xDiff, yDiff;
	var handle_y = sb.scrollHandle._y;
	var handle_h = sb.scrollHandle._height;
	var lane_h = sb.scrollLane._height;
	var ratio = sb.ratio;
	
	if(handle_y < 0)
		handle_y = 0;
		
	if(sb.scroll_y != handle_y){
		yDiff = handle_y - sb.scroll_y;
		sb.scroll_y = handle_y;
		//sb.moveMC._y -= yDiff * (lane_h / handle_h) * 1/ratio;
		switch(sbType)
		{
			case "pic":
				for(i = 0; i < scrollArr.length; i++){
					scrollArr[i].eFrame._y -= yDiff * (lane_h / handle_h)* 1/ratio;
					scrollArr[i].eFrame.page._y -= yDiff * (lane_h / handle_h)* 1/ratio;
				}
				break;
			case "pgThmb":
				for(i = 0; i < scrollArr.length; i++){
					scrollArr[i]._y -= yDiff * (lane_h / handle_h) * 1/ratio;
					for(j = 0; j < scrollArr[i].mvArr.length; j++){
						scrollArr[i].mvArr[j]._y -= yDiff * (lane_h / handle_h) * 1/ratio;
					}
				}
				break;
			default:
				sb.moveMC._y -= yDiff * (lane_h / handle_h) * 1/ratio;
				break;
		}
	}
}
public function sbColor(myColor){
	//var newColor, col = haveCol != undefined ? haveCol : elementArr[I_COL].toLowerCase();
	//if(col == "ffffff")
		//col = "cccccc";
	var newColor = new Color(sb.scrollHandle.scrollHandle2);
	newColor.setRGB("0x" + myColor);
	newColor = new Color(sb.scrollLane.scrollBack);
	newColor.setRGB("0x" + myColor);
	newColor = new Color(sb.scrollArrowTop.arrowBack);
	newColor.setRGB("0x" + myColor);
	newColor = new Color(sb.scrollArrowBtm.arrowBack);
	newColor.setRGB("0x" + myColor);
	
}
public function sbAlpha(elementArr){
	var I_ALPH = 1;
	sb.scrollLane._alpha = elementArr[I_ALPH];
	sb.scrollHandle.scrollHandle2._alpha = elementArr[I_ALPH];
	sb.scrollArrowTop.arrowBack._alpha = elementArr[I_ALPH];
	sb.scrollArrowBtm.arrowBack._alpha = elementArr[I_ALPH];
}
} //end of class