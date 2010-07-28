
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
		private var stage:Stage;
		
		
		public function ScrollBar(dragger:Sprite, limits:Rectangle, wheelScope:DisplayObject=null)
		{
			scrollDragger = dragger;
			originalLimits = limits;
			
			stage = dragger.stage;
			
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
					stage.addEventListener(MouseEvent.MOUSE_UP, scrollHandler);
					stage.addEventListener(MouseEvent.MOUSE_MOVE, scrollHandler);
					break;
				
				case MouseEvent.MOUSE_UP:
					stage.removeEventListener(MouseEvent.MOUSE_UP, scrollHandler);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrollHandler);
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
	
			stage.removeEventListener(MouseEvent.MOUSE_UP, scrollHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrollHandler);
			scrollDragger.removeEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
			if(scrollWheelScope) scrollWheelScope.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollHandler);
			
			originalLimits= null;
			scrollDragger =null;
			scrollWheelScope=null;
			scrollMode=null;
			stage=null;
		}
	}
}
