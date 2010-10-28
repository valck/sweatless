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
	import flash.events.Event;
	
	/**
	 * 
	 * The <code>CustomEvent</code> is a simple and customizable event for send any objects in this return. It's like a native <code>Event</code> class.
	 * 
	 */
	public dynamic class CustomEvent extends Event{
		
		private var _data : Object;

		/**
		 * 
		 * The <code>CustomEvent</code> is a simple and customizable event for send any objects in this return. It's like a native <code>Event</code> class.
		 * 
		 */
		public function CustomEvent(p_type:String, p_data:Object=null, p_bubbles:Boolean=false, p_cancelable:Boolean=false){
			super(p_type, p_bubbles, p_cancelable);
			
			data = p_data;
		}
		
		/**
		 *
		 * The <code>data</code> is the <code>Object</code> which are passed as parameter to <code>CustomEvent</code>.
		 *  
		 * @param p_value Any <code>Object</code> to send/receive in the <code>CustomEvent</code>
		 * 
		 */
		public function set data(p_value:Object):void{
			_data = p_value;
		}
		
		public function get data():Object{
			return _data;
		}
		
		/**
		 * 
		 * Returns a new <code>CustomEvent</code> object that is a copy of the original instance of the <code>CustomEvent</code> object. You do not normally call clone(); the <code>EventDispatcher</code> class calls it automatically when you redispatch an event that is, when you call dispatchEvent(customevent) from a handler that is handling event.
		 * The new <code>CustomEvent</code> object includes all the properties of the original.
		 *  
		 * @return A new <code>CustomEvent</code> object that is identical to the original. 
		 * 
		 */
		public override function clone():Event{
            return new CustomEvent(type, data, bubbles, cancelable);
        }
		
		/**
		 * Returns a string containing all the properties of the <code>CustomEvent</code> object. 
		 * 
		 * @return The string is in the following format: [CustomEvent type=value data=value bubbles=value cancelable=value]
		 * 
		 */
        public override function toString():String{
            return formatToString("CustomEvent", "type", "data", "bubbles", "cancelable");
        }
	}
}