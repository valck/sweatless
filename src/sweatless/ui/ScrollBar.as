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
 * @author João Marquesini
 * 
 */

package sweatless.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sweatless.utils.MacMouseWheel;
	

	public class ScrollBar extends EventDispatcher
	{
		public static const MODE_VERTICAL:String = "vertical";
		public static const MODE_HORIZONTAL:String = "horizontal";
		
		private var originalLimits:Rectangle;
		private var scrollDragger:Sprite;
		private var scrollWheelScope:DisplayObject;
		private var mouseWheelEnabled:Boolean = false;
		private var scrollMode:String;
		
		
		public function ScrollBar(dragger:Sprite, limits:Rectangle, wheelScope:DisplayObject=null)
		{
			scrollDragger = dragger;
			originalLimits = limits;
			
			scrollMode = (originalLimits.width>originalLimits.height) ? MODE_HORIZONTAL : MODE_VERTICAL;
			
			mouseWheelEnabled = Boolean(wheelScope);
			
			scrollWheelScope = wheelScope;
			
			scrollDragger.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
			
			if(mouseWheelEnabled) wheelScope.addEventListener(MouseEvent.MOUSE_WHEEL, scrollHandler);
			
			if(mouseWheelEnabled) MacMouseWheel.init(scrollDragger.stage);
			
		}
		
		private function scrollHandler(e:MouseEvent):void{
			var scrollLimits:Rectangle = getLimits();
			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					scrollDragger.startDrag(false, scrollLimits);
					scrollDragger.stage.addEventListener(MouseEvent.MOUSE_UP, scrollHandler);
					scrollDragger.stage.addEventListener(MouseEvent.MOUSE_MOVE, scrollHandler);
					break;
				
				case MouseEvent.MOUSE_UP:
					scrollDragger.stage.removeEventListener(MouseEvent.MOUSE_UP, scrollHandler);
					scrollDragger.stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrollHandler);
					scrollDragger.stopDrag();
					break;
				
				case MouseEvent.MOUSE_MOVE:
					refreshScroll();
					break;
				
				case MouseEvent.MOUSE_WHEEL:
					percent = percent -0.01*e.delta;
					break;
			}
		}
		
		public function set percent(value:Number):void{
			if(value<0) value = 0;
			if(value>1) value = 1;
			var scrollLimits:Rectangle = getLimits();
			if(scrollMode == MODE_VERTICAL) scrollDragger.y = scrollLimits.y + value*scrollLimits.height
				else scrollDragger.x = scrollLimits.x + value*scrollLimits.width;
			refreshScroll();
		}
		
		private function refreshScroll():void{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get percent():Number{
			var scrollLimits:Rectangle = getLimits();
			if(scrollMode == MODE_VERTICAL){
				return (scrollDragger.y-scrollLimits.y)/(scrollLimits.height);
			} 
		 	return (scrollDragger.x-scrollLimits.x)/(scrollLimits.width);
		}
		
		private function getLimits():Rectangle{
			if(scrollMode== MODE_VERTICAL) return new Rectangle(originalLimits.x,originalLimits.y, 0, originalLimits.height - scrollDragger.height);
			return new Rectangle(originalLimits.x,originalLimits.y, originalLimits.width - scrollDragger.width, 0);
		}
		
		public function destroy():void{
	
			scrollDragger.stage.removeEventListener(MouseEvent.MOUSE_UP, scrollHandler);
			scrollDragger.stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrollHandler);
			scrollDragger.removeEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
			if(scrollWheelScope) scrollWheelScope.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollHandler);
			
			originalLimits= null;
			scrollDragger =null;
			scrollWheelScope=null;
			scrollMode=null;
		}
	}
}
