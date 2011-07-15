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

package sweatless.utils{
	/**
	 * The <code>ArrayUtils</code> class have support methods for easier manipulation of 
	 * the native <code>Array</code> class.
	 * @see Array
	 */	
	public class ArrayUtils{
			
		/**
		 * Removes an item from an <code>Array</code>. 
		 * @param p_array The <code>Array</code> that contains the item that should be removed. 
		 * @param p_item The item to be removed from the <code>Array</code>.
		 * @return An <code>Array</code> with the removed items.
		 * @see Array.pop()
		 * @see Array.shift()
		 * @see Array.splice()
		 */
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
		
		/**
		 * Removes all duplicated items from an <code>Array</code>. 
		 * @param p_array The <code>Array</code> where the duplicates should be removed.
		 */
		public static function removeDuplicate(p_array:Array):void {
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
		}
		
		/**
		 * Finds element in <code>Array</code> and returns <code>Boolean</code> value 
		 * @param p_array The <code>Array</code> where the duplicates should be removed.
		 */
		public static function search(p_value:Object, p_array:Array):Boolean {
			var results:Boolean;
			for(var i:uint=0; i<p_array.length; i++) {
				results = (p_array[i]==p_value) ? true : false;
			}
			return results;
		}

		/**
		 * Returns a new merged <code>Array</code>. 
		 * @param p_array The <code>Array</code> to be used as reference.
		 * @return Returns a new merged <code>Array</code>.
		 * 
		 */
		public static function merge(p_arrayA:Array, p_arrayB:Array):Array {
            var result:Array = new Array();
            var i:uint = 0;
            var j:uint = 0;
            while((i < p_arrayA.length) || (j < p_arrayB.length)) {
                    if(i < p_arrayA.length){
                            result.push(p_arrayA[i]);
                            i+=1;
                    }
                    if(j < p_arrayB.length){
                            result.push(p_arrayB[j]);
                            j+=1;
                    }
            }
            return result;
        }

		/**
		 * Returns a random index inside the range of the <code>Array</code>. 
		 * @param p_array The <code>Array</code> to be used as reference.
		 * @return A random valid index.
		 * 
		 */
		public static function randomIndex(p_array:Array):int {
			return NumberUtils.rangeRandom(0, p_array.length-1, true);
		}
		
		/**
		 * Returns a random item within an <code>Array</code>.
		 * @param p_array The <code>Array</code> to be used as reference.
		 * @return The resulting object.
		 * @see Array
		 */
		public static function randomItem(p_array:Array):*{
			return p_array[NumberUtils.rangeRandom(0, p_array.length-1, true)];
		}
		
				
		/**
		 * Shuffles the order of the items in an <code>Array</code>. 
		 * @param p_array The <code>Array</code> to shuffled.
		 * 
		 */
		public static function shuffle(p_array:Array):Array {
			var total : int = p_array.length;
			var random : int;
			var temp : *;
			
			for (var i:int=(total-1); i >= 0; i--) {
				random = Math.floor(Math.random() * total);
				temp = p_array[i];
				p_array[i] = p_array[random];
				p_array[random] = temp;
			}
			
			return p_array;
		}
		
	}
}