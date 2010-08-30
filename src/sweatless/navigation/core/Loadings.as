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