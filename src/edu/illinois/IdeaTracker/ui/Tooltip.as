package edu.illinois.IdeaTracker.ui
{
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.controls.ToolTip;
	
	import spark.components.BorderContainer;

	public class Tooltip extends ToolTip  
	{
		//var tween:Tween; //A tween object to animate the tooltip at start  
		
		//var tooltip:Sprite = new Sprite(); //The Sprite containing the tooltip graphics  
		//var bmpFilter:BitmapFilter; //This will handle the drop shadow filter  
		
		//public static var TOOLTIP_WIDTH:int = 200;
		//public static var TOOLTIP_HEIGHT:int = 150;
		
		//var textfield:TextField = new TextField(); //The textfield inside the tooltip  
		//var textformat:TextFormat = new TextFormat(); //The format for the textfield  
		//var font:Harmo = new Harmony(); 
		
		/*public function Tooltip(content:String){
			textfield.x = 2;
			textfield.y = 2;
			textfield.width = TOOLTIP_WIDTH - 2 * textfield.x;
			textfield.height = TOOLTIP_HEIGHT - 2 * textfield.y;
			textfield.htmlText = content;
			
			//this.width = TOOLTIP_WIDTH;
			//this.height = TOOLTIP_HEIGHT;
			text = content;
		}*/
		public function Tooltip(){    
			super(); 
		}
		
		override protected function commitProperties():void{
			super.commitProperties();
			textField.htmlText = text;
		}
		
		/*public function Tooltip(w:int, h:int, cornerRadius:int, txt:String, color:uint, txtColor:uint, alfa:Number, useArrow:Boolean, dir:String, dist:int):void  
		{ 
			textfield.selectable = false; //You cannot select the text in the tooltip  
			
			textformat.align = TextFormatAlign.CENTER; //Center alignment  
			textformat.font = font.fontName; //Use the embedded font  
			textformat.size = 8; //Size of the font  
			
			textformat.color = txtColor; //Color of the text, taken from the parameters  
			
			textfield = new TextField(); //A new TextField object  
			textfield.embedFonts = true; //Specify the embedding of fonts  
			textfield.width = w;  
			textfield.height = h;  
			textfield.defaultTextFormat = textformat; //Apply the format  
			textfield.text = txt; //The
			
			tooltip = new Sprite();  
			
			tooltip.graphics.beginFill(color, alfa);  
			tooltip.graphics.drawRoundRect(0, 0, w, h, cornerRadius, cornerRadius);
			
			if (useArrow && dir == "up")  
			{  
				tooltip.graphics.moveTo(tooltip.width / 2 - 6, tooltip.height);  
				tooltip.graphics.lineTo(tooltip.width / 2, tooltip.height + 4.5);  
				tooltip.graphics.lineTo(tooltip.width / 2 + 6, tooltip.height - 4.5);  
			}  
			
			if (useArrow && dir == "down")  
			{  
				tooltip.graphics.moveTo(tooltip.width / 2 - 6, 0);  
				tooltip.graphics.lineTo(tooltip.width / 2, -4.5);  
				tooltip.graphics.lineTo(tooltip.width / 2 + 6, 0);  
			}  
			
			tooltip.graphics.endFill(); // T
			bmpFilter = new DropShadowFilter(1,90,color,1,2,2,1,15);  
			
			tooltip.filters = [bmpFilter];  
			tooltip.addChild(textfield); //Adds the TextField to the Tooltip Sprite  
			
			addChild(tooltip);
		}*/
	}
}