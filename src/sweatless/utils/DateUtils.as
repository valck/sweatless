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
 
package sweatless.utils {

	public class DateUtils {

		public static function countDays(p_start:Date, p_end:Date):String{
			var result : Number = p_end.time - p_start.time;
			
			var seconds : Number = Math.floor(result / 1000);
			var minutes : Number = Math.floor(seconds / 60);
			var hours : Number = Math.floor(minutes / 60);
			var days : Number = (Math.floor(hours / 24) - 31);
			
		    return result > 0 ? String(StringUtils.addDecimalZero(days) + ":" + StringUtils.addDecimalZero(hours % 24) + ":" + StringUtils.addDecimalZero(minutes % 60) + ":" + StringUtils.addDecimalZero(seconds % 60)) : "00:00:00:00";
		};

		/**
		 * Returns a string indicating whether the date represents a time in the ante meridiem (AM) or post meridiem (PM).
		 * @param p_hour the hour value in format <code>new Date()</code>
		 * @return The resulting <code>String</code> "PM" or "AM".
		 *
		 */
		public static function getAMPM(p_hour:Date):String {
	        return (p_hour.hours > 11) ? "PM" : "AM";
        };
		
		/**
		 * Returns a the current timestamp.
		 * @return The current <code>int</code> timestamp value.
		 *
		 */
		public static function getTimestamp():int{
			return new Date().time;
		}
		
		public static function get24hr(p_hour:Date):String{
			return StringUtils.addDecimalZero(p_hour.hours) + ":" + StringUtils.addDecimalZero(p_hour.minutes) + ":" + StringUtils.addDecimalZero(p_hour.seconds);
		};
		
		public static function get12hr(p_hour:Date):String{
			return StringUtils.addDecimalZero((p_hour.hours>12) ? p_hour.hours-12 : p_hour.hours) + ":" + StringUtils.addDecimalZero(p_hour.minutes) + ":" + StringUtils.addDecimalZero(p_hour.seconds);
		};
	}
}
