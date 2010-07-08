package sweatless.navigation.basics{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BasicLoading extends Sprite{
		
		public static const COMPLETE : String = "complete";
		
		private var _progress : Number=0;
		
		public function BasicLoading(){
		}

		public function create(evt:Event):void{
			throw new Error("Please, override this method.");
		}
		
		public function get progress():Number{
			return _progress;
		}
		
		public function set progress(p_progress:Number):void{
			_progress = p_progress
			p_progress >= 1 ? dispatchEvent(new Event(BasicLoading.COMPLETE)) : null;
		}

		public function show():void{
			throw new Error("Please, override this method.");
		}
		
		public function hide():void{
			throw new Error("Please, override this method.");
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