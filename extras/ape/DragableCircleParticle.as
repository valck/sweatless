package sweatless.extras.ape{
	import flash.events.MouseEvent;
	
	import org.cove.ape.CircleParticle;

	public class DragableCircleParticle extends CircleParticle{
		
		private var mouseIsDown:Boolean;

		public function DragableCircleParticle(x:Number, y:Number, radius:Number, fixed:Boolean = false, mass:Number = 1, elasticity:Number = 0.3, friction:Number = 0){
			super(x, y, radius, fixed, mass, elasticity, friction);
			
			alwaysRepaint = fixed;
		}
		
		public function addListeners():void{
			mouseIsDown = false;
			
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			sprite.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			sprite.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		public function removedListeners():void{
			mouseIsDown = false;
			
			sprite.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			sprite.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			sprite.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function mouseDownHandler(evt:MouseEvent):void{
			mouseIsDown = true;
			
			curr.setTo((evt.stageX - sprite.parent.x), (evt.stageY - sprite.parent.y));
			prev.setTo((evt.stageX - sprite.parent.x), (evt.stageY - sprite.parent.y));
		}
		
		private function mouseUpHandler(evt:MouseEvent):void{
			mouseIsDown = false;
		}
		
		private function mouseMoveHandler(evt:MouseEvent):void{
			if(!mouseIsDown) return
			
			prev.copy(curr);
			curr.setTo((evt.stageX - sprite.parent.x), (evt.stageY - sprite.parent.y));
		}
		
		public override function update(dt2:Number):void {
			if(mouseIsDown) return;
			
			super.update(dt2);
		}
	}
}