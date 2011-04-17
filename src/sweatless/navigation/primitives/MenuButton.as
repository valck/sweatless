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

package sweatless.navigation.primitives {

	import sweatless.events.CustomEvent;
	import sweatless.interfaces.IButton;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class MenuButton extends Base implements IButton{
		
		private var clicked : Boolean;
		
		public function MenuButton(){
			addEventListener(Event.ADDED_TO_STAGE, check);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function check(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, check);
			
			if(!area) throw new Error("Please, set a area for this button, before add to stage");
		}
		
		public function get area():String{
			return data.area;
		}
		
		public function set area(p_area:String):void{
			data["area"] = p_area; 
		}
		
		public function get label():String{
			return data.label;
		}
		
		public function set label(p_label:String):void{
			data["label"] = p_label;
		}
		
		public function get type():String{
			return data.type;
		}
		
		public function set type(p_type:String):void{
			data["type"] = p_type;
		}
		
		public function get external():String{
			return data.external;
		}
		
		public function set external(p_value:String):void{
			data["external"] = p_value;
		}
		
		public function get target():String{
			return data.target;
		}
		
		public function set target(p_value:String):void{
			data["target"] = p_value;
		}
		
		public function getProperty(p_id:String):*{
			return data[p_id] == undefined ? null : data[p_id];
		}
		
		public function setProperty(p_id:String, p_value:*):void{
			data[p_id] = p_value;
		}
		
		override public function create(evt:Event=null):void{
			throw new Error("Please, override this method.");
		}
		
		public final function addListeners():void{
			buttonMode = true;
			
			addEventListener(MouseEvent.CLICK, click);
			addEventListener(MouseEvent.ROLL_OVER, over);
			addEventListener(MouseEvent.ROLL_OUT, out);
		}
		
		public final function removeListeners():void{
			buttonMode = false;
			
			removeEventListener(MouseEvent.CLICK, click);
			removeEventListener(MouseEvent.ROLL_OVER, over);
			removeEventListener(MouseEvent.ROLL_OUT, out);
		}
		
		public function enabled():void{
			clicked ? clicked = false : null;
			
			addListeners();
		}
		
		public function disabled():void{
			!clicked ? clicked = true : null;
			
			removeListeners();
		}
		
		public function over(evt:MouseEvent):void{
			throw new Error("Please, override this method.");
		}
		
		public function out(evt:MouseEvent):void{
			throw new Error("Please, override this method.");
		}
		
		private function click(evt:MouseEvent):void{
			external ? navigateToURL(new URLRequest(external), target) : broadcaster.hasEvent("show_"+area) ? broadcaster.dispatchEvent(new Event(broadcaster.getEvent("show_"+area))) : null;
			broadcaster.dispatchEvent(new CustomEvent(broadcaster.getEvent("change_menu"), area));
		}
		
		override public function destroy(evt:Event=null):void{
			removeAllEventListeners();
		}
		
		override public function get name():String{
			return area;
		}
	}
}

