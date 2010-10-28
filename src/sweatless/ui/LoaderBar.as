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

package sweatless.ui{
	import flash.events.Event;
	
	import sweatless.graphics.SmartRectangle;
	import sweatless.navigation.primitives.Loading;

	public class LoaderBar extends Loading{
		
		private var bar : SmartRectangle;
		private var background : SmartRectangle;

		private var _width : Number = 0;
		private var _height : Number = 0;
		
		public function LoaderBar(){
 		}
		
		override public function create(evt:Event=null):void{
			background = new SmartRectangle();
			addChild(background);
			
			bar = new SmartRectangle();
			addChild(bar);

			background.width = bar.width = 200;
			background.height = bar.height = 1;
			
			backgroundColor = 0xCCCCCC;
			barColor = 0x999999;
			
			bar.scaleX = 0;
			
			alpha = 0;
			
			align();
			
			super.create(evt);
		}
		
		override public function show():void{
			alpha = 1;
			super.show();
		}
		
		override public function hide():void{
			alpha = 0;
			super.hide();
		}
		
		override public function set progress(p_progress:Number):void{
			bar ? bar.scaleX = progress : null;

			super.progress = p_progress;
		}
		
		public function set backgroundColor(p_value:uint):void{
			background.colors = [p_value, p_value];
		}
		
		public function set barColor(p_value:uint):void{
			bar.colors = [p_value, p_value];
		}
		
		override public function set width(p_value:Number):void{
			background.width = _width = p_value;
			
			bar.width = _width = p_value;
		}
		
		override public function set height(p_value:Number):void{
			background.height = _height = p_value;
			
			bar.height = _height = p_value;
		}
		
		override public function get width():Number{
			return _width;
		}
		
		override public function get height():Number{
			return _height;
		}

		override public function align():void{
			
		}
		
		override public function destroy(evt:Event=null):void{
			bar.destroy();
			background.destroy();
			
			super.destroy(evt);
		}
	}
}