package com.camoconnell
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class ScreenShotBlur extends Home
	{
		
		public function ScreenShotBlur()
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
		}
		
		private function go():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var mc:Sprite = new Sprite();
			mc.x = curXPos + (stage.stageWidth/2);
			mc.y = curYPos + (stage.stageHeight/2);
			addChild(mc);
			
			var tempBitmap:Bitmap = new Bitmap(Crop(this,curXPos, curYPos,stage.stageWidth, stage.stageHeight));
			tempBitmap.x = tempBitmap.x - (stage.stageWidth/2);
			tempBitmap.y = tempBitmap.y - (stage.stageHeight/2);
			mc.addChild(tempBitmap);
			TweenMax.to(mc, 3, {blurFilter:{blurX:3, blurY:3}});
			
			
			var vignette:Vignett = new Vignett();
			vignette.width = stage.stageWidth;
			vignette.height = stage.stageHeight;
			vignette.x = curXPos;
			vignette.y = curYPos;
			vignette.alpha = 0;
			addChild(vignette);
			
			TweenLite.to(vignette,  3, { alpha:1, ease:Circ.easeOut} );
		}
		
		private function Crop( source:MovieClip, x:Number, y:Number, w:int, h:int):BitmapData
		{
			var bmpd:BitmapData = new BitmapData(w,h,true, 0x00FFFFFF );
			var mat:Matrix = new Matrix(1,0,0,1,-x,-y);
			bmpd.draw( source, mat, null, null, null, true);
			return bmpd;
		}

	}
}