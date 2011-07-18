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
	 * The <code>ValidateUtils</code> class have validation methods for <code>String</code> object.
	 * @see String
	 */	
	public class ValidateUtils{
		
		
		/**
		 * Checks if the string is a url value like http://www.sweatless.as
		 * @param p_value The <code>String</code> to validate.
		 * @return The resulting <code>Boolean</code> object.
		 * @see String
		 * @see Boolean
		 * @see RegExp
		 */
		public static function isUrl(p_value:String):Boolean {
			var validate : RegExp = /^http(s)?:\/\/((\d+\.\d+\.\d+\.\d+)|(([\w-]+\.)+([a-z,A-Z][\w-]*)))(:[1-9][0-9]*)?(\/([\w-.\/:%+@&=]+[\w- .\/?:%+@&=]*)?)?(#(.*))?$/i;
			return validate.test(p_value);
		}
		
		
		/**
		 * Checks if the string is a email value like xxx@xxxx.xxx
		 * @param p_value The <code>String</code> to validate.
		 * @return The resulting <code>Boolean</code> object.
		 * @see String
		 * @see Boolean
		 * @see RegExp
		 */
		public static function isEmail(p_value:String):Boolean {
			var validate : RegExp = /([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})/gi;
			return validate.test(p_value);
		}
		
		
		/**
		 * Checks if the string is a full name value like xx x
		 * @param p_value The <code>String</code> to validate.
		 * @return The resulting <code>Boolean</code> object.
		 * 
		 */
		public static function isFullName(p_value:String):Boolean{
			var validate : RegExp = new RegExp(/\S{2,}( \S+)+/);
			return validate.test(p_value);
		}
		
		
		/**
		 * Checks if the string is a cpf value xxx.xxx.xxx-xx
		 * @param p_value The <code>String</code> to validate.
		 * @return The resulting <code>Boolean</code> object.
		 * @see String
		 * @see Boolean
		 * @see RegExp
		 */
		public static function isCPF(p_value:String):Boolean {
			var validate:RegExp = /(\d{3}.?\d{3}.?\d{3}-?\d{2})/g;
			return validate.test(p_value);
		}
		
		
		/**
		 * Checks if the string is a date value like xx/xx/xxxx
		 * @param p_value The <code>String</code> to validate.
		 * @return The resulting <code>Boolean</code> object.
		 * @see String
		 * @see Boolean
		 * @see RegExp
		 */
		public static function isDate(p_value:String):Boolean {
			var validate:RegExp = /^(\d{1,2})\/(\d{1,2})\/(\d{2}|(19|20)\d{2})$/;
			return validate.test(p_value);
		}
		

		/**
		 * Checks if the string is a alphanumeric value like a~Z/0~9.
		 * @param p_value The <code>String</code> to validate.
		 * @return The resulting <code>Boolean</code> object.
		 * @see String
		 * @see Boolean
		 * @see RegExp
		 */
		public static function isAlphaNumeric(p_value:String):Boolean {
			var validate:RegExp = /^[a-zA-Z0-9]*$/;
			return validate.test(p_value);
		}
		
		/**
		 * Checks if the string is a numeric value.
		 * @param p_value The <code>String</code> to validate like 0~9.
		 * @return The resulting <code>Boolean</code> object.
		 * @see String
		 * @see Boolean
		 * @see RegExp
		 */
		public static function isNumeric(p_value:String):Boolean {
			var validate:RegExp = /^(0|[1-9][0-9]*)$/;
			return validate.test(StringUtils.replace(p_value, " ", ""));
		}
		/**
		 * Checks if the string is a strong password value.
		 * @param p_value The <code>String</code> to validate.
		 * @return The resulting <code>Boolean</code> object.
		 * @see String
		 * @see Boolean
		 * @see RegExp
		 */
		public static function isStrongPassword(p_value:String):Boolean {
			var validate:RegExp = /(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/;
			return validate.test(p_value);
		}
		
		

	}
}

