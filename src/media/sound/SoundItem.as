package sweatless.media.sound{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundItem{

		public var isPlaying : Boolean;
		public var isLooping : Boolean;
		public var isMute : Boolean;
        
        private var sound : Sound;
		private var channel : SoundChannel;
        
		private var currentVolume : Number = 1;
		private var currentPan : Number = 0;
		
        private var count : uint;
        private var position : Number;
        private var object : DisplayObject;
		
		public function SoundItem(){
		
		}
		
		public function set track(p_sound:Sound):void{
			channel =  new SoundChannel();
			sound = p_sound;
		}
		
		public function get track():Sound{
			return sound;
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
			
			channel.stop();
		}
					
		public function pause():void {
			if(!sound) return;
			
			position = channel.position;
			
			if(!isPlaying) {
                channel = sound.play(position);
                isPlaying = true;
            }else {
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

		public function addMousePan(p_obj:DisplayObject):void{
			object = p_obj;
			object.stage.addEventListener(MouseEvent.MOUSE_MOVE, move);
		}
		
        public function removeMousePan():void {
        	if(!object) return;
			
			object.stage.removeEventListener(MouseEvent.MOUSE_MOVE, move);
            volume = 1;
            pan = 1;
        }
        
        public function destroy():void{
			try {
				sound.close();
			}catch (err:Error) {
			}
			
        	stop();
        	channel = null;
			sound = null;
        }
	}
}