package sweatless.display{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class CustomSprite extends Sprite{
		private var newPoint : Point;
		private var debugPoint : Shape;

		public static const NONE : int = 0;
		public static const TOP : int = 1;
		public static const MIDDLE : int = 2;
		public static const BOTTOM : int = 4;
		public static const LEFT : int = 8;
		public static const CENTER : int = 16;
		public static const RIGHT : int = 32;

		public function CustomSprite() {
			newPoint = new Point(0, 0);
		}

		public function registrationPoint(p_anchors:int=CustomSprite.MIDDLE+CustomSprite.CENTER):void{
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
			
			newPoint = new Point(p_x, p_y);
		}
		
		public function get _x():Number{
			return originalPoint.x;
		}

		public function set _x(p_value:Number):void {
			x += p_value - originalPoint.x;
		}

		public function get _y():Number {
			return originalPoint.y;
		}
		
		public function set _y(p_value:Number):void {
			y += p_value - originalPoint.y;
		}

		public function get _scaleX():Number {
			return scaleX;
		}

		public function set _scaleX(p_value:Number):void {
			setProperty("scaleX", p_value);
		}

		public function get _scaleY():Number {
			return scaleY;
		}

		public function set _scaleY(p_value:Number):void {
			setProperty("scaleY", p_value);
		}

		public function get _rotation():Number {
			return rotation;
		}

		public function set _rotation(p_value:Number):void {
			setProperty("rotation", p_value);
		}

		public function get _mouseX():Number {
			return Math.round(mouseX - newPoint.x);
		}

		public function get _mouseY():Number {
			return Math.round(mouseY - newPoint.y);
		}
		
		public function set debug(p_value:Boolean):void{
			if(debugPoint){
				debugPoint.graphics.clear();
				removeChild(debugPoint);
				debugPoint = null;
			}
			
			if(p_value){
				debugPoint = new Shape();
				addChild(debugPoint);
				
				debugPoint.graphics.clear();
				debugPoint.graphics.lineStyle(.1, 0x000000);
				debugPoint.graphics.drawEllipse(newPoint.x-2, newPoint.y-2, 4, 4);
				debugPoint.graphics.endFill();
			}
		}
		
		private function setProperty(p_prop:String, p_value:Number):void{
			var a:Point = originalPoint;
			this[p_prop] = p_value;

			var b:Point = originalPoint;

			x -= b.x - a.x;
			y -= b.y - a.y;
		}
		
		private function match(p_value:int, ...p_options:Array):int{
			var option : int;
			
			while (option = p_options.pop()){
				if ((p_value & option)==option) return option;
			}
			
			return 0;
		}
		
		private function get originalPoint():Point{
			return parent.globalToLocal(localToGlobal(newPoint));
		}
	}
}