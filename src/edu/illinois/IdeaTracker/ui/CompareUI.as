package edu.illinois.IdeaTracker.ui
{
	import edu.illinois.IdeaTracker.data.DataReader;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import mx.controls.HRule;
	import mx.controls.Image;
	import mx.controls.VRule;
	import mx.controls.scrollClasses.ScrollBar;
	import mx.core.Container;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.formatters.DateFormatter;
	
	import spark.components.BorderContainer;
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.Group;
	import spark.components.Label;
	
	//Main user interface that is shown in the time bar tab
	public class CompareUI extends Group
	{
		//List of ideas
		public var ideas:Vector.<Idea> = new Vector.<Idea>();
		public var timeBars:Vector.<VRule> = new Vector.<VRule>(); 
		
		public var mainUI:MainUI;
		
		public static var TIME_BAR_Y:int = 10+Idea.IDEA_HEIGHT + 20;
		public function CompareUI()
		{
			super();
		}		

		public function show(ideasToCompare:Vector.<Idea>, mainUI:MainUI):void{
			this.mainUI = mainUI;
			clear();
			ideas = ideasToCompare;
			createCommentsAndIdeas();
		}
		
		private function clear():void{
			this.removeAllElements();
		}
		
		public function createTimeBar(x:int, y:int):void{
			var timeBar:VRule = new VRule();
			//Create the time bar
			timeBar.x = x;
			timeBar.y = y;
			timeBar.height = mainUI.dateRange.length*MainUI.DATE_WIDTH;
			timeBar.width = 3;
			timeBar.setStyle("strokeColor", 0Xa0a2a6);
			
			this.addElement(timeBar);
			timeBars.push(timeBar);
		}
		
		public function createDates(x:int, y:int):void{
			var curLabel:Label;
			var curLine:HRule;
			for (var i:int = 0; i < mainUI.dateRange.length; i++){
				curLabel = new Label();
				//TODO: color and format of the date
				var df:DateFormatter = new DateFormatter();
				df.formatString = "MMM YYYY";
				curLabel.text = df.format(mainUI.dateRange[i].toString());
				curLabel.x = x + 25;
				curLabel.y = y + i*MainUI.DATE_WIDTH - 3;
				curLabel.width = 100;
				curLabel.height = 20;
				curLabel.setStyle("color", 0X95979b);
				this.addElement(curLabel);

				curLine = new HRule();
				curLine.x = x;
				curLine.y = y + i*MainUI.DATE_WIDTH;
				curLine.width = 20;
				curLine.height = 2;
				curLine.setStyle("strokeColor", 0Xa0a2a6);
				this.addElement(curLine);
			}
			
		}
		
		
		public function createCommentsAndIdeas():void
		{
			var x:int = 0, y:int = 10;
			var r:int = 2, m:int = 1;
			var prevCommentY:int = TIME_BAR_Y;
			for (var i:int=0 ; i < ideas.length; i++){
				x = findIdeaXPosition(m/r);
				//update ratio
				if(i%2 == 0){
					r = r*2;
					m = 3;
				}else{
					m = 1;
				}
				//draw idea
				ideas[i].drawCompareIdea(x - Idea.IDEA_IMAGE_WIDTH/2, y);
				this.addElement(ideas[i].ideaContainer);
				createTimeBar(x,TIME_BAR_Y);
				createDates(x,TIME_BAR_Y);
				//draw comments
				var allComments:Vector.<Comment> = mainUI.cloneComments();
				for(var j:int=0 ; j < allComments.length; j++){
					var curCommentY:int = findCommentYPosition(allComments[j].date, prevCommentY, x, TIME_BAR_Y);
					allComments[j].drawComment(x, curCommentY);
					this.addElement(allComments[j].commentContainer);
					prevCommentY = curCommentY;
					if(!mainUI.isRelated(allComments[j].commentNumber, ideas[i])){
						allComments[j].filter();
					}
				}
				/*for(var j:int=0 ; j < ideas[i].comments.length; j++){
					var curCommentY:int = findCommentYPosition(ideas[i].comments[j].date, prevCommentY, x, TIME_BAR_Y);
					ideas[i].comments[j].drawComment(x, curCommentY);
					this.addElement(ideas[i].comments[j].commentContainer);
					prevCommentY = y;
				}*/
				
				prevCommentY = TIME_BAR_Y;
			}
			
		}
		
		private function findIdeaXPosition(ratio:Number):int{
			var x:int = Capabilities.screenResolutionX*ratio - Idea.IDEA_WIDTH/2;
			return x;
		}
		
		private function findCommentYPosition(currentDate:Date, prevCommentY:int, timeBarX:int, timeBarY:int):int{
			var y:int = 0;
			
			var datePoint:Point = findDatePosition(currentDate, timeBarX, timeBarY);
			
			if(prevCommentY < datePoint.y){
				y = datePoint.y + 5;	
			}else{
				y = prevCommentY + Comment.COMMENT_HEIGHT + 5;
			}
			
			return y;
			
		}
		
		private function findDatePosition(currentDate:Date, timeBarx:int, timeBary:int):Point{
			var point:Point = new Point(0,0);
			for(var i:int = 0; i < mainUI.dateRange.length; i++){
				if(mainUI.dateRange[i].fullYear == currentDate.fullYear && mainUI.dateRange[i].month == currentDate.month){
					return new Point(timeBarx, timeBary + i*MainUI.DATE_WIDTH);
				}
			}
			return point;
		}
		
		
	}
}