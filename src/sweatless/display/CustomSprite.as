package sweatless.display{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	dynamic public class CustomSprite extends Sprite{
		
		private var _debug : Boolean;
		private var _anchors : Point;
		private var temp : Point;
		
		public static const NONE : int = 0;
		public static const TOP : int = 1;
		public static const MIDDLE : int = 2;
		public static const BOTTOM : int = 4;
		public static const LEFT : int = 8;
		public static const CENTER : int = 16;
		public static const RIGHT : int = 32;

		public function CustomSprite() {
			addEventListener(Event.ADDED_TO_STAGE, created);
		}
		
		private function created(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, created);

			_anchors = new Point();
			temp = new Point(super.x, super.y);
			
			update();
		}

		public function anchors(p_anchors:int=CustomSprite.MIDDLE+CustomSprite.CENTER):void{
			var p_x : Number = 0;
			var p_y : Number = 0;
			
			switch(match(p_anchors, LEFT, CENTER, RIGHT)){
				case CENTER:
					p_x = getBounds(this).width/2;
					break;
					
				case RIGHT:
					p_x = getBounds(this).width;
					break;
					
				case LEFT:
				case NONE:
					p_x = 0;
					break;
			}
			
			switch(match(p_anchors, TOP, MIDDLE, BOTTOM)){
				case MIDDLE:
					p_y = getBounds(this).height/2;
					break;
					
				case BOTTOM:
					p_y = getBounds(this).height;
					break;
				
				case TOP:
				case NONE:
					p_y = 0;
					break;
			}
			
			_anchors = new Point(p_x, p_y);
			update();
		}
		
		override public function get x():Number{
			return temp.x;
		}

		override public function set x(p_value:Number):void{
			temp.x = p_value;
			update();
		}

		override public function get y():Number{
			return temp.y;
		}
		
		override public function set y(p_value:Number):void{
			temp.y = p_value;
			update();
		}

		override public function set scaleX(p_value:Number):void{
			super.scaleX = p_value;
			update();
		}

		override public function set scaleY(p_value:Number):void{
			super.scaleY = p_value;
			update();
		}

		override public function set rotation(p_value:Number):void{
			super.rotation = p_value;
			update();
		}

		override public function get mouseX():Number{
			return Math.round(super.mouseX - _anchors.x);
		}

		override public function get mouseY():Number{
			return Math.round(super.mouseY - _anchors.y);
		}
		
		public function get anchorX():Number{
			return _anchors.x;
		}
		
		public function set anchorX(p_value:Number):void{
			_anchors.x = p_value;
			update();
		}
		
		public function get anchorY():Number{
			return _anchors.y;
		}
		
		public function set anchorY(p_value:Number):void{
			_anchors.y = p_value;
			update();
		}
		
		public function set debug(p_value:Boolean):void{
			_debug = p_value;
			update();
		}
		
		private function update():void{
			var oldPoint:Point = new Point(0, 0);
			var newPoint:Point = new Point(_anchors.x, _anchors.y);
			
			newPoint = parent.globalToLocal(localToGlobal(newPoint));
			oldPoint = parent.globalToLocal(localToGlobal(oldPoint));
			
			super.x = temp.x - (newPoint.x - oldPoint.x);
			super.y = temp.y - (newPoint.y - oldPoint.y);
			
			if(_debug){
				var circle : Shape = getChildByName("debug") ? Shape(getChildByName("debug")) : new Shape();
				
				circle.name = "debug";
				addChild(circle);
				
				circle.graphics.clear();
				circle.graphics.lineStyle(.1, 0x000000);
				circle.graphics.drawEllipse(_anchors.x - 2, _anchors.y - 2, 4, 4);
				circle.graphics.endFill();
			}
		}
		
		private function match(p_value:int, ...p_options:Array):int{
			var option : int;
			
			while (option = p_options.pop()){
				if ((p_value & option)==option) return option;
			}
			
			return 0;
		}
	}
}