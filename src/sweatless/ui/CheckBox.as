package sweatless.ui{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sweatless.graphics.CommonRectangle;
	import sweatless.interfaces.IButton;

	public class CheckBox extends Sprite{
		
		private var fill : CommonRectangle;
		private var background : CommonRectangle;
		private var clicked : Boolean;
		
		private var _width : Number = 0;
		private var _height : Number = 0;
		
		public function CheckBox(){
			addEventListener(Event.ADDED_TO_STAGE, create);
		}
		
		private function create(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, create);
			
			background = new CommonRectangle();
			addChild(background);
			
			fill = new CommonRectangle();
			addChild(fill);
			fill.visible = false;
		}

		private function click(evt:MouseEvent):void{
			clicked = fill.visible = clicked ? false : true;
		}

		public function addListeners():void{
			buttonMode = true;
			
			addEventListener(MouseEvent.CLICK, click);
		}

		public function removeListeners():void{
			buttonMode = false;
			
			removeEventListener(MouseEvent.CLICK, click);
		}

		public function get value():Boolean{
			return clicked;
		}
		
		public function set backgroundColor(p_value:uint):void{
			background.colors = [p_value, p_value];
		}
		
		public function set fillColor(p_value:uint):void{
			fill.colors = [p_value, p_value];
		}
		
		override public function set width(p_value:Number):void{
			background.width = _width = p_value;
			
			fill.width = p_value/2;
			fill.x = (background.width-fill.width)/2;
		}
		
		override public function set height(p_value:Number):void{
			background.height = _height = p_value;
			
			fill.height = p_value/2;
			fill.y = (background.height-fill.height)/2;
		}
		
		override public function get width():Number{
			return _width;
		}
		
		override public function get height():Number{
			return _height;
		}
		
		public function destroy():void{
			fill.destroy();
			background.destroy();
		}
	}
}

