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

package sweatless.events{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public dynamic class Broadcaster extends EventDispatcher{
		
		private static var instance : Broadcaster;
		private static var registeredEvents : Dictionary = new Dictionary();
		
		public function Broadcaster(){
			if(instance) throw new Error("Broadcaster already initialized.");
		}
		
		public static function getInstance():Broadcaster {
			if (!instance) instance = new Broadcaster();
			return instance;
		}
		
		public function getEvent(p_event:String):String {
			if(!hasEvent(p_event)) throw new Error("The event "+ toUppercase(p_event) +" doesn't exists.");
			return registeredEvents[toUppercase(p_event)];
		}
		
		public function setEvent(p_event:String): void{
			if(hasEvent(p_event)) throw new Error("The event "+ toUppercase(p_event) +" already registered.");
			registeredEvents[toUppercase(p_event)] = addEvent(toUppercase(p_event), toLowercase(p_event));
		}

		public function hasEvent(p_event:String):Boolean{
			return registeredEvents[toUppercase(p_event)] ? true : false;
		}

		public function clearEvent(p_event:String): void{
			if(!hasEvent(p_event)){
				throw new Error("The event "+ toUppercase(p_event) +" don't exists or already removed.");
			}else{
				registeredEvents[toUppercase(p_event)] = null;
				delete registeredEvents[toUppercase(p_event)];
			}
		}

		public function clearAllEvents(): void{
			for(var key:* in registeredEvents){
                registeredEvents[key] = null;
                delete registeredEvents[key];
            }
		}

		private function addEvent(p_upper : String, p_lower : String):*{
			return getInstance()[String(p_upper)] = String(p_lower);
		}
		
		private function toLowercase(p_string:String):String{
			return String(p_string.toLowerCase());
		}
		
		private function toUppercase(p_string:String):String{
			return String(p_string.toUpperCase());
		}
	}
}
