package sweatless.physics
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	
	import org.cove.ape.APEngine;

	public class StepManager
	{
		private var stage:Stage;
		private var stepsInCurrentFrame:int;
		private var listener:DisplayObject;
		
		private static var instance:StepManager;
		
		public function StepManager()
		{
			instance = this;
			if(!APEngine.container) throw(new Error("You must add a container to APEngine before using StepManager"));
			listener = APEngine.container.stage ? APEngine.container.stage : APEngine.container;
			listener.addEventListener(Event.ENTER_FRAME, resetSteps, false, Number.MAX_VALUE);
		}
		
		private function resetSteps(evt:Event):void{
			stepsInCurrentFrame = 0;
		}
		
		public function step():void{
			if(stepsInCurrentFrame>0) return;
			APEngine.step();
			stepsInCurrentFrame++;
		}
		
		static public function step():void{
			if(!instance) instance = new StepManager();
			instance.step();
		}
	}
}