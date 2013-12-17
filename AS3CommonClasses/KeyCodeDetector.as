
package{
	
import flash.events.*
import flash.ui.*;

public class KeyCodeDetector extends EventDispatcher{
	
private var docRoot:Main;
private var keySequenceArr:Array; // up,down,right,left
private var curIndx:Number = 0;
private var theEvent:String;
	
function KeyCodeDetector(_docRoot:Main, _theEvent:String, _keySequenceArr:Array){
	docRoot = _docRoot;
	keySequenceArr = _keySequenceArr;
	theEvent = _theEvent;
	for(var i:Number = 0; i < keySequenceArr.length; i++){
		keySequenceArr[i] = keySequenceArr[i].toLowerCase()
	}
	docRoot.stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
}
private function checkKeyEntry(_keyHit:String){
	if(keySequenceArr[curIndx] == _keyHit){
		if(curIndx == keySequenceArr.length-1){
			dispatchEvent(new Event(theEvent)); // got the sequence
			curIndx = 0;
		}
		else{
			curIndx++;
		}
	}
	else{
		curIndx = 0;
	}
}
private function reportKeyDown(event:KeyboardEvent){
	if(event.keyCode == Keyboard.UP){
		checkKeyEntry("up");
	}
	else
	if(event.keyCode == Keyboard.RIGHT){
		checkKeyEntry("right");
	}
	else
	if(event.keyCode == Keyboard.LEFT){
		checkKeyEntry("left");
	}
	else
	if(event.keyCode == Keyboard.DOWN){
		checkKeyEntry("down");
	}
	else{
		checkKeyEntry(String.fromCharCode(event.charCode));
	} 
}
}
}
	
