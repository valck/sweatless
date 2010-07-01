package sweatless.font{
	import flash.text.Font;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	public class FontRegister {
		
		private static var fonts : Dictionary = new Dictionary(true);

		public static function getFont(p_id:String):Font {
			if(!hasAdded(p_id)) throw new Error("The font "+ p_id +" doesn't exists.");
			return fonts[p_id];
		}
		
		public static function getfontName(p_id:String):String{
			if(!hasAdded(p_id)) throw new Error("The font "+ p_id +" doesn't exists.");
			return getFont(p_id).fontName;
		}
		
		public static function getAllFonts():Array{
			var results:Array = new Array();
			for(var key:* in fonts){
				results.push(fonts[key]);
			}
			return results;
		}
		
		public static function addFont(p_class:Class, p_id:String):void{
			if(!(describeType(p_class)..factory.extendsClass[0].@type == "flash.text::Font")) throw new Error("The class " + p_class + " is not a valid Font class.");
			if(hasAdded(p_id)) throw new Error("Font id " + p_id + " already registered.");
			
			try {
				Font.registerFont(p_class);
				fonts[p_id] = new p_class();
			} catch (e : Error) {
				trace("FontRegister error:", e.getStackTrace());
			}
		}
		
		public static function hasAdded(p_id:String):Boolean{
			return fonts[p_id] ? true : false;
		}
		
		public static function removeFont(p_id:String): void{
			if(!hasAdded(p_id)) throw new Error("The font "+ p_id +" doesn't exists or already removed.");

			fonts[p_id] = null;
			delete fonts[p_id];
		}
		
		public static function removeAllFonts():void{
			for(var id:* in fonts){
				fonts[id] = null;
				delete fonts[id];
			}
		}
	}
}