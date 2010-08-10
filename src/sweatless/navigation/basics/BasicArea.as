package sweatless.navigation.basics{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import sweatless.interfaces.IDisplay;
	
	public class BasicArea extends Sprite implements IDisplay{
		
		public static const READY : String = "ready";
		public static const CLOSED: String = "closed";
		
		private var _id : String;
		
		public function BasicArea(){
			tabEnabled = false;
			tabChildren = false;
		}
		
		public function create():void{
			dispatchEvent(new Event(READY));
		}
		
		public function set id(p_id:String):void{
			_id = p_id;
		}
		
		public function get id():String{
			return _id;
		}
		
		public function show():void{
		}
		
		public function hide():void{
			dispatchEvent(new Event(CLOSED));
		}
		
		public function destroy():void{
			if(stage) parent.removeChild(this);
		}
		
		public static function toString():String{
			return "BasicArea";
		}
	}
}
