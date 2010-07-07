package sweatless.navigation.basics{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import sweatless.events.Broadcaster;

	public class BasicMenuButton extends Sprite{
		
		private var _type : String;
		private var _area : String;
		private var _label : String;
		private var _external : Boolean;

		private var clicked : Boolean;
		private var broadcaster : Broadcaster;
		
		public function BasicMenuButton(){
			addEventListener(Event.ADDED_TO_STAGE, check);
		}
		
		private function check(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, check);
			
			broadcaster = Broadcaster.getInstance();
			
			if(!_area) throw new Error("Please, set a area for this button.");
		}
		
		public function get area():String{
			return _area;
		}
		
		public function set area(p_area:String):void{
			_area = p_area;
		}
		
		public function get label():String{
			return _label;
		}
		
		public function set label(p_label:String):void{
			_label = p_label;
		}
		
		public function get type():String{
			return _type;
		}
		
		public function set type(p_type:String):void{
			_type = p_type;
		}
		
		public function get external():Boolean{
			return _external;
		}
		
		public function set external(p_value:Boolean):void{
			_external = p_value;
		}
		
		public function create():void{
			throw new Error("Please, override this method.");
		}
		
		public final function addListeners():void{
			buttonMode = true;
			
			addEventListener(MouseEvent.CLICK, click);
			addEventListener(MouseEvent.ROLL_OVER, over);
			addEventListener(MouseEvent.ROLL_OUT, out);
		}
		
		public final function removeListeners():void{
			buttonMode = false;
			
			removeEventListener(MouseEvent.CLICK, click);
			removeEventListener(MouseEvent.ROLL_OVER, over);
			removeEventListener(MouseEvent.ROLL_OUT, out);
		}
		
		public function enabled():void{
			clicked ? clicked = false : null;

			addListeners();
			out(null);
		}
		
		public function disabled():void{
			!clicked ? clicked = true : null;
			
			removeListeners();
		}
		
		public function over(evt:MouseEvent):void{
			throw new Error("Please, override this method.");
		}
		
		public function out(evt:MouseEvent):void{
			throw new Error("Please, override this method.");
		}
		
		private function click(evt:MouseEvent):void{
			external ? navigateToURL(new URLRequest(area), "_blank") : broadcaster.hasEvent("show_"+area) ? broadcaster.dispatchEvent(new Event(broadcaster.getEvent("show_"+area))) : null;
		}
		
		public function destroy():void{
			removeListeners();
			
			if(stage) parent.removeChild(this);
		}
		
		public static function toString():String{
			return "BasicMenuButton";
		}				

		override public function get name():String{
			return area;
		}
	}
}

