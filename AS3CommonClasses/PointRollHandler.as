
/*  Event mapping:

1 - videoStart
2 - videoComplete
3 - videoPause
4 - Mute
5 - unMute
6 - replay
7 - 25% complete
8 - 50% complete
9 - 75% complete
10 - videoUnPause

*/


package{
	
import PointRollAPI_AS3.PointRoll;
import flash.events.*;
import flash.display.Sprite;

public class PointRollHandler extends Sprite{
	
private var docRoot:Object;
private var pointRollObj:PointRoll;
private var bcPlayer:Object;
private var pctDoneArr:Array;
private var pctDoneIndx:Number;
	
function PointRollHandler(_docRoot:Object){
	docRoot = _docRoot;
	pointRollObj = PointRoll.getInstance(docRoot.stage);
	pctDoneArr = new Array(25, 50, 75, 100000);
	pctDoneIndx = 0;
	setListeners();
}
private function setListeners(){
	bcPlayer = docRoot.bcPlayer;
	if(bcPlayer != null){
		// Now listen for videoComplete only after the videoLoad
		bcPlayer.addEventListener("mediaBegin", sendClipStartEvent);
		bcPlayer.addEventListener("mediaPlay", sendClipUnPauseEvent);
		bcPlayer.addEventListener("mediaStop", sendClipPauseEvent);
		bcPlayer.addEventListener("mediaProgress", checkPctDone); 
		docRoot.ctlBtns.speakerHolder.addEventListener("onMute", sendMuteEvent);
		docRoot.ctlBtns.speakerHolder.addEventListener("onUnMute", sendUnMuteEvent);
		docRoot.finHandler.finHolder.addEventListener("replayBtnClick", replayBtnClick);
	}
}
private function sendClipStartEvent(evt:Event){
	docRoot.myTrace("pointRoll - sendClipStartEvent");
	pctDoneIndx = 0;
	// Only now start listening for a videoComplete event - once the video has started
	bcPlayer.addEventListener("mediaComplete", sendClipFinEvent);
	pointRollObj.activity(1, false, docRoot.curTitle.displayName); 
}
private function sendClipFinEvent(evt:Event){
	docRoot.myTrace("pointRoll - sendClipFinEvent");
	// Now remove the listener until another videoLoad event occurs
	bcPlayer.removeEventListener("videoComplete", sendClipFinEvent);
	pointRollObj.activity(2, false, docRoot.curTitle.displayName); 
}
private function sendClipPauseEvent(evt:Event){
	docRoot.myTrace("pointRoll - sendClipPauseEvent");
	pointRollObj.activity(3, false, docRoot.curTitle.displayName); 
}
private function sendClipUnPauseEvent(evt:Event){
	trace("position: " + bcPlayer.getVideoPosition());
	if(bcPlayer.getVideoPosition() < 1){
		return;
	}
	docRoot.myTrace("pointRoll - sendClipUnPauseEvent");
	pointRollObj.activity(10, false, docRoot.curTitle.displayName); 
}
private function sendMuteEvent(evt:Event){
	docRoot.myTrace("pointRoll - sendMuteEvent");
	pointRollObj.activity(4, false, docRoot.curTitle.displayName); 
}
private function sendUnMuteEvent(evt:Event){
	docRoot.myTrace("pointRoll - sendUnMuteEvent");
	pointRollObj.activity(5, false, docRoot.curTitle.displayName); 
}
private function replayBtnClick(evt:Event){
	docRoot.myTrace("pointRoll - replayBtnClick");
	pointRollObj.activity(6, false, docRoot.curTitle.displayName); 
}
private function checkPctDone(evt:Event){
	var pctDone = (bcPlayer.getVideoPosition() / bcPlayer.getVideoDuration()) * 100;
	if(pctDone >= pctDoneArr[pctDoneIndx]){
		switch(pctDoneArr[pctDoneIndx])
		{
			case 25:
				pointRollObj.activity(7, false, docRoot.curTitle.displayName);
				break;
			case 50:
				pointRollObj.activity(8, false, docRoot.curTitle.displayName);
				break;
			case 75:
				pointRollObj.activity(9, false, docRoot.curTitle.displayName);
				break;
			default:
				break;
		}
		docRoot.myTrace("checkPctDone: " + pctDoneArr[pctDoneIndx] + "%");
		pctDoneIndx++;
	}
}
}
}