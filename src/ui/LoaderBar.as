package sweatless.ui{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import sweatless.graphics.CommonRectangle;

	public class LoaderBar extends Sprite{
		
		private var bar : CommonRectangle;
		private var background : CommonRectangle;

		private var backgroundColor : uint;
		private var barColor : uint;
		
		public function LoaderBar(p_bar_color:uint=0xcccccc, p_background_color:uint=0xffffff){
			barColor = p_bar_color;
			backgroundColor = p_background_color;
			
			addEventListener(Event.ADDED_TO_STAGE, create);
 		}
		
		private function create(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, create);
			
			background = new CommonRectangle();
			addChild(background);
			background.colors = [backgroundColor];
			background.width = 200;
			background.height = 1;
			
			bar = new CommonRectangle();
			addChild(bar);
			bar.colors = [barColor];
			bar.width = 200;
			bar.height = 1;
			
			bar.scaleX = 0;
		}
		
		public function get progress():Number{
			return bar.scaleX;
		}
		
		public function set progress(p_progress:Number):void{
			p_progress >= 1 ? dispatchEvent(new Event(Event.COMPLETE)) : bar.scaleX = p_progress;
		}

		public function destroy():void{
			bar.destroy();
			background.destroy();
			
			if(stage) parent.removeChild(this);
		}
	}
}