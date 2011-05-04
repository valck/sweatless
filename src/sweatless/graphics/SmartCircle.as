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

package sweatless.graphics {

	import sweatless.utils.NumberUtils;

	import flash.geom.Point;
	
	/**
	 * The <code>SmartCircle</code> is a simple circle graphic, this extends the internal class <code>Graphic</code>, with this you can set the line style, fill and gradient fill, or fill texture easily.
	 * 
	 * @see Graphic
	 */
	public class SmartCircle extends Graphic{
		
		private var _initialAngle:Number;
		private var _finalAngle:Number;
		
		/**
		 * The <code>SmartCircle</code> is a simple triangle graphic, this extends the internal class <code>Graphic</code>, with this you can set the line style, fill and gradient fill, or fill texture easily.
		 * 
		 * @param p_width The width of the triangle (in pixels). 
		 * @param p_height The height of the triangle (in pixels).
		 *  
		 * @see Graphic
		 */
		public function SmartCircle(p_width:Number = 0, p_height:Number = 0, p_initialAngle:Number=0, p_finalAngle:Number=360){
			super(p_width, p_height);
			finalAngle = p_finalAngle;
			initialAngle = p_initialAngle;
		}
		
		/**
		 *
		 * Adds a vector graphic. 
		 * 
		 */
		override protected function addGraphic():void{
			if(Math.abs(_finalAngle - _initialAngle) >=360){
				graphics.drawEllipse(0, 0, width, height);
			}else{
				var centerPoint:Point = new Point(width/2, height/2);
				graphics.moveTo(centerPoint.x, centerPoint.y);
				for(var i:Number = _initialAngle; i<=_finalAngle; i++) 
					graphics.lineTo(centerPoint.x + Math.cos(NumberUtils.toRadians(i))*width/2, centerPoint.y + Math.sin(NumberUtils.toRadians(i))*height/2);
				graphics.lineTo(centerPoint.x, centerPoint.y);
			}
		}
		
		
		/**
		 * The initialAngle to start drawing the circle. Defaults to 0. 
		 */
		public function get initialAngle() : Number {
			return _initialAngle + 90;
		}
		
		/**
		 * The initial angle to start drawing the circle. Defaults to 0. 
		 */
		public function set initialAngle(initialAngle : Number) : void {
			_initialAngle = initialAngle - 90;
			update();
		}

		/**
		 * The final angle to close the circle. Defaults to 360. 
		 */
		public function get finalAngle() : Number {
			return _finalAngle + 90;
		}
		
		/**
		 * The final angle to close the circle. Defaults to 360. 
		*/
		public function set finalAngle(finalAngle : Number) : void {
			_finalAngle = finalAngle - 90;
			update();
		}	
	}
}
