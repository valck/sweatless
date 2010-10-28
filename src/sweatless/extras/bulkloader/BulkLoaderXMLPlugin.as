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

package sweatless.extras.bulkloader{
	import br.com.stimuli.loading.lazyloaders.LazyBulkLoader;
	import br.com.stimuli.string.printf;
	
	import sweatless.utils.StringUtils;
	
	dynamic public class BulkLoaderXMLPlugin extends LazyBulkLoader {
		
		namespace lazy_loader = "http://code.google.com/p/bulk-loader/"
			
			public var source : XML;
		
		function BulkLoaderXMLPlugin(url:*, name:String){
			super (url, name);
		}
		
		lazy_loader override function _lazyParseLoader(p_data:String):void{
			var substitutions : Object = new Object();
			
			for each (var variable:* in new XML(p_data)..globals.variable){
				substitutions[String(variable.@name)] = String(variable.@value);
			}

			source = new XML(printf(StringUtils.replace(StringUtils.replace(p_data, "{", "%("), "}", ")s"), substitutions));
			
			source..fixed.asset == undefined ? add(lazy_loader::_lazyTheURL, new Object()) : null;
			source..tracking.@file != undefined ? add(String(source..tracking.@file), {id:String("tracking")}) : null;
			
			for each (var asset:XML in source..fixed.asset) {
				add(String(asset.@url), {id:String(asset.@id), pausedAtStart:asset.@paused ? true : false});
			}
		}
	}
}
