package{

public class PlayerSizer{
	
import flash.display.*;
import flash.events.*;
	
private var docRoot:Main;
	
public var PLAYER_W:Number = 640;
public var PLAYER_H:Number = 360;

public function PlayerSizer(_docRoot:Main){
	docRoot = _docRoot;
	docRoot.stage.scaleMode = StageScaleMode.NO_SCALE; 
	docRoot.stage.align = StageAlign.TOP_LEFT; 
	docRoot.stage.addEventListener(Event.RESIZE, resizeDisplay);
	docRoot.stage.addEventListener(FullScreenEvent.FULL_SCREEN, resizeDisplay);
	setStartingSize();
}
private function setStartingSize(){
	docRoot.myTrace("stage.stageWidth: " + docRoot.stage.stageWidth); 
	docRoot.myTrace("stage.stageHeight: " + docRoot.stage.stageHeight);
	PLAYER_W = docRoot.stage.stageWidth;
	PLAYER_H = docRoot.stage.stageHeight;
}
private function resizeDisplay(evt:Event):void 
{ 
    PLAYER_W = docRoot.stage.stageWidth; 
    //PLAYER_H = docRoot.stage.stageHeight; 
 
    // Resize the main content area 
    //var newPlayer_h:Number = PLAYER_H - 80; 
    /*docRoot.playerHolder.height = PLAYER_H; 
    docRoot.playerHolder.scaleX = docRoot.playerHolder.scaleY; */
    docRoot.playerHolder.width = PLAYER_W;
    docRoot.playerHolder.height = PLAYER_W * (9/16);
    //docRoot.playerHolder.scaleY = docRoot.playerHolder.scaleX;
    PLAYER_H = PLAYER_W * (9/16);
	//docRoot.playerMask.width = PLAYER_W;
	//docRoot.playerMask.height = PLAYER_H;
    // Reposition the control bar. 
    //controlBar.y = newContentHeight; 
}

}
}
