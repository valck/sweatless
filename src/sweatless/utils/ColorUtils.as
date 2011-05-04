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

	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	/**
	 * The <code>ColorUtils</code> class have support methods for easier manipulation of 
	 * color values and <code>DisplayObject</code> color transformations.
	 * @see flash.display.DisplayObject
	 */	
	public class ColorUtils{
		
		
		/**
		 * Tints the target <code>DisplayObject</code> with the given color. 
		 * @param p_target The target <code>DisplayObject</code> to be tinted.
		 * @param p_color The hexadecimal color value the target <code>DisplayObject</code> should be tinted.
		 * @default is 4.294967295E9 for remove the colorTransform.
		 * @see flash.display.DisplayObject
		 */
		public static function setColor(p_target:DisplayObject, p_color:uint=4.294967295E9):void{
			var colorT : ColorTransform = new ColorTransform();
			colorT.color = p_color;
			
			(p_target).transform.colorTransform = p_color != 4.294967295E9 ? colorT : new ColorTransform();
		}
		
		/**
		 * Lighten the target color value with the given amount. 
		 * @param p_color The target hexadecimal color value to be lightened.
		 * @param p_amount The amount to be lightened. This value must be between 0 and 1.
		 * @return The resulting lightened hexadecimal value.
		 * 
		 */
		public static function toLighten(p_color:uint, p_amount:Number):uint{	
			var color : RGB = getRGB(p_color);
			
			color.r += (255 - color.r) * p_amount;
			color.g += (255 - color.g) * p_amount;
			color.b += (255 - color.g) * p_amount;
			
			return getHex(color.r, color.g, color.b);
		}
		
		/**
		 * Darken the target color value with the given amount. 
		 * @param p_color The target hexadecimal color value to be darkened.
		 * @param p_amount The amount to be darkened. This value must be between 0 and 1.
		 * @return The resulting darkened hexadecimal value.
		 * 
		 */
		public static function toDarken(p_color:uint, p_amount:Number):uint{
			var color : RGB = getRGB(p_color);

			color.r = color.r * (1 - p_amount);
			color.g = color.g * (1 - p_amount);
			color.b = color.b * (1 - p_amount);
			
			return getHex(color.r, color.g, color.b);
		}
		
		
		/**
		 * Converts red, green and blue values to Hexadecimal format.  
		 * @param p_r The red value of the color. This value must be between 0 and 255.
		 * @param p_g The green value of the color. This value must be between 0 and 255.
		 * @param p_b The blue value of the color. This value must be between 0 and 255.
		 * @return The given color converted to Hexadecimal format.
		 * 
		 */
		public static function getHex(p_r:uint, p_g:uint, p_b:uint):uint{
			return uint("0x" + (p_r<16 ? "0" : "") + p_r.toString(16) + (p_g<16 ? "0" : "") + p_g.toString(16) + (p_b<16 ? "0" : "") + p_b.toString(16));
		}
		
		
		/**
		 * Converts a Hexadecimal color value to red, green and blue values. 
		 * @param p_color The Hexadecimal value that should be converted.
		 * @return A <code>RGB</code> Object containing the red, green and blue values.
		 * @see RGB
		 */
		public static function getRGB(p_color:uint):RGB{
			return new RGB(p_color >> 16 & 0xFF, p_color >> 8 & 0xFF, p_color & 0xFF);
		}
	}
}

/**
 *	The RGB class is used to get red, green and blue values with the ColorUtils class.
 */
internal class RGB{
	private var _r : uint;
	private var _g : uint;
	private var _b : uint;
	
	public function RGB(p_r:uint=0, p_g:uint=0, p_b:uint=0){
		r = p_r;
		g = p_g;
		b = p_b;
	}
	
	
	/**
	 * The red color value. This value must be between 0 and 255.
	 */
	public function get r():uint{
		return _r;
	}
	
	public function set r(p_value:uint):void{
		_r = p_value;
	}
	
	/**
	 * The green color value. This value must be between 0 and 255.
	 */
	public function get g():uint{
		return _g;
	}
	
	public function set g(p_value:uint):void{
		_g = p_value;
	}
	
	/**
	 * The blue color value. This value must be between 0 and 255.
	 */
	public function get b():uint{
		return _b;
	}
	
	public function set b(p_value:uint):void{
		_b = p_value;
	}
	
	/**
	 * The value of the colors in string format.
	 * @return The value in {r:255, g:255, b:255} format. 
	 */
	public function toString():String{
		return "{r:" + r + ", g:" + g + ", b:" + b + "}";
	}
}