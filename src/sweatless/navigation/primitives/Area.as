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
	import br.com.stimuli.loading.BulkLoader;
	
	import flash.events.Event;
	
	import sweatless.interfaces.IDisplay;
	import sweatless.navigation.core.Config;
	
	public class Area extends Base implements IDisplay{
		
		public static const READY : String = "ready";
		public static const CLOSED: String = "closed";
		
		private var _id : String;
		
		public function Area(){
			tabEnabled = false;
			tabChildren = false;
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		public function set id(p_id:String):void{
			_id = p_id;
		}
		
		public function get id():String{
			return _id;
		}
		
		public function get assets():XML{
			return loader.getXML("assets");
		}
		
		public function get loader():BulkLoader{
			return BulkLoader.getLoader(Config.currentAreaID);
		}
		
		public function navigateTo(p_areaID:String):void{
			broadcaster.hasEvent("show_"+p_areaID) ? broadcaster.dispatchEvent(new Event(broadcaster.getEvent("show_"+p_areaID))) : null;
		}
		
		override public function create(evt:Event=null):void{
			dispatchEvent(new Event(READY));
		}
		
		override public function destroy(evt:Event=null):void{
			removeAllEventListeners();
		}
		
		public function show():void{

		}
		
		public function hide():void{
			dispatchEvent(new Event(CLOSED));
		}
	}
}
