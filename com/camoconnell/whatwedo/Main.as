package com.camoconnell.whatwedo
{
	import com.camoconnell.Configure;
	import com.camoconnell.CursorEvent;
	import com.camoconnell.Model;
	import com.camoconnell.whatwedo.VimeoPlayer;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	public class Main extends MovieClip
	{
		private var isHome:Boolean;
		private var isDetails:Boolean;
		private var exitPanel_mc:ExitPanel;
		private var container_mc:ContainerMC;
		
		private var _whatwedoList:Array;
		private var _items:Array;
		private var mouth_mc:MovieClip;
		
		private var eyeOne_mc:EyeOne; 
		private var eyeTwo_mc:EyeTwo; 
		
		private var _model:Model;
		
		private var vimeoAr:Array;
		//private var descAr:Array;
		
		private static const _THUMB_WIDTH:Number = 282;
		private static const _THUMB_HEIGHT:Number = 246;		
		
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event)
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			vimeoAr = [];
			//descAr = [];
			
			
			isHome = true;
			isDetails = false;
	
			container_mc = new ContainerMC();
			container_mc.stop();
			container_mc.help_mc.stop();
			container_mc.y = stage.stageHeight;
			addChild(container_mc);
			
			container_mc.back_mc.stop();
			
			container_mc.loader_mc.buttonMode = false;
			
			container_mc.exit_mc.addEventListener(MouseEvent.CLICK, removeScene);
			container_mc.exit_mc.addEventListener(MouseEvent.ROLL_OVER, rollover);
			
			container_mc.details_mc.addEventListener(MouseEvent.CLICK, initDetails); 
		}
		
		public function initDetails(e:MouseEvent):void { 
			if(isDetails){
				TweenLite.to(container_mc,  .5, {frameLabel:'videoFrame', ease:Circ.easeOut, onComplete:displayVimeo});
				isDetails = false;
			} else {
				vimeoAr[0].pause();
				TweenLite.to(vimeoAr[0],  1, {alpha:0.8});
				
				
				TweenLite.to(container_mc,  1, {frameLabel:'detailsFrame', ease:Circ.easeOut, onComplete:displayDetails});
				
				isDetails = true;
			}
		}
		
		public function displayVimeo():void { 
			vimeoAr[0].play();
			TweenLite.to(vimeoAr[0],  1, {alpha:1}); 
		}
		
		public function displayDetails():void { 
		}
		
		public function removeScene(e:MouseEvent):void { 
			if(isHome){
				this.dispatchEvent(new Event('destroy',true));
			} else {
				backToMenu();
			}
		}
		
		private function backToMenu():void {
			TweenLite.to(container_mc,  1.5, {frameLabel:'endFrame', onComplete:regMenu});
			container_mc.loader_mc.alpha = 1;
			removeVimeoClip();
			isHome = true;
			
			container_mc.back_mc.gotoAndStop(1);
		}
		
		private function removeVimeoClip():void
		{
			vimeoAr[0].unloadVideo();
			container_mc.vimeo_mc.removeChild(vimeoAr[0]);
			vimeoAr[0] = null;
			vimeoAr = [];
		}
		
		private function regMenu():void { 
			
			container_mc.gotoAndStop('menuFrame');
			mouth_mc.visible = true;
			eyeOne_mc.visible = true;
			eyeTwo_mc.visible = true;
			
			addListeners();
		}
		
		public function rollover(e:MouseEvent):void { 
			
			var backState:String = (isHome) ? 'home' : 'exit';

			this.dispatchEvent(new CursorEvent(CursorEvent.CURSOR_EVENT,backState));
			container_mc.exit_mc.addEventListener(MouseEvent.ROLL_OUT, rollout);
		}
		
		public function rollout(e:MouseEvent):void { 
			this.dispatchEvent(new CursorEvent(CursorEvent.CURSOR_EVENT,'out'));
			container_mc.exit_mc.removeEventListener(MouseEvent.ROLL_OUT, rollout);
		}
		
		public function registerModel(m:Model):void {
			_model = m;
			
			_items = [];
			// loop through model data
			for(var i:uint = 0; i < _model._whatwedoItems.length; i++)
			{
				_items.push( 
					new Item(
						_model._whatwedoItems[i].title,
						_model._whatwedoItems[i].description,
						_model._whatwedoItems[i].id,
						new ImageLoader(
							_model._whatwedoItems[i].videothumb,{
								name:String(i), 
								//width:_THUMB_WIDTH, 
								height:_THUMB_HEIGHT, 
								scaleMode:"proportionalInside", 
								bgColor:0x000000, 
								estimatedBytes:13000,
								onProgress:itemProgressHandler, 
								onComplete:itemCompleteHandler
							}
						)
					)
				)
				
			}
			
			playIntro();
		}
		
		public function playIntro():void {
			var timeline:TimelineLite = new TimelineLite({onComplete:buildMouth});
			timeline.append(TweenLite.to(container_mc, 2, {y:-50,ease:Bounce.easeOut}));
			timeline.append(TweenLite.to(container_mc,  2, {frameLabel:'pauseFrame' ,ease:Bounce.easeOut}));
			timeline.append(TweenLite.to(container_mc,  1, {frameLabel:'midFrame' , delay:1, ease:Circ.easeOut}));
			timeline.append(TweenLite.to(container_mc.help_mc,  1.2, {frameLabel:'endFrame' ,ease:Circ.easeOut}));
			timeline.append(TweenLite.to(container_mc.help_mc,  1.2, {frameLabel:'startFrame' ,ease:Circ.easeOut}));
			timeline.append(TweenLite.to(container_mc,  2, {frameLabel:'endFrame' ,ease:Bounce.easeOut}));
		}
		
		private function buildMouth():void {
			
			container_mc.gotoAndStop('menuFrame');
			
			// add Mouth
			mouth_mc = new MovieClip();
			mouth_mc.x = 77;
			mouth_mc.y = 200;
			addChild(mouth_mc);
			
			// add Mask, Mask mask's scrolling content
			var mask_mc:Mask = new Mask();
			mask_mc.x = 64;
			mask_mc.y = 33;
			mouth_mc.addChild(mask_mc);
			
			// itemContainer_mc holds item content
			var itemContainer_mc:MovieClip = new MovieClip();
			itemContainer_mc.x = 50;
			itemContainer_mc.y = 50;
			mouth_mc.addChild(itemContainer_mc);
			
			// Add items to itemContainer_mc
			var xPos:Number = 5;
			for (var i:int = 0; i < _items.length; i++) {
				_items[i].x = xPos;
				xPos += _THUMB_WIDTH;
				itemContainer_mc.addChild(_items[i]);
			}
			
			// add following eye's
			eyeMovement();
			// add Listeners
			addListeners();
			
			// Add scrollerImg_mc (tounge image)
			var scrollerImg_mc:ScrollerImg = new ScrollerImg();
			scrollerImg_mc.mouseChildren = false;
			scrollerImg_mc.buttonMode = false;
			scrollerImg_mc.frontTounge_mc.stop();
			scrollerImg_mc.backTounge_mc.stop();
			mouth_mc.addChild(scrollerImg_mc);
			
			// Add invisible scroll bar bg
			var scrollBg_mc:ScrollBg = new ScrollBg();
			scrollBg_mc.x = 60;
			scrollBg_mc.y = 323;
			mouth_mc.addChild(scrollBg_mc);
			
			// Add invisible scrubber
			var scrubber_mc:Scrubber = new Scrubber();
			scrubber_mc.x = 60;
			scrubber_mc.y = 266;
			mouth_mc.addChild(scrubber_mc);
			
			// init scrollbar functionality
			var scroll:Scoller = new Scoller(mouth_mc,itemContainer_mc, mask_mc, scrubber_mc, scrollBg_mc,scrollerImg_mc);
			
			loadThumbs();
		}
		
		private function addListeners():void
		{
			for (var i:int = 0; i < _items.length; i++) {
				_items[i].addEventListener(WhatEvent.BTN_EVENT, playVideo, false, 0, true);
			}
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, updateEyes);
		}
		
		private function removeListeners():void
		{
			for (var i:int = 0; i < _items.length; i++) {
				_items[i].removeEventListener(WhatEvent.BTN_EVENT, playVideo);
			}
			
			this.removeEventListener(MouseEvent.MOUSE_MOVE, updateEyes);
		}
		
		private function playVideo(e:Event):void
		{
			isHome = false;
			
			//container_mc.vimeo_mc.alpha = 0;
			container_mc.gotoAndStop('endFrame')
			removeListeners();
			mouth_mc.visible = false;
			eyeOne_mc.visible = false;
			eyeTwo_mc.visible = false;
			
			dispatchEvent(new Event('loading',true));
			
			// Set details
			container_mc.deets_mc.title_txt.text = e.target.itemName;
			container_mc.deets_mc.desc_txt.htmlText  = e.target.description;
			
			var vm:VimeoPlayer = new VimeoPlayer(Configure.VIMEO_AUTH, e.target.videoPath, 772, 434, 10);
			vm.addEventListener(Event.COMPLETE, vimeoPlayerLoaded);
			container_mc.vimeo_mc.addChild(vm);
			
			vm.addEventListener(Event.CLOSE,updateScene);
			
			vimeoAr.push(vm)
			
			TweenLite.to(container_mc, 1.5, {frameLabel:'videoFrame', onComplete:backBtn});
		} 
		
		private function backBtn():void {container_mc.back_mc.gotoAndStop(2);};
		
		private function updateScene(e:Event):void {
			e.currentTarget.removeEventListener(Event.CLOSE,updateScene);
			backToMenu();
		}
		
		private function vimeoPlayerLoaded(e:Event):void{
			e.currentTarget.removeEventListener(Event.COMPLETE, vimeoPlayerLoaded);
			e.currentTarget.changeColor(String(Configure.colorAr[randRange(0,Configure.colorAr.length)]));
			e.currentTarget.play();
			TweenLite.to(container_mc.vimeo_mc, 1,{alpha:1});
			dispatchEvent(new Event('loading',true));
		}
		
		private function loadThumbs():void {
			
			//now create a LoaderMax queue and populate it with all the thumbnail ImageLoaders as well as the very first full-size ImageLoader. We don't want to show anything until the thumbnails are done loading as well as the first full-size one. After that, we'll create another LoaderMax queue containing the rest of the full-size images that will load silently in the background.
			var initialLoadQueue:LoaderMax = new LoaderMax({onComplete:_initialLoadComplete, maxConnections:1, onProgress:_progressHandler});
			for (var i:int = 0; i < _items.length; i++) {
				initialLoadQueue.append( _items[i].thumbnailLoader);
			}
		//	initialLoadQueue.append(_items[0].imageLoader);
			initialLoadQueue.load();
			
			//_setupThumbnails();
			dispatchEvent(new Event('loading',true));
			
		}
		
		private function _initialLoadComplete(e:Event):void 
		{
			dispatchEvent(new Event('loading',true));
		}
		
		private function _progressHandler(e:LoaderEvent):void {}
		private function itemProgressHandler(e:LoaderEvent):void {}
		private function itemCompleteHandler(e:Event):void 
		{
			_items[e.currentTarget.name].attachClip();
		}
		
		private function eyeMovement():void
		{
			eyeOne_mc = new EyeOne();
			eyeOne_mc.x = 523;
			eyeOne_mc.y = 50;
			addChild(eyeOne_mc);
			
			eyeTwo_mc = new EyeTwo();
			eyeTwo_mc.x = 690;
			eyeTwo_mc.y = 54;
			addChild(eyeTwo_mc);
		}
		
		private function updateEyes(e:MouseEvent):void
		{
			var xdiffOne:Number = mouseX - 523;
			var xdiffTwo:Number = mouseX - 690;
			
			var ydiffOne:Number = mouseY - 50;
			var ydiffTwo:Number = mouseY - 54;

			var radiusOne:Number = Math.min(Math.max(Math.sqrt(xdiffOne*xdiffOne+ydiffOne*ydiffOne)/5,0),8)
			var radiusTwo:Number = Math.min(Math.max(Math.sqrt(xdiffTwo*xdiffTwo+ydiffTwo*ydiffTwo)/5,0),8)
				
			var angleOne:Number = Math.atan2(ydiffOne,xdiffOne);
			var angleTwo:Number = Math.atan2(ydiffTwo,xdiffTwo);
			
			eyeOne_mc.x = Math.cos(angleOne)*radiusOne*1.5 + 519;
			eyeOne_mc.y = Math.sin(angleOne)*radiusOne + 50
				
			eyeTwo_mc.x = Math.cos(angleTwo)*radiusTwo*1.5 + 698;
			eyeTwo_mc.y = Math.sin(angleTwo)*radiusTwo + 54;
			
			e.updateAfterEvent();
		}
		
		private function randRange(minNum:Number, maxNum:Number):Number 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
	}
}