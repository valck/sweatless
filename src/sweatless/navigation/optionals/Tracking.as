package sweatless.navigation.optionals{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.google.analytics.AnalyticsTracker;
	
	import flash.utils.Dictionary;
	
	public class Tracking{
		
		private static var tracker : AnalyticsTracker;
		
		public static function init(p_account:String, p_debug:Boolean=false):void{
			tracker.account = p_account;
			tracker.mode    = "AS3";
			tracker.visualDebug = p_debug;
		}
		
		public static function trackPage(p_url:String):void{
			tracker.trackPageview(p_url);
		}

		public static function trackEvent(p_category:String, p_action:String, p_label:String=null, p_value:Number=NaN):void{
			tracker.trackEvent(p_category, p_action, p_label, p_value);
		}

	}
}
