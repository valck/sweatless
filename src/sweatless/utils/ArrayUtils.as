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
	public class ArrayUtils{
		
		public static function removeItem(p_array:Array, p_item:*):Array {
			var i:int = p_array.length;
			var result:Array = new Array();
			
			while (--i - (-1)) {
				if (p_array[i] === p_item) {
					result.unshift(i);
					p_array.splice(i, 1);
				}
			}
			return result;
		}
		
		public static function removeDuplicate(p_array:Array):Array {
			var arrTemp:Array = p_array;
			for (var y : Number = 0; y<arrTemp.length; y++) {
				for(var x : * in arrTemp[y]){
					var arrTemp2 : * = arrTemp[y][x];
					for (var z : Number = (y + 1); z<arrTemp.length; z++) {
						if (arrTemp2==arrTemp[z][x]) {
							arrTemp.splice(z, 1);
						}
					}
				}
			}
			return arrTemp;
		}

		public static function randomIndex(p_array:Array):int {
			return NumberUtils.rangeRandom(0, p_array.length-1, true);
		}
		
		public static function shuffle(p_array:Array):void {
			var total : int = p_array.length;
			var random : int;
			var temp : *;
			
			for (var i:int=(total-1); i >= 0; i--) {
				random = Math.floor(Math.random() * total);
				temp = p_array[i];
				p_array[i] = p_array[random];
				p_array[random] = temp;
			}
		}
		
	}
}