package sweatless.navigation.core {

	import flash.net.navigateToURL;
	import flash.net.URLRequest;
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
			type == "analytics" ? tracker.trackPageview(p_tag) : ExternalInterface.available ? ExternalInterface.call("trackPageview", p_tag) : navigateToURL(new URLRequest("javascript:trackPageview('" + p_tag + "');"), "_self");
		}

		public function trackevent(p_id:String, p_category:String=null, p_action:String=null, p_label:String=null, p_value:Number=NaN):void{
			p_category = p_category ? p_category : String(BulkLoader.getLoader("sweatless").getXML("tracking")..trackevent.(@id==p_id).@category);
			p_action = p_action ? p_action : String(BulkLoader.getLoader("sweatless").getXML("tracking")..trackevent.(@id==p_id).@action);
			p_label = p_label ? p_label : String(BulkLoader.getLoader("sweatless").getXML("tracking")..trackevent.(@id==p_id).@label);
			p_value = p_value ? p_value : Number(BulkLoader.getLoader("sweatless").getXML("tracking")..trackevent.(@id==p_id).@value);
			type == "analytics" ? tracker.trackEvent(p_category, p_action, p_label, p_value) : ExternalInterface.available ? ExternalInterface.call("trackEvent", p_category, p_action, p_label, p_value) : navigateToURL(new URLRequest("javascript:trackEvent('"+ p_category +"', '"+ p_action +"', '"+ p_label +"', '"+ p_value +"');"), "_self");
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