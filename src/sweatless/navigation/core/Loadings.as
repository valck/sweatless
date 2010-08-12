package sweatless.navigation.core{
	import flash.utils.Dictionary;
	
	import sweatless.navigation.primitives.Loading;
	import sweatless.utils.DictionaryUtils;

	public class Loadings{
		private static var loadings : Dictionary = new Dictionary();

		public static function exists(p_id:String):Boolean{
			return loadings[p_id] ? true : false;
		}
		
		public static function get(p_id:String):Loading{
			return loadings[p_id];
		}
		
		public static function add(p_loading:Class, p_id:String="default"):void{
			if(exists(p_id)) throw new Error("The loading "+ p_id +" already added.");
			loadings[p_id] = new p_loading();
		}

		public static function remove(p_id:String):void{
			loadings[p_id] = null;
			delete loadings[p_id];
		}
		
		public static function get length():int{
			return DictionaryUtils.length(loadings);
		}
		
	}
}