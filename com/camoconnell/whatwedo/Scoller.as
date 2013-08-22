package com.camoconnell.whatwedo
{
	import com.camoconnell.Configure;
	import com.camoconnell.CursorEvent;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	
	public class Scoller 
	{
		private var itemContainer_mc:MovieClip;
		private var mask_mc:MovieClip;
		private var scrubber_mc:MovieClip;
		private var scrollBg_mc:MovieClip;
		private var scrubberImg_mc:MovieClip;
		private var canvas:MovieClip;
		
		private var folowingMouse:Boolean = false;
		
		public function Scoller(_canvas:*, 
								_itemContainer_mc:MovieClip, 
								_mask_mc:MovieClip, 
								_scrubber_mc:MovieClip, 
								_scrollBg_mc:MovieClip,
								_scrubberImg_mc:MovieClip)
		{
			itemContainer_mc = MovieClip(_itemContainer_mc);
			mask_mc = MovieClip(_mask_mc);
			scrubber_mc =  MovieClip(_scrubber_mc);
			scrollBg_mc =  MovieClip(_scrollBg_mc);
			scrubberImg_mc =  MovieClip(_scrubberImg_mc);
			
			canvas = MovieClip(_canvas);
			
			init();
		}
		
		private function init():void
		{
			itemContainer_mc.mask = mask_mc;
			
			scrubber_mc.buttonMode = true;
			
			scrubber_mc.addEventListener(MouseEvent.MOUSE_DOWN, followMouse);
			scrubber_mc.addEventListener(MouseEvent.ROLL_OVER, over);
		}

		private function over(e:MouseEvent):void 
		{	
			scrubber_mc.dispatchEvent(new CursorEvent(CursorEvent.CURSOR_EVENT,'over'));
		//	var clr:* = Configure.colorAr[randRange(0,Configure.colorAr.length)];
		//	TweenLite.to(scrubberImg_mc.frontTounge_mc,1, {tint:clr});
		//	TweenLite.to(scrubberImg_mc.backTounge_mc,1, {tint:clr});
			e.currentTarget.addEventListener(MouseEvent.ROLL_OUT, out);
		}
		
		private function out(e:MouseEvent):void 
		{	
			scrubber_mc.dispatchEvent(new CursorEvent(CursorEvent.CURSOR_EVENT,'out'));
			e.currentTarget.removeEventListener(MouseEvent.ROLL_OUT, out);
		//	TweenLite.to(scrubberImg_mc.frontTounge_mc,1, {tint:null});
		//	TweenLite.to(scrubberImg_mc.backTounge_mc,1, {tint:null});
		}
			
		private function followMouse(e:MouseEvent):void 
		{
			scrubber_mc.dispatchEvent(new CursorEvent(CursorEvent.CURSOR_EVENT,'grab'));
		//	folowingMouse = true;
			canvas.addEventListener(MouseEvent.MOUSE_UP, relaxMouse);
			canvas.addEventListener(MouseEvent.MOUSE_MOVE, updatePosition);
		}
		
		private function relaxMouse(e:MouseEvent):void 
		{
			scrubber_mc.dispatchEvent(new CursorEvent(CursorEvent.CURSOR_EVENT,'out'));
		//	folowingMouse = false;
			canvas.removeEventListener(MouseEvent.MOUSE_UP, relaxMouse);
			canvas.removeEventListener(MouseEvent.MOUSE_MOVE, updatePosition);
		}
		
		private function updatePosition(e:MouseEvent):void 
		{
			
			var mouseXposition:int = canvas.mouseX - scrollBg_mc.x;
			
			
			if (mouseXposition <=  (scrubber_mc.width / 2)) {
				mouseXposition = (scrubber_mc.width / 2);
			}else if(mouseXposition >= scrollBg_mc.width - (scrubber_mc.width / 2)){
				mouseXposition = scrollBg_mc.width -  scrubber_mc.width / 2 ;
			}
			var mad:int;
			if (canvas.mouseX <= mask_mc.x) {
				mad = mask_mc.x;
			}else if (canvas.mouseX >= mask_mc.x + mask_mc.width) {
				mad = mask_mc.x + mask_mc.width;
			}else{
				mad = canvas.mouseX;
			}
			
			mad *= -( mask_mc.x+(itemContainer_mc.width) - mask_mc.width) / mask_mc.width  ;
			
			TweenLite.to(itemContainer_mc, .5, {x:mask_mc.x + scrubber_mc.width/2 + mad});
			scrubber_mc.x = (mouseXposition+scrollBg_mc.x - (scrubber_mc.width / 2));
			
			var tempXpos:Number = Math.floor((scrubber_mc.x-scrollBg_mc.x)/10)*2;
			//trace(tempXpos)
			scrubberImg_mc.backTounge_mc.gotoAndStop(tempXpos);
			scrubberImg_mc.frontTounge_mc.gotoAndStop(tempXpos);
			
			e.updateAfterEvent();
		}
		
		private function randRange(minNum:Number, maxNum:Number):Number 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
	}
}