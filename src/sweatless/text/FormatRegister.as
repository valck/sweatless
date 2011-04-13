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
 * http://code.google.com/p/sweatless/
 * 
 * @author Valério Oliveira (valck)
 * 
 */

package sweatless.text {

	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	/**
	 * The <code>FormatRegister</code> class have support methods for easier manipulation of
	 * the native <code>TextFormat</code> Class.
	 * @see TextFormat
	 * @see Dictionary
	 */
	public class FormatRegister {
		
		private static var formats : Dictionary = new Dictionary(true);
		
		/**
		 * Return the <code>TextFormat</code> that has been briefly recorded.
		 * @param p_id The <code>TextFormat</code> id (<code>String</code>).
		 * @return The resulting <code>TextFormat</code> object.
		 * @see TextFormat
		 * @see String
		 */
		public static function get(p_id:String):TextFormat {
			if(!hasAdded(p_id)) throw new Error("The format "+ p_id +" doesn't exists.");
			return formats[p_id];
		}
		
		/**
		 * Returns an <code>Array</code> with the formats registered.
		 * @return The resulting <code>Array</code> object.
		 * @see Array
		 */
		public static function getAll():Array{
			var results:Array = new Array();
			for(var key:* in formats){
				results.push(formats[key]);
			}
			return results;
		}
		
		/**
		 * Register a <code>TextFormat</code>.
		 * @param p_format The <code>TextFormat</code> id (<code>TextFormat</code>).
		 * @param p_id The <code>TextFormat</code> id (<code>String</code>).
		 * @see TextFormat
		 * @see String
		 */
		public static function add(p_format:TextFormat, p_id:String):void{
			if(hasAdded(p_id)) throw new Error("the format with id: " + p_id + " already registered.");
			
			formats[p_id] = p_format;
		}
		
		/**
		 * Check if a <code>TextFormat</code> has been added.
		 * @param p_id The <code>TextFormat</code> id (<code>String</code>).
		 * @return The resulting <code>Boolean</code> object with the format name.
		 * @see String
		 * @see Boolean
		 */
		public static function hasAdded(p_id:String):Boolean{
			return formats[p_id] ? true : false;
		}
		
		/**
		 * Unregister a <code>TextFormat</code>.
		 * @param p_id The <code>TextFormat</code> id (<code>String</code>).
		 * @see String
		 */
		public static function remove(p_id:String): void{
			if(!hasAdded(p_id)) throw new Error("The format "+ p_id +" doesn't exists or already removed.");
			
			formats[p_id] = null;
			delete formats[p_id];
		}
		
		/**
		 * Unregister all formats.
		 */
		public static function removeAll():void{
			for(var id:* in formats){
				formats[id] = null;
				delete formats[id];
			}
		}
	}
}