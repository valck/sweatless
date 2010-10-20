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
 * 
 */

package sweatless.data{
    import flash.events.NetStatusEvent;
    import flash.net.SharedObject;
    import flash.net.SharedObjectFlushStatus;
 
	/**
	 * 
	 * The SO class is a simple manager for <code>SharedObject</code>.
	 * 
	 * @see SharedObject
	 * 
	 */
    public class SO{
 
        private var saved : SharedObject;

		/**
		 * 
		 * The SO class is a simple manager for <code>SharedObject</code>.
		 * 
		 * @param p_name Name/ID of <code>SharedObject</code> to save.
		 * @example Usage example:<listing version="3.0">
var so : SO = new SO("some_id");
so.data = "foo";
 
trace(so.data);
trace(so.clear());
trace(so.data);
		 * </listing>
		 * 
		 * @see SharedObject
		 * 
		 */
        public function SO(p_name:String="cookie") {
            saved = SharedObject.getLocal(p_name);
        }
 
		/**
		 * Sets/Get any <code>String</code> value in <code>SharedObject</code>.
		 * 
		 * @param p_value any <code>String</code>.
		 * 
		 */
		public function set data(p_value:String):void {
            clear();

            saved.data.value = p_value;
 
            var flushStatus:String;
 
            try{
                flushStatus = saved.flush(10000);
            } catch (error:Error) {
				
            }
 			
            if(!flushStatus) return;
			
            switch (flushStatus) {
                case SharedObjectFlushStatus.PENDING:
                    saved.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
                    break;
                case SharedObjectFlushStatus.FLUSHED:
                    break;
            }
        }
 
		public function get data():String{
			if(!saved.data.value) return null;
			return saved.data.value;
		}
		
		/**
		 * 
		 * @return If <code>data</code> has been clean <code>true</code> or <code>false</code>. 
		 * 
		 */
        public function clear():Boolean {
            var result : Boolean;
			
			if(saved.data.value) {
				delete saved.data.value;
				result = true;
			}else{
				result = false;
			}
			
			return result;
        }
		
        private function onFlushStatus(evt:NetStatusEvent):void {
            switch (evt.info.code) {
                case "SharedObject.Flush.Success":
                    break;
                case "SharedObject.Flush.Failed":
                    break;
            }
			
            saved.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
        }
    }
}	