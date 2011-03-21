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
 * http://code.google.com/p/sweatless/
 * 
 * @author Valério Oliveira (valck)
 * 
 */
package sweatless.utils {

	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	
	/**
	 * The <code>TransformUtils</code> class have support methods to apply advanced transforms to
	 * the native <code>DisplayObject</code> Class.
	 * @see DisplayObject
	 */
	 
	public class TransformUtils {
		/**
		 * Rotate a <code>DisplayObject</code> around a given pivot <code>Point</code>.
		 * @param object The <code>DisplayObject</code> to be rotated.
		 * @param point The pivot point to rotate around.
		 * @param degrees The degrees of rotation to be applied.
		 */
		public static function rotateAroundPoint(object:DisplayObject, point:Point, degrees:Number):void{
			var distance:Number = Math.sqrt(Math.pow(point.x-object.x, 2) + Math.pow(point.y-object.y, 2));
			var currentAngle:Number = Math.atan2(object.y - point.y, object.x - point.x);
			var newAngle:Number = currentAngle + NumberUtils.toRadians(degrees-object.rotation);
			object.x = point.x + Math.cos(newAngle)*distance;
			object.y = point.y + Math.sin(newAngle)*distance;
			object.rotation = degrees;
		}
		
		
		/**
		 * Scale a <code>DisplayObject</code> around a given pivot <code>Point</code>.
		 * @param object The <code>DisplayObject</code> to be scale.
		 * @param point The pivot point to scale around.
		 * @param scale The scale factor to be applied.
		 */
		 
		public static function scaleAroundPoint(object:DisplayObject, point:Point, scale:Number):void{
			var distX:Number = (point.x-object.x)/object.scaleX;
			var distY:Number = (point.y-object.y)/object.scaleY;
			object.x = point.x - distX*scale;
			object.y = point.y - distY*scale;
			object.scaleX = object.scaleY = scale;
		}
				
		/**
		 * Flip horizontally or vertically a <code>DisplayObject</code>.
		 * @param p_target The <code>DisplayObject</code> to flip.
		 * @param p_horizontal Flip horizontally.
		 */
		public static function flip(p_target:DisplayObject, p_horizontal:Boolean=true):void{
			var matrix : Matrix = p_target.transform.matrix;
			
			matrix.transformPoint(new Point(p_target.width/2, p_target.height/2));
			
			if(p_horizontal){
				matrix.a = -1 * matrix.a;
				matrix.tx = matrix.a>0 ? p_target.width + p_target.x : p_target.x - p_target.width;
			}else {
				matrix.d = -1 * matrix.d;
				matrix.ty = matrix.d>0 ? p_target.height + p_target.y : p_target.y - p_target.height;
			}
			
			p_target.transform.matrix = matrix;
		}
		
		/**
		 * Flip horizontally or vertically a <code>DisplayObject</code>.
		 * @param p_target The <code>DisplayObject</code> to skew.
		 * @param p_x The <code>Number</code> of x property of p_target.
		 * @param p_y The <code>Number</code> of y property of p_target.
		 */
		public static function skew(p_target:DisplayObject, p_x:Number, p_y:Number):void{
			var matrix : Matrix = new Matrix();
			matrix.b = p_y * Math.PI/180;
			matrix.c = p_x * Math.PI/180;
			matrix.concat(p_target.transform.matrix);
			p_target.transform.matrix = matrix;
		}
		
	}
}
