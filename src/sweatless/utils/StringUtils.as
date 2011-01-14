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

package sweatless.utils {

	/**
	 * The <code>StringUtils</code> class have support methods for easier manipulation of
	 * the native <code>String</code> Class.
	 * @see String
	 */
	public class StringUtils {

		/**
		 * Check in a search in the string and returns whether it contains the sentence.
		 * @param p_str The <code>String</code> to validate.
		 * @param p_search The <code>String</code> to search in p_str.
		 * @return The resulting <code>Boolean</code> object.
		 * @see String
		 * @see Boolean
		 * @see RegExp
		 */
		public static function hasString(p_str:String, p_search:String):Boolean {
			return p_str.split(p_search).length != 1 ? true : false;
		}

		/**
		 * A basic method of replace a sentence in a String.
		 * @param p_str The <code>String</code> to search.
		 * @param p_search The <code>String</code> to search in p_str.
		 * @param p_replace The <code>String</code> to replace.
		 * @return The resulting <code>String</code> object.
		 * @see String
		 */
		public static function replace(p_str:String, p_search:String, p_replace:String):String {
			return p_str.split(p_search).join(p_replace);
		}

		/**
		 * A method to revert a content of a String.
		 * @param p_str The <code>String</code> to revert.
		 * @return The resulting <code>String</code> object.
		 * @see String
		 */
		public static function reverse(p_str:String):String {
			if (p_str == null) {
				return "";
			}

			return p_str.split("").reverse().join("");
		}

		/**
		 * A method to remove the white spaces in a String.
		 * @param p_str The <code>String</code> to remove the white spaces.
		 * @return The resulting <code>String</code> object.
		 * @see String
		 */
		public static function removeWhiteSpace(p_str:String):String {
			if (p_str == null) {
				return "";
			}

			return trim(p_str).replace(/\s+/g, " ");
		}
		
		/**
		 * A method to remove special characters in a String.
		 * @param p_str The <code>String</code> to remove the special characters.
		 * @return The resulting <code>String</code> object.
		 * @see String
		 */
		
		public static function removeSpecialChars(p_str:String):String{
			return p_str.replace(/[^a-zA-Z 0-9]+/g,'');
		}
		
		
		/**
		 * A method to convert a numeric string to brazillian CPF format. (###.###.###-##)
		 * @param p_str The <code>String</code> to format.
		 * @return The resulting <code>String</code> object.
		 * @see String
		 */
		public static function convertToCPF(p_str:String):String{
			p_str = removeSpecialChars(p_str);
			if(p_str.length>9){
				p_str = p_str.replace(/(\d{0,3})(\d{0,3})(\d{0,3})(\d{0,2})/,'$1' + "." + "$2" + "." + "$3" + "-" + "$4");
			}else if(p_str.length>6){
				p_str = p_str.replace(/(\d{0,3})(\d{0,3})(\d{0,3})(\d{0,2})/,'$1' + "." + "$2" + "." + "$3");
			}else if(p_str.length>3){
				p_str = p_str.replace(/(\d{0,3})(\d{0,3})(\d{0,3})(\d{0,2})/,'$1' + "." + "$2");
			}else{
				p_str = p_str.replace(/(\d{0,3})(\d{0,3})(\d{0,3})(\d{0,2})/,'$1');
			}
			return p_str;
		}
		
		/**
		 * A method to convert a numeric string to brazillian CEP format. (######-###)
		 * @param p_str The <code>String</code> to format.
		 * @return The resulting <code>String</code> object.
		 * @see String
		 */
		public static function convertToCEP(p_str:String):String{
			p_str = removeSpecialChars(p_str);
			if(p_str.length>5){
				p_str = p_str.replace(/(\d{0,5})(\d{0,3})/,'$1' + "-" + "$2");
			}else{
				p_str = p_str.replace(/(\d{0,5})(\d{0,3})/,'$1');
			}
			return p_str;
		}
		
		/**
		 * A method to convert a numeric string to date format. (##/##/####)
		 * @param p_str The <code>String</code> to format.
		 * @return The resulting <code>String</code> object.
		 * @see String
		 */
		public static function convertToDate(p_str:String):String{
			p_str = removeSpecialChars(p_str);
			if(p_str.length>4){
				p_str = p_str.replace(/(\d{0,2})(\d{0,2})(\d{0,4})/,'$1' + "/" + "$2" + "/" + "$3");
			}else if(p_str.length>2){
				p_str = p_str.replace(/(\d{0,2})(\d{0,2})(\d{0,4})/,'$1' + "/" + "$2");
			}else{
				p_str = p_str.replace(/(\d{0,2})(\d{0,2})(\d{0,4})/,'$1');
			}
			return p_str;
		}
		

		/**
		 * A method to check if the String is empty or null.
		 * @param p_str The <code>String</code> to remove the white spaces.
		 * @return The resulting <code>Boolean</code> object.
		 * @see String
		 * @see Boolean
		 */
		public static function isEmpty(p_str:String):Boolean {
			if (p_str == null || p_str == "") {
				return true;
			}

			return !p_str.length;
		}

		/**
		 * A method to capitalize case the String.
		 * @param p_str The <code>String</code> to capitalize case.
		 * @return The resulting <code>String</code> object.
		 * @see String
		 */
		public static function toCapitalizeCase(p_str:String, ... args):String {
			var str:String = trimLeft(p_str);

			return args[0] === true ? str.replace(/^.|\b./g, _upperCase) : str.replace(/(^\w)/, _upperCase);
		}

		/**
		 * A method to convert milisecounds (Number) in a String on time format.
		 * @param p_miliseconds The <code>Number</code> in milisecounds.
		 * @return The resulting <code>String</code> object.
		 * @see Number
		 * @see String
		 */
		public function toTimeFormat(p_miliseconds:Number):String {
			var minutes:Number = Math.floor(p_miliseconds / 60);
			var seconds:Number = Math.floor(p_miliseconds % 60);
			return String(minutes + ":" + seconds);
		}

		/**
		 * A method to convert a String in a HTML using the font tag with SmartCaps.
		 * @param p_str The <code>String</code> of text.
		 * @param minSize The <code>Number</code> of size of the smaller text.
		 * @param maxSize The <code>Number</code> of size of the bigger text.
		 * @return The resulting <code>String</code> object.
		 * @see Number
		 * @see String
		 * @see RegExp
		 */
		public static function toHTMLSmartCaps(p_str:String, minSize:int=10, maxSize:int=15):String {
			var pattern:RegExp = /[a-z]*?([A-Z])/g;
			var str:String = p_str.replace(pattern, "<font size='" + maxSize + "'>$1<font size='" + minSize + "'>");
			return str.toUpperCase();
		}

		/**
		 * A method to add a zero before if the p_value is smaller that 10 and bigger that -1.
		 * @param p_value The <code>Number</code>.
		 * @return The resulting <code>String</code> object.
		 * @see Number
		 * @see String
		 */
		public static function addDecimalZero(p_value:Number):String {
			var result:String = String(p_value);

			if (p_value < 10 && p_value > -1) {
				result="0" + result;
			}

			return result;
		}

		/**
		 * A method to abbreviate a String.
		 * @param p_str The <code>String</code> of text to abbreviate.
		 * @param p_max_length The <code>Number</code> of length to text.
		 * @param p_indicator The <code>String</code> of the end String.
		 * @param p_split The <code>String</code> to before p_indicator and after text.
		 * @return The resulting <code>String</code> object.
		 * @see Number
		 * @see String
		 * @todo Maybe we should use regex in this method.
		 */
		public static function abbreviate(p_str:String, p_max_length:Number=50, p_indicator:String='...', p_split:String=' '):String {
			if (p_str == null) {
				return "";
			}
			if (p_str.length < p_max_length) {
				return p_str;
			}

			var result:String='';
			var n:int = 0;
			var pieces:Array = p_str.split(p_split);

			var charCount:int = pieces[n].length;

			while (charCount < p_max_length && n < pieces.length) {
				result+=pieces[n] + p_split;

				charCount+=pieces[++n].length + p_split.length;
			}

			if (n < pieces.length) {
				// TODO - maybe we should use regex for this ?
				var badChars:Array=['-', '—', ',', '.', ' ', ':', '?', '!', ';', "\n", ' ', String.fromCharCode(10), String.fromCharCode(13)];
				while (badChars.indexOf(result.charAt(result.length - 1)) != -1) {
					result=result.slice(0, -1);
				}

				result=trim(result) + p_indicator;
			}

			if (n == 0) {
				result=p_str.slice(0, p_max_length) + p_indicator;
			}

			return result;
		}

		/**
		 * A method to convert a String to Boolean.
		 * @param p_str The <code>String</code>.
		 * @return The resulting <code>Boolean</code> object.
		 * @see String
		 * @see Boolean
		 */
		public static function toBoolean(p_str:String):Boolean {
			p_str=p_str.toLowerCase();

			return p_str == "yes" || p_str == "true" || p_str == "1" ? true : false;
		}

		private static function trim(p_str:String):String {
			if (p_str == null) {
				return "";
			}

			return p_str.replace(/^\s+|\s+$/g, "");
		}

		private static function trimLeft(p_str:String):String {
			if (p_str == null) {
				return "";
			}

			return p_str.replace(/^\s+/, "");
		}

		private static function _upperCase(p_char:String, ... args):String {
			return p_char.toUpperCase();
		}

	}
}