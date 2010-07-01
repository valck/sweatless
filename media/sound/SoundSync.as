package sweatless.media.sound{
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import sweatless.events.CustomEvent;


	public class SoundSync extends Sound{
		public static const CUEPOINT : String = "cuepoint";

		private var timer : Timer;
		
        private var pausePosition : Number;
		private var channel : SoundChannel;

		private var currentVolume : Number = 1;
		
		private var cuePoints : Dictionary;
		private var lastCuePoint : String;
		
		public var isPlayingFrom : Boolean;
		public var isPlaying : Boolean;
		public var isMute : Boolean;
		
		public function SoundSync(stream:URLRequest=null, context:SoundLoaderContext=null){
			super(stream, context);
		}
		
		public function create ():void
		{
			cuePoints = new Dictionary(true);
			channel =  new SoundChannel();
			timer = new Timer(0);
		}
		
		public function addCuePoint(p_id:String, p_time:String):void {
			if(hasCuePoint(p_id)) throw new Error("The cuepoint "+ p_id +" already exists.");

			var cuePoint : CuePoint = new CuePoint(p_id, p_time);
			cuePoints[p_id] = cuePoint;
		}
		
		public function getCuePoint(p_id:String):CuePoint{
			if(!hasCuePoint(p_id)) throw new Error("The cuepoint "+ p_id +" don't exists.");
			return cuePoints[p_id];
		}
		
		public function hasCuePoint(p_id:String):Boolean{
			return cuePoints[p_id] ? true : false;
		}

		public function clearCuePoint(p_id:String): void{
			if(!cuePoints[p_id]){
				throw new Error("The cuepoint "+ p_id +" don't exists or already removed.");
			}else{
				cuePoints[p_id] = null;
				delete cuePoints[p_id];
			}
		}

		public function clearAllCuePoints():void{
			for(var key:* in cuePoints){
                cuePoints[key] = null;
                delete cuePoints[key];
            }
		}
		
		private function dispatchCuePoints(evt : TimerEvent):void {
			var total : Number = Math.floor(length/1000);
			var totalMinutes : Number = Math.floor(total/60);
			var totalSeconds : Number = Math.floor(total-(totalMinutes*60));
			
			var current : Number = Math.floor(channel.position/1000);
            var currentMinute : Number = Math.floor(current/60);
            var currentSecond : Number = Math.floor(current-(currentMinute*60));
			
			if(isPlayingFrom) {
				isPlayingFrom = false;
				return;
			}
			
			for(var key:* in cuePoints){
				if(String(getCuePoint(key).time) == doubleDigitFormat(currentMinute)+":"+doubleDigitFormat(currentSecond)) {
					dispatchEvent(new CustomEvent(CUEPOINT, cuePoints[key]));
				}
            }
        }
        
        private function doubleDigitFormat(p_value:Number):String {
            if(p_value < 10) return ("0" + p_value);
            return String(p_value);
        }
		
		public function playFrom(cue : String):void {
			var timeStr : String = getCuePoint(cue).time;
			var slices : Array = timeStr.split(":");
			var timecode : Number = 0; 
			
			slices.reverse();
			
			for ( var i:int = 0; i<slices.length; i++ ){
				timecode += slices[i]*(i==0 ? 1000 : 1000*(60*i)); 
			}
			
			isPlayingFrom = true;
			
			play(timecode);
		}
		
		override public function play(startTime:Number=0, loops:int=0, sndTransform:SoundTransform=null):SoundChannel{
			isPlaying = true;
			
			timer.delay = 1000;
			timer.addEventListener(TimerEvent.TIMER, dispatchCuePoints);
     		timer.start();
     		
			channel.stop();
			
			channel = super.play(startTime, loops, sndTransform);
			return channel;
		}
		
		public function stop():void{
            isPlaying = false;
			
			timer.removeEventListener(TimerEvent.TIMER, dispatchCuePoints);
     		timer.stop();
     		timer.reset();
			
			channel.stop();
		}
		
		public function pause():void {
			if(!isPlaying) return;
            isPlaying = false;

			timer.removeEventListener(TimerEvent.TIMER, dispatchCuePoints);
     		timer.reset();
						
			pausePosition = channel.position;
            channel.stop();
        }
        
		public function resume():void {
            if(isPlaying) return;
            isPlaying = true;
            
            timer.addEventListener(TimerEvent.TIMER, dispatchCuePoints);
     		timer.start();
     		
            channel = play(pausePosition);
        }
        
        public function set volume(p_volume:Number):void {
            var transform : SoundTransform = new SoundTransform(p_volume);

            transform.volume = p_volume;
            channel.soundTransform = transform;
            currentVolume = transform.volume;            
        }

        public function get volume():Number {
            return channel.soundTransform.volume;
        }

        public function mute():void {
			var transform : SoundTransform;
			
			if(!isMute){
	            isMute = true;

	            transform = new SoundTransform(0);
	
	            transform.volume = 0;
	            channel.soundTransform = transform;
   			}else{
	            isMute = false

	            transform = new SoundTransform(currentVolume);
	
	            transform.volume = currentVolume;
	            channel.soundTransform = transform;
   			}
        }
        
        public function destroy():void{
        	stop();
			
     		clearAllCuePoints();
     		
			timer.removeEventListener(TimerEvent.TIMER, dispatchCuePoints);
     		timer.reset();

			cuePoints = null;
     		timer = null;
     		channel = null;
        }
	}
}		

