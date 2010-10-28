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
	
	import flash.events.Event;
	import flash.utils.getQualifiedSuperclassName;
	
	import sweatless.events.Broadcaster;
	import sweatless.interfaces.IBase;
	import sweatless.navigation.core.Config;
	
	public class Menu extends Base implements IBase{
		
		public static const CHANGE : String = "change";
		
		private var type : String;
		private var properties : Array;
		private var buttons : Array;
		
		protected var selected : MenuButton;
		
		public function Menu(p_type:String="*"){
			type = p_type;
			properties = Config.getMenu(type);
			broadcaster = Broadcaster.getInstance();
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function change(evt:Event):void{
			var changed : MenuButton = getButton(Config.currentAreaID);
			
			if(selected) selected.enabled();
			
			selected = changed;
			
			if(selected) selected.disabled();
			
			dispatchEvent(new Event(Menu.CHANGE));
		}
		
		private function getButton(p_area:String):MenuButton{
			for(var i:uint=0; i<buttons.length; i++){
				if(buttons[i].area == p_area && buttons[i].type == type) return buttons[i];
			}
			return null; 
		}
		
		protected final function getButtons(p_skin:Class):Array{
			buttons = new Array();
			if(getQualifiedSuperclassName(p_skin) != (new MenuButton).toString()) throw new Error("Please, extends MenuButton Class");
			
			for(var i:uint=0; i<properties.length; i++){
				var button : MenuButton = new p_skin();
				
				for (var prop:* in properties[i]){
					button.setProperty(prop, properties[i][prop]);
				}
				
				button.type = type;
				button.area = properties[i].area == undefined ? properties[i].external : properties[i].area;
				
				buttons.push(button);
			}

			broadcaster.addEventListener(broadcaster.getEvent("change_menu"), change);
			
			return buttons;
		}
		
		override public function destroy(evt:Event=null):void{
			removeAllEventListeners();
		}
	}
}