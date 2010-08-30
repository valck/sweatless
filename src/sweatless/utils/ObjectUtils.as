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

package sweatless.utils{
	import flash.utils.describeType;
	public class ObjectUtils{
		
		public static function getProperties(p_obj:*):Array {
			var properties : XMLList = describeType(p_obj)..variable;
			var result : Array = new Array();
			
			for(var i:uint; i<properties.length(); i++){
				trace("instance name =", properties[i].@name, ":", p_obj[properties[i].@name], "-> type", properties[i].@type);
				result.push({name:properties[i].@name, type:properties[i].@type});
			}
			
			return result;
		}
		
		public static function getMethods(p_obj:*):void {
			for each (var m:XML in describeType(p_obj).method) {
				trace(m.@name+" : "+m.@returnType);
				if (m.parameter != undefined) {
					trace("     arguments:");
					for each (var p:XML in m.parameter) trace("               - "+p.@type);
				}
			}
		}
	}
}

