package com.camoconnell
{
	import com.camoconnell.Container;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class Main extends MovieClip
	{
		public function Main()
		{
			var wvLogo:WVLogo = new WVLogo();
			wvLogo.x = stage.stageWidth/2;
			wvLogo.y = stage.stageHeight/2;
			addChild(wvLogo)
		}
	}
}