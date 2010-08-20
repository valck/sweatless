package sweatless.navigation.primitives{
	
	import flash.events.Event;
	import flash.utils.getQualifiedSuperclassName;
	
	import sweatless.events.Broadcaster;
	import sweatless.interfaces.IBase;
	import sweatless.navigation.core.Config;
	
	public class Menu extends Base implements IBase{
		
		public static const CHANGE : String = "change";
		
		private var type : String;
		private var properties : Array;
		private var buttons : Array;
		
		protected var selected : MenuButton;
		
		public function Menu(p_type:String="*"){
			type = p_type;
			properties = Config.getMenu(type);
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
				if(buttons[i].area == p_area && buttons[i].type == type) return buttons[i];
			}
			return null; 
		}
		
		protected final function getButtons(p_skin:Class):Array{
			buttons = new Array();
			if(getQualifiedSuperclassName(p_skin) != (new MenuButton).toString()) throw new Error("Please, extends MenuButton Class");
			
			for(var i:uint=0; i<properties.length; i++){
				var button : MenuButton = new p_skin();
				
				for (var prop:* in properties[i]){
					button.setProperty(prop, properties[i][prop]);
				}
				
				button.type = type;
				button.area = properties[i].area == undefined ? properties[i].external : properties[i].area;
				
				broadcaster.hasEvent("show_"+properties[i].area) ? broadcaster.addEventListener(broadcaster.getEvent("show_"+properties[i].area), change) : null;
				
				buttons.push(button);
			}
			
			return buttons;
		}
		
		override public function destroy():void{
			removeAllEventListeners();
			if(stage) parent.removeChild(this);
		}
	}
}