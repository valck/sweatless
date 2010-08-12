package sweatless.navigation.primitives{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import sweatless.events.Broadcaster;
	import sweatless.interfaces.IBase;
	
	internal class Base extends Sprite implements IBase{
		
		public var data : Object = new Object();
		public var broadcaster : Broadcaster;
		
		public function Base(){

		}
		
		public function create(evt:Event=null):void{
			throw new Error("Please, override this method.");
		}
		
		public function destroy():void{
			throw new Error("Please, override this method.");
		}
		
		override public function toString():String{
			return getQualifiedClassName(this);
		}
	}
}