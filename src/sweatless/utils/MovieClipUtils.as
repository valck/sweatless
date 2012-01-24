/**
 * Licensed under the MIT License and Creative Commons 3.0 BY-SA
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
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC 
 * LICENSE ("CCPL" OR "LICENSE"). THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW. 
 * ANY USE OF THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS 
 * PROHIBITED.
 * BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE TO BE BOUND BY THE 
 * TERMS OF THIS LICENSE. TO THE EXTENT THIS LICENSE MAY BE CONSIDERED TO BE A CONTRACT, THE 
 * LICENSOR GRANTS YOU THE RIGHTS CONTAINED HERE IN CONSIDERATION OF YOUR ACCEPTANCE OF SUCH 
 * TERMS AND CONDITIONS.
 * 
 * http://creativecommons.org/licenses/by-sa/3.0/legalcode
 * 
 * http://www.sweatless.as/
 * 
 * @author João Marquesini
 * 
 */
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