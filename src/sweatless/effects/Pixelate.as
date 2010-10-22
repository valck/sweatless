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
	import com.greensock.TweenMax;
	
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
		
		public function create(p_source:Bitmap, p_amount:Number=0):void{
			source = p_source.bitmapData;
			clone = BitmapUtils.convertToBitmap(p_source).bitmapData;
			
			amount = p_amount;
		}
		
		public function get pixelize():Number{
			return amount;
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
		
		public function start(p_to:DisplayObject):void{
			var scopeIn : DisplayObjectContainer = p_to.parent;
			
			var bmpIn : Bitmap = BitmapUtils.convertToBitmap(p_to, 0, false);
			
			create(bmpIn, bmpIn.width);
			scopeIn.addChild(bmpIn);
			
			
			setInterval(render, 1);
			
			return
			TweenMax.to(this, 2,{
				pixelize:10,
				yoyo:true,
				repeat:1,
				onComplete:destroy
			});
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