package
{
import com.akamai.net.f4f.hds.AkamaiStreamController;
import com.akamai.net.f4f.hds.events.AkamaiHDSEvent;

import flash.display.Sprite;
import flash.media.Video;

public class AkamaiVideoEngine_HDS extends Sprite{
//private var MEDIA:String = "http://multiplatform-f.akamaihd.net/z/multi/april11/hdworld/hdworld_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,1280x720_1900_m,1280x720_2500_m,1280x720_3500_m,.mp4.csmil/manifest.f4m";
private var streamController:AkamaiStreamController;
private var docRoot:Main;

public function AkamaiVideoEngine_HDS(_docRoot:Main){
	docRoot = _docRoot;
	streamController = new AkamaiStreamController();
	streamController.addEventListener(AkamaiHDSEvent.NETSTREAM_READY, onNetStreamReady);
}

private function onNetStreamReady(event:AkamaiHDSEvent):void{
	var video:Video = new Video(docRoot.playerSizer.PLAYER_W, docRoot.playerSizer.PLAYER_H);
	video.attachNetStream(streamController.netStream);
	addChild(video);
}
public function playVideo(_resourceUrl:String):void{
	streamController.play(_resourceUrl);
}


}
}