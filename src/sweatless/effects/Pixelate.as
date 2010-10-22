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

package sweatless.effects{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.setInterval;
	
	import sweatless.utils.BitmapUtils;
	
	/**
	 * 
	 * @see BitmapData
	 * 
	 */
	public class Pixelate{
		
		private var source : BitmapData;
		private var clone : BitmapData;
		private var pixelated : BitmapData;
		
		private var amount : Number;
		private var temp : Number = 0;
		
		public function Pixelate(){
		}
		
		public function create(p_source:DisplayObject, p_amount:Number=0):void{
			var scope : DisplayObjectContainer = p_source.parent;
			var bmp : Bitmap = BitmapUtils.convertToBitmap(p_source, 0, false);
			
			source = bmp.bitmapData;
			clone = BitmapUtils.convertToBitmap(p_source, 0).bitmapData;
			
			scope.addChild(bmp);
			
			amount = p_amount;
			
			//setInterval(render, 10);
		}
		
		public function set pixelize(p_value:Number):void{
			amount = clone.width/p_value;
			amount>0 ? processing() : null;
		}
		
		public function destroy():void{
			source.dispose();
			clone.dispose();
			pixelated.dispose();
			
			source = null;
			clone = null;
			pixelated = null;
			
			amount = 0;
		}
		
		public function render():void{
			temp ++;
			pixelize = temp;
			
			trace(amount);
		}
		
		private function processing():void{
			var scale : Number = 1 / amount;
			var width : int = (scale * source.width) >= 1 ? (scale * source.width) : 1;
			var height : int = (scale * source.height) >= 1 ? (scale * source.height) : 1;
			
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