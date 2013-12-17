package{

public class VideoDataHandler{

private var docRoot:Main;
//private var private var byline_override:
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
	
private var videoObj:Object;

public function VideoDataHandler(_docRoot:Main, paramObj:Object){
	docRoot = _docRoot;
	videoObj = JSON2.decode(paramObj._videoJson);
	
	docRoot.curTitle = new Title(docRoot, videoObj);
	//docRoot.myTrace(paramObj._videoJson);
	//docRoot.myTrace("videoObj: " + videoObj);
	//docRoot.myTrace("videoObj: " + videoObj.playlist_url);
	//loadSmil(videoObj.playlist_url + "&manifest=f4m");
	
}



}
}
