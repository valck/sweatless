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
 * 
 */

package sweatless.navigation.primitives{
	import flash.events.Event;
	
	import sweatless.interfaces.IDisplay;
	
	public class Loading extends Base implements IDisplay{
		
		public static const OPEN : String = "open";
		public static const COMPLETE : String = "complete";
		
		private var _progress : Number=0;
		
		public function Loading(){
			mouseChildren = false;
			mouseEnabled = false;
			
			addEventListener(Event.ADDED_TO_STAGE, create);
		}
		
		override public function create(evt:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, create);
		}
		
		public function get progress():Number{
			return _progress;
		}
		
		public function set progress(p_progress:Number):void{
			_progress = p_progress
		}
		
		public function show():void{
			dispatchEvent(new Event(Loading.OPEN));
		}
		
		public function hide():void{
			dispatchEvent(new Event(Loading.COMPLETE));
		}
		
		public function align():void{
			
		}
		
		override public function destroy():void{
			_progress = 0;
			removeAllEventListeners();
			if(stage) parent.removeChild(this);
		}
	}
}