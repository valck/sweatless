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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import sweatless.events.Broadcaster;
	import sweatless.interfaces.IBase;
	
	internal class Base extends Sprite implements IBase{
		
		public var data : Object = new Object();
		public var broadcaster : Broadcaster = Broadcaster.getInstance();
		
		protected var events : Dictionary;
		
		public function Base(){
			events = new Dictionary(true);
		}
		
		public function create(evt:Event=null):void{
			throw new Error("Please, override this method.");
		}
		
		public function destroy():void{
			throw new Error("Please, override this method.");
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			var key : Object = {type:type, listener:listener, capture:useCapture};
			events[key] = listener;
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			var key : Object = {type:type, listener:listener, capture:useCapture};

			events[key] = null;
			delete events[key];
			
			super.removeEventListener(type, listener, useCapture);
		}
		
		public function removeAllEventListeners():void{
			for(var key:* in events){
				removeEventListener(key.type, key.listener, key.capture);	
			}
		}
		
		override public function toString():String{
			return getQualifiedClassName(this);
		}
	}
}

