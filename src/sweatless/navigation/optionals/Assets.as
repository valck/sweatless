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

package sweatless.navigation.optionals{
	import br.com.stimuli.loading.BulkLoader;
	
	import flash.utils.Dictionary;
	
	import sweatless.navigation.core.Config;

	public class Assets{
		
		public static const TEXT : String = "text";
		public static const AUDIO : String = "audio";
		public static const VIDEO : String = "video";
		public static const IMAGE : String = "image";
		public static const OTHER : String = "other";

		public static function getString(p_id:String, p_type:String, p_area:XML=null):String{
			var result : String;

			p_area = p_area ? p_area : BulkLoader.getLoader(Config.currentAreaID).getXML("assets");

			switch(p_type){
				case "text":
					result = String(p_area..text.(@id==p_id));
				break;
	
				case "image":
					result = String(p_area..image.(@id==p_id).@url);
				break;
				
				case "video":
					result = String(p_area..video.(@id==p_id).@url);
				break;
				
				case "audio":
					result = String(p_area..audio.(@id==p_id).@url);
				break;

				case "other":
					result = String(p_area..other.(@id==p_id).@url);
				break;
			}
			
			return result;
		}
		
		public static function get source():XML{
			return BulkLoader.getLoader(Config.currentAreaID).getXML("assets");
		}
		
		public static function getStringGroup(p_type:String, p_area:XML=null):Dictionary{
			var result : Dictionary = new Dictionary();
			var i : uint = 0;
			
			p_area = p_area ? p_area : BulkLoader.getLoader(Config.currentAreaID).getXML("assets");
			
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