
package {  
      
import flash.display.DisplayObject;    
import flash.display.MovieClip;    
import flash.display.Stage;        

public class GlobalStage extends MovieClip{ 

public static var stage:Stage;        
public static var root:DisplayObject;

public function GlobalStage(){            
	GlobalStage.stage = this.stage;            
	GlobalStage.root = this;        
}    
}
}