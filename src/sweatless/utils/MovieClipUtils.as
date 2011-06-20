package sweatless.utils
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class MovieClipUtils
	{
		
		/**
		 * Returns the frame number of the given label.
		 * @param movieclip The <Code>MovieClip</Code> to get the frame number.
		 * @param label The label to search for.
		 * @return The frame number for the given label.
		 * 
		 */		
		public static function getFrameByLabel(movieclip:MovieClip, label:String):int{
			for(var i:String in movieclip.currentLabels){
				var frame:FrameLabel = FrameLabel(movieclip.currentLabels[i]);
				if(frame.name == label) return frame.frame; 
			}
			return 0;
		}
		
		
		/**
		 * Plays the <Code>MovieClip</Code> until the given label is reached. 
		 * @param movieclip The <Code>MovieClip</Code> to be played.
		 * @param label The label to be played to.
		 * 
		 */
		public static function playToLabel(movieclip:MovieClip, label:String):void{
			function checkFrame():void{
				if(movieclip.currentFrameLabel == label || getFrameByLabel(movieclip, label) == 0) {
					movieclip.removeEventListener(Event.ENTER_FRAME, checkFrame);
					movieclip.stop();
					movieclip.dispatchEvent(new Event(Event.COMPLETE));
				}else{
					movieclip.play();
				}
			}
			movieclip.addEventListener(Event.ENTER_FRAME, checkFrame);
		}
		
		/**
		 * Plays the <Code>MovieClip</Code> from one label to another. 
		 * @param movieclip The <Code>MovieClip</Code> to be played.
		 * @param from The initial label to be played from.
		 * @param to The label to be played to.
		 */
		public static function playFromLabelToLabel(movieclip:MovieClip, from:String, to:String):void{
			movieclip.gotoAndStop(from);
			playToLabel(movieclip, to);
		}
	}
}