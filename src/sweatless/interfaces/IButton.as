package sweatless.interfaces{
	import flash.events.MouseEvent;

	public interface IButton extends IBase{
		function addListeners():void;
		function removeListeners():void;
		function out(evt:MouseEvent):void;
		function over(evt:MouseEvent):void;
		function enabled():void;
		function disabled():void;
	}
}