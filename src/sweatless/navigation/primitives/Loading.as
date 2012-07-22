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
 * @author Valério Oliveira (valck)
 * 
 */

package sweatless.navigation.primitives {

	import sweatless.interfaces.IDisplay;

	import flash.events.Event;
	
	public class Loading extends Base implements IDisplay{
		
		public static const READY : String = "ready";
		public static const SHOWED : String = "showed";
		public static const HIDDEN : String = "hidden";
		public static const RESIZE : String = "resize";
		public static const DESTROYED : String = "destroyed";
		
		private var _progress : Number = 0;
		
		public function Loading(){
			mouseChildren = false;
			mouseEnabled = false;
			
			addEventListener(Event.ADDED_TO_STAGE, create);
		}

		override public function create(evt:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, create);
			stage.addEventListener(Event.RESIZE, resize);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			dispatchEvent(new Event(READY));
		}
				
		public function get progress():Number{
			return _progress;
		}
		
		public function set progress(p_progress:Number):void{
			_progress = p_progress <= 1 ? p_progress : 1;
		}
		
		public function resize(evt:Event=null):void{
			dispatchEvent(new Event(RESIZE));
		}
		
		public function show():void{
			dispatchEvent(new Event(SHOWED));
		}
		
		public function hide():void{
			dispatchEvent(new Event(HIDDEN));
		}
		
		override public function destroy(evt:Event=null):void{
			stage.removeEventListener(Event.RESIZE, resize);
			removeAllEventListeners();
			dispatchEvent(new Event(DESTROYED));
		}
	}
}