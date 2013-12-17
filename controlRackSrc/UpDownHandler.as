package{
	
import fl.motion.easing.*;
import flash.events.*;
import flash.utils.*;

public class UpDownHandler extends EventDispatcher{
	
private var docRoot:Object;
private var controlRackMain:ControlRackMain;
private var playerSizer:Object;
private var mouseIsOnStage:Boolean;
private var ctlBtnsAreUp:Boolean;
private var ctlBtnsTimer:Timer;

public function UpDownHandler(_docRoot:Object, _controlRackMain:ControlRackMain, _playerSizer:Object){
	docRoot = _docRoot;
	controlRackMain = _controlRackMain;
	playerSizer = _playerSizer;
	setCtlBtnsUpDown();
}
private function listenForMouseMove(){
	docRoot.stage.removeEventListener(MouseEvent.MOUSE_MOVE, myMouseMove); 
	docRoot.stage.addEventListener(MouseEvent.MOUSE_MOVE, myMouseMove);
}
private function myMouseLeave(evt:Event){
	mouseIsOnStage = false;
	ctlBtnsDown(new Event("mouseLeave"));
	//ctlBtnsTimer.start();
}
private function myMouseMove(evt:MouseEvent){
	ctlBtnsUp();
	ctlBtnsTimer.start();
	mouseIsOnStage = true;
}
private function ctlBtnsUp(){
	dispatchEvent(new Event("controlRackUp"));
	docRoot.stage.removeEventListener(MouseEvent.MOUSE_MOVE, myMouseMove);
	TweenLite.to(controlRackMain, .6, {y:playerSizer.PLAYER_H - controlRackMain.CONTROL_RACK_BACK_H, ease:Exponential.easeOut});
	ctlBtnsAreUp = true;
}
private function ctlBtnsDown(evt:Event){
	if(mouseIsOnStage 
	   	&& (controlRackMain.controlRackBack.hitTestPoint(controlRackMain.controlRackBack.stage.mouseX, 
																controlRackMain.controlRackBack.stage.mouseY))){
		return;
	}
	if(mouseIsOnStage 
	   	&& (controlRackMain.volumeController.scrubberHolder.hitTestPoint(
									controlRackMain.volumeController.scrubberHolder.stage.mouseX, 
									controlRackMain.volumeController.scrubberHolder.stage.mouseY))){
		return;
	}
	
	ctlBtnsTimer.stop();
	dispatchEvent(new Event("controlRackDown"));
	TweenLite.to(controlRackMain, .4, {y:playerSizer.PLAYER_H, ease:Exponential.easeOut});
	ctlBtnsAreUp = false;
	listenForMouseMove();
}
public function setCtlBtnsUpDown(){
	docRoot.myTrace("setCtlBtnsUpDown");
	listenForMouseMove();
	docRoot.stage.removeEventListener(Event.MOUSE_LEAVE, myMouseLeave);
	docRoot.stage.addEventListener(Event.MOUSE_LEAVE, myMouseLeave);
	
	ctlBtnsTimer = new Timer(3000, 0);
	ctlBtnsTimer.removeEventListener(TimerEvent.TIMER, ctlBtnsDown);
	ctlBtnsTimer.addEventListener(TimerEvent.TIMER, ctlBtnsDown);
	ctlBtnsTimer.start();
}
public function turnOffCtlBtnsUpDown(){
	//ctlBtnsTimer.stop();
	docRoot.myTrace("turnOffCtlBtnsUpDown");
	docRoot.stage.removeEventListener(MouseEvent.MOUSE_MOVE, myMouseMove);
	docRoot.stage.removeEventListener(Event.MOUSE_LEAVE, myMouseLeave);
	ctlBtnsTimer.stop();
	TweenLite.to(controlRackMain, .4, {y:playerSizer.PLAYER_H, ease:Exponential.easeOut});
	dispatchEvent(new Event("controlRackDown"));
}


}
}
