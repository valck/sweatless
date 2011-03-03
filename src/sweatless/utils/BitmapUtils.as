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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * The <code>BitmapUtils</code> class have support methods for easier manipulation of
	 * the native <code>Bitmap</code> and <code>BitmapData</code> classes.
	 * @see flash.display.Bitmap
	 * @see flash.display.BitmapData
	 */
	public class BitmapUtils {

		/**
		 * Draws the target <code>DisplayObject</code> into a <code>Bitmap</code>.
		 * @param p_target The <code>DisplayObject</code> to be drawn.
		 * @param p_margin The margin to be added to the <code>DisplayObject</code> width and height.
		 * @param p_smoothing Defines if the resulting <code>Bitmap</code> should be smoothed or not.
		 * @param p_remove Defines if the target <code>DisplayObject</code> should be removed from stage or not.
		 * @param p_crop The area to crop.
		 * @return The resulting <code>Bitmap</code> object.
		 * @see flash.display.DisplayObject
		 * @see flash.display.BitmapData
		 * @see flash.display.Bitmap
		 */
		public static function convertToBitmap(p_target:DisplayObject, p_margin:int=5, p_smoothing:Boolean=true, p_remove:Boolean=true, p_crop:Rectangle=null):Bitmap{
			var qualityStage:String;

			if(p_target.stage) {
				qualityStage = p_target.stage.quality;
				p_target.stage.quality = StageQuality.BEST;
			}
			
			if(!p_crop) p_crop = new Rectangle(0, 0, p_target.width, p_target.height);

			var targetToDraw : BitmapData = new BitmapData(p_crop.width + p_margin, p_crop.height + p_margin, true, 0x00000000);
			targetToDraw.draw(p_target, new Matrix( 1, 0, 0, 1, -p_crop.x, -p_crop.y ), null, null, null, true);

			var targetDrawed : Bitmap = new Bitmap(targetToDraw, PixelSnapping.ALWAYS, true);
			if(p_target.stage) p_target.stage.quality = qualityStage;

			targetDrawed.name=p_target.name;
			targetDrawed.x=p_target.x;
			targetDrawed.y=p_target.y;
			targetDrawed.smoothing=p_smoothing;

			if(p_remove && p_target.stage) p_target.parent.removeChild(p_target);

			return targetDrawed;
		}

		/**
		 * Checks whether the bitmap is empty or not. In this case, empty means a BitmapData with a single color.
		 * @param p_bmp The <code>BitmapData</code> to be check.
		 * @return The resulting <code>Boolean</code> object.
		 * @see BitmapData
		 */
		public static function isEmptyBitmapData(p_bmp:BitmapData):Boolean {
			var width:int = p_bmp.width;
			var height:int = p_bmp.height;

			var last:uint;
			var color:uint;
			var first:Boolean;

			xAxis: for ( var x:int = 0; x < width; x++ ) {
				yAxis: for ( var y:int = 0; y < height; y++ ) {

					first=x == 0 && y == 0;
					color=p_bmp.getPixel( x, y );

					if ( !first && last != color ) {
						break xAxis;
						break yAxis;
						return false;
					}
					last=color;
				}
			}
			return true;
		}
		
		public static function getDrawMatrix(p_target:Bitmap, p_hit:Rectangle, p_accuracy:Number):Matrix{
			var localToGlobal : Point;;
			var matrix : Matrix;

			var rootConcatenatedMatrix : Matrix = p_target.root.transform.concatenatedMatrix;

			localToGlobal = p_target.localToGlobal(new Point());
			
			matrix = p_target.transform.concatenatedMatrix;
			matrix.tx = localToGlobal.x - p_hit.x;
			matrix.ty = localToGlobal.y - p_hit.y;

			matrix.a = matrix.a / rootConcatenatedMatrix.a;
			matrix.d = matrix.d / rootConcatenatedMatrix.d;
			
			if(p_accuracy != 1) matrix.scale(p_accuracy, p_accuracy);

			return matrix;
		}
		
		public static function comparePixels(p_target:BitmapData, p_other:BitmapData, p_accuracy:Number=1):Boolean{
			var pixels : Number = 0;
			var commonPixels : Number = 0;
			
			xAxis:for(var x:int=0; x<p_target.width; x++) {
				yAxis:for(var y:int=0; y<p_target.height; y++) {
					pixels++;
					p_target.getPixel(y,x) == p_other.getPixel(y,x) ? commonPixels++ : null;
				}
			}

			return commonPixels/pixels >= p_accuracy ? true : false;
		}

	}
}