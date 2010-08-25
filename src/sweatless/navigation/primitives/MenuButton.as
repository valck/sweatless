package sweatless.navigation.primitives{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import sweatless.events.Broadcaster;
	import sweatless.events.CustomEvent;
	import sweatless.interfaces.IButton;
	
	public class MenuButton extends Base implements IButton{
		
		private var clicked : Boolean;
		
		public function MenuButton(){
			addEventListener(Event.ADDED_TO_STAGE, check);
		}
		
		private function check(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, check);
			
			broadcaster = Broadcaster.getInstance();
			
			if(!area) throw new Error("Please, set a area for this button, before add to stage");
		}
		
		public function get area():String{
			return data.area;
		}
		
		public function set area(p_area:String):void{
			data["area"] = p_area; 
		}
		
		public function get label():String{
			return data.label;
		}
		
		public function set label(p_label:String):void{
			data["label"] = p_label;
		}
		
		public function get type():String{
			return data.type;
		}
		
		public function set type(p_type:String):void{
			data["type"] = p_type;
		}
		
		public function get external():String{
			return data.external;
		}
		
		public function set external(p_value:String):void{
			data["external"] = p_value;
		}
		
		public function get target():String{
			return data.target;
		}
		
		public function set target(p_value:String):void{
			data["target"] = p_value;
		}
		
		public function getProperty(p_id:String):*{
			return data[p_id];
		}
		
		public function setProperty(p_id:String, p_value:*):void{
			data[p_id] = p_value;
		}
		
		override public function create(evt:Event=null):void{
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
			external ? navigateToURL(new URLRequest(external), target) : broadcaster.hasEvent("show_"+area) ? broadcaster.dispatchEvent(new Event(broadcaster.getEvent("show_"+area))) : null;
			broadcaster.dispatchEvent(new CustomEvent(broadcaster.getEvent("change_menu"), area));
		}
		
		override public function destroy():void{
			removeListeners();
			removeAllEventListeners();
			if(stage) parent.removeChild(this);
		}
		
		override public function get name():String{
			return area;
		}
	}
}

