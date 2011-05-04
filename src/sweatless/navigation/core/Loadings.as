/**
 * Licensed under the MIT License and Creative Commons 3.0 BY-SA
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
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC 
 * LICENSE ("CCPL" OR "LICENSE"). THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW. 
 * ANY USE OF THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS 
 * PROHIBITED.
 * BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE TO BE BOUND BY THE 
 * TERMS OF THIS LICENSE. TO THE EXTENT THIS LICENSE MAY BE CONSIDERED TO BE A CONTRACT, THE 
 * LICENSOR GRANTS YOU THE RIGHTS CONTAINED HERE IN CONSIDERATION OF YOUR ACCEPTANCE OF SUCH 
 * TERMS AND CONDITIONS.
 * 
 * http://creativecommons.org/licenses/by-sa/3.0/legalcode
 * 
 * http://www.sweatless.as/
 * 
 * @author Valério Oliveira (valck)
 * 
 */

package sweatless.navigation.core {

	import sweatless.navigation.primitives.Loading;
	import sweatless.utils.DictionaryUtils;

	import flash.utils.Dictionary;

	internal final class Loadings{
		private static var _loadings : Loadings;
		private static var loaders : Dictionary = new Dictionary();
		
		public function Loadings(){
			if(_loadings) throw new Error("Loadings already initialized.");
		}
		
		public static function get instance():Loadings{
			_loadings = _loadings || new Loadings();
			
			return _loadings;
		}

		public function exists(p_id:String):Boolean{
			return loaders[p_id] ? true : false;
		}
		
		public function get(p_id:String):Loading{
			p_id = p_id.toLowerCase();
			
			return loaders[p_id];
		}
		
		public function add(p_loading:Class, p_id:String="default"):void{			
			p_id = p_id.toLowerCase();
			
			if(exists(p_id)) throw new Error("The loading "+ p_id +" already added.");
			
			var l : * = new p_loading();
			
			l.name = l.id = p_id;
			loaders[p_id] = l;
		}

		public function remove(p_id:String):void{
			p_id = p_id.toLowerCase();
			
			loaders[p_id] = null;
			delete loaders[p_id];
		}
		
		public function get length():int{
			return DictionaryUtils.length(loaders);
		}
		
	}
}