package sweatless.navigation.primitives{
	
	import flash.events.Event;
	
	import sweatless.events.Broadcaster;
	import sweatless.interfaces.IBase;
	import sweatless.navigation.core.Config;
	
	public class Menu extends Base implements IBase{
		
		public static const CHANGE : String = "change";
		
		private var type : String;
		private var buttons : Array;
		
		protected var selected : MenuButton;
		
		public function Menu(p_type:String="*"){
			type = p_type;
			buttons = Config.getMenu(type);
			broadcaster = Broadcaster.getInstance();
		}
		
		private function change(evt:*):void{
			var changed : MenuButton = getButton(Config.currentAreaID);
			if(!changed) throw new Error("this button doesn't exists.");
			if(selected) selected.enabled();
			
			selected = changed;
			selected.disabled();
			
			dispatchEvent(new Event(Menu.CHANGE));
		}
		
		private function getButton(p_area:String):MenuButton{
			for(var i:uint=0; i<buttons.length; i++){
				if(getChildAt(i) is MenuButton && MenuButton(getChildAt(i)).area == p_area) return MenuButton(getChildAt(i));
			}
			return null; 
		}
		
		protected final function getButtons(p_skin:Class):Array{
			var results : Array = new Array();
			//if(getQualifiedClassName(p_skin) != MenuButton) throw new Error("Please, extends MenuButton Class");
			
			for(var i:uint=0; i<buttons.length; i++){
				var button : MenuButton = new p_skin();
				
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
		
		override public function destroy():void{
			removeAllEventListeners();
			if(stage) parent.removeChild(this);
		}
		
		public static function toString():String{
			return "BasicMenu";
		}
	}
}