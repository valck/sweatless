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
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;

    public class CustomListener{
        private static var targetMap : Dictionary = new Dictionary();
		
        public static function addListener(p_target:IEventDispatcher, p_type:String, p_listener:Function, ...args):void{
            var targetEventMap : Dictionary;

            targetEventMap = targetMap[p_target] == undefined ? new Dictionary : targetMap[p_target];
            
            targetEventMap[p_type] = {listener:p_listener, args:args};
            targetMap[p_target] = targetEventMap;
            
            p_target.addEventListener(p_type, onEvent);
        }
        
        public static function dispatch(p_target:IEventDispatcher, p_type:String, p_data:Object=null) : void{
            p_target.dispatchEvent(new CustomEvent(p_type, p_data));
        }
        
        public static function removeListener(p_target:IEventDispatcher, p_type:String) : void{
            var targetEventMap : Dictionary = targetMap[p_target];
            
            targetEventMap[p_type] = null;
            delete targetEventMap[p_type];
            
            p_target.removeEventListener(p_type, onEvent);
        }
        
        private static function onEvent (evt:Event):void{
            var target : IEventDispatcher = evt.currentTarget as IEventDispatcher;
            
            var targetEventMap : Dictionary = targetMap[target];
            var eventType : String = evt.type;
            
            var listener : Function = targetEventMap[eventType].listener;
            var args:Array = targetEventMap[eventType].args;
            
            if (args[0] is Event) args.shift();
            
            args.unshift(evt);

            listener.apply(target, args);
        }

    }
}
