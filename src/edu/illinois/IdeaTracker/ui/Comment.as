package edu.illinois.IdeaTracker.ui
{
	import edu.illinois.IdeaTracker.data.PostStatistics;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.utils.setTimeout;
	
	import mx.controls.LinkButton;
	import mx.core.Container;
	import mx.states.SetProperty;
	import mx.styles.IStyleManager2;
	
	import spark.components.BorderContainer;
	import spark.components.Button;

	//Store all comment information
	public class Comment
	{
		public var text:String;
		public var date:Date;
		public var username:String;
		public var commentNumber:int;
		public var isIdea:Boolean;
		public var commentLength: int  = 0;
		public var negativeTune: Number = 0;
		public var positiveTune: Number = 0;
		public var url:String;
		public var argument:String;
		
		public var buttonPositive:BorderContainer = new BorderContainer();
		public var tooltip:Tooltip;
		public var buttonNegative:BorderContainer = new BorderContainer();
		public var tooltipIsShown:Boolean = false;
		public var commentContainer:BorderContainer = new BorderContainer();
		
		public var idea:Idea;
		
		public static var MAX_COMMENT_LENGTH:int = 100;
		public static var MIN_COMMENT_LENGTH:int = 25;
		
		public static var COMMENT_HEIGHT:int = 5;
		
		public function Comment(text:String, date:Date, username:String, commentNumber:int, isIdea:Boolean, url:String)
		{
			this.text = text;
			this.date = date;
			this.username = username;
			this.commentNumber = commentNumber; 
			this.isIdea = isIdea;
			this.url = url;
			setCommentLength();
			
		}
		
		public function drawComment (x:int, y:int):void{
			if(positiveTune > negativeTune){
				commentContainer.setStyle("borderColor",0x000000);
				trace("positiveTune: "+positiveTune + " negativeTune: " + negativeTune);
			}			
			commentContainer.x = x - commentLength/2; 
			commentContainer.y = y; 
			commentContainer.height = COMMENT_HEIGHT+1;
			commentContainer.width = commentLength;
		
			//Check the positive vs negative tune
			//Show only one color: red, green or yellow
			//Ambiguous - Yellow
			if(positiveTune > 0 && negativeTune > 0)
			{
				//ffcc33
				commentContainer.setStyle("backgroundColor", 0xffd65c);//0xfffd9c);
				//drawButton(commentLength, 0xEAFF02);
				
			}
				//Negative - Red
			else if(negativeTune > 0 && positiveTune == 0)
			{
				//aa0033
				commentContainer.setStyle("backgroundColor", 0xee0048);//0xE00000);
				//drawButton(commentLength, 0xE00000);
			}
				//Positive - Green
			else if(positiveTune > 0 && negativeTune == 0)
			{
				//008000
				commentContainer.setStyle("backgroundColor", 0x00cc00);//0x76CD18);
				//drawButton(commentLength, 0x76CD18);
			}
			else
			{
				//6699cc (Good)
				//commentContainer.setStyle("backgroundColor", 0xEAFF02);
				//drawButton(commentLength, 0xFFFFFF);
			}
			
			//commentContainer.addElement(buttonPositive);
			//commentContainer.addElement(buttonNegative);
			commentContainer.setStyle("borderColor",0Xa0a2a6);
			
			/*commentContainer.addEventListener(MouseEvent.MOUSE_OVER,function():void{
				commentContainer.toolTip = findMainContent(text) + " ..." + " <a href=\""+ url + "\"> Read More </a>"; 
			});
			buttonPositive.addEventListener(MouseEvent.MOUSE_OVER,function():void{
			buttonPositive.toolTip = findMainContent(text) + "..." + " <a href=\""+ url + "\"> Read More </a>";
			});
			buttonNegative.addEventListener(MouseEvent.MOUSE_OVER,function():void{
			buttonNegative.toolTip = findMainContent(text) + "..." + " <a href=\""+ url + "\"> Read More </a>";
			});*/
			
			
			tooltip = new Tooltip();
			tooltip.text = "#" + commentNumber + " Posted by " + username + "\n"+ findMainContent(text) + "..." + "  <b><a href=\""+ url + "\"> Read More </a></b>";
			tooltip.depth = 100;
			commentContainer.addEventListener(MouseEvent.MOUSE_OVER, showTooltip);  
			commentContainer.addEventListener(MouseEvent.MOUSE_OUT, hideTooltip);								
			//commentContainer.addEventListener(MouseEvent.CLICK, fixTooltip);
		}

		//Function to draw button
		//Takes parameters commentLength, comment height and tune
		//tune is a hex value which represents the color of the button
		public function drawButton(commentLength:int, tune:*)
		{
			buttonPositive.x = 1;
			buttonPositive.y = 0;
			buttonPositive.height = COMMENT_HEIGHT;
			buttonPositive.width = commentLength/2;
			buttonPositive.setStyle("borderColor",0Xa0a2a6);
			buttonPositive.setStyle("backgroundColor", tune);
			buttonPositive.setStyle("borderVisible",false);
			
			buttonNegative.x = commentLength/2;
			buttonNegative.y = 0;
			buttonNegative.height = COMMENT_HEIGHT;
			buttonNegative.width = commentLength/2 - 3;
			if(buttonNegative.width < 3){
				buttonNegative.width = 0;
				buttonNegative.height = 0;
			}
			buttonNegative.setStyle("borderColor",0Xa0a2a6);
			buttonNegative.setStyle("backgroundColor", tune);
			buttonNegative.setStyle("borderVisible",false);
		}
		
		public function fixTooltip(event:MouseEvent):void{
			if(!tooltipIsShown){
				commentContainer.addElement(tooltip);
				tooltipIsShown = true;
			}
			commentContainer.parent.addEventListener(MouseEvent.CLICK, mouseUp);			
		}
		public function showTooltip(event:MouseEvent):void{
			if(!tooltipIsShown){
				commentContainer.addElement(tooltip);
				tooltipIsShown = true;
			}
		}
		public function mouseUp(event:MouseEvent):void {
			if (event.target == tooltip || tooltip.contains(DisplayObject(event.target))){
				// mouse is up over circle (onRelease)
				// (if circle is not a DisplayObjectContainer, 
				// you do not need to use the contains check)
			}else{
				commentContainer.removeElement(tooltip);
				commentContainer.parent.removeEventListener(MouseEvent.CLICK, mouseUp);
			}
		}
		public function hideTooltip(event:MouseEvent):void{
			if(tooltipIsShown){
				commentContainer.removeElement(tooltip);
				tooltipIsShown = false;
			}
		}
		public function filter():void{
			buttonNegative.setStyle("backgroundAlpha",0.25);
			buttonPositive.setStyle("backgroundAlpha",0.25);
			commentContainer.setStyle("backgroundAlpha",0.25);
			buttonNegative.setStyle("borderAlpha",0.25);
			buttonPositive.setStyle("borderAlpha",0.25);
			commentContainer.setStyle("borderAlpha",0.25);
		}
		
		public function undoFilter():void{
			buttonNegative.setStyle("backgroundAlpha",1);
			buttonPositive.setStyle("backgroundAlpha",1);
			commentContainer.setStyle("backgroundAlpha",1);
			buttonNegative.setStyle("borderAlpha",1);
			buttonPositive.setStyle("borderAlpha",1);
			commentContainer.setStyle("borderAlpha",1);
		}
		
		private function setCommentLength ():void {
			//y = ax+b
			var a:Number = (MAX_COMMENT_LENGTH - MIN_COMMENT_LENGTH)/(PostStatistics.maxPostLength - PostStatistics.minPostLength);
			var b:Number = MIN_COMMENT_LENGTH - a*PostStatistics.minPostLength;
			
			commentLength = a*text.length + b; 
		}
		
		private function findMainContent(content:String):String{
			var NUM_SENTENCE:int = 3;
			var result:String = "";
			var sentences:String = new String(content); 
			
			var curSentence:String;
			
				for (var i:int = 0; i < NUM_SENTENCE; i++) {
					var ind:int = parseSentences(sentences);
					if(ind == -1)
						curSentence = sentences;
					else					
						curSentence = sentences.substring(0, ind + 1);
					//update result
					if(curSentence == null)
						return result;
					else
						result += curSentence;
					//update sentences
					if(ind + 1 < sentences.length)
						sentences = sentences.substring(ind + 1);
					else
						return result;
					
				}
			return result;
		}
		
		private function parseSentences(sentences:String):int{
			var ind:int = -1;
			var curSentence:String = null;
			var endText:int = sentences.indexOf("sticky-enabled");
			if(endText > 0)
				sentences = sentences.substring(0, endText);
			
			if(sentences.length > 0){
				var a:int = sentences.indexOf('.');
				if(a+7 < sentences.length && sentences.substring(a + 1, a + 7) == "patch")
					a = (sentences.substring(a+1).indexOf('.'));
				var b:int = sentences.indexOf('?');
				
				ind = Math.min(a, b);
				
				if(a < 0 && b > 0)
					ind = b;
				else if(a > 0 && b < 0)
					ind = a;
			}
	
			return ind;
		}
		
	}
}