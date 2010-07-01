package sweatless.effects{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filters.BlurFilter;

	public class Noise{
		private var scope : DisplayObjectContainer;
		private var statics : Bitmap;
		
		public function Noise(){
		}

		public function create(p_scope:DisplayObjectContainer, p_width:Number, p_height:Number, p_blur_x:Number=0, p_blur_y:Number=0):void{
			scope = p_scope;
			
			statics = new Bitmap(new BitmapData(p_width, p_height, true, 0x000000));
			scope.addChild(statics);
			
			if(p_blur_x || p_blur_y) statics.filters = [new BlurFilter(p_blur_x, p_blur_y, 2)]; 
		}
		
		public function start():void{
			scope.addEventListener(Event.ENTER_FRAME, render);
		}
		
		public function stop():void{
			scope.removeEventListener(Event.ENTER_FRAME, render);
		}
		
		private function render(e:Event):void{
			statics.bitmapData.noise(int(Math.random() * int.MAX_VALUE), 0, 0xFFFFFF, BitmapDataChannel.ALPHA, true);
		}
		
		public function destroy():void{
			stop();
			
			statics.bitmapData.dispose();
			scope.removeChild(statics);
		}				
	}
}
