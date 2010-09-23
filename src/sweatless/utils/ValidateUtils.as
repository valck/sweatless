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
	public class ValidateUtils{
		public static function isUrl(p_value:String):Boolean {
			var validate : RegExp = /^http(s)?:\/\/((\d+\.\d+\.\d+\.\d+)|(([\w-]+\.)+([a-z,A-Z][\w-]*)))(:[1-9][0-9]*)?(\/([\w-.\/:%+@&=]+[\w- .\/?:%+@&=]*)?)?(#(.*))?$/i;
			return validate.test(p_value);
		}

		public static function isEmail(p_value:String):Boolean {
			var validate : RegExp = /([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})/gi;
			return validate.test(p_value);
		}

		public static function isCPF(p_value:String):Boolean {
			var validate:RegExp = /(\d{3}.?\d{3}.?\d{3}-?\d{2})/g;
			return validate.test(p_value);
		}

	}
}

