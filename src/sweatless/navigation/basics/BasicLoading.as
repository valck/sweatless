package sweatless.navigation.basics{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BasicLoading extends Sprite{
		
		public static const OPEN : String = "open";
		public static const COMPLETE : String = "complete";
		
		private var _progress : Number=0;
		
		public function BasicLoading(){
			mouseChildren = false;
			mouseEnabled = false;
			addEventListener(Event.ADDED_TO_STAGE, create);
		}
		
		public function create(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, create);
		}
		
		public function get progress():Number{
			return _progress;
		}
		
		public function set progress(p_progress:Number):void{
			_progress = p_progress
		}
		
		public function show():void{
			dispatchEvent(new Event(BasicLoading.OPEN));
		}
		
		public function hide():void{
			dispatchEvent(new Event(BasicLoading.COMPLETE));
		}
		
		public function destroy():void{
			_progress = 0;
			if(stage) parent.removeChild(this);
		}
		
		public static function toString():String{
			return "BasicLoading";
		}
	}
}