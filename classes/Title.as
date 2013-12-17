package{

import flash.events.*;
import flash.net.*;

public class Title extends EventDispatcher{

private var docRoot:Main;
private var videoObjFromPage:Object;
// page variables
private var byline_override:String;
private var id:Number;
private var meta_description:String;
private var mp4_url:String;
private var playlist_url:String;
private var poly_url:String;
private var primary_photo:String;
private var resource_uri:String;
private var slug:String;
private var source:String;
private var title:String;
// end page variables
// vars from SMIL file
private var resourceUrl:String;	
public var displayTitle:String;	
private var abstract:String;	
private var categories:String;	
private var guid:String;	
private var video_w:Number;
private var video_h:Number;
// end vars from SMIL
	
public function Title(_docRoot:Main){
	docRoot = _docRoot;
	//videoObjFromPage = _videoObjFromPage;
	//checkVideoData(); 
}
// If we have a playlist_url, then we can do adaptive bitrate. 
// If not - just try to play the MP4
/*private function checkVideoData(){
	if(videoObjFromPage.playlist_url && videoObjFromPage.playlist_url.indexOf("http://") != -1){
		loadSmil(videoObjFromPage.playlist_url + "&manifest=f4m");
	}
	else
	if(videoObjFromPage.mp4_url && videoObjFromPage.mp4_url.indexOf("http://") != -1){
		docRoot.videoEngine.playVideo(videoObjFromPage.mp4_url);
	}
}*/
public function loadSmil(_smilUrl:String){
	var loader:URLLoader = new URLLoader();
	loader.addEventListener(Event.COMPLETE, smilLoaded);
	loader.addEventListener(IOErrorEvent.IO_ERROR, smilLoadError);
	loader.load(new URLRequest(_smilUrl));
}	
private function smilLoaded(evt:Event){
	docRoot.myTrace("smilLoaded: " + evt.target.data);
	var smilXml = new XML(evt.target.data);
	var seqXmlList:XMLList = smilXml.seq;
	docRoot.myTrace("seqXmlList: " + seqXmlList);
	docRoot.myTrace("seqXmlList[0]: " + seqXmlList[0]);
	var ns:Namespace = new Namespace("http://www.w3.org/2005/SMIL21/Language");
	
	resourceUrl = smilXml.ns::body.ns::seq.ns::video.@["src"];
	displayTitle = smilXml.ns::body.ns::seq.ns::video.@["title"];
	abstract = smilXml.ns::body.ns::seq.ns::video.@["abstract"];
	categories = smilXml.ns::body.ns::seq.ns::video.@["categories"];
	guid = smilXml.ns::body.ns::seq.ns::video.@["guid"];
	video_w = parseInt(smilXml.ns::body.ns::seq.ns::video.@["width"]);
	video_h = parseInt(smilXml.ns::body.ns::seq.ns::video.@["height"]);
	
	docRoot.myTrace("resourceStr: " + resourceUrl);
	docRoot.myTrace("displayTitle: " + displayTitle);
	docRoot.videoEngine.playVideo(resourceUrl);
	dispatchEvent(new Event("smilLoaded"));

}
private function smilLoadError(evt:Event){
	;
}


}
}
