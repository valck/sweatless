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
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filters.BlurFilter;

	public class Noise{
		private var scope : DisplayObjectContainer;
		private var statics : Bitmap;
		private var _grayscale : Boolean = true;

		
		public function Noise(){
		}

		public function create(p_scope:DisplayObjectContainer, p_width:Number, p_height:Number, p_blur_x:Number=0, p_blur_y:Number=0):void{
			scope = p_scope;
			
			statics = new Bitmap(new BitmapData(p_width, p_height, true, 0x000000));
			scope.addChild(statics);
			
			if(p_blur_x || p_blur_y) statics.filters = [new BlurFilter(p_blur_x, p_blur_y, 2)]; 
		}
		
		public function get grayscale():Boolean{
			return _grayscale;
		}

		public function set grayscale(p_value:Boolean):void{
			_grayscale = p_value;
		}
		
		public function start():void{
			scope.addEventListener(Event.ENTER_FRAME, render);
		}
		
		public function stop():void{
			scope.removeEventListener(Event.ENTER_FRAME, render);
		}
		
		private function render(e:Event):void{
			statics.bitmapData.noise(int(Math.random() * int.MAX_VALUE), 0, 0xFFFFFF, BitmapDataChannel.ALPHA, grayscale);
		}
		
		public function destroy():void{
			stop();
			
			statics.bitmapData.dispose();
			scope.removeChild(statics);
		}				
	}
}
