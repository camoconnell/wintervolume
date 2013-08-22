package com.camoconnell
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	
	public class Model extends EventDispatcher
	{
		
		private var _youtubeList:Array;
		private var _vimeoCountList:Array;
		private var _whatwedoList:Array;
		public var _whatwedoItems:Array;
		private var youTubeViewCount:Number = 0;
		private var vimeoMinCount:Number = 0;
		private var youTubeMinCount:Number = 0;
		private var vimeoViewCount:Number = 0;
		public var projects:Number = 0;
		public var views:Number = 0;
		public var minutes:Number = 0;
		
		public function Model() {
			init();
		}
		
		private function init():void {
			//create a LoaderMax named "mainQueue" and set up onProgress, onComplete and onError listeners
			var queue:LoaderMax = new LoaderMax({name:"mainQueue", maxConnections:1, onComplete:XML_onComplete});
			
			//append several loaders
			queue.append( new XMLLoader(Configure.WHATWEDO_XML, {name:"xmlDoc", onComplete:WHATWEDO_onComplete}) );
			queue.append( new XMLLoader(Configure.VIMEO_XML, {name:"xmlVimeo", onComplete:VIMEO_onComplete}) ); 
			
			//start loading
			queue.load();
		}
		
		private function WHATWEDO_onComplete(event:LoaderEvent):void {
			
			_whatwedoList = [];
			
			var xml:XML = event.target.content; //the XMLLoader's "content" is the XML that was loaded. 
			var itemList:XMLList = xml.item; //In the XML, we have <image /> nodes with all the info we need.
			
			for each (var item:XML in itemList) 
			{
				_whatwedoList.push({id:item.@itemID,
					useThumb:item.@useThumb,
					itemThumb:item.@itemThumb}
				)
			}
		}
		
		private function VIMEO_onComplete(event:LoaderEvent):void {
			_vimeoCountList = [];
			_whatwedoItems = [];
			
			var thumbPath:String = Configure.WHATWEDO_THUMBPATH;
			
			// Parse the YouTube API XML response and get the value of the
			// aspectRatio element.
			var xml:XML = event.target.content;
			var vimeoList:XMLList = xml.video;
			
			for each (var item:XML in vimeoList) {
				// Create Count list
				_vimeoCountList.push({	
					view:Number(item.stats_number_of_plays), 
					mins:Number(item.duration)
				})
				
				//trace('item.id : '+item.id)
					
				// Loop through _whatwedoList items 
				for(var j:uint = 0; j < _whatwedoList.length; j++)
				{
					// if match found push into _items Array
					if(item.id == _whatwedoList[j].id)
					{
						//trace('_whatwedoList'+j+' : '+_whatwedoList[j].id);
						var videoThumb:String = (_whatwedoList[j].useThumb == "no") ? item.thumbnail_large : thumbPath + _whatwedoList[j].itemThumb;
						
						_whatwedoItems.push({
							title:item.title,
							description:item.description,
							id:item.id,
							videothumb:videoThumb
						})
						
					}
				}
			}
			
			for(var i:uint = 0; i < _vimeoCountList.length; i++){
				vimeoViewCount += _vimeoCountList[i].view;
				vimeoMinCount += _vimeoCountList[i].mins;
			}
		}
		
		/*private function YOUTUBE_onComplete(event:LoaderEvent):void {
			
			_youtubeList = [];
			
			var atomData:XML = event.target.content; 
			var atom:Namespace = new Namespace(Configure.ATOM_NAMESPACE);
			var yt:Namespace = new Namespace(Configure.YOUTUBE_NAMESPACE);
			
			// Parse the YouTube API XML response
			var atomXml:XML = new XML(atomData);
			
			var viewCountList:XMLList = atomXml.children();
			//var viewMinList:XMLList = atomXml..yt::duration.@seconds;
			
			for each (var item:XML in viewCountList) {
				_youtubeList.push({view:Number(item..yt::statistics.@viewCount), mins:Number(item..yt::duration.@seconds)})
			}
			
			
			for(var i:uint = 0; i < _youtubeList.length; i++){
				youTubeViewCount += _youtubeList[i].view;
				youTubeMinCount += _youtubeList[i].mins;
			}
		}*/
		
		
		
		
		private function XML_onComplete(event:LoaderEvent):void {
			
			dispatchEvent(new Event('complete',true)); 
		}
	}
}
		