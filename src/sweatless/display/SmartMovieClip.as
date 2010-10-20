/**
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 Sweatless Team 
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * http://code.google.com/p/sweatless/
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * @author Valério Oliveira (valck) / João Marquesini
 * 
 * @todo loop, repeat and custom eases equations
 * 
 */

package sweatless.display{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sweatless.events.CustomListener;

	
	/**
	 * 
	 * Dispatched when the <code>SmartSprite</code> has played.
	 * @eventType sweatless.display.SmartMovieClip
	 * @see Event
	 *  
	 */
	[Event(name="start", type="sweatless.display.SmartMovieClip")]

	/**
	 * 
	 * Dispatched when the <code>SmartSprite</code> has paused.
	 * @eventType sweatless.display.SmartMovieClip
	 * @see Event 
	 * 
	 */
	[Event(name="pause", type="sweatless.display.SmartMovieClip")]
	
	/**
	 * 
	 * Dispatched when the <code>SmartSprite</code> has stopped.
	 * @eventType sweatless.display.SmartMovieClip
	 * @see Event
	 * 
	 */
	[Event(name="complete", type="sweatless.display.SmartMovieClip")]

	/**
	 * The <code>SmartMovieClip</code> is a substitute class for the native <code>MovieClip</code> class, but need sets the <code>source</code>. It extends <code>SmartSprite</code> also the all properties of the native <code>MovieClip</code> class and more.
	 * Remember the <code>SmartMovieClip</code> don't have scenes.
	 * 
	 * @param p_source <code>MovieClip</code>
	 * @see SmartSprite
	 * @see MovieClip
	 * @see Sprite
	 * 
	 */
	public class SmartMovieClip extends SmartSprite{
		
		/**
		 * 
		 * Dispatched when the <code>SmartSprite</code> has played.
		 * 
		 * @see Event
		 *  
		 */
		public static const START : String = "start";
		
		/**
		 *
		 * Dispatched when the <code>SmartSprite</code> has paused.
		 * 
		 * @see Event 
		 * 
		 */
		public static const PAUSE : String = "pause";
		
		/**
		 * 
		 * Dispatched when the <code>SmartSprite</code> has stopped.
		 * 
		 * @see Event
		 * 
		 */
		public static const COMPLETE : String = "complete";
		
		private var timer : uint;
		
		private var current : int = 0;
		private var end : int = 0;
		
		private var _delay : Number = 0;
		private var _source : MovieClip;
		
		/**
		 * The <code>SmartMovieClip</code> is a substitute class for the native <code>MovieClip</code> class, but need sets the <code>source</code>. It extends <code>SmartSprite</code> also the all properties of the native <code>MovieClip</code> class and more.
		 * Remember the <code>SmartMovieClip</code> don't have scenes.
		 * 
		 * @param p_source
		 * @see SmartSprite
		 * @see MovieClip
		 * @see Sprite
		 * 
		 */
		public function SmartMovieClip(p_source:MovieClip=null){
			source = p_source;

			super();
		}
		
		/**
		 * Sets the <code>MovieClip</code> source.
		 * @param p_value
		 * @see MovieClip
		 * 
		 */
		public function set source(p_value:MovieClip):void{
			if(!p_value) return;
			
			_source = p_value;
			addChild(_source);
			
			_source.gotoAndStop(1);
		}
		
		/**
		 * Sets/Get the time in seconds before the playhead should begin.
		 * @return <code>Number</code>
		 * 
		 */
		public function get delay():Number{
			return _delay;
		}
		
		public function set delay(p_value:Number):void{
			_delay = (p_value*1000);
		}

		/**
		 * The total number of frames in the MovieClip instance.
		 * If the movie clip contains multiple frames, the totalFrames property returns the total number of frames
		 * @return <code>int</code> 
		 * 
		 */
		public function get totalFrames():int{
			return _source.totalFrames;
		}
		
		/**
		 * Specifies the number of the frame in which the playhead is located in the timeline of the MovieClip instance. 
		 * @return <code>int</code> 
		 * 
		 */
		public function get currentFrame():int{
			return _source.currentFrame;
		}
		
		/**
		 * The current label in which the playhead is located in the timeline of the MovieClip instance.
		 * @return <code>String</code>
		 * 
		 */
		public function get currentLabel():String{
			return _source.currentLabel;
		}
		
		/**
		 * Returns an array of FrameLabel objects from the MovieClip.
		 * @return <code>Array</code>
		 * 
		 */
		public function get currentLabels():Array{
			return _source.currentLabels;
		}
		
		/**
		 * The number of frames that are loaded.
		 * @return <code>int</code> 
		 * 
		 */
		public function get framesLoaded():int{
			return _source.framesLoaded;
		}
		
		/**
		 * Moves the playhead in the timeline of the movie clip.
		 * 
		 */
		public function play():void{
			goto(currentFrame, totalFrames);
		}

		/**
		 * Stops the playhead in the movie clip.
		 * 
		 */
		public function stop():void{
			if(!_source) return;

			clearTimeout(timer);
			CustomListener.removeListener(_source, Event.ENTER_FRAME);

			_source.stop();
			dispatchEvent(new Event(COMPLETE));
		}
		
		/**
		 * Pause the playhead in the movie clip.
		 * 
		 */
		public function pause():void{
			if(!_source) return;
			
			clearTimeout(timer);
			CustomListener.removeListener(_source, Event.ENTER_FRAME);

			_source.stop();
			dispatchEvent(new Event(PAUSE));
		}

		/**
		 * Resumes the playhead in the movie clip.
		 * 
		 */
		public function resume():void{
			play();
		}

		/**
		 * 
		 * Brings the playhead to the specified frame of movie clip and stops it there.
		 * The <code>SmartMovieClip</code> don't have scenes.
		 * 
		 * @param p_frame A number representing the frame number, or a string representing the label of the frame.
		 * 
		 */
		public function gotoAndStop(p_frame:Object):void{
			if(!_source) return;

			goto(p_frame is Number ? int(p_frame) : getFrameNumber(String(p_frame)) -1, p_frame);
		}
		
		/**
		 * 
		 * Starts playing the movie clip at the specified frame and goes to last frame of movie clip.
		 * The <code>SmartMovieClip</code> don't have scenes.
		 *  
		 * @param p_frame A number representing the frame number, or a string representing the label of the frame.
		 * 
		 */
		public function gotoAndPlay(p_frame:Object):void{
			if(!_source) return;

			goto(p_frame, totalFrames);
		}

		/**
		 *
		 * Brings the playhead to the specified frame of movie clip and starts playing the movie clip at the specified frame.
		 *  
		 * @param p_start A number representing the start frame number, or a string representing the label of the start frame.
		 * @param p_end A number representing the end frame number, or a string representing the label of the end frame.
		 * 
		 */
		public function goto(p_start:Object, p_end:Object):void{
			if(!_source) return;

			var start : int = p_start is Number ? int(p_start) : getFrameNumber(String(p_start));
			var finish : int = p_end is Number ? int(p_end) : getFrameNumber(String(p_end));
			
			current = 0;
			end =  Math.abs(start-finish);
			
			timer = setTimeout(
				function():void{
					CustomListener.addListener(_source, Event.ENTER_FRAME, checkFinalFrameAndStop, start, finish);

					dispatchEvent(new Event(START));
					_source.gotoAndStop(p_start);
				},
			delay);
		}
		
		/**
		 * Destroy clear the source, delays and all events.
		 * 
		 * @default <code>null</code>
		 * @param evt <code>Event</code>
		 * @see #removeAllEventListeners()
		 */
		override public function destroy(evt:Event=null):void{
			clearTimeout(timer);
			
			_source ? CustomListener.removeListener(_source, Event.ENTER_FRAME) : null;
			_source ? _source.stop() : null;
			_source ? _source.parent.removeChild(_source) : null;
			_source = null;
			
			delay = 0;
			current = 0;
			end = 0;
			
			super.destroy(evt);
		}
		
		private function checkFinalFrameAndStop(evt:Event, p_start:int, p_finish:int):void{
			if(!_source) return;
			
			if(_source.currentFrame == p_finish){
				CustomListener.removeListener(_source, Event.ENTER_FRAME);
				
				_source.stop();
				
				delay = 0;
				current = 0;
				end = 0;
				
				dispatchEvent(new Event(COMPLETE));
			}else{
				var frame : int = p_start + (p_finish-p_start) * (current/end);
				_source.gotoAndStop(frame);
				
				current++;
			}
		}
		
		private function getFrameNumber(p_frame:String):int{
			if(!_source || !_source.currentLabels) return 0;
			
			var labels : Array = _source.currentLabels;
			
			for(var i:Number = 0; i<labels.length; i++){
				if(p_frame == labels[i].name) return int(labels[i].frame);
			}
			
			return 0;
		}
	}
}