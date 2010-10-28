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

package sweatless.events{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * The <code>Broadcaster</code> is a very useful dynamic singleton for management events. It's a better and more fast way to centralize events.
	 * 
	 */
	public dynamic class Broadcaster extends EventDispatcher{
		
		private static var instance : Broadcaster;
		private static var registeredEvents : Dictionary = new Dictionary();
		
		/**
		 * 
		 * The <code>Broadcaster</code> is a very useful dynamic singleton for management events. It's a better and more fast way to centralize events.
		 * 
		 */
		public function Broadcaster(){
			if(instance) throw new Error("Broadcaster already initialized.");
		}
		
		/**
		 *
		 * Initialize/Get the <code>Broadcaster</code> instance. 
		 * 
		 * @return The instance of the <code>Broadcaster</code> 
		 * 
		 */
		public static function getInstance():Broadcaster{
			if (!instance) instance = new Broadcaster();
			return instance;
		}
		
		/**
		 *
		 * Get a registered event.
		 *  
		 * @param p_event The name of the event
		 * @return The value in <code>String</code> of the event
		 * 
		 */
		public function getEvent(p_event:String):String{
			if(!hasEvent(p_event)) throw new Error("The event "+ toUppercase(p_event) +" doesn't exists.");
			return registeredEvents[toUppercase(p_event)];
		}
		
		/**
		 * 
		 * Sets a event
		 * 
		 * @param p_event The name of the event
		 * 
		 */
		public function setEvent(p_event:String):void{
			if(hasEvent(p_event)) throw new Error("The event "+ toUppercase(p_event) +" already registered.");
			registeredEvents[toUppercase(p_event)] = addEvent(toUppercase(p_event), toLowercase(p_event));
		}

		/**
		 *
		 * Checks if the event has exists.
		 *  
		 * @param p_event The name of the event
		 * @return <code>true</code> or <code>false</code>
		 * 
		 */
		public function hasEvent(p_event:String):Boolean{
			return registeredEvents[toUppercase(p_event)] ? true : false;
		}

		/**
		 *
		 * Remove a specific registered event. 
		 *  
		 * @param p_event The name of the event
		 * 
		 */
		public function clearEvent(p_event:String):void{
			if(!hasEvent(p_event)){
				throw new Error("The event "+ toUppercase(p_event) +" don't exists or already removed.");
			}else{
				registeredEvents[toUppercase(p_event)] = null;
				delete registeredEvents[toUppercase(p_event)];
			}
		}

		/**
		 *
		 * Clear all registered events of the <code>Broadcaster</code> instance. 
		 * 
		 */
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
