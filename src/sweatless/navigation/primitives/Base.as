package sweatless.navigation.primitives{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import sweatless.events.Broadcaster;
	import sweatless.interfaces.IBase;
	
	internal class Base extends Sprite implements IBase{
		
		public var data : Object = new Object();
		public var broadcaster : Broadcaster = Broadcaster.getInstance();
		
		protected var events : Dictionary;
		
		public function Base(){
			events = new Dictionary(true);
		}
		
		public function create(evt:Event=null):void{
			throw new Error("Please, override this method.");
		}
		
		public function destroy():void{
			throw new Error("Please, override this method.");
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			var key : Object = {type:type, listener:listener, capture:useCapture};
			events[key] = listener;
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			var key : Object = {type:type, listener:listener, capture:useCapture};

			events[key] = null;
			delete events[key];
			
			super.removeEventListener(type, listener, useCapture);
		}
		
		public function removeAllEventListeners():void{
			for(var key:* in events){
				removeEventListener(key.type, key.listener, key.capture);	
			}
		}
		
		override public function toString():String{
			return getQualifiedClassName(this);
		}
	}
}

