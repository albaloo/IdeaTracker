package edu.illinois.IdeaTracker.data
{
	public class PostStatistics
	{
		public static var maxPostLength:int = 0;
		public static var minPostLength:int = 0;
		
		public static function setMaxLength(maxLenght:int):void {
			maxPostLength = maxLenght;
		}
		
		public static function setMinLength(minLenght:int):void {
			minPostLength = minLenght;
		}
	}
}