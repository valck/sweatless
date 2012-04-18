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
 * @author João Paulo Marquesini (markezine)
 * 
 */

package sweatless.utils{
	/**
	 * The <code>ArrayUtils</code> class have support methods for easier manipulation of 
	 * the native <code>XML</code> and <code>XMLList</code> class.
	 * @see XML
	 * @see XMLList
	 */	
	public class XMLUtils{
		
		/**
		 * Sorts a <code>XMLList</code> based on given attribute. 
		 * @param list The <code>XMLList</code> to be sorted. 
		 * @param attribute The name of the attribute to be sorted on.
		 * @param options The options to sort the attribute. You can use the same options as the Array version of the sort function.
		 * @return A <code>XMLList</code> ordered by the attribute you selected.
		 * @see Array.sortOn()
		 * @see Array.sort()
		 */
		public static function sortOn(list:XMLList, attribute:String, options:* = 0):XMLList {
			var array:Array = [];
			for each(var node:XML in list){
				array.push(node);
			}
			array.sortOn("@" + attribute, options);
			
			var newList:XMLList = new XMLList();
			
			for(var i:String in array){
				newList += array[i];
			}
			
			return newList;
			
		}
		
		/**
		 * Sorts a <code>XMLList</code> based in a random way. 
		 * @param list The <code>XMLList</code> to be sorted. 
		 * @return A <code>XMLList</code> ordered by the attribute you selected.
		 * @see Array.sortOn()
		 * @see Array.sort()
		 */
		public static function shufle(list:XMLList):XMLList {
			var array:Array = [];
			for each(var node:XML in list){
				array.push(node);
			}
			array = ArrayUtils.shuffle(array);
			
			var newList:XMLList = new XMLList();
			
			for(var i:String in array){
				newList += array[i];
			}
			
			return newList;
		}
	}
}