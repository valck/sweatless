package sweatless.media.video{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	
	public class VideoTrack extends Sprite{
		public static const TYPE_BITMAP:String = "bitmap";
		public static const TYPE_VIDEO:String = "video";
		public static const COMPLETE:String = "complete";
		public static const START:String = "start";

		private var _playing : Boolean;
		private var _looping : Boolean;
		private var _mute : Boolean;

		private var netstream : NetStream;
		private var video : Video;
		private var channel : SoundChannel;
		
		private var currentVolume : Number = 1;
		private var currentPan : Number = 0;
		
		private var count : uint;
		
		public function VideoTrack(){

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
		
		public function set track(p_netstream:NetStream):void{
			netstream = p_netstream;
		}
		
		public function get track():NetStream{
			return netstream;
		}
		
		public function play():void{
			isPlaying = true;
			
			if(p_loops>0){
				count = p_loops;
				
				looping(null);
			}else{
				channel = sound.play(p_time);
			};
			
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
			
			position = channel.position;
			
			if(!isPlaying) {
				timer.addEventListener(TimerEvent.TIMER, dispatchCuePoints);
				timer.start();
				
				channel = sound.play(position);
				isPlaying = true;
			}else {
				timer.removeEventListener(TimerEvent.TIMER, dispatchCuePoints);
				timer.reset();
				
				channel.stop();
				isPlaying = false;
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
		
	}
}