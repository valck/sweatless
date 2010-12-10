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
	import br.com.stimuli.loading.BulkLoader;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedSuperclassName;
	
	import sweatless.interfaces.IDisplay;
	import sweatless.navigation.core.Config;
	
	public class Area extends Base implements IDisplay{
		
		public static const READY : String = "ready";
		public static const CLOSED: String = "closed";
		
		private var subareas:Dictionary;
		
		private var currentSubArea:SubArea;
		private var previousSubArea:SubArea;
		
		private var _id : String;
		
		public function Area(){
			tabEnabled = false;
			tabChildren = false;
			
			if(Config.getSubareas(Config.currentAreaID).length>0) subareas = new Dictionary();
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		public function addSubArea(p_id:String, p_subareaClass:Class):void{
			if(String(describeType(p_subareaClass)..extendsClass.(@type=="sweatless.navigation.primitives::SubArea").@type).length <= 0) 
				throw new Error("The subarea class must extend the SubArea primitive class to be added");
			
			subareas[p_id] = p_subareaClass;
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
		
		public function navigateTo(p_areaID:String, subArea:String=""):void{
			Config.currentSubareaID = subArea;
			broadcaster.hasEvent("show_"+p_areaID) ? broadcaster.dispatchEvent(new Event(broadcaster.getEvent("show_"+p_areaID))) : null;
		}
		
		override public function create(evt:Event=null):void{
			dispatchEvent(new Event(READY));
		}
		
		override public function destroy(evt:Event=null):void{
			removeAllEventListeners();
			
			if(currentSubArea){
				currentSubArea.destroy();
				currentSubArea = null;
			}
		}
		
		public function changeSubArea(p_subarea:String):void{
			previousSubArea = currentSubArea;
			previousSubArea.hide();
			previousSubArea.addEventListener(SubArea.CLOSED, subAreaChanging);
			Config.currentSubareaID = p_subarea;
		}
		
		private function subAreaChanging(evt:Event):void{
			previousSubArea.removeEventListener(SubArea.CLOSED, subAreaChanging);
			previousSubArea.destroy();
			previousSubArea = null;
			showSubArea(Config.currentSubareaID);
		}
		
		public function show():void{
			if(!subareas) return;
			showSubArea(Config.currentSubareaID);
		}
		
		protected function showSubArea(p_subarea:String):void{
			if(!subareas[p_subarea]) throw new Error("You need to add the subarea before showing it.");
			currentSubArea = new subareas[p_subarea]();
			addChild(currentSubArea);
			currentSubArea.create();
			currentSubArea.show();
		}
		
		public function hide():void{
			if(!currentSubArea) {
				dispatchEvent(new Event(CLOSED));
			}else{
				currentSubArea.addEventListener(SubArea.CLOSED, subAreaClosed);
				currentSubArea.hide();
			}
		}
		
		private function subAreaClosed(evt:Event):void{
			currentSubArea.removeEventListener(SubArea.CLOSED, subAreaClosed);
			dispatchEvent(new Event(CLOSED));
		}
	}
}
