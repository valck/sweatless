package sweatless.media{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	import sweatless.graphics.CommonRectangle;
	
	public class SoundBars extends Sprite{
		
		private var bytes : ByteArray;
		
		private var bars : Array;
		
		private var offset : Number;
		private var amplitude : Number;
		
		public function SoundBars(){
		}
		
		public function create(p_amount:uint, p_width:Number, p_amplitude:Number=30):void{
			amplitude = p_amplitude;
			
			bytes = new ByteArray();
			bars = new Array();
			
			var last : CommonRectangle;
			for(var i:uint=0; i<p_amount; i++){
				var bar : CommonRectangle = new CommonRectangle();
				addChild(bar);
				
				bar.width = p_width;
				bar.x = last ? last.x + last.width + 2 : 0;
				
				bars.push(bar);
				
				last = bar;
			}
		}
		
		public function on():void{
			addEventListener(Event.ENTER_FRAME, draw);		
		}
		
		public function off():void{
			removeEventListener(Event.ENTER_FRAME, draw);
			reset();
		}
		
		private function reset():void{
			for (var i:uint=0; i<bars.length; i++) {
				bars[i].height = 1; 
				bars[i].y = 0;
			}
		}
		
		private function draw(evt:Event):void{
			try{
				SoundMixer.computeSpectrum(bytes, true);
				
				for (var i:uint=0; i<bars.length; i++) {
					bytes.position = i * 4;
					offset = Math.round(bytes.readFloat()*amplitude);
					
					bars[i].height = offset == 0 ? 1 : offset; 
					bars[i].y = offset == 0 ? -offset : -(offset-1);
				}
			} catch(err:Error){
				
			}
		}
	}
}