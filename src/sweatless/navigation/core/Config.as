package sweatless.navigation.core{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import sweatless.utils.StringUtils;
	
	public final class Config{
		
		private static var _started : Boolean;
		private static var _source : XML;
		private static var _currentAreaID : String;
		
		private static var trackerGA : AnalyticsTracker;
		private static var parameters : Dictionary = new Dictionary();
		
		public static function get started():Boolean{
			return _started;
		}
		
		public static function set started(p_value:Boolean):void{
			_started = p_value;
		}
		
		public static function set source(p_file:XML):void{
			_source = p_file;
		}
		
		public static function get source():XML{
			return _source;
		}
		
		public static function get currentAreaID():String{
			return _currentAreaID;
		}
		
		public static function set currentAreaID(p_area:String):void{
			_currentAreaID = p_area;
		}
		
		public static function get firstArea():String{
			return String(source..areas.@first);
		}
		
		public static function get crossdomain():String{
			return String(source..crossdomain.@file);
		}
		
		public static function get tracking():String{
			return String(source..tracking.@file);
		}
		
		public static function getVar(p_name:String):Object{
			return parameters[p_name];
		}
		
		public static function setVar(p_name:String, p_value:Object):void{
			parameters[p_name] = p_value;
		}
		
		public static function getService(p_id:String):String{
			return String(source..services.service.(@id==p_id).@url);
		}
		
		public static function addAnalytics(p_scope:DisplayObject):void{
			trackerGA = new GATracker(p_scope, String(BulkLoader.getLoader("sweatless").getXML("tracking")..analytics.@account), "AS3", StringUtils.toBoolean(BulkLoader.getLoader("sweatless").getXML("tracking")..analytics.@debug));
		}
		
		public static function trackPage(p_id:String):void{
			BulkLoader.getLoader("sweatless").hasItem("tracking") ? trackerGA.trackPageview(String(BulkLoader.getLoader("sweatless").getXML("tracking")..trackpage.(@id==p_id).@tag)) : null;
		}
		
		public static function get layers():XMLList{
			return source..layer;
		}
		
		public static function get areas():XMLList{
			return source..area;
		}
		
		public static function getInArea(p_id:String, p_attribute:String):String{
			return String(areas.(@id==p_id)[p_attribute]);
		}
		
		public static function getAreaAdditionals(p_id:String, p_attribute:String):String{
			return String(areas.(@id==p_id).additionals[p_attribute]);
		}
		
		public static function getAreaDependencies(p_id:String, p_type:String):Dictionary{
			var dependencies : Dictionary = new Dictionary();
			var i : uint = 0;
			
			switch(p_type){
				case "image":
					for(i=0; i<areas.(@id==p_id).dependencies..image.length(); i++){
						dependencies[String(areas.(@id==p_id).dependencies..image[i].@id)] = String(areas.(@id==p_id).dependencies..image[i].@url);
					}
					break;
				
				case "video":
					for(i=0; i<areas.(@id==p_id).dependencies..video.length(); i++){
						dependencies[String(areas.(@id==p_id).dependencies..video[i].@id)] = String(areas.(@id==p_id).dependencies..video[i].@url);
					}
					break;
				
				case "audio":
					for(i=0; i<areas.(@id==p_id).dependencies..audio.length(); i++){
						dependencies[String(areas.(@id==p_id).dependencies..audio[i].@id)] = String(areas.(@id==p_id).dependencies..audio[i].@url);
					}
					break;
				
				case "other":
					for(i=0; i<areas.(@id==p_id).dependencies..other.length(); i++){
						dependencies[String(areas.(@id==p_id).dependencies..other[i].@id)] = String(areas.(@id==p_id).dependencies..other[i].@url);
					}
					break;
			}
			
			return dependencies;
		}
		
		public static function hasDeeplink(p_deeplink:String):Boolean{
			for(var key : String in getAllDeeplinks()){
				if(p_deeplink == getAllDeeplinks()[key]) return true;
			}
			
			return false;
		}
		
		public static function getDeeplinkByArea(p_area:String):String{
			for(var key : String in getAllDeeplinks()){
				if(p_area == key) return getAllDeeplinks()[key];
			}
			
			return getAreaAdditionals(firstArea, "@deeplink");
		}
		
		public static function getAreaByDeeplink(p_deeplink:String):String{
			for(var key : String in getAllDeeplinks()){
				if(p_deeplink == getAllDeeplinks()[key]) return key;
			}
			
			return firstArea;
		}
		
		public static function getAllDeeplinks():Dictionary{
			var deeplinks : Dictionary = new Dictionary();
			
			for(var i:uint=0; i<areas.length(); i++){
				getAreaAdditionals(String(areas[i].@id), "@deeplink") ? deeplinks[String(areas[i].@id)] = String("/" + getAreaAdditionals(String(areas[i].@id), "@deeplink")) : null;
			}
			
			return deeplinks;
		}
		
		public static function getMenu(p_type:String="*"):Array{
			var all : Boolean = p_type == "*" ? true : false;
			var buttons : Array = new Array();
			
			for(var a:uint=0; a<uint(all ? source..button.length() : source..buttons.(@type==p_type).button.length()); a++){
				var attributes : Object = new Object();
				for(var b:uint=0; b<uint(all ? source..button[a].@*.length() : source..buttons.(@type==p_type).button[a].@*.length()); b++){
					all ? attributes[String(source..button[a].@*[b].name())] = String(source..button[a].@*[b]) : attributes[String(source..buttons.(@type==p_type)..button[a].@*[b].name())] = String(source..buttons.(@type==p_type)..button[a].@*[b]);
				}
				
				buttons.push(attributes);
			}
			
			return buttons;
		}
	}
}
