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

package sweatless.navigation.core{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import sweatless.utils.StringUtils;
	
	public final class Config{
		
		private static var _started : Boolean;
		private static var _source : XML;
		private static var _currentAreaID : String;
		private static var _currentSubareaID : String;
		
		private static var trackerGA : AnalyticsTracker;
		private static var parameters : Dictionary = new Dictionary();

		public static function get started():Boolean{
			return _started;
		}
		
		public static function set started(p_value:Boolean):void{
			_started = p_value;
		}
		
		public static function set source(p_file:XML):void{
			_source = p_file;
		}
		
		public static function get source():XML{
			return _source;
		}
		
		public static function get currentAreaID():String{
			return _currentAreaID;
		}
		
		public static function set currentAreaID(p_area:String):void{
			_currentAreaID = p_area;
		}
		
		public static function get currentSubareaID():String
		{
			return _currentSubareaID;
		}
		
		public static function set currentSubareaID(p_subarea:String):void
		{
			_currentSubareaID = p_subarea;
		}
		
		public static function get firstArea():String{
			return String(source..areas.@first);
		}
		
		public static function get crossdomain():String{
			return String(source..crossdomain.@file);
		}
		
		public static function get tracking():String{
			return String(source..tracking.@file);
		}
		
		public static function getVar(p_name:String):Object{
			return parameters[p_name];
		}
		
		public static function setVar(p_name:String, p_value:Object):void{
			parameters[p_name] = p_value;
		}
		
		public static function getService(p_id:String):String{
			return String(source..services.service.(@id==p_id).@url);
		}
		
		public static function addAnalytics(p_scope:DisplayObject):void{
			trackerGA = new GATracker(p_scope, String(BulkLoader.getLoader("sweatless").getXML("tracking")..analytics.@account), "AS3", StringUtils.toBoolean(BulkLoader.getLoader("sweatless").getXML("tracking")..analytics.@debug));
		}
		
		public static function trackPage(p_id:String):void{
			BulkLoader.getLoader("sweatless").hasItem("tracking") ? trackerGA.trackPageview(String(BulkLoader.getLoader("sweatless").getXML("tracking")..trackpage.(@id==p_id).@tag)) : null;
		}
		
		public static function get layers():XMLList{
			return source..layer;
		}
		
		public static function get areas():XMLList{
			return source..area;
		}
		
		public static function getInArea(p_id:String, p_attribute:String):String{
			return String(areas.(@id==p_id)[p_attribute]);
		}
		
		public static function getAreaAdditionals(p_id:String, p_attribute:String):String{
			return String(areas.(@id==p_id).additionals[p_attribute]);
		}
		
		public static function getSubAreaParameter(p_area:String, p_subarea:String, p_paramname:String):String{
			return areas.(@id==p_area).subareas.subarea.(@id==p_subarea).attribute(p_paramname);
		}
		
		public static function getSubareas(p_area:String):Array{
			var result:Array = new Array();
			for(var i:String in areas.(@id==p_area).subareas.subarea){
				result.push(areas.(@id==p_area).subareas.subarea[i].@id);
			}
			return result;
		}
		
		public static function getAreaDependencies(p_id:String, p_type:String):Dictionary{
			var dependencies : Dictionary = new Dictionary();
			var i : uint = 0;
			
			switch(p_type){
				case "image":
					for(i=0; i<areas.(@id==p_id).dependencies..image.length(); i++){
						dependencies[String(areas.(@id==p_id).dependencies..image[i].@id)] = String(areas.(@id==p_id).dependencies..image[i].@url);
					}
					break;
				
				case "video":
					for(i=0; i<areas.(@id==p_id).dependencies..video.length(); i++){
						dependencies[String(areas.(@id==p_id).dependencies..video[i].@id)] = String(areas.(@id==p_id).dependencies..video[i].@url);
					}
					break;
				
				case "audio":
					for(i=0; i<areas.(@id==p_id).dependencies..audio.length(); i++){
						dependencies[String(areas.(@id==p_id).dependencies..audio[i].@id)] = String(areas.(@id==p_id).dependencies..audio[i].@url);
					}
					break;
				
				case "other":
					for(i=0; i<areas.(@id==p_id).dependencies..other.length(); i++){
						dependencies[String(areas.(@id==p_id).dependencies..other[i].@id)] = String(areas.(@id==p_id).dependencies..other[i].@url);
					}
					break;
			}
			
			return dependencies;
		}
		
		public static function hasDeeplink(p_deeplink:String):Boolean{
			for(var key : String in getAllDeeplinks()){
				if(p_deeplink == getAllDeeplinks()[key]) return true;
			}
			
			return false;
		}
		
		public static function getDeeplinkByArea(p_area:String):String{
			for(var key : String in getAllDeeplinks()){
				if(p_area == key) return getAllDeeplinks()[key];
			}
			
			return getAreaAdditionals(firstArea, "@deeplink");
		}
		
		public static function getAreaByDeeplink(p_deeplink:String):String{
			for(var key : String in getAllDeeplinks()){
				if(p_deeplink == getAllDeeplinks()[key]) return key;
			}
			
			return firstArea;
		}
		
		public static function getFirstSubArea(p_area:String):String{
			return areas.(@id == p_area).subareas.@first;
		}
		
		public static function getSubAreaByDeeplink(p_area:String, p_subarea:String):String{
			var area:String = getAreaByDeeplink(p_area);
			var node:XMLList = areas.(@id==area); 
			for(var i:uint=0; i<node.subareas.subarea.length(); i++){
				if(node.subareas.subarea[i].@deeplink==p_subarea) return node.subareas.subarea[i].@id;
			}
			
			if(node.subareas.@first) return node.subareas.@first;
			
			return "";
		}
		
		public static function getAllDeeplinks():Dictionary{
			var deeplinks : Dictionary = new Dictionary();
			
			for(var i:uint=0; i<areas.length(); i++){
				getAreaAdditionals(String(areas[i].@id), "@deeplink") ? deeplinks[String(areas[i].@id)] = String(getAreaAdditionals(String(areas[i].@id), "@deeplink")) : null;
			}
			
			return deeplinks;
		}
		
		public static function getMenuButtons(p_type:String="*"):Array{
			var all : Boolean = p_type == "*" ? true : false;
			var buttons : Array = new Array();
			
			for(var a:uint=0; a<uint(all ? source..button.length() : source..buttons.(@type==p_type).button.length()); a++){
				var attributes : Object = new Object();
				for(var b:uint=0; b<uint(all ? source..button[a].@*.length() : source..buttons.(@type==p_type).button[a].@*.length()); b++){
					all ? attributes[String(source..button[a].@*[b].name())] = String(source..button[a].@*[b]) : attributes[String(source..buttons.(@type==p_type)..button[a].@*[b].name())] = String(source..buttons.(@type==p_type)..button[a].@*[b]);
				}
				
				buttons.push(attributes);
			}
			
			return buttons;
		}

		public static function getMenuTypes():Array{
			var buttons : Array = new Array();
			
			for(var a:uint=0; a<source..buttons.length(); a++){
				buttons.push(source..buttons[a]);
			}
			
			return buttons;
		}
	}
}
