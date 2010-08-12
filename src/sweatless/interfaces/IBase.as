package sweatless.interfaces{
	import flash.events.Event;

	public interface IBase{
		function create(evt:Event=null):void;
		function destroy():void;
	}
}