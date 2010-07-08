package sweatless.media.sound{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import sweatless.events.CustomEvent;

	public class SoundTrack extends EventDispatcher{
		public static const CUEPOINT : String = "cuepoint";

		private var _playing : Boolean;
		private var _looping : Boolean;
		private var _mute : Boolean;
		
		private var isPlayingFrom : Boolean;
		private var timer : Timer;
        
        private var sound : Sound;
		private var channel : SoundChannel;
        
		private var currentVolume : Number = 1;
		private var currentPan : Number = 0;
		
        private var count : uint;
        private var _position : Number;
        private var object : DisplayObject;
		
		private var cuePoints : Dictionary;
		private var lastCuePoint : String;

		public function SoundTrack(){
		}
		
		public function get isMute():Boolean{
			return _mute;
		}

		public function set isMute(value:Boolean):void{
			_mute = value;
		}

		public function get isLooping():Boolean{
			return _looping;
		}

		public function set isLooping(value:Boolean):void{
			_looping = value;
		}

		public function get isPlaying():Boolean{
			return _playing;
		}

		public function set isPlaying(value:Boolean):void{
			_playing = value;
		}

		public function set track(p_sound:Sound):void{
			sound = p_sound;

			cuePoints = new Dictionary(true);
			channel =  new SoundChannel();
			timer = new Timer(1000);
		}
		
		public function get track():Sound{
			return sound;
		}
		
		public function get position():Number{
			if(!channel) return NaN;
			return channel.position;
		}
		
		public function get bytesLoaded():Number{
			if(!sound) return NaN;
			return sound.bytesLoaded;
		}
		
		public function get bytesTotal():Number{
			if(!sound) return NaN;
			return sound.bytesTotal;
		}
		
		public function get length():Number{
			if(!sound) return NaN;
			if(sound.bytesLoaded >= sound.bytesTotal) return sound.length;
			return sound.length/sound.bytesLoaded *sound.bytesTotal;
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

			//trace(doubleDigitFormat(currentMinute)+":"+doubleDigitFormat(currentSecond));
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
			
			for(var i:int = 0; i<slices.length; i++){
				timecode += slices[i]*(i==0 ? 1000 : 1000*(60*i)); 
			}
			
			isPlayingFrom = true;
			
			play(timecode);
		}
		
		public function play(p_time:Number=0, p_loops:int=0):void{
			if(!sound) return;
			
			isPlaying = true;

			if(p_loops>0){
				count = p_loops;
				
				looping(null);
			}else{
				channel = sound.play(p_time);
			};
			
			channel.addEventListener(Event.SOUND_COMPLETE, looping);
			
			timer.addEventListener(TimerEvent.TIMER, dispatchCuePoints);
			timer.start();
			
			volume = currentVolume;
		}
		
		private function looping(evt:Event):void{
			if(count>0){
				isLooping = true;
				
				channel = sound.play();
				channel.addEventListener(Event.SOUND_COMPLETE, looping);
				volume = currentVolume;
				
				count--;
			}else{
				channel.removeEventListener(Event.SOUND_COMPLETE, looping);
				isLooping = false;
				stop();	
			}
		}
					
		public function stop():void{
			if(!sound) return;
            isPlaying = false;
			
			timer.removeEventListener(TimerEvent.TIMER, dispatchCuePoints);
			timer.stop();
			timer.reset();
			
			channel.stop();
		}
					
		public function pause():void {
			if(!sound) return;
			
			_position = channel.position;
			
			if(!isPlaying) {
				timer.addEventListener(TimerEvent.TIMER, dispatchCuePoints);
				timer.start();
				
                channel = sound.play(_position);
                isPlaying = true;
            }else {
				timer.removeEventListener(TimerEvent.TIMER, dispatchCuePoints);
				timer.reset();
				
                channel.stop();
                isPlaying = false;
            }
			
			volume = currentVolume;
        }
		
		public function seek(time:Number):void{
			if(!sound || !channel) return;
			if(time > length) return;
			
			if(isPlaying) {
				
				channel.stop();
				channel = sound.play(time);
				
			}else {
				
				_position = time;
				
			}
			
			volume = currentVolume;
		}
        
 		public function set pan(p_pan:Number):void {
            var transform : SoundTransform = new SoundTransform(currentVolume, p_pan);
 			
            transform.pan = p_pan;
            channel.soundTransform = transform;
            currentPan = transform.pan;            
        }

 		public function get pan():Number {
			return currentPan;
		}
		
        public function set volume(p_volume:Number):void {
            var transform : SoundTransform = new SoundTransform(p_volume, currentPan);

            transform.volume = p_volume;
            channel.soundTransform = transform;
            currentVolume = transform.volume;            
        }

        public function get volume():Number {
			return currentVolume;
		}
		
        public function mute():void {
			var transform : SoundTransform;
			
			if(!isMute){
	            isMute = true

	            transform = new SoundTransform(0, currentPan);
	
	            transform.volume = 0;
	            channel.soundTransform = transform;
				
				currentVolume = transform.volume;
   			}else{
	            isMute = false

	            transform = new SoundTransform(currentVolume, currentPan);
	
	            transform.volume = currentVolume;
	            channel.soundTransform = transform;
   			}
        }

        private function move(evt:MouseEvent):void {
        	if(!object && !sound) return;
        	
            var value : Number = 0;

            if (evt.stageX>(object.width/2)) {
                value = (evt.stageX/(object.width/2))-1;
            } else if (evt.stageX<(object.width/2)){
                value = (evt.stageX-(object.width/2))/(object.width/2);
            }
            
            if(value>1) value = 0;
			
            volume = 1-(evt.stageY/object.width);
            pan = value;
        }        

		public function addMousePan(p_target:DisplayObject):void{
			object = p_target;
			object.stage.addEventListener(MouseEvent.MOUSE_MOVE, move);
		}
		
        public function removeMousePan():void {
        	if(!object) return;
			
			object.stage.removeEventListener(MouseEvent.MOUSE_MOVE, move);

			volume = 1;
            pan = 0;
        }
        
        public function destroy():void{
        	stop();
			
			timer.removeEventListener(TimerEvent.TIMER, dispatchCuePoints);
			timer.reset();
			
			clearAllCuePoints();

			cuePoints = null;
			timer = null;
			
			removeMousePan();
			
        	channel = null;
			sound = null;
        }
	}
}

internal class CuePoint{
	private var _id : String;
	private var _time : String;
	
	public function CuePoint(p_id:String, p_time:String){
		id = p_id;
		time = p_time;
	}
	
	public function get time():String{
		return _time;
	}
	
	public function set time(value:String):void{
		_time = value;
	}
	
	public function get id():String{
		return _id;
	}
	
	public function set id(value:String):void{
		_id = value;
	}
	
}