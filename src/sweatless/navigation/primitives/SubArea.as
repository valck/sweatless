package sweatless.navigation.primitives
{
	import flash.events.Event;
	
	import sweatless.interfaces.IDisplay;
	
	public class SubArea extends Base implements IDisplay
	{
		public static const READY : String = "ready";
		public static const CLOSED: String = "closed";
		
		public function SubArea()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, create);
		}
		
		override public function create(evt:Event=null):void{
		}
						
		public function show():void
		{
		}
		
		public function hide():void
		{
			dispatchEvent(new Event(CLOSED));
		}
		
		override public function destroy(evt:Event=null):void{
			removeAllEventListeners();
		} 
	}
}