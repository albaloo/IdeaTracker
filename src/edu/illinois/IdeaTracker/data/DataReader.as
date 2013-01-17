package edu.illinois.IdeaTracker.data
{
	import edu.illinois.IdeaTracker.ui.Comment;
	import edu.illinois.IdeaTracker.ui.Idea;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.DateField;

	public class DataReader
	{
		public var commentsXML:XML;
		public var inputComments:Vector.<Post> = new Vector.<Post>();
		public function DataReader()
		{
			
		}
		
		/*private function loadXMLfile():void{
			//Read from XML file	
			var loader:URLLoader = new URLLoader(); 
			loader.addEventListener(Event.COMPLETE, loadXML);
			loader.load(new URLRequest('out.xml'));	
			
			function loadXML (e:Event):void{
				var com:XML = new XML(e.target.data);
				commentsXML = com;
				
			}
			
		}*/
	
	
		private function readPosts():void{//Vector.<Post>{
			//loadXMLfile();
			//Parse XML file and create Comments
			//var posts:Vector.<Post> = new Vector.<Post>();
			//var commentList:XMLList = commentsXML.comment;
				
			commentsXML = LoadXML.load();
			var currentPost:Post;
			
			for each (var item in commentsXML.comment) {
				var img:String = "";
				var isIdea:Boolean = false;
				if(item.images[0] != null){
					img = item.images[0].image;
					isIdea = true;
				}
				var currentDate:Date = DateField.stringToDate(item.date.toString(),"MM/DD/YYYY"); //new Date(item.date.toString());//"EEE MMM DD HH:NN:SS zzz YYYY";
				currentPost = new Post(item.commentNumber.toString(), currentDate, item.author.toString(), new String(item.content.toString()), isIdea, img, item.title.toString());
				inputComments.push(currentPost);
					
			}
			
			//return posts;
		}
		
		
		public function initializeCommentsAndIdeas(comments: Vector.<Comment>, ideas: Vector.<Idea>):void{
			//inputComments = readPosts();
			readPosts();
			var currentComment:Comment;
			var currentIdea:Idea;
			
			//set Statistics
			var maxLength: int = 0;
			
				
			var minLength:int = inputComments[0].content.length;
			
			for (var i:int = 0; i < inputComments.length; i++){
				if(maxLength < inputComments[i].content.length)
					maxLength = inputComments[i].content.length;
				if(minLength > inputComments[i].content.length)
					minLength = inputComments[i].content.length;
			}
			
			PostStatistics.setMaxLength(maxLength);
			PostStatistics.setMinLength(minLength);
			
			for (i = 0; i < inputComments.length; i++){
				currentComment = new Comment(inputComments[i].content, inputComments[i].dateTime, inputComments[i].username, inputComments[i].commentNumber, inputComments[i].isIdea, inputComments[i].url);
				processComments(currentComment, comments, ideas);
				comments.push(currentComment);
				
				if(inputComments[i].isIdea){
					currentIdea = new Idea(inputComments[i].username, inputComments[i].imagePath, inputComments[i].dateTime, inputComments[i].commentNumber, inputComments[i].content);
					ideas.push(currentIdea);
				}				
			}
		}

		private function processComments(comment:Comment, comments: Vector.<Comment>, ideas: Vector.<Idea>):void{
		
			//Process Content
			var index:int = comment.text.indexOf('#');
			var referredComment:int = findReferredComment(comment.text, index);
			var content:String = comment.text;
			
			while(referredComment!= 0){	
				var referredSentence:String = findReferredSentence(content, index);
				
				if(ideaIsLiked(referredSentence)){
					var ideaFound:Boolean = false;
					for (var i:int = 0; i < ideas.length; i++) {
						if(ideas[i].commentNumber == referredComment){
							ideas[i].votes++;
							ideas[i].comments.push(comment);
							comment.idea = ideas[i];
							comment.argument = referredSentence;
							ideaFound = true;
						}
					}
					if(!ideaFound){
						for (var j:int = 0; j < comments.length; j++) {
							if(comments[j].commentNumber == referredComment){
								var idea:Idea = new Idea(comments[j].username, "", comments[j].date, comments[j].commentNumber, comments[j].text);
								idea.votes++;
								//idea.setMainContent(findMainContent(commentInfo.getPlainContent()));
								comments[j].isIdea = true;
								ideas.push(idea);
								idea.comments.push(comment);
								comment.idea = idea;
								comment.argument = referredSentence;
							}
						}
					}
				}
				content = content.substring(index+2); 
				index = content.indexOf('#');
				referredComment = findReferredComment(content, index);
			}
			
			findCommentTune(comment);
			//TODO: also look for authors names without @
			//TODO: handle this case: +1 for this patch. (this patch refers to the latest patch.)
			//TODO: how to get comment 63?
			//TODO: anything we can do about comment 61?
			//TODO: sort the ideas by number at the end
			index = comment.text.indexOf('@');
			
		}
	
		private function findCommentTune(comment:Comment):void{
			var words:Array = comment.text.split(" ");
			
			var numWords:Number = findNumWords(words);
			var numPositiveWords:Number = findNumPositiveWords(words);
			var numNegativeWords:Number = findNumNegativeWords(words);
			
			if(numPositiveWords + numNegativeWords == 0){
				comment.positiveTune = 0;
				comment.negativeTune = 0;
			}
			else{
				comment.positiveTune = numPositiveWords/(numPositiveWords + numNegativeWords);
				comment.negativeTune = numNegativeWords/(numPositiveWords + numNegativeWords);
			}
		}
		
		private function findNumWords(words:Array):Number{
			var result:Number = 0;
			for(var i:int = 0; i < words.length; i++){
				if(isWord(words[i]))
					result++;
			}
			
			return result;
		}
		
		private function isWord (word:String):Boolean{
			return WordsManipulation.isWord(word);
		}
		
		private function findNumPositiveWords(words:Array):Number{
			var result:Number = 0;
				for(var i:int = 0; i < words.length; i++){
					if(isPositive(words[i]))
						result++;
				}
			return result;
		}
		
		private function isPositive (word:String):Boolean{
			return WordsManipulation.isPositive(word);
		}
		
		private function findNumNegativeWords(words:Array):Number{
			var result:Number = 0;
			for(var i:int = 0; i < words.length; i++){
				if(isNegative(words[i]))
					result++;
			}
			return result;
		}
		
		private function isNegative (word:String):Boolean{
			return WordsManipulation.isNegative(word);
		}
		
		
		private function findReferredComment(content:String, index:int):int{
			//find the referred comment
			var contentSize:int = content.length;
			var referredComment:int = 0;
			if(index >= 0){
				if(index+1 < contentSize && content.charAt(index+1) >= '0' && content.charAt(index+1) <= '9'){
					referredComment = parseInt(content.substring(index+1, index+2));
					if(index+2 < contentSize && content.charAt(index+2) >= '0' && content.charAt(index+2) <= '9'){
						referredComment = parseInt(content.substring(index+1, index+3));
						if(index+3 < contentSize && content.charAt(index+3) >= '0' && content.charAt(index+3) <= '9'){
							referredComment = parseInt(content.substring(index+1, index+4));
						}
					}
				}	
			}
			
			return referredComment;
		}
		
		private function findReferredSentence(content:String, index:int):String {
			//find the sentence containing the #nn .
			var a:int = content.lastIndexOf('.', index);
			var b:int = content.lastIndexOf(',', index);
			var c:int = content.lastIndexOf('?', index);
			var d:int = content.lastIndexOf("http://", index);
			var temp1:int = Math.max(a, b);
			var temp2:int = Math.max(c,d);
			var sentenceBeginInd:int = Math.max(temp1, temp2);
			if(sentenceBeginInd < 0)
				sentenceBeginInd = 0;
			
			a = content.indexOf('.', index);
			b = content.indexOf(',', index);
			c = content.indexOf('?', index);
			d = content.indexOf("http://", index);
			
			var sentenceEndInd:int = Math.min(a, b);
			if(a < 0)
				sentenceEndInd = b;
			if(sentenceEndInd < 0)
				sentenceEndInd = content.length;
			if(c >= 0)
				sentenceEndInd = Math.min(c, sentenceEndInd);
			if(d >= 0)
				sentenceEndInd = Math.min(d, sentenceEndInd);
			
			return content.substring(sentenceBeginInd, sentenceEndInd);
		}

		private function ideaIsLiked(referredSentence:String):Boolean {
			//look for like/prefer/glad/well/cool/nice/nicely/good/consensus/rather
			
			var notIndex1:int = referredSentence.indexOf("doesn't");
			var notIndex2:int = referredSentence.indexOf("don't");
			var notIndex3:int = referredSentence.indexOf("doesnt"); 
			var notIndex4:int = referredSentence.indexOf("dont");
			
			var index:int = referredSentence.indexOf("like");
			if(index > 0 && !(index - notIndex1 < 9) && !(index - notIndex2 < 7) && !(index - notIndex3 < 9) && !(index - notIndex4 < 7))
				return true;
			index = referredSentence.indexOf("liked");
			if(index > 0 && !(index - notIndex1 < 9) && !(index - notIndex2 < 7) && !(index - notIndex3 < 9) && !(index - notIndex4 < 7))
				return true;
			index = referredSentence.indexOf("prefer");
			if(index > 0 && !(index - notIndex1 < 9) && !(index - notIndex2 < 7) && !(index - notIndex3 < 9) && !(index - notIndex4 < 7))
				return true;
			index = referredSentence.indexOf("glad");
			if(index > 0 && !(index - notIndex1 < 9) && !(index - notIndex2 < 7) && !(index - notIndex3 < 9) && !(index - notIndex4 < 7))
				return true;
			index = referredSentence.indexOf("+1");
			if(index > 0 )
				return true;
			index = referredSentence.indexOf("cool");
			if(index > 0 && !(index - notIndex1 < 9) && !(index - notIndex2 < 7) && !(index - notIndex3 < 9) && !(index - notIndex4 < 7))
				return true;
			index = referredSentence.indexOf("nice");
			if(index > 0 && !(index - notIndex1 < 9) && !(index - notIndex2 < 7) && !(index - notIndex3 < 9) && !(index - notIndex4 < 7))
				return true;
			index = referredSentence.indexOf("nicely");
			if(index > 0 && !(index - notIndex1 < 9) && !(index - notIndex2 < 7) && !(index - notIndex3 < 9) && !(index - notIndex4 < 7))
				return true;
			index = referredSentence.indexOf("good");
			if(index > 0 && !(index - notIndex1 < 9) && !(index - notIndex2 < 7) && !(index - notIndex3 < 9) && !(index - notIndex4 < 7))
				return true;
			index = referredSentence.indexOf("consensus");
			if(index > 0 && !(index - notIndex1 < 9) && !(index - notIndex2 < 7) && !(index - notIndex3 < 9) && !(index - notIndex4 < 7))
				return true;
			index = referredSentence.indexOf("rather");
			if(index > 0)
				return true;
			index = referredSentence.indexOf("well"); 
			if(index > 0 && !(index - notIndex1 < 9) && !(index - notIndex2 < 7) && !(index - notIndex3 < 9) && !(index - notIndex4 < 7))
				return true;
	
			
			return false;
		}
		
		private function findMainContent(content:String):String{
			var NUM_SENTENCE:int = 3;
			var result:String = "";
			var sentences:Vector.<String> = parseSentences(content);
			
			var skipNum:int = (sentences.length - NUM_SENTENCE)/2;
			
			if(skipNum > 0){
				for (var i:int = 0; i < NUM_SENTENCE; i++) {
					result += sentences[i + skipNum];
				}
			}else{
				result = content;
			}
			return result;
		}
		
		private function parseSentences(content:String):Vector.<String>{
			
			var sentences:Vector.<String> = new Vector.<String>();
			var endText:int = content.indexOf("sticky-enabled");
			if(endText > 0)
				content = content.substring(0, endText);
			
			while(content.length > 0){
				var a:int = content.indexOf('.');
				if(a+7 < content.length && content.substring(a + 1, a + 7) == "patch")
					a = (content.substring(a+1).indexOf('.'));
				var b:int = content.indexOf('?');
				
				var ind:int = Math.min(a, b);
				
				if(a < 0 && b > 0)
					ind = b;
				else if(a > 0 && b < 0)
					ind = a;
				
				if(ind == -1){
					sentences.push(content);
					break;
				}
				
				var sentence:String = content.substring(0, ind + 1);
				
				sentences.push(sentence);
				if(ind + 1 < content.length)
					content = content.substring(ind + 1);
				else
					break;
			}
			return sentences;
		}
		
		
		
		
	}
}