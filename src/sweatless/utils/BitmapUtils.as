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
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.StageQuality;
	import flash.geom.ColorTransform;
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
		public static function convertToBitmap( p_target:DisplayObject, p_margin:int=5, p_smoothing:Boolean=true, p_remove:Boolean=true, p_crop:Rectangle=null ):Bitmap {
			var qualityStage:String;

			if ( p_target.stage ) {
				qualityStage=p_target.stage.quality;
				p_target.stage.quality=StageQuality.BEST;
			}

			if ( !p_crop ) {
				p_crop=new Rectangle( 0, 0, p_target.width, p_target.height );
			}

			var targetToDraw:BitmapData = new BitmapData( p_crop.width + p_margin, p_crop.height + p_margin, true, 0x00000000 );
			targetToDraw.draw( p_target, new Matrix( 1, 0, 0, 1, -p_crop.x, -p_crop.y ), null, null, null, true );

			var targetDrawed:Bitmap = new Bitmap( targetToDraw, PixelSnapping.ALWAYS, true );
			if ( p_target.stage ) {
				p_target.stage.quality=qualityStage;
			}

			targetDrawed.name=p_target.name;
			targetDrawed.x=p_target.x;
			targetDrawed.y=p_target.y;
			targetDrawed.smoothing=p_smoothing;

			if ( p_remove ) {
				if ( p_target.stage ) {
					p_target.parent.removeChild( p_target );
				};
			}

			return targetDrawed;
		}

		/**
		 * Checks whether the bitmap is empty or not. In this case, empty means a BitmapData with a single color.
		 * @param p_bmp The <code>BitmapData</code> to be check.
		 * @return The resulting <code>Boolean</code> object.
		 * @see BitmapData
		 */
		public static function isEmptyBitmapData( p_bmp:BitmapData ):Boolean {
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
		
		/**
		 * Check the Hit Test of two DisplayObjects with accuracy level.
		 * @param p_target The <code>DisplayObject</code> to check.
		 * @param p_target2 The <code>DisplayObject</code> to check.
		 * @param p_accuracy The accuracy<code>Number</code> to check.
		 * @return The resulting <code>Boolean</code> object.
		 * @see DisplayObject
		 * @see Number
		 */
		public static function specialHitTestObject( p_target:DisplayObject, p_target2:DisplayObject, p_accuracy:Number=1 ):Boolean {
			return specialIntersectionRectangle( p_target, p_target2, p_accuracy ).width != 0;
		}
		
		/**
		 * Check the intersection of two DisplayObjects.
		 * @param p_target The <code>DisplayObject</code> to check.
		 * @param p_target2 The <code>DisplayObject</code> to check.
		 * @return The resulting <code>Rectangle</code> object.
		 * @see DisplayObject
		 * @see Rectangle
		 */
		public static function intersectionRectangle( p_target:DisplayObject, p_target2:DisplayObject ):Rectangle {
			if ( !p_target.root || !p_target2.root || !p_target.hitTestObject( p_target2 )) {
				return new Rectangle();
			}

			var bounds1:Rectangle = p_target.getBounds( p_target.root );
			var bounds2:Rectangle = p_target2.getBounds( p_target2.root );

			var intersection:Rectangle = new Rectangle();
			intersection.x=Math.max( bounds1.x, bounds2.x );
			intersection.y=Math.max( bounds1.y, bounds2.y );
			intersection.width=Math.min(( bounds1.x + bounds1.width ) - intersection.x, ( bounds2.x + bounds2.width ) - intersection.x );
			intersection.height=Math.min(( bounds1.y + bounds1.height ) - intersection.y, ( bounds2.y + bounds2.height ) - intersection.y );

			return intersection;
		}
		
		/**
		 * Check the intersection of two DisplayObjects with accuracy level.
		 * @param p_target The <code>DisplayObject</code> to check.
		 * @param p_target2 The <code>DisplayObject</code> to check.
		 * @param p_accuracy The accuracy<code>Number</code> to check.
		 * @return The resulting <code>Rectangle</code> object.
		 * @see DisplayObject
		 * @see Rectangle
		 */
		public static function specialIntersectionRectangle( p_target:DisplayObject, p_target2:DisplayObject, p_accuracy:Number=1 ):Rectangle {
			if ( p_accuracy <= 0 ) {
				throw new Error( "ArgumentError: Error #5001: Invalid value for accuracy", 5001 );
			}

			if ( !p_target.hitTestObject( p_target2 )) {
				return new Rectangle();
			}

			var hitRectangle:Rectangle = intersectionRectangle( p_target, p_target2 );
			if ( hitRectangle.width * p_accuracy < 1 || hitRectangle.height * p_accuracy < 1 ) {
				return new Rectangle();
			}

			var bitmapData:BitmapData = new BitmapData( hitRectangle.width * p_accuracy, hitRectangle.height * p_accuracy, false, 0x000000 );

			bitmapData.draw( p_target, BitmapUtils.getDrawMatrix( p_target, hitRectangle, p_accuracy ), new ColorTransform( 1, 1, 1, 1, 255, -255, -255, 255 ));
			bitmapData.draw( p_target2, BitmapUtils.getDrawMatrix( p_target2, hitRectangle, p_accuracy ), new ColorTransform( 1, 1, 1, 1, 255, 255, 255, 255 ), BlendMode.DIFFERENCE );

			var intersection:Rectangle = bitmapData.getColorBoundsRect( 0xFFFFFFFF, 0xFF00FFFF );

			bitmapData.dispose();

			if ( p_accuracy != 1 ) {
				intersection.x/=p_accuracy;
				intersection.y/=p_accuracy;
				intersection.width/=p_accuracy;
				intersection.height/=p_accuracy;
			}

			intersection.x+=hitRectangle.x;
			intersection.y+=hitRectangle.y;

			return intersection;
		}

		private static function getDrawMatrix( p_target:DisplayObject, hitRectangle:Rectangle, accuracy:Number ):Matrix {
			var localToGlobal:Point;;
			var matrix:Matrix;

			var rootConcatenatedMatrix:Matrix = p_target.root.transform.concatenatedMatrix;

			localToGlobal=p_target.localToGlobal( new Point());
			matrix=p_target.transform.concatenatedMatrix;
			matrix.tx=localToGlobal.x - hitRectangle.x;
			matrix.ty=localToGlobal.y - hitRectangle.y;

			matrix.a=matrix.a / rootConcatenatedMatrix.a;
			matrix.d=matrix.d / rootConcatenatedMatrix.d;
			if ( accuracy != 1 ) {
				matrix.scale( accuracy, accuracy );
			}

			return matrix;
		}

	}
}