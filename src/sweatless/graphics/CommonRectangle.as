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

package sweatless.graphics{
	
	public class CommonRectangle extends CommonGraphic{
		
		private var TLCorner : Number = 0;
		private var TRCorner : Number = 0;
		private var BLCorner : Number = 0;
		private var BRCorner : Number = 0;
		
		public function CommonRectangle(p_width:Number = 100, p_height:Number = 100){
			super(p_width, p_height);
		}
		
		override protected function addGraphic():void{
			graphics.drawRoundRectComplex(0, 0, width, height, topLeftCorner, topRightCorner, bottomLeftCorner, bottomRightCorner);
		}
		
		public function set bothCorners(p_value:Number):void{
			TLCorner = p_value;
			TRCorner = p_value;
			BLCorner = p_value;
			BRCorner = p_value;
			update();
		}
		
		public function set topLeftCorner(p_value:Number):void{
			TLCorner = p_value;
			update();
		}
		
		public function get topLeftCorner():Number{
			return TLCorner;
		}
		
		public function set topRightCorner(p_value:Number):void{
			TRCorner = p_value;
			update();
		}
		
		public function get topRightCorner():Number{
			return TRCorner;
		}
		
		public function set bottomLeftCorner(p_value:Number):void{
			BLCorner = p_value;
			update();
		}
		
		public function get bottomLeftCorner():Number{
			return BLCorner;
		}
		
		public function set bottomRightCorner(p_value:Number):void{
			BRCorner = p_value;
			update();
		}
		
		public function get bottomRightCorner():Number{
			return BRCorner;
		}
	}
}
