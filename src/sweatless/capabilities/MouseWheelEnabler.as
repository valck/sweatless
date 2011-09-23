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
 * @author João Marquesini
 *
 */

package sweatless.capabilities {

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * The <code>MouseWheelEnabler</code> class fixes some browsers bugs on MouseWheel event handling.
	 * @see Stage
	 */
	public class MouseWheelEnabler {
		private static var _instance:MouseWheelEnabler;
		
		private const eventTimeout:uint = 50;
		
		private var lastEventTime:uint = 0;
		private var currentItem:InteractiveObject;
		private var browserMouseEvent:MouseEvent;
		
		/**
		 * Init the dispatchers of the <code>MouseWheelEnabler</code> class.
		 * @param stage The <code>Stage</code>.
		 * @see Stage
		 */
		public static function init(stage:Stage):void {
			instance.init(stage);
		}
		

		private function init(stage:Stage):void {
			if (ExternalInterface.available) {
				stage.addEventListener(MouseEvent.MOUSE_MOVE, setInteractiveObject);
				var jsId:String = 'mws_' + getTimer();
				ExternalInterface.addCallback(jsId, function():void{});
				ExternalInterface.call(JavaScript.MouseWheel);
				ExternalInterface.call("mws.InitMouseWheelSupport", jsId);
				ExternalInterface.addCallback('externalMouseEvent', handleExternalMouseEvent);
			}
		}
		
		private function setInteractiveObject(e:MouseEvent ):void
		{
			currentItem = InteractiveObject( e.target );
			browserMouseEvent = MouseEvent( e );
		}

		private function handleExternalMouseEvent(rawDelta:Number, scaledDelta:*):void
		{
			var delta:Number;
			var curTime:uint = getTimer();
			
			if (curTime >= eventTimeout + lastEventTime)
			{				
				delta = scaledDelta;
				
				if(currentItem && browserMouseEvent)
				{
					currentItem.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false, 
						browserMouseEvent.localX, browserMouseEvent.localY, browserMouseEvent.relatedObject,
						browserMouseEvent.ctrlKey, browserMouseEvent.altKey, browserMouseEvent.shiftKey, browserMouseEvent.buttonDown,
						int(delta)));
				}
				
				lastEventTime = curTime;
			}
		}


		private static function get instance():MouseWheelEnabler {
			if (!_instance) {
				_instance=new MouseWheelEnabler();
			}
			return _instance;
		}

	}
}

class JavaScript
{
	public static const MouseWheel : XML = 
	
		<script><![CDATA[
			function()
			{
				// create unique namespace
				if(typeof mws == "undefined" || !mws)	
				{
					mws = {};
				}
				
				var userAgent = navigator.userAgent.toLowerCase();
				mws.agent = userAgent;
				mws.platform = 
				{
					win:/win/.test(userAgent),
					mac:/mac/.test(userAgent),
					other:!/win/.test(userAgent) && !/mac/.test(userAgent)
				};
				
				mws.vars = {};
				
				mws.browser = 
				{
					version: (userAgent.match(/.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/) || [])[1],
					safari: /webkit/.test(userAgent) && !/chrome/.test(userAgent),
					opera: /opera/.test(userAgent),
					msie: /msie/.test(userAgent) && !/opera/.test(userAgent),
					mozilla: /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent),
					chrome: /chrome/.test(userAgent)
				};
				
				// find the function we added
				mws.findSwf = function(id) 
				{
					var objects = document.getElementsByTagName("object");
					for(var i = 0; i < objects.length; i++)
					{
						if(typeof objects[i][id] != "undefined")
						{
							return objects[i];
						}
					}
					
					var embeds = document.getElementsByTagName("embed");
					
					for(var j = 0; j < embeds.length; j++)
					{
						if(typeof embeds[j][id] != "undefined")
						{
							return embeds[j];
						}
					}
						
					return null;
				}
				
				mws.usingWmode = function( swf )
				{
					if( typeof swf.getAttribute == "undefined" )
					{
						return false;
					}
					
					var wmode = swf.getAttribute( "wmode" );
					if( typeof wmode == "undefined" )
					{
						return false;
					}
					
					return true;
				}
				
				//Debug logging
				mws.log = function( message ) 
				{
					if( typeof console != "undefined" )
					{
						console.log( message );
					}
					else
					{
						//alert( message );
					}
				}
				
				mws.shouldAddHandler = function( swf )
				{
					if( !swf )
					{
						return false;
					}
					
					return true;
				}
				
				mws.getBrowserInfo = function()
				{//getBrowserObj
					return mws.browser;
				}//getBrowserObj
				
				mws.getAgentInfo = function()
				{//getAgentInfo
					return mws.agent;
				}//getAgentInfo
				
				mws.getPlatformInfo = function()
				{//getPlatformInfo
					return mws.platform;
				}//getPlatformInfo
				
				mws.addScrollListeners = function()
				{//addScrollListeners
					
					// install mouse listeners
					if(typeof window.addEventListener != 'undefined') 
					{
						window.addEventListener('DOMMouseScroll', _mousewheel, false);
					}
					
					window.onmousewheel = document.onmousewheel = _mousewheel;
					
				}//addScrollListeners
				
				mws.removeScrollListeners = function()
				{//removeScrollListeners
					// install mouse listeners
					if(typeof window.removeEventListener != 'undefined') 
					{
						window.removeEventListener('DOMMouseScroll', _mousewheel, false);
					}
					
					window.onmousewheel = document.onmousewheel = null;
				}//removeScrollListeners
				
				mws.InitMouseWheelSupport = function(id) 
				{//InitMouseWheelSupport
					//grab reference to the swf
					var swf = mws.findSwf(id);
					
					//see if we can add the mouse listeners
					var shouldAdd = mws.shouldAddHandler( swf );
					
					if( shouldAdd ) 
					{
						/// Mousewheel support
						_mousewheel = function(event) 
						{//Mouse Wheel
								
							//Cover for IE
							if (!event) event = window.event;
							
							var rawDelta = 0;
							var divisor = 1;
							var scaledDelta = 0;
							
							//Handle scaling the delta.
							//This is becoming less and less useful as more browser/hardware combos emerge.
							if(event.wheelDelta)	
							{//normal event
								rawDelta = event.wheelDelta;
								
								if(mws.browser.opera)
								{
									divisor = 12;
								}
								else if(mws.browser.safari && mws.browser.version.split(".")[0] >= 528)
								{
									divisor = 12;
								}
								else
								{
									divisor = 120;
								}
							}//normal event
							else if(event.detail)		
							{//special event
								rawDelta = -event.detail;
							}//special event
							else
							{//odd event
								//Unhandled event type (future browser graceful fail)
								rawDelta = 0;
								scaledDelta = 0;
								
								//alert('Odd Event');
							}//odd event
							
							if(Math.abs(rawDelta) >= divisor)
							{//divide
								scaledDelta = rawDelta/divisor;
							}//divide
							else
							{//don't scale
								scaledDelta = rawDelta;
							}//don't scale
							
							//Call into the swf to fire a mouse event
							swf.externalMouseEvent(rawDelta, scaledDelta);
							
							if(event.preventDefault)	
							{//Stop default action
								event.preventDefault();
							}//Stop default action
							else
							{//stop default action (IE)
								return false;
							}//stop default action (IE)
								
							return true;
						}//MouseWheel
	
						//set up listeners
						swf.onmouseover = mws.addScrollListeners;
						swf.onmouseout = mws.removeScrollListeners;
					}//Should Add
						
				}//InitMouseWheelSupport
				
			}
		]]></script>;
}