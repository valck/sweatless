package sweatless.extras.ape{
	import flash.events.MouseEvent;
	
	import org.cove.ape.CircleParticle;
	
	public class InteractiveParticle extends CircleParticle{
		
		private var mouseDown : Boolean;
		private var _angle : Number;

		public function InteractiveParticle(x:Number, y:Number, radius:Number, fixed:Boolean = false, mass:Number = 1, elasticity:Number = 0.3, friction:Number = 0){
			super(x, y, radius, fixed, mass, elasticity, friction);
			
			alwaysRepaint = fixed;
		}
		
		public function get angle():Number{
			return _angle;
		}

		public function set angle(value:Number):void{
			_angle = value;
		}

		public function addListeners():void{
			mouseDown = false;
			
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, handler);
			sprite.stage.addEventListener(MouseEvent.MOUSE_UP, handler);
			sprite.stage.addEventListener(MouseEvent.MOUSE_MOVE, handler);
		}
		
		public function removedListeners():void{
			mouseDown = false;
			
			sprite.removeEventListener(MouseEvent.MOUSE_DOWN, handler);
			sprite.stage.removeEventListener(MouseEvent.MOUSE_UP, handler);
			sprite.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handler);
		}
		
		private function handler(evt:MouseEvent):void{
			switch(evt.type){
				case "mouseUp":
					mouseDown = false;
				break;
				
				case "mouseDown":
					mouseDown = true;
					
					curr.setTo((evt.stageX - sprite.parent.x), (evt.stageY - sprite.parent.y));
					prev.setTo((evt.stageX - sprite.parent.x), (evt.stageY - sprite.parent.y));
				break;

				case "mouseMove":
					if(!mouseDown) return;
					
					//if(sprite.rotation > 20 || sprite.rotation < -20) return;
					
					prev.copy(curr);
					curr.setTo((evt.stageX - sprite.parent.x), (evt.stageY - sprite.parent.y));
					
					angle = center.x < 50 ? Math.atan2((evt.stageY - sprite.parent.y), (evt.stageX - sprite.parent.x)) : angle;
					angle = center.x > 50 ? Math.atan2((evt.stageY - sprite.parent.y), (evt.stageX - sprite.parent.x)) : angle;
					
					sprite.rotation = center.x < 90 ? center.x : sprite.rotation;
					
					//trace("rotation:", sprite.rotation, "angle:", angle, px, py);
				break;
			}
		}
		
		public override function update(dt2:Number):void {
			if(mouseDown) return;
			
			sprite.rotation = angle = sprite.rotation != 0 ? center.x : 0;
			
			super.update(dt2);
		}
	}
}