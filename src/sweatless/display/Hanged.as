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

package sweatless.display {
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sweatless.utils.NumberUtils;
	
	public class Hanged extends Sprite{
		
		private var source : DisplayObject;
		private var position : Point;
		
		public function Hanged(){
			
		}
		
		public function create(p_source:DisplayObject, p_offset:Number):void{
			source = p_source;
			addChild(source);
			
			position = new Point(source.x, source.y);

			rotationX = NumberUtils.rangeRandom(-p_offset, p_offset);
		}
		
		public function addListeners():void{
			source.addEventListener(MouseEvent.MOUSE_MOVE, over);
			source.addEventListener(MouseEvent.MOUSE_OUT, out);
		}
		
		public function removeListeners():void{
			source.removeEventListener(MouseEvent.MOUSE_MOVE, over);
			source.removeEventListener(MouseEvent.MOUSE_OUT, out);
		}
		
		public function swing():void{
			TweenMax.to(this, 5,{
				rotationX:0, 
				rotationY:0,
				ease:Elastic.easeOut
			});
			
			source.y = 0;
			
			TweenMax.to(source, 3,{
				y:position.y,
				ease:Elastic.easeOut
			});
		}
		
		private function over(evt:MouseEvent):void{
			TweenMax.to(this, 5,{
				rotationY:(evt.localX - position.x)/4,
				ease:Elastic.easeOut,
				onComplete:swing
			});
		}

		private function out(evt:MouseEvent):void{
			swing();
		}

		public function destroy():void{
			removeListeners();
			
			TweenMax.killTweensOf(this);
			TweenMax.killTweensOf(source);
		}
	}
}