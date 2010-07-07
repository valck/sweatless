package sweatless.ui{
	import flash.events.Event;
	
	import sweatless.graphics.CommonRectangle;
	import sweatless.navigation.basics.BasicLoading;

	public class LoaderBar extends BasicLoading{
		
		private var bar : CommonRectangle;
		private var background : CommonRectangle;

		private var backgroundColor : uint;
		private var barColor : uint;
		
		public function LoaderBar(p_bar_color:uint=0xffffff, p_background_color:uint=0x333333){
			barColor = p_bar_color;
			backgroundColor = p_background_color;
			
			addEventListener(Event.ADDED_TO_STAGE, create);
 		}
		
		override public function create(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, create);
			
			background = new CommonRectangle();
			addChild(background);
			background.colors = [backgroundColor];
			
			bar = new CommonRectangle();
			addChild(bar);
			bar.colors = [barColor];

			bar.width = background.width = 200;
			bar.height = background.height = 1;
			
			bar.scaleX = 0;
			
			alpha = 0;
		}
		
		override public function show():void{
			alpha = 1;
		}
		
		override public function hide():void{
			alpha = 0;
		}
		
		override public function set progress(p_progress:Number):void{
			bar.scaleX = p_progress
			super.progress = p_progress;
		}

		override public function destroy():void{
			bar.destroy();
			background.destroy();
			
			if(stage) parent.removeChild(this);
		}
	}
}