package edu.illinois.IdeaTracker.ui
{
	import edu.illinois.IdeaTracker.IdeaTracker;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.TextField;
	
	import mx.controls.Button;
	import mx.controls.CheckBox;
	import mx.controls.HRule;
	import mx.controls.Image;
	import mx.controls.LinkButton;
	import mx.controls.Text;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.utils.ColorUtil;
	
	import spark.components.Application;
	import spark.components.BorderContainer;
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.VScrollBar;
	

	//Store all idea information
	public class Idea
	{
		//Data
		public var comments:Vector.<Comment> = new Vector.<Comment>();
		public var username:String;	
		public var date:Date;
		public var commentNumber:int;
		public var imagePath:String;
		public var text:String;
		
		public var votes:int = 0;
		
		public var expanded:Boolean = false;
		//Tracking if votes are being displayed or not
		public var votesExpanded:Boolean = false;
		public var filtered:Boolean = false;
		public var hovered:Boolean = false;
		public var lineIsShown:Boolean = false;
		
		public var app: IdeaTracker;
		
		//UI components
		public var ideaImage:Image  = new Image();
		public var ideaImageBorder:BorderContainer = new BorderContainer();
		public var ideaImageLabel:Label = new Label();
		public var postedByLabel:Label = new Label();
		public var ideaContainer:BorderContainer = new BorderContainer();
		//Added votesBorder
		public var votesDisplayBorder:BorderContainer = new BorderContainer();
		public var votesDisplayLabel:TextArea = new TextArea();
		//compare UI components
		public var votesText:Label = new Label();
		
		//main UI components
		public var checkBox:CheckBox = new CheckBox;
		public var compareText:Label = new Label();
		public var filterButton:LinkButton = new LinkButton();
		public var expandButton:LinkButton = new LinkButton();
		public var votesButton:LinkButton = new LinkButton();
		public var rankButton:LinkButton = new LinkButton();
		public var ideaTextLabel:TextArea = new TextArea();
		public var ideaTextLabelBorder:BorderContainer = new BorderContainer();
		public var line:HRule = new HRule();
		
		//Static Variables
		public static var IDEA_WIDTH:int = 237;
		public static var IDEA_HEIGHT:int = 116;
		
		public static var IDEA_IMAGE_WIDTH:int = 150;
		public static var IDEA_IMAGE_HEIGHT:int = 85;
		public static var DISPLAY_HEIGHT:int = 99;
		
		public static var RIGHT_MENU_WIDTH:int = 70;
		public static var RIGHT_MENU_HEIGHT:int = 34;
		
		[Embed("Expand2.png")]
		public var linkButtonDownIcon:Class;
		
		[Embed("Expand3.png")]
		public var linkButtonUpIcon:Class;
		
		[Embed("comment.png")]
		public var commentIcon:Class;
		
		[Embed("big-thumbs-up2.png")]
		public var votesIcon:Class;
		
		[Embed("pics/image0.png")]
		public var tempImg0:Class;
		[Embed("pics/image3.png")]
		public var tempImg3:Class;
		[Embed("pics/image7.png")]
		public var tempImg7:Class;
		[Embed("pics/image11.png")]
		public var tempImg11:Class;
		[Embed("pics/image19.png")]
		public var tempImg19:Class;
		[Embed("pics/image23.png")]
		public var tempImg23:Class;
		[Embed("pics/image33.png")]
		public var tempImg33:Class;
		[Embed("pics/image53.png")]
		public var tempImg53:Class;
		[Embed("pics/image61.png")]
		public var tempImg61:Class;
		[Embed("pics/image63.png")]
		public var tempImg63:Class;
		[Embed("pics/image76.png")]
		public var tempImg76:Class;
			
		public var pic:Bitmap;
		
		public var myLoader:Loader = new Loader(); 
		public function Idea(username:String ,imagePath:String, tDate:Date, commentNumber:int, text:String)
		{
			this.username = username; 
			this.date = tDate;
			this.imagePath = imagePath;
			//if(imagePath != "")
			//	this.imagePath = "pics/image"+commentNumber+".png";
			this.commentNumber = commentNumber;
			this.text = text;
			this.line.setStyle("strokeColor", 0Xa0a2a6);
			
			/*if(this.imagePath != ""){
				var url :URLRequest = new URLRequest(this.imagePath);
				myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				myLoader.load(url);//, context);
							
				function onImageLoaded(e:Event):void {
					ideaImage.source = e.target.content.bitmapData;
					
				}			
			}*/
			
			switch(commentNumber) { 
				case 3: 
					ideaImage.source = tempImg3;
					pic = new tempImg3();
					break; 
				case  7: 
					ideaImage.source = tempImg7;
					pic = new tempImg7();
					break; 
				case 11: 
					ideaImage.source = tempImg11;
					pic = new tempImg11();
					break;
				case  19: 
					ideaImage.source = tempImg19;
					pic = new tempImg19();
					break; 
				case 23: 
					ideaImage.source = tempImg23;
					pic = new tempImg23();
					break;
				case  33: 
					ideaImage.source = tempImg33;
					pic = new tempImg33();
					break; 
				case 53: 
					ideaImage.source = tempImg53;
					pic = new tempImg53();
					break;
				case  61: 
					ideaImage.source = tempImg61;
					pic = new tempImg61();
					break; 
				case 63: 
					ideaImage.source = tempImg63;
					pic = new tempImg63();
					break;
				case  76: 
					ideaImage.source = tempImg76;
					pic = new tempImg76();
					break; 
				
			} 			
			if(imagePath != "")
				applyEffects();
		}
		
		public function setApp(application:IdeaTracker):void{
			this.app = application;
		}
		
		public function drawIdea(x:int, y:int):void {
			ideaContainer.x = x; //(timeBar.x - 520) + timeBar.x;
			ideaContainer.y = y; //400;
			ideaContainer.height = IDEA_HEIGHT;//*2;
			ideaContainer.width = IDEA_WIDTH;
			
			postedByLabel.text = "Proposed By " + username;
			postedByLabel.x = 2;
			postedByLabel.y = 2;
			postedByLabel.width = IDEA_IMAGE_WIDTH;
			postedByLabel.height = DISPLAY_HEIGHT - IDEA_IMAGE_HEIGHT;
			//Image & imageBoarder
			ideaImageBorder.x = 2;
			ideaImageBorder.y = 2;
			ideaImageBorder.width = IDEA_IMAGE_WIDTH + 3;
			ideaImageBorder.height = DISPLAY_HEIGHT + 3;
			if(imagePath != ""){
				ideaImage.x = 1;
				ideaImage.y = 1 + postedByLabel.height;
				ideaImageBorder.addElement(ideaImage);
				ideaImage.toolTip = comments.length + " comments are posted about this idea.";
				ideaImage.addEventListener(MouseEvent.CLICK,drawLine);
				ideaImageBorder.addElement(postedByLabel);
			}else{
				ideaImageLabel.text = "Proposed By " + username + "\n" + text;
				ideaImageLabel.x = 2;
				ideaImageLabel.y = 2;
				ideaImageLabel.width = IDEA_IMAGE_WIDTH;
				ideaImageLabel.height= DISPLAY_HEIGHT;
				ideaImageLabel.toolTip = comments.length + " comments are posted about this idea.";
				ideaImageLabel.addEventListener(MouseEvent.CLICK,drawLine);
				ideaImageBorder.addElement(ideaImageLabel);
			}
			ideaImageBorder.toolTip = comments.length + " comments are posted about this idea.";
			ideaImageBorder.setStyle("borderColor",0Xa0a2a6);
			ideaContainer.addElement(ideaImageBorder);
			
			ideaContainer.setStyle("borderColor",0Xa0a2a6);
			ideaContainer.setStyle("borderWeight", 5);
			ideaContainer.setStyle("borderVisible",false);
		}
	
		public function drawCompareIdea(x:int, y:int):void {
			drawIdea(x,y+20);
			
			//Check box and compare label
			votesText.x = 5;
			votesText.text = "Votes: " + votes;
			votesText.y = IDEA_HEIGHT + 2;
			ideaContainer.addElement(votesText);	
		}
		
		public function drawMainIdea(x:int, y:int):void {
			drawIdea(x,y);
			
			//text label setup
			//ideaTextLabel.htmlText = "<p>Posted By </p>" + username + " <br><br/> " + text;
			ideaTextLabel.text = "#" + commentNumber+ " Posted By " + username + " \n\n "+ text;
			ideaTextLabel.x = 2;
			ideaTextLabel.y = 2;
			ideaTextLabel.width = IDEA_IMAGE_WIDTH - 6 + RIGHT_MENU_WIDTH+3;
			ideaTextLabel.height = DISPLAY_HEIGHT - 6;
			ideaTextLabelBorder.addElement(ideaTextLabel);
			ideaTextLabelBorder.x = ideaImageBorder.x;
			ideaTextLabelBorder.y = DISPLAY_HEIGHT+7;
			ideaTextLabelBorder.width = IDEA_IMAGE_WIDTH + RIGHT_MENU_WIDTH+3;
			ideaTextLabelBorder.height = DISPLAY_HEIGHT;
			ideaTextLabelBorder.setStyle("borderColor",0Xa0a2a6);

			//Check box and compare label
			checkBox.x = 5;
			checkBox.y = IDEA_HEIGHT - 2;
			checkBox.setStyle("borderColor",0xFFFFFF);
			ideaContainer.addElement(checkBox);
			compareText.text = "Compare";
			compareText.x = 25;
			compareText.y = IDEA_HEIGHT + 2;
			ideaContainer.addElement(compareText);
			//compareText.addEventListener(MouseEvent.CLICK, app.compareUI_showHandler);
			compareText.addEventListener(MouseEvent.MOUSE_OVER, compareHover);
			compareText.addEventListener(MouseEvent.MOUSE_OUT, compareAfterHover);
			
			function compareHover(event: MouseEvent):void{
					compareText.setStyle("textDecoration", "underline");
			}
			function compareAfterHover(event: MouseEvent):void{
					compareText.setStyle("textDecoration", "none");
			}
			
			var votesBorder:BorderContainer = new BorderContainer();
			votesBorder.x = ideaImageBorder.x + IDEA_IMAGE_WIDTH +3;
			votesBorder.y = ideaImageBorder.y ;// + .3;
			votesBorder.width = RIGHT_MENU_WIDTH;
			votesBorder.height = RIGHT_MENU_HEIGHT;
			votesBorder.setStyle("borderColor",0Xa0a2a6);
			votesButton.label = "" + votes;
			votesButton.setStyle("icon",votesIcon);
			votesButton.setStyle("textColor",0Xa0a2a6);
			votesButton.labelPlacement = "left";
			votesButton.x = 0;
			votesButton.y = 0;
			votesButton.width = RIGHT_MENU_WIDTH;
			votesButton.height = RIGHT_MENU_HEIGHT;
			votesButton.setStyle("rollOverColor",0xFFFFFF);
			votesButton.setStyle("selectionColor",0xFFFFFF);
			votesButton.toolTip = "Likes";
			/*if(votes == 1)
			{
				votesButton.label = votes + " Like";
			}
			else
			{
				votesButton.label = votes + " Likes";
			}*/
			votesBorder.addElement(votesButton);
			//Add event listener to votesbutton
			votesButton.addEventListener(MouseEvent.CLICK, votesOnClick);
			votesButton.setStyle("rollOverColor",0xE7E8EA);
			votesButton.setStyle("selectionColor",0Xa0a2a6);
			ideaContainer.addElement(votesBorder);	
			votesDisplayBorder.x = ideaImageBorder.x + IDEA_IMAGE_WIDTH +3 + RIGHT_MENU_WIDTH + 3;
			votesDisplayBorder.y = ideaImageBorder.y ;// + .3;
			votesDisplayBorder.width = IDEA_IMAGE_WIDTH;
			votesDisplayBorder.height = DISPLAY_HEIGHT + 3;
			votesDisplayBorder.setStyle("borderColor",0Xa0a2a6);

			votesDisplayLabel.x = 2;
			votesDisplayLabel.y = 2;
			votesDisplayLabel.width = IDEA_IMAGE_WIDTH - 4;
			votesDisplayLabel.height = DISPLAY_HEIGHT - 4;
			displayUserNames();
			votesDisplayBorder.addElement(votesDisplayLabel);
			
			var filterBorder:BorderContainer = new BorderContainer();
			filterBorder.x = ideaImageBorder.x + IDEA_IMAGE_WIDTH +3;
			filterBorder.y = ideaImageBorder.y + RIGHT_MENU_HEIGHT;
			filterBorder.width = RIGHT_MENU_WIDTH;
			filterBorder.height = RIGHT_MENU_HEIGHT;
			filterBorder.setStyle("borderColor",0Xa0a2a6);
			//filterButton.setStyle("icon", commentIcon);//label = "Comment";
			filterButton.label = "Filter";
			filterButton.x = 0;
			filterButton.y = 0;
			filterButton.width = RIGHT_MENU_WIDTH;
			filterButton.height = RIGHT_MENU_HEIGHT;
			filterButton.setStyle("rollOverColor",0xE7E8EA);
			filterButton.setStyle("selectionColor",0Xa0a2a6);
			filterButton.toolTip = "Comments";
			filterBorder.addElement(filterButton);
			ideaContainer.addElement(filterBorder);
			filterButton.addEventListener(MouseEvent.CLICK,filter);
			var expandBorder:BorderContainer = new BorderContainer();
			expandBorder.x = ideaImageBorder.x + IDEA_IMAGE_WIDTH +3;
			expandBorder.y = ideaImageBorder.y + 2*RIGHT_MENU_HEIGHT;// + .25;
			expandBorder.width = RIGHT_MENU_WIDTH;
			expandBorder.height = RIGHT_MENU_HEIGHT;
			expandBorder.setStyle("borderColor",0Xa0a2a6);
			expandButton.setStyle("icon", linkButtonDownIcon);
			expandButton.x = 0;
			expandButton.y = 0;
			expandButton.width = RIGHT_MENU_WIDTH;
			expandButton.height = RIGHT_MENU_HEIGHT;
			expandButton.setStyle("rollOverColor",0xE7E8EA);
			expandButton.setStyle("selectionColor",0Xa0a2a6);
			expandButton.toolTip = "Read More...";
			expandBorder.addElement(expandButton);
			ideaContainer.addElement(expandBorder);
			
			expandButton.addEventListener(MouseEvent.CLICK,expand);
			
			[Embed("pics/rank-ribbon-12-trans-small.png")]
			var rankRibbon1Icon:Class;
			rankButton.x = ideaImageBorder.x + IDEA_IMAGE_WIDTH + RIGHT_MENU_WIDTH - 7;
			rankButton.y = ideaImageBorder.y + 8*RIGHT_MENU_HEIGHT/3;
			rankButton.width = 20;
			rankButton.height = 40;
			rankButton.setStyle("icon",rankRibbon1Icon);
			rankButton.mouseEnabled = false;
		}
	
		public function votesOnClick(event:MouseEvent):void
		{
			votesExpanded = !votesExpanded;
			if(votesExpanded)
			{
				if(comments.length > 0)
				ideaContainer.addElement(votesDisplayBorder);
			}
			else
			{
				if(comments.length > 0)
				ideaContainer.removeElement(votesDisplayBorder);
			}
		}
		
		private function displayUserNames():void
		{
			var temp:String;
			votesDisplayLabel.text = "";
			for(var i:int = 0; i < comments.length; i++)
			{
				votesDisplayLabel.text = votesDisplayLabel.text.concat(comments[i].username + " said: \"" + comments[i].argument + "\""+ "\n");
			}
		}
		
		private function expand(e:Event):void{
			expanded = !expanded;
			if(expanded){			
				ideaContainer.addElement(ideaTextLabelBorder);
				expandButton.setStyle("icon", linkButtonUpIcon);
			}else{
				ideaContainer.removeElement(ideaTextLabelBorder);
				expandButton.setStyle("icon", linkButtonDownIcon);
			}
		}
		
		private function filter(e:Event):void{
			filtered = !filtered;
			if(filtered){
				((MainUI)(ideaContainer.parent)).filter(this);
				filterButton.label = "Undo";
				ideaContainer.setStyle("borderVisible",true);
			}else{
				((MainUI)(ideaContainer.parent)).undoFilter(this);
				filterButton.label = "Filter";
				ideaContainer.setStyle("borderVisible",false);
			}
		}
	
		private function drawLine(e:Event):void{
			lineIsShown = !lineIsShown;
			if(lineIsShown){			
				((MainUI)(ideaContainer.parent)).drawLine(this)
			}else{
				((MainUI)(ideaContainer.parent)).undoDrawLine(this);
			}
		}
		public static function getUIComponentBitmapData( target:UIComponent ):BitmapData {
			var bd:BitmapData = new BitmapData( target.width, target.height, true, 0 );
			var m:Matrix = new Matrix();
			
			bd.draw( target, m, null, null, null, true );
			return bd;
		}
		
		private function applyEffects():void {
			var w:int = IDEA_IMAGE_WIDTH;
			//var ratio:Number = w / ideaImage.source.width;
			var h:int = IDEA_IMAGE_HEIGHT;//ideaImage.source.height * ratio;
			
			//var blurXValue:Number = Math.max(1, ideaImage.source.width / w) * 1.25;
			//var blurYValue:Number = Math.max(1, ideaImage.source.height / h) * 1.25;
				
			//var blurFilter:BlurFilter = new BlurFilter(blurXValue, blurYValue, int(BitmapFilterQuality.LOW));
			ideaImage.filters = [];//[blurFilter];
			
			var bd:BitmapData = pic.bitmapData;//BitmapData(ideaImage.source);//getUIComponentBitmapData(UIComponent(ideaImage.source));
			
			
			var rbd:BitmapData = resizeImageBD(bd, w, h);
			ideaImage.source = new Bitmap(rbd, PixelSnapping.AUTO, true);
		}
		
		
		public static function resizeImageBD( bitmapData:BitmapData, width:Number, height:Number ):BitmapData {
			var newBitmapData:BitmapData	= new BitmapData( width, height, true, 0x000000 );
			var matrix:Matrix				= new Matrix();
			matrix.identity();
			matrix.createBox( width / bitmapData.width, height / bitmapData.height );
			newBitmapData.draw( bitmapData, matrix, null, null, null, true );
			return newBitmapData;
		}
		
		public function clone():Idea{
			var newIdea:Idea = new Idea(this.username, this.imagePath, this.date, this.commentNumber, this.text);
			
			for(var i:int = 0; i < comments.length; i++){
				var newComment:Comment = new Comment(comments[i].text, comments[i].date,comments[i].username, comments[i].commentNumber, comments[i].isIdea, comments[i].url);
				newComment.negativeTune = comments[i].negativeTune;
				newComment.positiveTune = comments[i].positiveTune;
				newComment.idea = newIdea;
				newIdea.comments.push(newComment);
			}			
			return newIdea;
		}
		
		public static function compareIdea(a:Idea, b:Idea):int{
			
			if(a.date < b.date)
				return -1;
			else if (a.date == b.date)
				return 0;
			else
				return 1;
			//A negative return value specifies that A appears before B in the sorted sequence. 
			//A return value of 0 specifies that A and B have the same sort order. 
			//A positive return value specifies that A appears after B in the sorted sequence
		}
	}
}