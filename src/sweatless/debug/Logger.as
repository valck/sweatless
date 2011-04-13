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

package sweatless.debug {

	import sweatless.utils.StringUtils;

	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.utils.getQualifiedClassName;

	public final class Logger{
		
		public static const DEBUG : uint = 0;
		public static const INFO : uint = 1;
		public static const WARNING : uint = 2;
		public static const ERROR : uint = 3;

		private var level : String;
		private var scope : String;
		
		public function Logger(p_scope:Object){
			scope = getQualifiedClassName(p_scope);
		}
		
		public function log(p_level:uint, ...p_message):void{
			switch (p_level){
				case Logger.DEBUG:
					level = "debug";
					break;
				case Logger.INFO:
					level = "info";
					break;
				case Logger.WARNING:
					level = "warn";
					break;
				case Logger.ERROR:
					level = "error";
					break;
			}
			
			output(p_message);
		}

		public function debug(...p_message):void{
			log(Logger.DEBUG, p_message);
		}
		
		public function info(...p_message):void{
			log(Logger.INFO, p_message);
		}
		
		public function warning(...p_message):void{	
			log(Logger.WARNING, p_message);
		}
		
		public function error(...p_message):void{
			log(Logger.ERROR, p_message);
		}

		private function output(...p_message) : void {
			!Capabilities.isDebugger && ExternalInterface.available ? ExternalInterface.call("console."+level, "["+scope+"] "+StringUtils.replace(String(p_message), ",", " ")) : trace("["+level.toUpperCase()+" @ "+scope+"]", StringUtils.replace(String(p_message), ",", " "));
		}
	}
}
