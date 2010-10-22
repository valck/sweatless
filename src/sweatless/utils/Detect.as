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

package sweatless.utils{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;

	/**
	 * 
	 * Simple Class for detect OS and browser.
	 * 
	 *  
	 * @example <listing version="3.0">
	 private var detect = new Detect();
	 detect.addEventListener(Detect.COMPLETE, detected);
	 
	 private function detected(evt:Event):void{
	 	trace(detect.os);
		trace(detect.plataform);
	 	trace(detect.browser);
	    trace(detect.browser_version);
	    trace(detect.servicepack);
	 }
	 * </listing>
	 */
	public class Detect extends EventDispatcher{
		
		public static const COMPLETE : String = "complete";
		
		private var userBrowser : String;
		private var userBrowserVersion : String;
		private var userOs : String;
		private var userPlatform : String;
		private var userSPack : String;
		
		/**
		 * Create a virtual JS in memory to detect the browser
		 */
		public function Detect(){
			if(Capabilities.playerType == "StandAlone") throw new Error("UserDetect, only detect the user in browser.");
			
			var js : URLRequest = new URLRequest("javascript:function detect(){return [navigator.userAgent, navigator.platform,navigator.appMinorVersion];};");
			navigateToURL(js, "_self");
			
			setTimeout(load, 500);
		}
		
		/**
		 * Returns the current OS.
		 * @return String
		 * 
		 */
		public function get os():String{
			return userOs;
		}
		
		/**
		 * Plataform getter
		 * @return String
		 * 
		 */
		public function get plataform():String{
			return userPlatform;
		}
		
		/**
		 * Browser getter
		 * @return String
		 * 
		 */
		public function get browser():String{
			return userBrowser;
		}
		
		/**
		 * Browser Version getter
		 * @return String
		 * 
		 */
		public function get browser_version():String{
			return userBrowserVersion;
		}
		
		/**
		 * Service Pack getter only for Windows XP
		 * @return String
		 * 
		 */
		public function get servicepack():String{
			return userSPack;
		}
		
		/**
		 * Call and parser the virtual JS
		 * 
		 */		
		private function load():void{
			var results : Array = String(ExternalInterface.call('detect')).split(",");
			
			var a : String = results[0];
			var b : String = results[1];
			var d : String = results[2];
			
			var c : Object  = new Object();
			c = {
				version: (a.toLowerCase().match( /.+(?:rv|it|ra|ie|me)[\/: ]([\d.]+)/ ) || [])[1],
				chrome: /chrome/.test( a.toLowerCase() ),
				safari: /webkit/.test( a.toLowerCase() ) ,
				opera: /opera/.test( a.toLowerCase() ),
				msie: /msie/.test( a.toLowerCase() ),
				mozilla: /mozilla/.test( a.toLowerCase() )
			};
			
			var mozilla : Boolean = c.mozilla;
			var msie : Boolean = c.msie;
			var opera : Boolean = c.opera;
			var safari : Boolean = c.safari;
			var chrome : Boolean = c.chrome;
			var version : String = c.version;
			
			if(mozilla){
				userBrowser = 'Mozilla';
				userBrowserVersion = version;
			}
			
			if(msie){
				userBrowser = 'Msie';
				userBrowserVersion = version ;
			}
			
			if(opera){
				userBrowser = 'Opera';
				userBrowserVersion = version ;
			}
			
			if(safari){
				userBrowser = 'Safari';
				userBrowserVersion = version;
			}
			
			if(chrome){
				userBrowser = 'Chrome';
				userBrowserVersion = version;
			}
			
			
			switch(b){
				case 'Win64':
					userPlatform = 'Windows 64'
					break;
				case 'Win32':
					userPlatform = 'Windows 32'
					break;
				case 'Linux i686':
					userPlatform = 'Linux'
					break;
				case 'MacPPC':
					userPlatform = 'Mac PPC'
					break;
				case 'MacIntel':
					userPlatform = 'Mac Intel'
					break;
				case 'iPhone':
					userPlatform = 'iPhone'
					break;
			}

			if(a.indexOf('Windows NT 6.1') > -1) userOs = 'Windows 7';
			if(a.indexOf('Windows NT 6.0') > -1) userOs = 'Windows Vista';
			if(a.indexOf('Windows NT 5.2') > -1) userOs = 'Windows Server 2003 | Windows XP (x64)';
			if(a.indexOf('Windows NT 5.1') > -1) userOs = 'Windows XP';
			if(a.indexOf('Windows NT 5.0') > -1) userOs = 'Windows 2000';
			if(a.indexOf('Windows NT 4.0') > -1) userOs = 'Windows NT 4.0';
			if(a.indexOf('Windows NT 3.51') > -1) userOs = 'Windows NT 3.51';
			if(a.indexOf('Windows NT 3.5') > -1) userOs = 'Windows NT 3.5';
			if(a.indexOf('Windows NT 3.1') > -1) userOs = 'Windows NT 3.1';
			
			
			if ((d.indexOf('SP3') > -1) && (a.indexOf('Windows NT 5.1') > -1)) userSPack = 'SP3';
			if ((d.indexOf('SP2') > -1) && (a.indexOf('Windows NT 5.1') > -1)) userSPack = 'SP2';
			if ((d.indexOf('SP1') > -1) && (a.indexOf('Windows NT 5.1') > -1)) userSPack = 'SP1';
			
			
			dispatchEvent(new Event(COMPLETE));
		}
	}
}