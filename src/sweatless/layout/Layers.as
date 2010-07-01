package sweatless.layout{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	public final class Layers{

		private static var scope : DisplayObjectContainer;
		private static var layers : Dictionary;
		
		public static function init(p_scope:DisplayObjectContainer):void{
			if(getAll()) return;
			
			scope = p_scope;
			layers = new Dictionary();
		}
		
		public static function add(p_id:String):void{
			if(exists(p_id)) throw new Error("The layer " + p_id + " already exists.");
			
			layers[p_id] = new Layer();
			layers[p_id].name = p_id.toLowerCase();
			
			scope.addChild(layers[p_id]);
			
			layers[p_id].depth = scope.getChildIndex(layers[p_id]);
			
			update();
		}
		
		public static function remove(p_id:String):void{
			if(!exists(p_id)) throw new Error("The layer " + p_id + " doesn't exists.");

			scope.removeChild(layers[p_id]);

			layers[p_id] = null;
			delete layers[p_id];
		}
		
		public static function removeAll():void{
			for(var id:* in layers){
				scope.removeChild(layers[id]);
				layers[id] = null;
				delete layers[id];
			}
		}
		
		public static function getAll():Dictionary{
			return layers;
		}
		
		public static function get(p_id:String):Layer{
			if(!exists(p_id)) throw new Error("The layer " + p_id + " doesn't exists.");
			return layers[p_id];
		}
		
		public static function get length():int{
			var total : int = 0;
			for (var key:* in layers) {
				total++;
			}
			return total;
		}
		
		public static function exists(p_id:String):Boolean{
			return layers[p_id] ? true : false;
		}
		
		public static function depth(p_id:String):int{
			if(!exists(p_id)) throw new Error("The layer " + p_id + " doesn't exists.");
			
			return get(p_id).depth;
		}
		
		public static function swapDepth(p_id:String, p_depth:*):void{
			if(!exists(p_id)) throw new Error("The layer " + p_id + " doesn't exists.");
			
			get(p_id).depth = isNaN(p_depth) ? p_depth.toLowerCase() == "top" ? length-1 : p_depth.toLowerCase() == "bottom" ? 0 : p_depth : p_depth >= length-1 ? length-1 : p_depth == -1 ? 0 : p_depth;

			update();
		}
		
		private static function update():void{
			for (var key:* in layers) {
				scope.setChildIndex(layers[key], layers[key].depth == -1 ? scope.getChildIndex(layers[key]) : layers[key].depth);
			}
		}
	}
}

import flash.display.Sprite;

internal class Layer extends Sprite{
	private var index : int = -1;
	
	public function Layer(){
		
	}
	
	public function get depth():int{
		return index;
	}
	
	public function set depth(p_value:int):void{
		index = p_value;
	}
}
