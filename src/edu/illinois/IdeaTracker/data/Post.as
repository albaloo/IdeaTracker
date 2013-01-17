package edu.illinois.IdeaTracker.data
{
	public class Post
	{
		public var commentNumber:int;
		public var dateTime:Date; 
		public var username:String;
		public var content:String; 
		public var isIdea:Boolean; 
		public var imagePath:String;
		public var url:String;
		
		public function Post(commentNumber:int, date:Date, username:String, content:String, isIdea:Boolean, imagePath:String, url:String)
		{
			this.commentNumber = commentNumber;
			this.content = correctContent(content);
			this.dateTime = date;
			this.username = username;
			this.isIdea = isIdea;
			this.imagePath = imagePath;
			this.url = url;
		}
		
		private function correctContent(text:String):String{
			var retText:String;
			if(text.lastIndexOf("Login or register to post comments") > 0)
				retText = text.substring(0, text.lastIndexOf("Login or register to post comments"));
			else
				retText = text;
			return retText;
		}
	}
}