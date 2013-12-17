
package{
	
import flash.geom.*
import flash.display.*

public class Drawing{
	
public static function drawCustomRect(myShape:Shape, 
						wVal:Number, hVal:Number, 
						col1:String, col2:String,
						alpha1:Number, alpha2:Number, 
						fillType:String, fillRot:Number,
						frame_w:Number, frameAlph:Number,
						_frameColor1:String, _frameColor2:String, _frameColor3:String, _frameColor4:String,
						_corn1:Number, _corn2:Number, _corn3:Number, _corn4:Number,
						spec:String){
						
	var myAngle:Number
	function drawCurve(myShape, x, y, radius, theta){
		var cx, cy, px, py;
		
		cx = x + (Math.cos(myAngle+(theta/2)) * radius/Math.cos(theta/2));
		cy = y + (Math.sin(myAngle+(theta/2)) * radius/Math.cos(theta/2));
		px = x + (Math.cos(myAngle+theta) * radius);
		py = y + (Math.sin(myAngle+theta) * radius);
		myShape.graphics.curveTo(cx, cy, px, py);
		myAngle += theta;
		cx = x + (Math.cos(myAngle+(theta/2)) * radius/Math.cos(theta/2));
		cy = y + (Math.sin(myAngle+(theta/2)) * radius/Math.cos(theta/2));
		px = x + (Math.cos(myAngle+theta) * radius);
		py = y + (Math.sin(myAngle+theta) * radius);
		myShape.graphics.curveTo(cx, cy, px, py);
	}
	
	var hexColor1 = parseInt("0x" + col1);
	var hexColor2 = parseInt("0x" + col2);
	var frameColor1 = parseInt("0x" + _frameColor1);
	var frameColor2 = parseInt("0x" + _frameColor2);
	var frameColor3 = parseInt("0x" + _frameColor3);
	var frameColor4 = parseInt("0x" + _frameColor4);
	
	var twoColFrame;
	var frameStyle = frame_w == 0 || spec == "justFill" || _frameColor1 == null ? undefined : frame_w -1;
	var colors = [hexColor1, hexColor2];
	var alphas = [alpha1, alpha2];
	var ratios = [0, 255];
	
	if(spec == "justFrame")
		fillType = null;
	else
	if(spec == "justFill" || fillType != "noFill"){
		if(fillType == "solid"){
			colors[1] = colors[0];
			alphas[1] = alphas[0];
			fillType = "linear";
		}
		//trace("fillType: " + fillType);
		//trace("elementArr[I_GRAD_X]: " + elementArr[I_GRAD_X]);
		//var matrix = { matrixType:"box", x:100, y:100, w:200, h:200, r:(45/180)*Math.PI };
	var matrix:Matrix = new Matrix();
	matrix.createGradientBox(wVal, hVal, fillRot * Math.PI/180, 0, 0);
	
	/*var matrix = { matrixType:"box", x:grad_x, 
										y:grad_y, 
										w:wVal, 
										h:hVal, //elementArr[I_H], 
										r:fillRot * Math.PI/180 };*/
	}
	if(true){
		var theta;
		// make sure that w + h are larger than 2*cornRad
		var cornMin = Math.min(wVal, hVal)/2;
		var corn1 = _corn1 > cornMin ? cornMin : _corn1;
		var corn2 = _corn2 > cornMin ? cornMin : _corn2;
		var corn3 = _corn3 > cornMin ? cornMin : _corn3;
		var corn4 = _corn4 > cornMin ? cornMin : _corn4;
		// theta = 45 degrees in radians
		theta = Math.PI/4;
		myShape.graphics.clear();
		myShape.graphics.lineStyle(frameStyle, frameColor1, frameAlph);
		// draw top line
		myShape.graphics.moveTo(0 + Math.abs(corn1), 0);
		
		if(fillType != null)
			myShape.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix);
		
		myShape.graphics.lineTo(wVal - Math.abs(corn2), 0);
		//angle is currently 90 degrees
		//myShape.lineStyle(frameStyle, midCol, 100);
		myAngle = -Math.PI/2;
		// draw tr corner
		frameStyle = frame_w == 0 || spec == "justFill" || _frameColor2 == null ? undefined : frame_w -1;
		myShape.graphics.lineStyle(frameStyle, frameColor2, frameAlph);
		if(corn2 < 1){
			myShape.graphics.lineTo(wVal, Math.abs(corn2));//ZZ1
			myAngle += theta;
		}
		else{
			drawCurve(myShape, wVal - corn2, corn2, corn2, theta);
		}
		// draw right line
		myShape.graphics.lineTo(wVal, hVal - Math.abs(corn3));
		// draw br corner
		myAngle += theta;
		//myShape.lineTo(wVal - corn3, hVal);//ZZ2
		frameStyle = frame_w == 0 || spec == "justFill" || _frameColor3 == null ? undefined : frame_w -1;
		myShape.graphics.lineStyle(frameStyle, frameColor3, frameAlph);
		if(corn3 < 1){
			myShape.graphics.lineTo(wVal - Math.abs(corn3), hVal);//ZZ2
			myAngle += theta;
		}
		else{
			drawCurve(myShape, wVal - corn3, hVal - corn3, corn3, theta);
		}
		// draw bottom line
		myShape.graphics.lineTo(Math.abs(corn4), hVal);
		//myShape.lineStyle(frameStyle, midCol, 100);
		// draw bl corner
		myAngle += theta;
		//myShape.lineTo(0, hVal - corn4);//ZZ3
		frameStyle = frame_w == 0 || spec == "justFill" || _frameColor4 == null ? undefined : frame_w -1;
		myShape.graphics.lineStyle(frameStyle, frameColor4, frameAlph);
		if(corn4 < 1){
			myShape.graphics.lineTo(0, hVal - Math.abs(corn4));//ZZ3
			myAngle += theta;
		}
		else{
			drawCurve(myShape, corn4, hVal - corn4, corn4, theta);
		}
		// draw left line
		myShape.graphics.lineTo(0, Math.abs(corn1));
		// draw tl corner
		myAngle += theta;
		//myShape.lineTo(corn1, 0);//ZZ4
		if(corn1 < 1){
			myShape.graphics.lineTo(Math.abs(corn1), 0);//ZZ4
			myAngle += theta;
		}
		else{
			drawCurve(myShape, corn1, corn1, corn1, theta);
		}
		if(fillType != null)
			myShape.graphics.endFill();
	}
}
public static function drawRect(myShape:Shape, 
								wVal:Number, hVal:Number,
								color1:String, color2:String,
								alpha1:Number, alpha2:Number,
								fillRot:Number,
								fillType:String){
	var hexColor1 = parseInt("0x" + color1);
	var hexColor2 = parseInt("0x" + color2);
	//var frameColor = parseInt("0x" + _frameColor);
	var colors:Array = [hexColor1, hexColor2];
	var alphas:Array = [alpha1, alpha2];
	var ratios:Array = [0, 255];

	var matrix:Matrix = new Matrix();
	matrix.createGradientBox(wVal, hVal, fillRot * Math.PI/180, 0, 0);
	myShape.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, "pad", "RGB", 0);
	myShape.graphics.drawRect(0, 0, wVal, hVal);
	//myShape.graphics.drawRoundRect(0, 0, wVal, hVal, 0, 0);
	//addChild(gradient);
}
public static function drawArrow(myShape:Shape, 
						wVal:Number, 
						myLen:Number, // how "long" the arrow point is 1 is pretty pointy .7 is approx equalateral
						myRotation:Number, // like a clock: 0 points to 12:00, 90 points to 3:00, etc
						_fillColor:String, // fill Color
						fillAlph:Number,
						frame_w:Number, frameAlph:Number,
						_frameColor:String,
						spec:String){
	
	var frameStyle = frame_w == 0 || spec == "justFill" ? undefined : frame_w -1;
	var fillColor:Number = parseInt("0x" + _fillColor);
	var frameColor:Number = parseInt("0x" + _frameColor);
	
	myShape.graphics.lineStyle(frameStyle, frameColor, frameAlph);
	myShape.graphics.beginFill(fillColor, fillAlph);
	myShape.graphics.moveTo(0, 0);
	myShape.graphics.lineTo(wVal, 0);
	myShape.graphics.lineTo(wVal/2, wVal* -1 * myLen);
	myShape.graphics.lineTo(0, 0);
	myShape.graphics.endFill();
	myShape.rotation = myRotation;
}
}
}