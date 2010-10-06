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
 * @author Valério Oliveira (valck)
 * @author João Marquesini
 * 
 */

package sweatless.display{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sweatless.events.CustomListener;

	public class SmartMovieClip extends SmartSprite{
		
		public static const START : String = "start";
		public static const COMPLETE : String = "complete";
		
		private var timer : uint;
		
		private var current : int = 0;
		private var end : int = 0;
		
		private var _delay : Number = 0;
		private var _source : MovieClip;
		
		public function SmartMovieClip(p_source:MovieClip=null){
			super();
			
			source = p_source;
		}
		
		public function set source(p_value:MovieClip):void{
			if(!p_value) return;
			
			_source = p_value;
			_source.stage ? null : addChild(_source);
			
			stop();
		}
		
		public function get delay():Number{
			return _delay;
		}
		
		public function set delay(p_value:Number):void{
			_delay = (p_value*1000);
		}

		public function get totalFrames():int{
			return _source.totalFrames;
		}
		
		public function get currentFrame():int{
			return _source.currentFrame;
		}
		
		public function play():void{
			goto(currentFrame, totalFrames);
		}

		public function stop():void{
			if(!_source) return;

			clearTimeout(timer);
			CustomListener.removeListener(_source, Event.ENTER_FRAME);

			_source.gotoAndStop(1);
		}
		
		public function pause():void{
			if(!_source) return;
			
			clearTimeout(timer);
			CustomListener.removeListener(_source, Event.ENTER_FRAME);

			_source.stop();
		}

		public function resume():void{
			play();
		}

		public function gotoAndStop(p_frame:Object):void{
			if(!_source) return;

			_source.gotoAndStop(p_frame);
		}
		
		public function gotoAndPlay(p_frame:Object):void{
			if(!_source) return;

			goto(p_frame, totalFrames);
		}

		public function goto(p_start:Object, p_end:Object):void{
			if(!_source) return;

			var start : int = p_start is Number ? int(p_start) : getFrameNumber(String(p_start));
			var finish : int = p_end is Number ? int(p_end) : getFrameNumber(String(p_end));
			
			current = 0;
			end =  Math.abs(start-finish);
			
			timer = setTimeout(
				function():void{
					dispatchEvent(new Event(START));
					
					gotoAndStop(p_start);
					
					CustomListener.addListener(_source, Event.ENTER_FRAME, checkFinalFrameAndStop, start, finish);
				},
			delay);
		}
		
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