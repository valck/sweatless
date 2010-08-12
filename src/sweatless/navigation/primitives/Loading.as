package sweatless.navigation.primitives{
	import flash.events.Event;
	
	import sweatless.interfaces.IDisplay;
	
	public class Loading extends Base implements IDisplay{
		
		public static const OPEN : String = "open";
		public static const COMPLETE : String = "complete";
		
		private var _progress : Number=0;
		
		public function Loading(){
			mouseChildren = false;
			mouseEnabled = false;
			
			addEventListener(Event.ADDED_TO_STAGE, create);
		}
		
		override public function create(evt:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, create);
		}
		
		public function get progress():Number{
			return _progress;
		}
		
		public function set progress(p_progress:Number):void{
			_progress = p_progress
		}
		
		public function show():void{
			dispatchEvent(new Event(Loading.OPEN));
		}
		
		public function hide():void{
			dispatchEvent(new Event(Loading.COMPLETE));
		}
		
		public function align():void{
			
		}
		
		override public function destroy():void{
			_progress = 0;
			if(stage) parent.removeChild(this);
		}
	}
}