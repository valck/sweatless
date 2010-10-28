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
 * @author João Marquesini
 * 
 */

package sweatless.utils
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;

	public class MacMouseWheel
	{
		private static var _instance:MacMouseWheel;
		
		
		private var dummyEvent:MouseEvent;
		private var dummy:DisplayObject;
		
		public static function init( stage:Stage ):void
		{
			var isMac:Boolean = Capabilities.os.toLowerCase().indexOf( "mac" ) != -1;
			
			var js:URLRequest = new URLRequest("javascript:var swfmacmousewheel=function(){if(!swfobject)return null;var u=navigator.userAgent.toLowerCase();var p=navigator.platform.toLowerCase();var d=p?/mac/.test(p):/mac/.test(u);if(!d)return null;var k=[];var r=function(event){var o=0;if(event.wheelDelta){o=event.wheelDelta/120;if(window.opera)o= -o;}else if(event.detail){o= -event.detail;}if(event.preventDefault)event.preventDefault();return o;};var l=function(event){var o=r(event);var c;for(var i=0;i<k.length;i++){c=swfobject.getObjectById(k[i]);if(typeof(c.externalMouseEvent)=='function')c.externalMouseEvent(o);}};if(window.addEventListener)window.addEventListener('DOMMouseScroll',l,false);window.onmousewheel=document.onmousewheel=l;return{registerObject:function(m){k[k.length]=m;}};}();");		
			
			if( isMac ) navigateToURL(js, "_self");
			
			if( isMac ) setTimeout(instance._init , 1000, stage );
		}
		
		private function _init(stage:Stage):void{
			if( ExternalInterface.available )
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, targetGetter);
				ExternalInterface.addCallback('externalMouseEvent', javascriptMouseEvent );	
			}
		}
		
		private function targetGetter(e:MouseEvent):void{
			
			dummyEvent = e;
			dummy = DisplayObject(e.target);
		}
		
		private function javascriptMouseEvent(delta:Number):void{
			if(!dummyEvent || !dummy) return;
			var evt:MouseEvent = new MouseEvent(
				MouseEvent.MOUSE_WHEEL,
				true,
				false,
				dummyEvent.localX,
				dummyEvent.localY,
				dummyEvent.relatedObject,
				dummyEvent.ctrlKey, 
				dummyEvent.altKey, 
				dummyEvent.shiftKey, 
				dummyEvent.buttonDown, 
				int(delta));
			dummy.dispatchEvent(evt);
		}
		
		private static function get instance():MacMouseWheel{
			if(!_instance) _instance = new MacMouseWheel();
			return _instance;
		}
		
	}
}