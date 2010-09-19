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
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	public class ColorUtils{
		
		public static function setColor(p_target:DisplayObject, p_color:uint):void{
			var colorT : ColorTransform = new ColorTransform();
			colorT.color = p_color;
			
			(p_target).transform.colorTransform = colorT;
		}
		
		public static function toLighten(p_color:uint, p_amount:Number):uint{	
			var color : RGB = getRGB(p_color);
			
			color.r += (255 - color.r) * p_amount;
			color.g += (255 - color.g) * p_amount;
			color.b += (255 - color.g) * p_amount;
			
			return getHex(color.r, color.g, color.b);
		}
		
		public static function toDarken(p_color:uint, p_amount:Number):uint{
			var color : RGB = getRGB(p_color);

			color.r = color.r * (1 - p_amount);
			color.g = color.g * (1 - p_amount);
			color.b = color.b * (1 - p_amount);
			
			return getHex(color.r, color.g, color.b);
		}
		
		public static function getHex(p_r:uint, p_g:uint, p_b:uint):uint{
			return uint("0x" + (p_r<16 ? "0" : "") + p_r.toString(16) + (p_g<16 ? "0" : "") + p_g.toString(16) + (p_b<16 ? "0" : "") + p_b.toString(16));
		}
		
		public static function getRGB(p_color:uint):RGB{
			return new RGB(p_color >> 16 & 0xFF, p_color >> 8 & 0xFF, p_color & 0xFF);
		}
	}
}
import flash.utils.getQualifiedClassName;

internal class RGB{
	private var _r : uint;
	private var _g : uint;
	private var _b : uint;
	
	public function RGB(p_r:uint=0, p_g:uint=0, p_b:uint=0){
		r = p_r;
		g = p_g;
		b = p_b;
	}
	
	public function get r():uint{
		return _r;
	}
	
	public function set r(p_value:uint):void{
		_r = p_value;
	}
	
	public function get g():uint{
		return _g;
	}
	
	public function set g(p_value:uint):void{
		_g = p_value;
	}
	
	public function get b():uint{
		return _b;
	}
	
	public function set b(p_value:uint):void{
		_b = p_value;
	}
	
	public function toString():String{
		return "{r:" + r + ", g:" + g + ", b:" + b + "}";
	}
}