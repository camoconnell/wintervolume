package com.camoconnell
{
	import com.camoconnell.CursorEvent;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.plagro.processors.FindURL;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.net.*;
	import flash.text.*;
	
	public class TitleBar extends MovieClip
	{
		
		// Twitter
		private var user:String;
		private var url:String;
		private var tweetCount:int;
		private var tweets:Array;
		private var times:Array;
		
		private var titleBarBtnAr:Array;
		
		private var loadingBar:LoadingBar;
		public var isLoading:Boolean;
		private var bar_mc:BarMC;
		
		private var textfieldAr:Array;
		private var curTweet:int;
		
		private var mouth_mc:TwitterMouth;
		private var links_mc:Links;
		private var upperEar_mc:UpperEar;
		private var masker:Bitmap;
		
		private var btnAr:Array;
		
		public function TitleBar() 
		{
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			stage.addEventListener("resizing", resize);
			
			bar_mc = new BarMC();
			addChild(bar_mc);
			
			isLoading = true;
			attachLoadBar();
			attachAssets();
			loadTwitter();
			loadSkype();
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}		
		
		private function loadSkype():void
		{
			var queue:LoaderMax = new LoaderMax({name:"mainQueue", maxConnections:1});
			
			queue.append( new XMLLoader(Configure.SKYPE_XML, {name:"xmlSkype", onComplete:SKYPE_onComplete}) );
			
			//start loading
			queue.load();
		}
		
		private function SKYPE_onComplete(event:LoaderEvent):void {
			var xml:XML = event.target.content;
			
			var ns:Namespace = xml.namespaceDeclarations()[2];
			var statusCode:Number = int(String(xml..ns::statusCode));
			links_mc.skype_mc.gotoAndStop(statusCode);
			
		}
		
		private function attachLoadBar():void
		{
			var bar:BitmapData = new Bar(50,50);
			var bitmap:BitmapData = new BitmapData(bar.width,bar.height,true,0x00FFFFFF)
			bitmap.draw(bar, new Matrix());
			masker = new Bitmap(bitmap);
			masker.cacheAsBitmap = true;
			addChild(masker);
			
			loadingBar = new LoadingBar();
			loadingBar.x = stage.stageWidth;
			loadingBar.y = 0;
			
			addChild(loadingBar);
			loadingBar.cacheAsBitmap = true;
			loadingBar.mask = masker;
			bar_mc.visible = false;
			
			load();
		}
		
		public function toggleLoad():void
		{
			
			isLoading = (isLoading)?false : true;
			
			
			if(isLoading)
			{
				loadingBar.alpha = 1;
				bar_mc.visible = false;
				load();
			} else {
				bar_mc.visible = true;
				TweenLite.killTweensOf(loadingBar);
				remove()
			}
		}
		
		private function load():void
		{
			TweenLite.to(loadingBar, 2, {x:loadingBar.x+403,onComplete:reload, ease:Linear.easeNone});
		}
		
		private function reload():void
		{
			loadingBar.x = stage.stageWidth;
			load();
		}
		
		private function remove():void
		{
			TweenLite.to(loadingBar, 1, {alpha:0});
		}
		
		private function attachAssets():void
		{
			tweetCount = 5;
			
			upperEar_mc = new UpperEar();
			addChild(upperEar_mc)
			
			mouth_mc = new TwitterMouth();
			mouth_mc.stop();
			mouth_mc.name = 'mouth_mc';
			mouth_mc.x = stage.stageWidth-mouth_mc.width;
			addChild(mouth_mc)
			
			links_mc = new Links();
			links_mc.y = 8;
			links_mc.x = stage.stageWidth-160;
			addChild(links_mc)
			links_mc.skype_mc.gotoAndStop(6);
			
			titleBarBtnAr = [links_mc.vimeo_mc,links_mc.twitter_mc,links_mc.fb_mc,links_mc.skype_mc];
			btnAr = ['vimeo','twitter','fb','skype'];
			registerListeners();
		}
		
		public function registerListeners():void
		{
			for (var i:int = 0; i < titleBarBtnAr.length; i++) {
				titleBarBtnAr[i].addEventListener(MouseEvent.ROLL_OVER, mouseOverHandler, false, 0, true);
				titleBarBtnAr[i].addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
				titleBarBtnAr[i].id = btnAr[i];
				titleBarBtnAr[i].buttonMode = true;
			}
		}
		
		public function removeListeners():void
		{
			for (var i:int = 0; i < titleBarBtnAr.length; i++) {
				titleBarBtnAr[i].removeEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
				titleBarBtnAr[i].removeEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
		
		private function mouseOverHandler(e:MouseEvent):void
		{
			this.dispatchEvent(new CursorEvent(CursorEvent.CURSOR_EVENT,'over'));
			TweenLite.to(e.currentTarget, .5, {tint:0xe8d74c, ease:Circ.easeOut});	
			
			e.currentTarget.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler, false, 0, true);
		}
		
		private function mouseOutHandler(e:MouseEvent):void
		{
			e.currentTarget.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
			this.dispatchEvent(new CursorEvent(CursorEvent.CURSOR_EVENT,'out'));
			TweenLite.to(e.currentTarget, 1, {tint:null, ease:Circ.easeOut});
		}
		
		private function clickHandler(e:MouseEvent)
		{
			var url:String;
			
			switch (e.currentTarget.id)
			{
				case "vimeo":
					url = Configure.VIMEO_URL;
					break;
				case "fb":
					url = Configure.FACEBOOK_URL;
					break;
				case "twitter":
					url = Configure.TWITTER_URL;
					break;
				case "skype":
					url = "skype:rob.wintervolume";
					break;
			}
			
			var request:URLRequest = new URLRequest(url);
			try { navigateToURL(request, '_blank'); } catch (e:Error) { trace("Error occurred!"); }
			
			
		}
		
		private function loadTwitter():void
		{
			curTweet = 0;
			
			var urlReq:URLRequest = new URLRequest(Configure.TWITTER_PROXY);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, getTweets);
			loader.addEventListener(IOErrorEvent.IO_ERROR, IOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SError);
			loader.load(urlReq);
		}
		
		private function getTweets(e:Event):void
		{
			textfieldAr = new Array();
			
			if ( e.target.data ) {
				
				tweets = new Array(); 
				times = new Array();
				var twitterXML:XML = new XML(e.target.data);
				var tweetList:XMLList = twitterXML.children();
				
				var tweetItem:String; 
				var timeItem:String;
				
				for (var i:int = 0; i < tweetList.length(); i++) {
					tweetItem = tweetList[i].*::title;
					timeItem = tweetList[i].*::published;
					
					if ( tweetItem != "" ) {
						var tweetItemA:Array  = tweetItem.split(": ");
						tweetItem = tweetItemA[1].toUpperCase();
						tweetItem ='"'+tweetItem+'"';
						var linkFinder:FindURL = new FindURL(tweetItem);
						//return the new processed text
						tweetItem = linkFinder.Process();
						tweets.push(tweetItem);
						
						var timeItemA:Array = timeItem.split("T");
						timeItem = timeItemA[0];
						var timeItemB:Array = timeItem.split("-");
						timeItem = " - "+'<p>'+timeItemB[2]+"/"+timeItemB[1]+"/"+timeItemB[0]+"</p>";
						times.push(timeItem);
						
						creatTextFields(tweetItem+timeItem)
					}
				}
				TweenLite.to(mouth_mc, .3, {frameLabel:"endFrame", ease:Linear.easeNone});
				TweenLite.to(textfieldAr[curTweet],  3, { x:30, y:8, delay:.5, ease:Circ.easeOut, onComplete:nextTextfield} );	
			}
		}
		
		private function creatTextFields(textContent:String):void
		{
			
			var laterOn:LaterOn = new LaterOn();
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 14;
			myFormat.letterSpacing = 1;
			myFormat.align = TextFormatAlign.CENTER;
			myFormat.font = laterOn.fontName;
			
			var twitter_txt:TextField = new TextField();
			twitter_txt.defaultTextFormat = myFormat;
			twitter_txt.embedFonts = true;
			twitter_txt.antiAliasType = AntiAliasType.ADVANCED;
			
			twitter_txt.border = false;
			twitter_txt.wordWrap = false;
			twitter_txt.x = 0;
			twitter_txt.y = 0;
			twitter_txt.textColor = 0xffffff;
			
			//create and initialize css
			var myCSS:StyleSheet = new StyleSheet();
			myCSS.setStyle("a:link", {color:'#e8d74c',textDecoration:'none'});
			myCSS.setStyle("a:hover", {color:'#e0b3ba',textDecoration:'none'});
			myCSS.setStyle("p", {fontSize:'12'});
			
			twitter_txt.styleSheet = myCSS;
			twitter_txt.htmlText = textContent;
			//resize the textbox to exact fit the text in it
			twitter_txt.autoSize = "left";
			
			
			var twitterSprite:Sprite = new Sprite()
			twitterSprite.addChild(twitter_txt);
			twitterSprite.y = 8;
			twitterSprite.x = stage.stageWidth;
			addChild(twitterSprite);
			
			textfieldAr.push(twitterSprite)
			setChildIndex(mouth_mc, (numChildren - 1));
			setChildIndex(upperEar_mc, (numChildren - 1));
			setChildIndex(links_mc, (numChildren - 1));
		}
		
		private function nextTextfield():void 
		{
			TweenLite.to(mouth_mc, .3, {frameLabel:"startFrame", ease:Linear.easeNone});
			TweenLite.to(textfieldAr[curTweet],  1, { x:-textfieldAr[curTweet].width, y:8, delay:8, ease:Circ.easeOut, onComplete:returnTextField} );
		}
		
		private function returnTextField():void
		{
			textfieldAr[curTweet].x = stage.stageWidth;
			textfieldAr[curTweet].y = 8;
			
			if(curTweet == (tweetCount-1)){
				curTweet = 0;
			} else {
				curTweet++;
			}
			
			TweenLite.to(mouth_mc, .3, {frameLabel:"endFrame", ease:Linear.easeNone});
			TweenLite.to(textfieldAr[curTweet],  3, { x:30, y:8, delay:.5,ease:Circ.easeOut, onComplete:nextTextfield});
		}
		
		private function IOError(e:Event):void { trace("io error!"); }
		
		private function SError(e:Event):void { trace("security error!"); }	
		
		private function randRange(minNum:Number, maxNum:Number):Number 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		private function resize(e:Event):void
		{
			mouth_mc.x = stage.stageWidth-mouth_mc.width;
			links_mc.x = stage.stageWidth-160;
			
			/*for (var i:int = 0; i < textfieldAr.length(); i++) {
				textfieldAr[i].x = stage.stageWidth;
			}*/
		}
	}
}