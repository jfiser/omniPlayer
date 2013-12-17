package{

import flash.display.*;
import flash.events.*;

public class Resizer{
	
private var docRoot:Object;
private var controlRackMain:ControlRackMain;
private var playerSizer:Object;

public function Resizer(_docRoot:Object, _controlRackMain:ControlRackMain, _playerSizer:Object){
	docRoot = _docRoot;
	controlRackMain = _controlRackMain;
	playerSizer = _playerSizer;
	
	docRoot.stage.addEventListener(Event.RESIZE, resizeControlRack); 
	docRoot.stage.addEventListener(FullScreenEvent.FULL_SCREEN, resizeControlRack);
}
private function resizeControlRack(evt:Event){
	trace("resize");
	controlRackMain.set_xy();
	controlRackMain.controlRackBack.resize();
	controlRackMain.scrubber.resize();
	reszeMask();
	controlRackMain.playPauseTextOverlay.resize();
}
private function reszeMask(){
	controlRackMain.controlRackMask.width = playerSizer.PLAYER_W;
	controlRackMain.controlRackMask.height = playerSizer.PLAYER_H;
}


}
}
