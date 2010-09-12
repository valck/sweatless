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
	public class NumberUtils{
		public static function isEven(p_value:Number):Boolean{
			if (p_value%2==0) {
				return true;
			} else {
				return false;
			}
		}
		
		public static function isZero(p_value:Number):Boolean{
			return Math.abs(p_value) < 0.00001;
		}
		
		public static function toRadians(p_value:Number):Number{
			return p_value / 180 * Math.PI;
		}
		
		public static function toDegrees(p_value:Number):Number{
			return p_value * 180 / Math.PI;
		}
		
		public static function degreesToRadians(p_value:Number):Number{
			return (2 * Math.PI * p_value) / 360;
		}
		
		public static function toPercent(p_value:Number, p_min:Number, p_max:Number):Number{
			return ((p_value - p_min) / (p_max - p_min)) * 100;
		}
		
		public static function percentToValue(p_percent:Number, p_min:Number, p_max:Number):Number{
			return ((p_max - p_min) * p_percent) + p_min;
		}
		
		public static function rangeRandom(p_low:Number, p_high:Number, p_rounded:Boolean=false):Number{
			return !p_rounded ? (Math.random() * (p_high - p_low)) + p_low : Math.round(Math.round(Math.random() * (p_high - p_low)) + p_low);
		}
	}
}