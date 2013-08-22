package com.camoconnell
{
	dynamic public class Configure
	{
		// HOME INFO
		public static const HOME_HEIGHT:Number = 1616;
		public static const HOME_WIDTH:Number = 4000;		
		public static const WV_TITLE:String = 'WinterVolume - ';
		public static const TITLE:String = 'Youth and Action Sports';	
		public static const SITE_URL:String = 'http://www.wintervolume.com/';
		
		public static const CONTACT_URL:String = 'contact';
		public static const CONTACT_TITLE:String = 'Contact Us';
		public static const CONTACT_SWF:String = 'swfs/contact.swf';
		public static const CONTACT_PHP:String = '/php/contact.php';
		
		public static const YOUTHLEADERS_URL:String = 'thoughtleaders';
		public static const YOUTHLEADERS_TITLE:String = 'Thought Leaders';
		public static const YOUTHLEADERS_SWF:String = 'swfs/youth.swf';
		public static const YOUTHLEADERS_DIR:String = 'swfs/youthleaders/';
		public static const YOUTHLEADERS_XML:String = 'xml/youthleaders_data.xml';		
		
		public static const WHATWEDO_URL:String = 'recentwork';
		public static const WHATWEDO_TITLE:String = 'Recent Work';
		public static const WHATWEDO_SWF:String = 'swfs/what.swf';
		public static const WHATWEDO_XML:String = 'xml/whatwedo_data.xml';
		public static const WHATWEDO_THUMBPATH:String = 'images/whatwedo/';
		
		public static const WHOWEARE_URL:String = 'services';
		public static const WHOWEARE_TITLE:String = 'Our Services';
		public static const WHOWEARE_SWF:String = 'swfs/who.swf';
		
		public static const BLOG_URL:String = 'blog';
		public static const BLOG_TITLE:String = 'Blog';
		
		public static const colorAr:Array = [0x05c401,0xc359d9,0xfeeb1b,0xff3439,0x05c401,0x05c401,0xc359d9,0xfeeb1b,0xff3439];
		
		// API DATA
		// YOUTUBE INFO
		public static const YOUTUBE_XML:String = "http://gdata.youtube.com/feeds/api/videos/?author=wintervolume";
		public static const ATOM_NAMESPACE:String = "http://www.w3.org/2005/Atom";
		public static const YOUTUBE_NAMESPACE:String = "http://gdata.youtube.com/schemas/2007";
		
		// VIMEO INFO
		public static const VIMEO_XML:String = '/php/vimeo_proxy.php';
		public static const VIMEO_AUTH:String = "8b0f318c8cd3fa414cd1f5c85ccc6d6d";		
		public static const VIMEO_URL:String = 'http://vimeo.com/wintervolume';	
		
		// TWITTER INFO
		public static const TWITTER_AUTH:String = 'f22c4247bfbe498ed6554f52da52edec';
		public static const TWITTER_PROXY:String = 'swfs/twitter.php';
		public static const TWITTER_URL:String = 'http://twitter.com/wintervolume';
		
		// FACEBOOK INFO
		public static const FACEBOOK_URL:String = 'http://www.facebook.com/pages/WinterVolume/224284200636';
		
		// SKYPE INFO
		public static const SKYPE_XML:String = '/php/skype_proxy.php';
		
		public function Configure(){}
	}
}