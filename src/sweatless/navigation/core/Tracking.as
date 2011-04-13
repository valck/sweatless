package sweatless.navigation.core {

	import br.com.stimuli.loading.BulkLoader;

	import sweatless.layout.Layers;
	import sweatless.utils.StringUtils;

	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;

	import flash.external.ExternalInterface;

	internal final class Tracking{
		
		private static var _tracking : Tracking;
		
		private static var tracker : AnalyticsTracker;
		private static var type : String;

		public function Tracking(){
			if(_tracking) throw new Error("Tracking already initialized.");
		}
		
		public static function get instance():Tracking{
			_tracking = _tracking || new Tracking();
			
			return _tracking;
		}

		public function add():void{
			BulkLoader.getLoader("sweatless").hasItem("tracking") ? Boolean(String(BulkLoader.getLoader("sweatless").getXML("tracking")..analytics.@account)) ? addGA() : addGeneric() : null;
		}
		
		public function trackpage(p_id:String, p_tag:String=null):void{
			p_tag = p_tag ? p_tag : String(BulkLoader.getLoader("sweatless").getXML("tracking")..trackpage.(@id==p_id).@tag);
			type == "analytics" ? tracker.trackPageview(p_tag) : ExternalInterface.available ? ExternalInterface.call("trackPageview", p_tag) : null;
		}

		private function addGeneric():void{
			type = "generic"; 
		}
		
		private function addGA():void{
			tracker = new GATracker(Layers.getInstance("sweatless").get("debug"), String(BulkLoader.getLoader("sweatless").getXML("tracking")..analytics.@account), "AS3", StringUtils.toBoolean(BulkLoader.getLoader("sweatless").getXML("tracking")..analytics.@debug));
			type = "analytics";
		}
	}
}