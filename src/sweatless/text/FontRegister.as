/**
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 Sweatless Team 
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * http://code.google.com/p/sweatless/
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * @author Valério Oliveira (valck)
 * 
 */

package sweatless.text{
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