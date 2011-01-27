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
	
	import flash.utils.Dictionary;

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
			
			_source = p_area ? p_area : BulkLoader.getLoader(Sweatless.config.currentAreaID).getXML("assets") ? BulkLoader.getLoader(Sweatless.config.currentAreaID).getXML("assets") : null;
			
			switch(p_type){
				case "text":
					result = String(_source..text.(@id==p_id));
				break;
	
				case "image":
					result = String(_source..image.(@id==p_id).@url);
				break;
				
				case "video":
					result = String(_source..video.(@id==p_id).@url);
				break;
				
				case "audio":
					result = String(_source..audio.(@id==p_id).@url);
				break;

				case "other":
					result = String(_source..other.(@id==p_id).@url);
				break;
			}
			
			return _source ? result : "[id:"+p_id+" type:"+p_type+"]";
		}
		
		public function get source():XML{
			return _source;
		}
		
		public function getStringGroup(p_type:String, p_area:XML=null):Dictionary{
			var result : Dictionary = new Dictionary();
			var i : uint = 0;
			
			p_area = p_area ? p_area : BulkLoader.getLoader(Sweatless.config.currentAreaID).getXML("assets");
			
			switch(p_type){
				case "text":
					for(i=0; i<p_area..text.length(); i++){
						result[String(p_area..text[i].@id)] = String(p_area..text[i].@url);
					}
				break;
				
				case "image":
					for(i=0; i<p_area..image.length(); i++){
						result[String(p_area..image[i].@id)] = String(p_area..image[i].@url);
					}
				break;
				
				case "video":
					for(i=0; i<p_area..video.length(); i++){
						result[String(p_area..video[i].@id)] = String(p_area..video[i].@url);
					}
				break;
				
				case "audio":
					for(i=0; i<p_area..audio.length(); i++){
						result[String(p_area..audio[i].@id)] = String(p_area..audio[i].@url);
					}
				break;
				
				case "other":
					for(i=0; i<p_area..other.length(); i++){
						result[String(p_area..other[i].@id)] = String(p_area..other[i].@url);
					}
				break;
			}
			
			return result;
		}

	}
}