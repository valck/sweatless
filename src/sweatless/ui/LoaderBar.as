package sweatless.ui{
	import flash.events.Event;
	
	import sweatless.graphics.CommonRectangle;
	import sweatless.navigation.primitives.Loading;

	public class LoaderBar extends Loading{
		
		private var bar : CommonRectangle;
		private var background : CommonRectangle;

		private var _width : Number = 0;
		private var _height : Number = 0;
		
		public function LoaderBar(){
			addEventListener(Event.ADDED_TO_STAGE, create);
 		}
		
		override public function create(evt:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, create);
			
			background = new CommonRectangle();
			addChild(background);
			
			bar = new CommonRectangle();
			addChild(bar);

			background.width = bar.width = 200;
			background.height = bar.height = 1;
			
			backgroundColor = 0xCCCCCC;
			barColor = 0x999999;
			
			bar.scaleX = 0;
			
			alpha = 0;
			
			align();
		}
		
		override public function show():void{
			alpha = 1;
			super.show();
		}
		
		override public function hide():void{
			alpha = 0;
			super.hide();
		}
		
		override public function set progress(p_progress:Number):void{
			bar ? bar.scaleX = p_progress : null;
			super.progress = p_progress;
		}
		
		public function set backgroundColor(p_value:uint):void{
			background.colors = [p_value, p_value];
		}
		
		public function set barColor(p_value:uint):void{
			bar.colors = [p_value, p_value];
		}
		
		override public function set width(p_value:Number):void{
			background.width = _width = p_value;
			
			bar.width = _width = p_value;
		}
		
		override public function set height(p_value:Number):void{
			background.height = _height = p_value;
			
			bar.height = _height = p_value;
		}
		
		override public function get width():Number{
			return _width;
		}
		
		override public function get height():Number{
			return _height;
		}

		override public function align():void{
			
		}
		
		override public function destroy():void{
			bar.destroy();
			background.destroy();
			
			if(stage) parent.removeChild(this);
		}
	}
}