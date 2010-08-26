package sweatless.navigation.primitives{
	import br.com.stimuli.loading.BulkLoader;
	
	import flash.events.Event;
	
	import sweatless.interfaces.IDisplay;
	import sweatless.navigation.core.Config;
	
	public class Area extends Base implements IDisplay{
		
		public static const READY : String = "ready";
		public static const CLOSED: String = "closed";
		
		private var _id : String;
		
		public function Area(){
			tabEnabled = false;
			tabChildren = false;
		}
		
		public function set id(p_id:String):void{
			_id = p_id;
		}
		
		public function get id():String{
			return _id;
		}
		
		public function get assets():XML{
			return loader.getXML("assets");
		}
		
		public function get loader():BulkLoader{
			return BulkLoader.getLoader(Config.currentAreaID);
		}
		
		public function navigateTo(p_areaID:String):void{
			broadcaster.hasEvent("show_"+p_areaID) ? broadcaster.dispatchEvent(new Event(broadcaster.getEvent("show_"+p_areaID))) : null;
		}
		
		override public function create(evt:Event=null):void{
			dispatchEvent(new Event(READY));
		}
		
		override public function destroy():void{
			removeAllEventListeners();
			if(stage) parent.removeChild(this);
		}
		
		public function show():void{

		}
		
		public function hide():void{
			dispatchEvent(new Event(CLOSED));
		}
	}
}
