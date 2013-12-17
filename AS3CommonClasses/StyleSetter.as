package{
// Take in some CSS and convert to an object with xVal, yVal, width, height, color, etc
// This is a subset of actual CSS properties available in browsers. But you can add on whichever 
// additional properties you want by modifying setProperties below
// You can also add on properties that don't exist in CSS - such as "scrubberColor" (for example) - or any other string
public class StyleSetter{
	
public static function setDefaultStyles():Object{
	var retObj:Object = {};
	retObj.xVal = 0;
	retObj.yVal = 0;
	retObj.widthPx = 0;
	retObj.widthPct = 0;
	retObj.heightPx = 0;
	retObj.heightPct = 0;
	retObj.bgColor = "ffffff";
	retObj.opacity = 1;
	retObj.borderColor = "000000";
	retObj.borderWidth = 0;
	retObj.bgImage = null;
	retObj.marginLeft = 0;
	retObj.marginRight = 0;
	retObj.marginTop = 0;
	retObj.marginBottom = 0;
	retObj.fontSize = 15;
	retObj.color = "000000";
	return(retObj);
}
public static function setProperties(_styleObj:Object):Object{
	trace("_styleObj: " + _styleObj)
	var retObj:Object = setDefaultStyles();
	
	for(var item in _styleObj){
		trace("item: " + item + ": " + _styleObj[item]);
		switch(item)
		{
			case "left":
				retObj.xVal = parseFloat(_styleObj["left"]);
				break;
			case "top":
				retObj.yVal = parseFloat(_styleObj["top"]);
				break;
			case "width": 
				trace("width: " + _styleObj["width"]);
				if(_styleObj["width"].indexOf("%") != -1){
					retObj.widthPct = parseInt(_styleObj["width"]);
				}
				else{
					retObj.widthPx = parseFloat(_styleObj["width"]);
				}
				trace("retObj.wVal: " + retObj.wVal);
				break;
			case "height": 
				if(_styleObj["height"].indexOf("%") != -1){
					retObj.heightPct = parseInt(_styleObj["height"]);
				}
				else{
					retObj.heightPx = parseFloat(_styleObj["height"]);
				}
				break;
			case "backgroundColor": 
				trace("backgroundColor: " + _styleObj["backgroundColor"]);
				retObj.bgColor = _styleObj["backgroundColor"].split("#")[1];
				//trace("BBBBBBB: " + retObj.bgColor);
				break;
			case "opacity":
				retObj.opacity = parseFloat(_styleObj["opacity"]); //0.6;
				trace("retObj.opacity: " + retObj.opacity);
				break;
			case "borderColor":
				retObj.borderColor = _styleObj["borderColor"].split("#")[1];
				break;
			case "borderWidth":
				retObj.borderWidth = parseInt(_styleObj["borderWidth"]);
				break;
			case "backgroundImage": 
				retObj.bgImage = _styleObj["backgroundImage"].split("'")[1]; // :url('paper.gif');
				trace("backgroundImage: " + retObj.bgImage);
				break;
			case "marginLeft":
				retObj.marginLeft = parseFloat(_styleObj["marginLeft"]);
				break;
			case "marginRight":
				retObj.marginRight = parseFloat(_styleObj["marginRight"]);
				trace("retObj.marginRight: " + retObj.marginRight);
				break;
			case "marginTop":
				retObj.marginTop = parseFloat(_styleObj["marginTop"]);
				break;
			case "marginBottom":
				retObj.marginBottom = parseFloat(_styleObj["marginBottom"]);
				break;
			case "color":
				retObj.color = _styleObj["color"].split("#")[1];
				break;
			case "fontSize":
				retObj.fontSize = parseInt(_styleObj["fontSize"]);
				break;
		}
	}
	return(retObj);
}


}
}
