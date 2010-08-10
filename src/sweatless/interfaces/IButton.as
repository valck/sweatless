package sweatless.interfaces{
	import flash.events.MouseEvent;

	public interface IButton extends IBasic{
		function addListeners():void;
		function removeListeners():void;
		function handlers(evt:MouseEvent):void;
		function enabled():void;
		function disabled():void;
	}
}