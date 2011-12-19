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

package sweatless.effects {

	import sweatless.utils.NumberUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	
	/**
	 * 
	 * The Pixelate class is a easily way to creates a pixelated effect.
	 * 
	 * @see BitmapData()
	 * 
	 */
	public class Pixelate{
		
		private var source : BitmapData;
		private var clone : BitmapData;
		private var pixelated : BitmapData;
		
		private var _size : Number;
		
		public function Pixelate(){
		
		}
		
		/**
		 * Sets the source to apply the effect and return a new bitmap.
		 *  
		 * @param p_source The source.
		 * @param p_size The initial size of pixels in display.
		 * @return Bitmap
		 * 
		 * @see Bitmap
		 * 
		 */
		public function bitmap(p_source:DisplayObject, p_size:Number=1):Bitmap{
			drawFrame(p_source);
			size = p_size;

			return new Bitmap(source);
		}
		
		private function drawFrame(p_source:DisplayObject):void{
			source = getBitmapData(p_source);
			clone = getBitmapData(p_source);
		};
		
		/**
		 *
		 * Sets/Get a size of pixels in display.
		 *   
		 * @return Number
		 * @default 1
		 * 
		 */
		public function get size():Number{
			return _size;
		}
		
		public function set size(p_value:Number):void{
			if(p_value<=0 || p_value>source.width/2){
				throw new Error("The value must be above 0 and below of overall half of width of the source.");
			}else{
				_size = p_value;
				render();
			}
		}
		
		/**
		 * 
		 * Destroy the all dependencies of effect.
		 * 
		 * @see BitmapData#dispose()
		 * 
		 */
		public function destroy():void{
			source.dispose();
			clone.dispose();
			pixelated.dispose();
			
			source = null;
			clone = null;
			pixelated = null;
		}
		
		private function getBitmapData(p_target:DisplayObject):BitmapData{
		    var bmp : BitmapData = new BitmapData(p_target.width, p_target.height);
			bmp.draw(p_target);

			return bmp;
		};
		
		private function render():void{
			var scale : Number = 1 / _size;
			var width : int = (scale * source.width) > 0 || (scale * source.width) < 2880 ? NumberUtils.isZero(int(scale * source.width)) ? 1 : (scale * source.width) > 2880 ? 2880 : (scale * source.width) : 1;
			var height : int = (scale * source.height) > 0 || (scale * source.height) < 2880 ? NumberUtils.isZero(int(scale * source.height)) ? 1 : (scale * source.height) > 2880 ? 2880 : (scale * source.height) : 1;
			
			var pxMtx : Matrix = new Matrix();
			pxMtx.identity();
			pxMtx.scale(scale, scale);
			
			pixelated = new BitmapData(width, height);
			pixelated.draw(clone, pxMtx);
			
			var mtx : Matrix = new Matrix();
			mtx.identity();
			mtx.scale(source.width/pixelated.width, source.height/pixelated.height);
			
			source.draw(pixelated, mtx);
		}
	}
}