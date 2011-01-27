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
 * http://code.google.com/p/sweatless/
 * 
 * @author Valério Oliveira (valck)
 * 
 */

package sweatless.navigation.primitives{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import sweatless.events.Broadcaster;
	import sweatless.interfaces.IBase;
	
	internal class Base extends Sprite implements IBase{
		
		public var data : Object = new Object();
		public var broadcaster : Broadcaster = Broadcaster.getInstance();
		
		private var listeners : Array;
		private var _id : String;
		
		public function Base(){
			listeners = new Array();
		}
		
		public function create(evt:Event=null):void{
			throw new Error("Please, override this method.");
		}
		
		public function destroy(evt:Event=null):void{
			throw new Error("Please, override this method.");
		}
		
		public function set id(p_id:String):void{
			_id = p_id.toLowerCase();
		}
		
		public function get id():String{
			return _id;
		}
		
		override public function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void{
			listeners.push({type:p_type, listener:p_listener, capture:p_useCapture});

			super.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
		}
		
		override public function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void{
			for (var i:uint=0; i<listeners.length; i++) {
				if (listeners[i].type == p_type && listeners[i].listener == p_listener && listeners[i].capture == p_useCapture) {
					listeners[i] = null;
					listeners.splice(i, 1);
					
					break;
				};
			}

			super.removeEventListener(p_type, p_listener, p_useCapture);
		}
		
		public function getAllEventListeners():Array{
			return listeners;
		}
		
		public function removeAllEventListeners():Boolean{
			var i:uint = listeners.length;
			
			while (i) {
				super.removeEventListener(listeners[i-1].type, listeners[i-1].listener, listeners[i-1].capture);

				listeners[i-1] = null;
				listeners.splice(i-1, 1);
				
				i--;
			}
			
			return listeners.length != 0 ? false : true;
		}
		
		override public function toString():String{
			return getQualifiedClassName(this);
		}
	}
}

