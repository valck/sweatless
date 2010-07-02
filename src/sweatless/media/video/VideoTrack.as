package sweatless.media.video{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	
	public class VideoTrack extends Sprite{
		
		public static const TYPE_BITMAP : String = "bitmap";
		public static const TYPE_VIDEO : String = "video";
		
		public static const COMPLETE : String = "complete";
		public static const START : String = "start";

		private var _width : Number;
		private var _height : Number;

		private var _deblocking : int = 3;
		private var _smoothing : Boolean;
		
		private var _playing : Boolean;
		private var _looping : Boolean;
		private var _mute : Boolean;

		private var stream : NetStream;
		private var video : Video;
		
		private var currentVolume : Number = 1;
		private var currentPan : Number = 0;
		
		private var count : uint;

		private var object : DisplayObject;
		
		public function VideoTrack(){
			video = new Video();
			addChild(video);
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
		
		public function get deblocking():int{
			return _deblocking;
		}
		
		public function set deblocking(value:int):void{
			_deblocking = video.deblocking = value;
		}
		
		public function get smoothing():Boolean{
			return _smoothing;
		}
		
		public function set smoothing(value:Boolean):void{
			_smoothing = video.smoothing = value;
		}
		
		public function set track(p_netstream:NetStream):void{
			stream = p_netstream;
			
			video.attachNetStream(stream);
		}
		
		public function get track():NetStream{
			return stream;
		}
		
		public function play(p_loops:uint=0):void{
			isPlaying = true;
			
			stream.addEventListener(NetStatusEvent.NET_STATUS, status);
			
			p_loops>0 ? count = p_loops : null;

			stream.seek(0);
			stream.resume();

			volume = currentVolume;
		}
		
		public function stop():void{
			isPlaying = false;
			
			stream.removeEventListener(NetStatusEvent.NET_STATUS, status);
			stream.seek(0);
			stream.pause();
		}
		
		public function pause():void {
			if(!isPlaying) {
				stream.addEventListener(NetStatusEvent.NET_STATUS, status);
				stream.resume();
				
				isPlaying = true;
			}else {
				stream.removeEventListener(NetStatusEvent.NET_STATUS, status);
				stream.pause();
				
				isPlaying = false;
			}
			
			volume = currentVolume;
		}
		
		public function set pan(p_pan:Number):void {
			var transform : SoundTransform = new SoundTransform(currentVolume, p_pan);
			
			transform.pan = p_pan;
			stream.soundTransform = transform;
			currentPan = transform.pan;            
		}
		
		public function get pan():Number {
			return currentPan;
		}
		
		public function set volume(p_volume:Number):void {
			var transform : SoundTransform = new SoundTransform(p_volume, currentPan);
			
			transform.volume = p_volume;
			stream.soundTransform = transform;
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
				stream.soundTransform = transform;
				
				currentVolume = transform.volume;
			}else{
				isMute = false
				
				transform = new SoundTransform(currentVolume, currentPan);
				
				transform.volume = currentVolume;
				stream.soundTransform = transform;
			}
		}
		
		private function status(evt:NetStatusEvent):void{
			if(evt.info.code == "NetStream.Play.Stop"){
				if(count>0){
					count--;

					isLooping = true;

					play(count);
					
					volume = currentVolume;
				}else{
					isLooping = false;
					
					stop();	
					
					stream.removeEventListener(NetStatusEvent.NET_STATUS, status);
					
					dispatchEvent(new Event(COMPLETE));
				}

			}else if(evt.info.code == "NetStream.Seek.Notify"){
				//stream.resume();
			}
		}

		private function move(evt:MouseEvent):void{
			if(!object && !stream) return;
			
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

		override public function set width(p_value:Number):void{
			_width = video.width = int(p_value);
		}
		
		override public function set height(p_value:Number):void{
			_height = video.height = int(p_value);
		}
		
		override public function get width():Number{
			return _width;
		}
		
		override public function get height():Number{
			return _height;
		}
		
		public function destroy():void{
			stop();
			
			removeMousePan();
		}
		
	}
}