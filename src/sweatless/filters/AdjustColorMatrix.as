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
 
 package sweatless.filters {

	import flash.filters.ColorMatrixFilter;
	public class AdjustColorMatrix {
		private var array : Array;
		private var _hue : Number;
		private var _saturation : Number;
		private var _brightness : Number;
		private var _contrast : Number;
		private static const DELTA_INDEX : Array = [0, 0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1, 0.11, 0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24, 0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42, 0.44, 0.46, 0.48, 0.5, 0.53, 0.56, 0.59, 0.62, 0.65, 0.68, 0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98, 1.0, 1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54, 1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0, 2.12, 2.25, 2.37, 2.50, 2.62, 2.75, 2.87, 3.0, 3.2, 3.4, 3.6, 3.8, 4.0, 4.3, 4.7, 4.9, 5.0, 5.5, 6.0, 6.5, 6.8, 7.0, 7.3, 7.5, 7.8, 8.0, 8.4, 8.7, 9.0, 9.4, 9.6, 9.8, 10.0];
		private static const IDENTITY : Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
		
		/** 
	 	* The <code>AdjustColorMatrix</code> class is a wrapper to be used with the native ColorMatrixFilter class.
	 	* @param hue The hue value to be applied to the image. The value can be in the range from -180 to 180.
	 	* @param saturation The saturation value to be applied to the image. This value can be in the range from -100 to 100.
	 	* @param brightness The brightness value to be applied to the image. This value can be in the range from -100 to 100.
	 	* @param contrast The contrast value to be applied to the image. This value can be in the range from -100 to 100. 
	 	*/
		public function AdjustColorMatrix(hue : Number = 0, saturation : Number = 0, brightness : Number = 0, contrast : Number = 0) {
			array = AdjustColorMatrix.IDENTITY.slice();
			
			this.hue = hue;
			this.saturation = saturation;
			this.brightness = brightness;
			this.contrast = contrast;
		}
		
		/**
		 * Returns the matrix to be used with the <code>ColorMatrixFilter</code> class.
		 */
		public function get matrix():Array{
			return array.slice();
		}
		
		/**
		 * Returns a <code>ColorMatrixFilter</code> instance with the values already applied.
		 */
		public function get filter():ColorMatrixFilter{
			return new ColorMatrixFilter(this.array);
		}

		/**
		 * The hue value to be applied to the image. The value can be in the range from -180 to 180.
		 */
		public function get hue() : Number { return _hue;}

		/**
		 * The hue value to be applied to the image. The value can be in the range from -180 to 180.
		 */
		public function set hue(hue : Number) : void {
			_hue = limit(hue, 180) / 180 * Math.PI;
			if (_hue == 0 || isNaN(_hue)) {
				return;
			}
			var cosVal : Number = Math.cos(_hue);
			var sinVal : Number = Math.sin(_hue);
			var lumR : Number = 0.213;
			var lumG : Number = 0.715;
			var lumB : Number = 0.072;
			multiply([lumR + cosVal * (1 - lumR) + sinVal * (-lumR), lumG + cosVal * (-lumG) + sinVal * (-lumG), lumB + cosVal * (-lumB) + sinVal * (1 - lumB), 0, 0, lumR + cosVal * (-lumR) + sinVal * (0.143), lumG + cosVal * (1 - lumG) + sinVal * (0.140), lumB + cosVal * (-lumB) + sinVal * (-0.283), 0, 0, lumR + cosVal * (-lumR) + sinVal * (-(1 - lumR)), lumG + cosVal * (-lumG) + sinVal * (lumG), lumB + cosVal * (1 - lumB) + sinVal * (lumB), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		}

		/**
		 * The saturation value to be applied to the image. The value can be in the range from -100 to 100.
		 */
		public function get saturation() : Number {return _saturation;}
		
		/**
		 * The saturation value to be applied to the image. The value can be in the range from -100 to 100.
		 */
		public function set saturation(saturation : Number) : void {
			_saturation = limit(saturation, 100);
			if (_saturation == 0 || isNaN(_saturation)) {
				return;
			}
			var x : Number = 1 + ((_saturation > 0) ? 3 * _saturation / 100 : _saturation / 100);
			var lumR : Number = 0.3086;
			var lumG : Number = 0.6094;
			var lumB : Number = 0.0820;
			multiply([lumR * (1 - x) + x, lumG * (1 - x), lumB * (1 - x), 0, 0, lumR * (1 - x), lumG * (1 - x) + x, lumB * (1 - x), 0, 0, lumR * (1 - x), lumG * (1 - x), lumB * (1 - x) + x, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		}
		
		/**
		 * The brightness value to be applied to the image. The value can be in the range from -100 to 100.
		 */
		public function get brightness() : Number {return _brightness;}

		/**
		 * The brightness value to be applied to the image. The value can be in the range from -100 to 100.
		 */
		public function set brightness(brightness : Number) : void {
			_brightness = limit(brightness, 100);
			if (_brightness == 0 || isNaN(_brightness)) {
				return;
			}
			multiply([1, 0, 0, 0, _brightness, 0, 1, 0, 0, _brightness, 0, 0, 1, 0, _brightness, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		}

		/**
		 * The contrast value to be applied to the image. The value can be in the range from -100 to 100.
		 */
		public function get contrast() : Number {return _contrast;}

		/**
		 * The contrast value to be applied to the image. The value can be in the range from -100 to 100.
		 */
		public function set contrast(contrast : Number) : void {
			_contrast = limit(contrast, 100);
			if (_contrast == 0 || isNaN(_contrast)) {
				return;
			}
			var x : Number;
			if (_contrast < 0) {
				x = 127 + _contrast / 100 * 127;
			} else {
				x = _contrast % 1;
				if (x == 0) {
					x = DELTA_INDEX[_contrast];
				} else {
					x = DELTA_INDEX[(_contrast << 0)] * (1 - x) + DELTA_INDEX[(contrast << 0) + 1] * x;
				}
				x = x * 127 + 127;
			}
			multiply([x / 127, 0, 0, 0, 0.5 * (127 - x), 0, x / 127, 0, 0, 0.5 * (127 - x), 0, 0, x / 127, 0, 0.5 * (127 - x), 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		}

		private function limit(value : Number, limit : Number) : Number {
			return Math.min(limit, Math.max(-limit, value));
		}
		
		private function multiply(matrix : Array) : void {
			var col : Array = [];
			for (var i : Number = 0;i < 5;i++) {
				for (var j : Number = 0;j < 5;j++) {
					col[j] = array[j + i * 5];
				}
				for (j = 0;j < 5;j++) {
					var val : Number = 0;
					for (var k : Number = 0;k < 5;k++) {
						val += matrix[j + k * 5] * col[k];
					}
					array[j + i * 5] = val;
				}
			}
		}
	}
}