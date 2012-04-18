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
	import flash.geom.Point;
	
	/**
	 * The <code>NumberUtils</code> class have support methods for easier manipulation of
	 * the native <code>Number</code> Class.
	 * @see Number
	 */
	public class NumberUtils{
		
		/**
		 * Checks whether the <code>Number</code> is an even number.
		 * @param p_value The <code>Number</code> to check.
		 * @return The resulting <code>Boolean</code> object.
		 * @see Number
		 * @see Boolean
		 */
		public static function isEven(p_value:Number):Boolean{
			return (p_value%2==0) ? true : false;
		}
		
		/**
		 * Checks whether the <code>Number</code> is zero.
		 * @param p_value The <code>Number</code> to check.
		 * @return The resulting <code>Boolean</code> object.
		 * @see Number
		 * @see Boolean
		 */
		public static function isZero(p_value:Number):Boolean{
			return Math.abs(p_value) < 0.00001;
		}
		
		/**
		 * Returns the value in percent of a <code>Number</code>.
		 * @param p_value The <code>Number</code> to check.
		 * @param p_min The <code>Number</code> of lower limit.
		 * @param p_max The <code>Number</code> of higher limit.
		 * @return The resulting <code>Number</code> object.
		 * @see Number
		 */
		public static function toPercent(p_value:Number, p_min:Number, p_max:Number):Number{
			return ((p_value - p_min) / (p_max - p_min)) * 100;
		}
		
		/**
		 * Returns the value in Number of a <code>percent</code>.
		 * @param p_percent The <code>Number</code> in percent to check.
		 * @param p_min The <code>Number</code> of lower limit.
		 * @param p_max The <code>Number</code> of higher limit.
		 * @return The resulting <code>Number</code> object.
		 * @see Number
		 */
		public static function percentToValue(p_percent:Number, p_min:Number, p_max:Number):Number{
			return ((p_max - p_min) * p_percent) + p_min;
		}

		 /**
		  * Returns bytes to formatted MB's string.
		  * @param p_bytes
		  * @return <code>String</code>
		  *
		  */
		public static function getBytesAsMegabytes(p_bytes:Number):String{
			return (Math.floor(((p_bytes / 1024 / 1024) * 100)) / 100)+" MB";
		}
		
		/**
		 * Generates a random number between two numbers.
		 * @param p_low The <code>Number</code> of lower limit.
		 * @param p_high The <code>Number</code> of higher limit.
		 * @param p_rounded Return a round number.
		 * @return The resulting <code>Number</code> object.
		 * @see Number
		 */
		public static function rangeRandom(p_low:Number, p_high:Number, p_rounded:Boolean=false):Number{
			return !p_rounded ? (Math.random() * (p_high - p_low)) + p_low : Math.round(Math.round(Math.random() * (p_high - p_low)) + p_low);
		}
		
		/**
		 * Getting the distance between two geographical points.
		 * @param p_from From coordinates <code>Points</code>.
		 * @param p_high To coordinates <code>Points</code>.
		 * @param p_units Mean radius of Earth in <code>String</code> (km, meters, feet and miles).
		 * @return The resulting the coordinates <code>Number</code>.
		 * @see Number
		 */
		public static function distanceBetweenCoordinates(p_from:Point, p_to:Point, p_units : String = "km") : Number {
			var radius : uint;
			switch(p_units){
				case "km":
					radius = 6371;
				break;
				case "meters":
					radius = 6378000;
				break;
				case "feet":
					radius = 20925525;
				break;
				case "miles":
					radius = 3963;
				break;
			}
			
			var dLatitude : Number = (p_to.x - p_from.x) * Math.PI / 180;
			var dLongitude : Number = (p_to.y - p_from.y) * Math.PI / 180;
			
			var a : Number = Math.sin(dLatitude / 2) * Math.sin(dLatitude / 2) + Math.sin(dLongitude / 2) * Math.sin(dLongitude / 2) * Math.cos(p_from.x * Math.PI / 180) * Math.cos(p_to.x * Math.PI / 180);
			var c : Number = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
			
			return radius * c;
		}
	}
}