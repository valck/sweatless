package sweatless.navigation.basics{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import sweatless.events.Broadcaster;
	import sweatless.navigation.core.Config;
	import sweatless.utils.ValidateUtils;
	
	public class BasicMenu extends Sprite{
		
		public static const CHANGE : String = "change";
		
		private var type : String;
		private var buttons : Array;
		private var broadcaster : Broadcaster;
		protected var selected : BasicMenuButton;
		
		public function BasicMenu(p_type:String="*"){
			type = p_type;
			buttons = Config.getMenu(type);
			broadcaster = Broadcaster.getInstance();
		}
		
		public function create():void{
			throw new Error("Please, override this method.");	
		}
		
		private function change(evt:*):void{
			var changed : BasicMenuButton = getButton(Config.currentAreaID);
			if(!changed) throw new Error("this button doesn't exists.");
			if(selected) selected.enabled();
			
			selected = changed;
			selected.disabled();
			
			dispatchEvent(new Event(BasicMenu.CHANGE));
		}
		
		private function getButton(p_area:String):BasicMenuButton{
			for(var i:uint=0; i<buttons.length; i++){
				if(getChildAt(i) is BasicMenuButton && BasicMenuButton(getChildAt(i)).area == p_area) return BasicMenuButton(getChildAt(i));
			}
			return null; 
		}
		
		protected final function getButtons(p_skin:Class):Array{
			var results : Array = new Array();
			if(String(describeType(p_skin)..extendsClass).search(BasicMenuButton.toString()) == -1) throw new Error("Please, extends BasicMenuButton Class");
			
			for(var i:uint=0; i<buttons.length; i++){
				var button : BasicMenuButton = new p_skin();
				
				for (var prop:* in buttons[i]){
					button.setProperty(prop, buttons[i][prop]);
				}
				
				button.type = type;
				button.area = buttons[i].area == undefined ? buttons[i].external : buttons[i].area;
				
				broadcaster.hasEvent("show_"+buttons[i].area) ? broadcaster.addEventListener(broadcaster.getEvent("show_"+buttons[i].area), change) : null;
				
				results.push(button);
			}
			
			return results;
		}
		
		public function destroy():void{
			if(stage) parent.removeChild(this);
		}
		
		public static function toString():String{
			return "BasicMenu";
		}
	}
}