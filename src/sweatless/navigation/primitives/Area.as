package sweatless.navigation.primitives{
	import flash.events.Event;
	
	import sweatless.interfaces.IDisplay;
	
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
		
		public function navigateTo(p_areaID:String):void{
			broadcaster.hasEvent("show_"+p_areaID) ? broadcaster.dispatchEvent(new Event(broadcaster.getEvent("show_"+p_areaID))) : null;
		}
		
		override public function create(evt:Event=null):void{
			dispatchEvent(new Event(READY));
		}
		
		override public function destroy():void{
			if(stage) parent.removeChild(this);
		}
		
		public function show():void{

		}
		
		public function hide():void{
			dispatchEvent(new Event(CLOSED));
		}
	}
}
