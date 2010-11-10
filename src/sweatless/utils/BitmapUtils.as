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

package sweatless.utils{
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
	public class BitmapUtils{
		
		
		/**
		 * Draws the target <code>DisplayObject</code> into a <code>Bitmap</code>. 
		 * @param p_target The <code>DisplayObject</code> to be drawn.
		 * @param p_margin The margin to be added to the <code>DisplayObject</code> width and height.
		 * @param p_smoothing Defines if the resulting <code>Bitmap</code> should be smoothed or not.
		 * @param p_remove Defines if the target <code>DisplayObject</code> should be removed from stage or not.
		 * @return The resulting <code>Bitmap</code> object.
		 * @see flash.display.DisplayObject
		 * @see flash.display.BitmapData
		 * @see flash.display.Bitmap
		 */
		public static function convertToBitmap(p_target:DisplayObject, p_margin:int=5, p_smoothing:Boolean=true, p_remove:Boolean=true):Bitmap{
			var qualityStage : String;
			
			if(p_target.stage){
				qualityStage = p_target.stage.quality;
				p_target.stage.quality = StageQuality.BEST;
			}
			
			var targetToDraw : BitmapData = new BitmapData(p_target.width+p_margin, p_target.height+p_margin, true, 0x00000000);
			targetToDraw.draw(p_target, null, null, null, null, true);
			
			var targetDrawed : Bitmap = new Bitmap(targetToDraw, PixelSnapping.ALWAYS, true);
			if(p_target.stage) p_target.stage.quality = qualityStage;
			
			targetDrawed.name = p_target.name;
			targetDrawed.x = p_target.x;
			targetDrawed.y = p_target.y;
			targetDrawed.smoothing = p_smoothing;
			
			if(p_remove){
				if(p_target.stage){
					p_target.parent.removeChild(p_target);
				};
			}

			return targetDrawed;
		}
		
		/*
		Checks whether the bitmap is empty or not. In this case, empty means a BitmapData with a single color.
		*/
		public static function isEmptyBitmapData(p_bmp:BitmapData):Boolean{
			var width : int = p_bmp.width;
			var height : int = p_bmp.height;
			
			var last : uint;
			var color : uint;
			var first : Boolean;
			
			xAxis: for(var x:int = 0; x<width; x++){
				yAxis: for(var y:int = 0; y<height; y++){
					
					first = x == 0 && y == 0;
					color = p_bmp.getPixel(x, y);
					
					if(!first && last != color) {
						break xAxis;
						break yAxis;
						return false;
					}
					last = color;
				}
			}
			return true;	
		}

		
		
		public static function specialHitTestObject(p_target:DisplayObject, target2:DisplayObject, accuracy:Number = 1 ):Boolean{
			return specialIntersectionRectangle(p_target, target2, accuracy).width != 0;
        }
        
        public static function intersectionRectangle( target1:DisplayObject, target2:DisplayObject ):Rectangle{
            if( !target1.root || !target2.root || !target1.hitTestObject( target2 ) ) return new Rectangle();
            
            var bounds1:Rectangle = target1.getBounds( target1.root );
            var bounds2:Rectangle = target2.getBounds( target2.root );
            
            var intersection:Rectangle = new Rectangle();
            intersection.x = Math.max( bounds1.x, bounds2.x );
            intersection.y = Math.max( bounds1.y, bounds2.y );
            intersection.width = Math.min( ( bounds1.x + bounds1.width ) - intersection.x, ( bounds2.x + bounds2.width ) - intersection.x );
            intersection.height = Math.min( ( bounds1.y + bounds1.height ) - intersection.y, ( bounds2.y + bounds2.height ) - intersection.y );
			
            return intersection;
        }
        
        public static function specialIntersectionRectangle( target1:DisplayObject, target2:DisplayObject, accuracy:Number = 1 ):Rectangle{            
            if( accuracy <= 0 ) throw new Error( "ArgumentError: Error #5001: Invalid value for accuracy", 5001 );
            
            if( !target1.hitTestObject( target2 ) ) return new Rectangle();
            
            var hitRectangle:Rectangle = intersectionRectangle( target1, target2 );
            if( hitRectangle.width * accuracy < 1 || hitRectangle.height * accuracy < 1 ) return new Rectangle();
            
            var bitmapData:BitmapData = new BitmapData( hitRectangle.width * accuracy, hitRectangle.height * accuracy, false, 0x000000 );    
			
            bitmapData.draw( target1, BitmapUtils.getDrawMatrix( target1, hitRectangle, accuracy ), new ColorTransform( 1, 1, 1, 1, 255, -255, -255, 255 ) );
            bitmapData.draw( target2, BitmapUtils.getDrawMatrix( target2, hitRectangle, accuracy ), new ColorTransform( 1, 1, 1, 1, 255, 255, 255, 255 ), BlendMode.DIFFERENCE );
            
            var intersection:Rectangle = bitmapData.getColorBoundsRect( 0xFFFFFFFF,0xFF00FFFF );
            
            bitmapData.dispose();
            
            if( accuracy != 1 ){
                intersection.x /= accuracy;
                intersection.y /= accuracy;
                intersection.width /= accuracy;
                intersection.height /= accuracy;
            }
            
            intersection.x += hitRectangle.x;
            intersection.y += hitRectangle.y;
            
            return intersection;
        }
        
        private static function getDrawMatrix( p_target:DisplayObject, hitRectangle:Rectangle, accuracy:Number ):Matrix{
            var localToGlobal:Point;;
            var matrix:Matrix;
            
            var rootConcatenatedMatrix:Matrix = p_target.root.transform.concatenatedMatrix;
            
            localToGlobal = p_target.localToGlobal( new Point( ) );
            matrix = p_target.transform.concatenatedMatrix;
            matrix.tx = localToGlobal.x - hitRectangle.x;
            matrix.ty = localToGlobal.y - hitRectangle.y;
            
            matrix.a = matrix.a / rootConcatenatedMatrix.a;
            matrix.d = matrix.d / rootConcatenatedMatrix.d;
            if ( accuracy != 1 ) matrix.scale( accuracy, accuracy );
			
            return matrix;
        }		
		
	}
}