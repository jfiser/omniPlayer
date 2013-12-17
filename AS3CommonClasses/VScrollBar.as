
package{
	
import flash.display.*;
import flash.events.*
import flash.geom.*
import flash.utils.*;

public class VScrollBar{

//private var docRoot:Object;
private var sb:Sprite;
public var isVisible:Boolean = false;
private var firstRun:Boolean = true;
private var scrollLane:Sprite;
private var scrollHandle:Sprite;
private var attachToObj:Object;
private var handle_y:Number;
private var scroll_y:Number;
private var moveObj:Object;
private var maskObj:Object; // usually the mask whose height will be the show_h
private var handleTimer:Timer = new Timer(20, 0);

public var HANDLE_W:Number = 9;
private var HANDLE_H:Number = 50;
	
public function VScrollBar(_attachToObj:Object, _moveObj:Object, _maskObj:Object){
	attachToObj = _attachToObj;
	moveObj = _moveObj;
	maskObj = _maskObj;
	scroll_y = 0;
	sb = new Sprite();
	sb.x = maskObj.width; // - HANDLE_W;
	attachToObj.addChild(sb);
	addScrollLane(maskObj.height);
	addScrollHandle(moveObj.height, maskObj.height);
	setHandleBehavior();
	setLaneBehavior();
	handleTimer.addEventListener(TimerEvent.TIMER, startV_Scroll);
	if(attachToObj.stage){
		attachToObj.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelEvent);
	}
}
public function stayOnBtm(){
	scrollHandle.y = scrollLane.height - scrollHandle.height;
	startV_Scroll(new Event("stayOnBtm"));
}
private function onMouseWheelEvent(evt:MouseEvent){
	if(!sb.visible)
		return;
	var myDelta:Number = evt.delta * 2;
	if(scrollHandle.y - myDelta < 0)
		scrollHandle.y = 0;
	else
	if(scrollHandle.y - myDelta > scrollLane.height - scrollHandle.height)
		scrollHandle.y = scrollLane.height - scrollHandle.height;
	else
		scrollHandle.y -= myDelta;
	startV_Scroll(new Event("mouseWheel"));
}
private function addScrollLane(show_h:Number){
	scrollLane = new Sprite();
	sb.addChild(scrollLane);
	scrollLane.graphics.beginFill(0xcecece);
	scrollLane.graphics.drawRect(0, 0, HANDLE_W, show_h);
}
private function addScrollHandle(total_h:Number, show_h:Number){
	scrollHandle = new Sprite();
	sb.addChild(scrollHandle);
	var handleShape = new Shape();
	scrollHandle.addChild(handleShape);
	Drawing.drawRect(handleShape, 
				 HANDLE_W, HANDLE_H, 
				 "777777", "777777",
				 1, 1,
				 0,
				 "linear");
	
	//scrollHandle.graphics.beginFill(0x3232599);
	//scrollHandle.graphics.drawRect(0, 0, HANDLE_W, HANDLE_H);
	scrollHandle.height = (show_h / total_h * show_h) * 1; // 1 was ratio; 
}
private function handleStartDrag(evt:Event){
	//GlobalStage.stage.addEventListener(MouseEvent.MOUSE_UP, handleStopDrag);
	attachToObj.stage.addEventListener(MouseEvent.MOUSE_UP, handleStopDrag);
	handleTimer.start();
	scrollHandle.startDrag(false, new Rectangle(0, 0, 0, scrollLane.height - scrollHandle.height));
}
private function handleStopDrag(evt:Event){
	scrollHandle.stopDrag();
	handleTimer.stop();
	
	// need this because startDrag always rounds down - fix that here
	if(scrollHandle.y == Math.floor(scrollLane.height - scrollHandle.height)){
		scrollHandle.y = scrollLane.height - scrollHandle.height;
	}
	else
	if(scrollHandle.y == 0){
		moveObj.y = 0;
	}
	startV_Scroll(new Event("stopDrag"));
	
	//startV_Scroll(new Event("handleStopDrag"));
	//GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_UP, handleStopDrag);
	attachToObj.stage.removeEventListener(MouseEvent.MOUSE_UP, handleStopDrag);

}
private function setHandleBehavior(){
	scrollHandle.addEventListener(MouseEvent.MOUSE_DOWN, handleStartDrag);
	scrollHandle.addEventListener(MouseEvent.MOUSE_UP, handleStopDrag);
}
private function laneClick(evt:Event){
	if(scrollLane.mouseY > scrollHandle.y){ // click below handle
		// handle_h < available space to go down
		if(scrollHandle.height <= scrollLane.height - (scrollHandle.y + scrollHandle.height)){
			scrollHandle.y += scrollHandle.height;
		}
		else{ // handle_h > available space to go down - go to bottom
			scrollHandle.y = scrollLane.height - scrollHandle.height;
		}
	}
	else{  // click above handle
		if(scrollHandle.height < scrollHandle.y){// handle_h < available space to go up
			scrollHandle.y -= scrollHandle.height;
		}
		else{ // handle_h > available space to go up - go to top
			scrollHandle.y = 0;
		}
	}
	startV_Scroll(new Event("laneClick"));
}
private function setLaneBehavior(){
	scrollLane.addEventListener(MouseEvent.CLICK, laneClick);
}
//public function sbResize(total_h, show_h, xEnd, bar2LaneRatio, view_h){
public function sbResize(){
	var xEnd = maskObj.width;
	var total_h = moveObj.height;
	var show_h = maskObj.height;
	var view_h = moveObj.height + moveObj.y;
	var bar2LaneRatio = Math.abs(moveObj.y / moveObj.height);
	
	sb.x = xEnd;// - HANDLE_W;
	scrollLane.height = show_h * 1; //ratio
	scrollHandle.height = (show_h / total_h * show_h) * 1; // 1 was ratio;
	if(total_h > show_h){
		sb.visible = true;
		isVisible = true;
	}
	else{
		sb.visible = false;
		isVisible = false;
	}
								
	scrollHandle.y = scrollLane.height * bar2LaneRatio;
	scroll_y = scrollHandle.y;
	
	// when scrollBar is at very btm of scrollLane and resizing to increase height we must 
	// pull the content down with the resizer. 
	if(scrollHandle.y > 0 && show_h > view_h && moveObj.y < 0){
		scrollHandle.y = scrollLane.height - scrollHandle.height;
		//scrollHandle.y = scrollLane.height * bar2LaneRatio;
		startV_Scroll(new Event("handleAtBtm"));
	}
}
private function startV_Scroll(evt:Event){
	var yDiff;
	var handle_y = scrollHandle.y;
	var handle_h = scrollHandle.height;
	var lane_h = scrollLane.height;
	var ratio = 1;
	
	if(handle_y < 0)
		handle_y = 0;
	if(scroll_y != handle_y){
		yDiff = handle_y - scroll_y;
		scroll_y = handle_y;
		moveObj.y -= yDiff * (lane_h / handle_h) * 1/ratio;
	}
	if(scrollHandle.y == 0){
		moveObj.y = 0;
	}
}


}
}



