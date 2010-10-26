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

package sweatless.display.graphics{
	
	/**
	 * The <code>SmartCircle</code> is a simple circle graphic, this extends the internal class <code>Graphic</code>, with this you can set the line style, fill and gradient fill, or fill texture easily.
	 * 
	 * @see Graphic
	 */
	public class SmartCircle extends Graphic{
		
		/**
		 * The <code>SmartCircle</code> is a simple triangle graphic, this extends the internal class <code>Graphic</code>, with this you can set the line style, fill and gradient fill, or fill texture easily.
		 * 
		 * @param p_width The width of the triangle (in pixels). 
		 * @param p_height The height of the triangle (in pixels).
		 *  
		 * @see Graphic
		 */
		public function SmartCircle(p_width:Number = 0, p_height:Number = 0){
			super(p_width, p_height);
		}
		
		override protected function addGraphic():void{
			graphics.drawEllipse(0, 0, width, height);
		}
	}
}
