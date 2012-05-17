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
 * http://www.sweatless.as/
 * 
 * @author Valério Oliveira (valck)
 * 
 */

package sweatless.navigation.core {


	internal final class Assets{
		
		public static const TEXT : String = "text";
		public static const AUDIO : String = "audio";
		public static const VIDEO : String = "video";
		public static const IMAGE : String = "image";
		public static const OTHER : String = "other";
		
		private static var _source : XML;
		private static var _assets : Assets;
		
		public function Assets(){
			if(_assets) throw new Error("Assets already initialized.");
		}
		
		public static function get instance():Assets{
			_assets = _assets || new Assets();
			
			return _assets;
		}

		public function getString(p_id:String, p_type:String, p_area:XML=null):String{
			var result : String;
			var language : String = Sweatless.config.currentLanguage;
			
			_source = p_area ? p_area : Sweatless.loader.current().getXML("assets") ? Sweatless.loader.current().getXML("assets") : null;
			
			switch(p_type){
				case "image":
					result = String(_source..image.(@id==p_id).language.@id != undefined ? _source..image.(@id==p_id).language.(@id==language).text() : _source..image.(@id==p_id).text());
				break;
				
				case "video":
					result = String(_source..video.(@id==p_id).language.@id != undefined ? _source..video.(@id==p_id).language.(@id==language).text() : _source..video.(@id==p_id).text());
				break;
				
				case "audio":
					result = String(_source..audio.(@id==p_id).language.@id != undefined ? _source..audio.(@id==p_id).language.(@id==language).text() : _source..audio.(@id==p_id).text());
				break;

				case "other":
					result = String(_source..other.(@id==p_id).language.@id != undefined ? _source..other.(@id==p_id).language.(@id==language).text() : _source..other.(@id==p_id).text());
				break;

				case "swf":
					result = String(_source..swf.(@id==p_id).language.@id != undefined ? _source..swf.(@id==p_id).language.(@id==language).text() : _source..swf.(@id==p_id).text());
				break;
			}
			
			return _source ? result : "Asset id "+p_id+" and type "+p_type.toUpperCase()+" not found.";
		}
		
		public function getLength(p_type:String=null, p_area:XML=null):uint{
			var result : uint = 0;
			
			_source = p_area ? p_area : Sweatless.loader.current().getXML("assets") ? Sweatless.loader.current().getXML("assets") : null;
			
			switch(p_type){
				case "text":
					result = _source..text.(@id==p_id).length();
				break;
				
				case "image":
					result = _source..image.(@id==p_id).length();
				break;
				
				case "video":
					result = _source..video.(@id==p_id).length();
				break;
				
				case "audio":
					result = _source..audio.(@id==p_id).length();
				break;

				case "other":
					result = _source..other.(@id==p_id).length();
				break;

				case "swf":
					result = _source..swf.(@id==p_id).length();
				break;
			}
			
			return result;
		}
		public function getTextPagesLength(p_id:String, p_area:XML=null):uint{
			var result : uint = 0;
			
			_source = p_area ? p_area : Sweatless.loader.current().getXML("assets") ? Sweatless.loader.current().getXML("assets") : null;
			
			if(_source..text.(@id==p_id)..page.@id != undefined){
				result = _source..text.(@id==p_id)..page.length();
			}
			
			return result;
		}
		
		public function getText(p_id:String, p_page:String=null, p_area:XML=null):String{
			var language : String = Sweatless.config.currentLanguage;
			
			_source = p_area ? p_area : Sweatless.loader.current().getXML("assets") ? Sweatless.loader.current().getXML("assets") : null;
			
			var temp : Array = new Array();
			var result : String;
			
			if(_source..text.(@id==p_id)..language.@id != undefined){
				if(p_page){
					result = _source..text.(@id==p_id).page.(@id==p_page).language.(@id==language).text();
//				}else if(_source..text.(@id==p_id)..page.@id != undefined){
//					result = _source..text.(@id==p_id)..page.(@id==p_page).language.(@id==language).text();
				}else{
					_source..text.(@id==p_id)..language.(@id==language).(temp.push(text()));
					result = temp.toString().split(",").join("\n"); 
				}
			}else{
				if(p_page){
					result = _source..text.(@id==p_id).page.(@id==p_page).text();
				}else if(_source..text.(@id==p_id)..page.@id != undefined){
					_source..text.(@id==p_id)..page.(temp.push(text()));
					result = temp.toString().split(",").join("\n");
				}else{
					_source..text.(@id==p_id).(temp.push(text()));
					result = temp.toString().split(",").join("\n");
				}
			}
			
			return _source ? result : "Text id "+p_id+" not found.";
		}
		public function get source():XML{
			_source = Sweatless.loader.current().getXML("assets") ? Sweatless.loader.current().getXML("assets") : null;
			return _source;
		}
	}
}