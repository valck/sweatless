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
			//source.removeEventListener(MouseEvent.MOUSE_OVER, over);
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