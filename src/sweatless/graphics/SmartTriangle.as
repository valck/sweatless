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

package sweatless.graphics{
	import flash.geom.Point;
	
	/**
	 * The <code>SmartTriangle</code> is a simple triangle graphic, this extends the internal class <code>Graphic</code>, with this you can set the line style, fill and gradient fill, or fill texture easily.
	 * 
	 * @see Graphic
	 */
	public class SmartTriangle extends Graphic{
		
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		private var _direction:String = UP;
		
		/**
		 * The <code>SmartTriangle</code> is a simple triangle graphic, this extends the internal class <code>Graphic</code>, with this you can set the line style, fill and gradient fill, or fill texture easily.
		 * 
		 * @param p_width The width of the triangle (in pixels). 
		 * @param p_height The height of the triangle (in pixels).
		 *  
		 * @see Graphic
		 */
		public function SmartTriangle(p_width:Number = 0, p_height:Number = 0){
			super(p_width, p_height);
		}
		
		/**
		 *
		 * Adds a vector graphic. 
		 * 
		 */
		override protected function addGraphic():void{
			var yAxys:int = _direction == UP ? -1 : _direction == DOWN ? 1 : 0;
			var xAxys:int = _direction == LEFT ? -1 : _direction == RIGHT ? 1 : 0;
			var edge:Point = new Point((Math.max(0, xAxys) + Math.abs(yAxys)/2)*width, (Math.max(yAxys,0) + Math.abs(xAxys)/2)*height);
			var point1:Point = new Point((Math.abs(yAxys) + Math.abs(Math.min(0, xAxys)))*width, (Math.abs(Math.min(0, yAxys)) + Math.abs(xAxys)) * height);
			var point2:Point = new Point(Math.abs(Math.min(0, xAxys))*width,Math.abs(Math.min(0, yAxys))*height);
			graphics.moveTo(edge.x, edge.y);
			graphics.lineTo(point1.x, point1.y);
			graphics.lineTo(point2.x, point2.y);
			graphics.lineTo(edge.x, edge.y);
		}

		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			_direction = value;
			update();
		}

	}
}
