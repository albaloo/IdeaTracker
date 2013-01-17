package edu.illinois.IdeaTracker.ui
{
	import edu.illinois.IdeaTracker.IdeaTracker;
	import edu.illinois.IdeaTracker.data.DataReader;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.controls.HRule;
	import mx.controls.Image;
	import mx.controls.Label;
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
	
	
	//Main user interface that is shown in the time bar tab
	public class MainUI extends Group
	{
		//List of ideas
		public var ideas:Vector.<Idea> = new Vector.<Idea>();
		//List of Comments
		public var comments:Vector.<Comment> = new Vector.<Comment>();
		public var timeBar:VRule = new VRule(); 
		public var dateRange:Vector.<Date>;
		public var dates:Vector.<Label> = new Vector.<Label>();
		public var lastYinPosition1:int = -2*Idea.IDEA_HEIGHT;
		public var lastYinPosition2:int = -2*Idea.IDEA_HEIGHT;
		public var lastYinPosition3:int = -2*Idea.IDEA_HEIGHT;
		public var overview:BorderContainer = new BorderContainer;
		public var overviewLabel: Label = new Label();
		public var criteriaList:BorderContainer = new BorderContainer;
		public var criteriaLabel:Label = new Label();
		
		public static var DATE_WIDTH:int = 200;
		
		public function MainUI()
		{
			super();
			var dataReader:DataReader = new DataReader();
			dataReader.initializeCommentsAndIdeas(comments, ideas);
			createTimeBar();
			createDates();
			createCommentsAndIdeas();
			
			var issueLabel: Label = new Label();
			issueLabel.htmlText = "<font size='+4'><b> <a href= \"http://drupal.org/node/331893\">Add colouring (and description) to password checker</a></b></font>" ;				
			
			issueLabel.x = 30;
			issueLabel.y = 40;
			issueLabel.width = 2* Capabilities.screenResolutionX/3;
			issueLabel.height = 30;
			//issueLabel. = TextFieldAutoSize.CENTER;
			this.addElement(issueLabel);
			
			var issueLabel2: Label = new Label();
			issueLabel2.htmlText = "Posted by <a href=\"http://drupal.org/user/24967\">webchick</a> on <i>November 8, 2008 at 8:06pm</i>" ;				
			
			issueLabel2.x = 30;
			issueLabel2.y = 70;
			issueLabel2.width = 2* Capabilities.screenResolutionX/3;
			issueLabel2.height = 20;
			this.addElement(issueLabel2);
			
			/*
			overviewLabel.setStyle("color", 0xBFC1C6);
			overviewLabel.x = 30;
			overviewLabel.y = 90;
			overviewLabel.text = "Overview";
			overviewLabel.width = 80;
			overviewLabel.height = 20;
			this.addElement(overviewLabel);
			
			overview.setStyle("borderColor",0xBFC1C6);
			overview.x = 30;
			overview.y = 110;
			overview.width = 160;
			overview.height = 300;
			this.addElement(overview);
			
			criteriaLabel.setStyle("color", 0xBFC1C6);
			criteriaLabel.x = 30;
			criteriaLabel.y = 110 + overview.height + 10;
			criteriaLabel.text = "Criteria";
			criteriaLabel.width = 50;
			criteriaLabel.height = 20;
			this.addElement(criteriaLabel);
			
			criteriaList.setStyle("borderColor",0xBFC1C6);
			criteriaList.x = 30;
			criteriaList.y = 110 + overview.height + criteriaLabel.height + 10;
			criteriaList.width = 160;
			criteriaList.height = 300;
			this.addElement(criteriaList);
			*/
		}		

		public function createTimeBar():void{
			//Draw Dates
			dateRange = findDateRange();
			
			//Create the time bar
			var commentsLabel: Label = new Label();
			commentsLabel.text = "Comments";
			commentsLabel.width = 70;
			commentsLabel.height = 20;
			commentsLabel.x = Capabilities.screenResolutionX/2 - 35;
			commentsLabel.y = 80;
			commentsLabel.setStyle("color", 0X95979b);
			timeBar.x = Capabilities.screenResolutionX/2;
			timeBar.y = 100;
			timeBar.height = dateRange.length*DATE_WIDTH;
			timeBar.width = 3;
			timeBar.setStyle("strokeColor", 0Xa0a2a6);
			this.addElement(commentsLabel);
			this.addElement(timeBar);
			
		}
		
		public function createDates():void{
			var curLabel:Label;
			var curLine:HRule;
			for (var i:int = 0; i < dateRange.length; i++){
				curLabel = new Label();
				//TODO: color and format of the date
				var df:DateFormatter = new DateFormatter();
				df.formatString = "MMM YYYY";
				curLabel.text = df.format(dateRange[i].toString());
				curLabel.x = timeBar.x + 25;
				curLabel.y = timeBar.y + i*DATE_WIDTH - 3;
				curLabel.width = 100;
				curLabel.height = 20;
				curLabel.setStyle("color", 0X95979b);
				this.addElement(curLabel);
				curLine = new HRule();
				curLine.x = timeBar.x;
				curLine.y = timeBar.y + i*DATE_WIDTH;
				curLine.width = 20;
				curLine.height = 2;
				curLine.setStyle("strokeColor", 0Xa0a2a6);
				this.addElement(curLine);
				dates.push(curLabel);
			}
			
		}
		
		private function findDateRange():Vector.<Date>{
			var range:Vector.<Date> = new Vector.<Date>();
			var firstDate:Date = comments[0].date;
			var lastDate:Date = comments[comments.length-1].date;
			
			var firstYear:int = firstDate.fullYear;
			var lastYear:int = lastDate.fullYear;
			
			var firstMonth:int = firstDate.month; // 0 for Jan
			var lastMonth:int = lastDate.month; // 0 for Jan
			
			while (firstYear != lastYear || firstMonth != lastMonth){
				range.push(new Date(firstYear, firstMonth, 1));
				
				firstMonth++;
				if(firstMonth > 11){
					firstYear++;
					firstMonth = 0;
				}
			}
			
			range.push(new Date(firstYear, firstMonth, 1));
			
			return range;
		}
		
		public function createCommentsAndIdeas():void
		{
			var ideaCounter:int = 1;
			var currentIdea:Idea;
			var currentComment:Comment;
			var ideaPosition:Point = new Point(0,0);
			var prevIdea:Idea = ideas[0];
			var prevIdeaPosition:Point = new Point(0, 0);
			var prevCommentY:int = timeBar.y;
			ideas.sort(Idea.compareIdea);
			for (var i:int=0 ; i < comments.length; i++){
				if(comments[i].isIdea && comments[i].commentNumber != 3){
					currentIdea = ideas[ideaCounter];
					ideaPosition.y = findCommentYPosition(currentIdea.date, prevCommentY);
					ideaPosition.x = findIdeaXPosition(ideaPosition.y, prevIdeaPosition);
					currentIdea.drawMainIdea(ideaPosition.x, ideaPosition.y);
					this.addElementAt(currentIdea.ideaContainer, 3);
					/*var curLine:HRule = new HRule();
					if(timeBar.x < ideaPosition.x){
						curLine.width = ideaPosition.x - timeBar.x+currentIdea.ideaImageBorder.x;
						curLine.x = timeBar.x;
					}
					else{
						curLine.width = timeBar.x - ideaPosition.x - Idea.IDEA_WIDTH + 10;
						curLine.x = ideaPosition.x + Idea.IDEA_IMAGE_WIDTH + Idea.RIGHT_MENU_WIDTH + 5;
					}
					curLine.height = 2;
					curLine.y = ideaPosition.y + Idea.IDEA_HEIGHT/2;
					this.addElement(curLine);*/
					ideaCounter ++;
					prevIdeaPosition = ideaPosition;
					prevCommentY = ideaPosition.y;
				}else{
					currentComment = comments[i];
					var y:int = findCommentYPosition(currentComment.date, prevCommentY);
					currentComment.drawComment(timeBar.x, y);
					this.addElementAt(currentComment.commentContainer, 2);
					prevCommentY = y;
				}
			}
			
		}
	
		private function findIdeaXPosition(ideaPositionY:int, prevIdeaPosition:Point):int{
			var x:int = 0;
			var position:int = 3;
			var halfMaxCommentLength:int = Math.max(Comment.MAX_COMMENT_LENGTH/2 + 10, 80);
			
			if(prevIdeaPosition.x == 0){
				x = timeBar.x - halfMaxCommentLength - Idea.IDEA_WIDTH;
				position = 1;
			}else if(prevIdeaPosition.x == timeBar.x - halfMaxCommentLength - Idea.IDEA_WIDTH && ideaPositionY > lastYinPosition2 + 2 * Idea.IDEA_HEIGHT){
				x = timeBar.x + halfMaxCommentLength;
				position = 2;
			}else if(prevIdeaPosition.x == timeBar.x + halfMaxCommentLength && ideaPositionY > lastYinPosition1 + 2 * Idea.IDEA_HEIGHT){
				x = timeBar.x - halfMaxCommentLength - Idea.IDEA_WIDTH;
				position = 1;
			} 
			
			if(position == 3){
				if(ideaPositionY - (lastYinPosition1 + Idea.IDEA_HEIGHT) >= ideaPositionY - (lastYinPosition2 + Idea.IDEA_HEIGHT) && ideaPositionY - (lastYinPosition1 + Idea.IDEA_HEIGHT) >= ideaPositionY - (lastYinPosition3 + Idea.IDEA_HEIGHT)){
					x = timeBar.x - halfMaxCommentLength - Idea.IDEA_WIDTH;
					position = 1;
				}else if(ideaPositionY - (lastYinPosition2 + Idea.IDEA_HEIGHT) >= ideaPositionY - (lastYinPosition1 + Idea.IDEA_HEIGHT) && ideaPositionY - (lastYinPosition2 + Idea.IDEA_HEIGHT) >= ideaPositionY - (lastYinPosition3 + Idea.IDEA_HEIGHT)){
					x = timeBar.x + halfMaxCommentLength;
					position = 2;
				}else{
					x = timeBar.x - halfMaxCommentLength - 2*Idea.IDEA_WIDTH - 5;
				}
			}
			
			if(position == 1)
				lastYinPosition1 = ideaPositionY;
			else if(position == 2)
				lastYinPosition2 = ideaPositionY;
			else
				lastYinPosition3 = ideaPositionY;
				
			return x;
		}
		
		private function findCommentYPosition(currentDate:Date, prevCommentY:int):int{
			var y:int = 0;
			
			var datePoint:Point = findDatePosition(currentDate);
			
			if(prevCommentY < datePoint.y){
				y = datePoint.y + 5;	
			}else{
				y = prevCommentY + Comment.COMMENT_HEIGHT + 5;
			}
			
			return y;
		}
		
		private function findDatePosition(currentDate:Date):Point{
			var point:Point = new Point(0,0);
			for(var i:int = 0; i < dateRange.length; i++){
				if(dateRange[i].fullYear == currentDate.fullYear && dateRange[i].month == currentDate.month){
					return new Point(timeBar.x, timeBar.y + i*DATE_WIDTH);
				}
			}
			return point;
		}
		
		public function filter(idea:Idea):void{
			for (var i:int = 0; i < comments.length; i++){
				if(!isRelated(comments[i].commentNumber, idea)){
					comments[i].filter();
				}
			}	
		}
		
		public function isRelated(num:int, idea:Idea): Boolean{
			for (var i:int = 0; i < idea.comments.length; i++){
				if(idea.comments[i].commentNumber==num)
					return true;
			}
			
			return false;
		}
		
		public function undoFilter(idea:Idea):void{
			for (var i:int = 0; i < comments.length; i++){
				if(!isRelated(comments[i].commentNumber, idea)){
					comments[i].undoFilter();
				}
			}
		}
		
		public function drawLine(idea:Idea):void{
			if(timeBar.x < idea.ideaContainer.x){
				idea.line.width = idea.ideaContainer.x - timeBar.x + idea.ideaImageBorder.x;
				idea.line.x = timeBar.x;
			}
			else{
				idea.line.width = timeBar.x - idea.ideaContainer.x - Idea.IDEA_WIDTH + 10;
				idea.line.x = idea.ideaContainer.x + Idea.IDEA_IMAGE_WIDTH + Idea.RIGHT_MENU_WIDTH + 5;
			}
			idea.line.height = 2;
			idea.line.y = idea.ideaContainer.y + Idea.IDEA_HEIGHT/2;
			this.addElement(idea.line);
		}
		
		public function undoDrawLine(idea:Idea):void{
			this.removeElement(idea.line);
		}
		
		public function cloneComments(): Vector.<Comment>{
			var retComments:Vector.<Comment> = new Vector.<Comment>();
			for(var i:int = 0; i < comments.length; i++){
				var newComment:Comment = new Comment(comments[i].text, comments[i].date,comments[i].username, comments[i].commentNumber, comments[i].isIdea, comments[i].url);
				newComment.negativeTune = comments[i].negativeTune;
				newComment.positiveTune = comments[i].positiveTune;
				newComment.idea = comments[i].idea;
				retComments.push(newComment);
			}
			
			return retComments;
		}
	}
}