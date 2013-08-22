package com.camoconnell.util
{
	public class MathUtil
	{
		public function MathUtil()
		{
		}
		
		public static function randRange(minNum:Number, maxNum:Number):Number 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
	}
}