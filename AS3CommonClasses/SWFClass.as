
/*************** The parent SWF that wants to load a SWFClass ********************
USAGE:

private var testClass:Object; // the instance variable for the class you are loading
	
function Main(){
	// Pass 2 args to SWFClass
	// arg1 - The name of the class you want to load
	// arg2 - An array of the params you wish to pass to the constructor (really an init function)
	testClass = new SWFClass("TestClass", new Array(this, "xxx", pubFunc));
	// the event you will listen for will be the class name plus the string "Loaded"
	testClass.addEventListener("TestClassLoaded", testClassLoaded);
}
// When the event fires and your class is loaded, set your instance var to testClass.instance
private function testClassLoaded(evt:Event){
	testClass = testClass.instance;
}
*******************************/

/*************** The SWFClass that is to be loaded ********************
USAGE:

public class TestClass extends MovieClip{
	
private var docRoot:Object;
// The constructor doesn't init the params - the init function does	
function TestClass(){
	;
}
// Pass the params array to the init function. This does the initialization - not the constructor
public function init(_paramsArr:Array){
	docRoot = _paramsArr[0]; // for example
	var str:String = _paramsArr[1]; // for example
	_paramsArr[2](); // for example
}

TestClass.fla has "TestClass" as the Document class

*******************************/


package{
	
import flash.display.*;
import flash.net.*;
import flash.events.*;
import flash.utils.*;
import flash.text.*;
import flash.system.*;
	
public class SWFClass extends EventDispatcher{
	
private var paramsArr:Array;
public var instance:Object;
private var classSwfName:String;
public var classSwfLoader:Loader;
	
function SWFClass(_classSwfName:String, _paramsArr:Array){
	paramsArr = _paramsArr
	classSwfName = _classSwfName;
	loadClassSwf();
}
private function classSwfLoaded(evt:Event){
	trace("classSwfLoaded");
	instance = evt.target.content;
	instance.init(paramsArr);
	dispatchEvent(new Event((getFileName(classSwfName) + "Loaded")));
}
private function loadClassSwf(){
	trace("loadClassSwf: " + classSwfName);
	classSwfLoader = new Loader();
	classSwfLoader.contentLoaderInfo.addEventListener(Event.INIT, classSwfLoaded);
	classSwfLoader.load(new URLRequest(classSwfName + ".swf"));
}	
private function getFileName(path:String):String{
	var arr:Array = path.split('/');
	return(arr[arr.length-1]);
}
}
}