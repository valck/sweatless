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

package sweatless.debug{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	/**
	 * The FPS class is a simple FPS and MB viewer for offline applications.
	 * 
	 */
	public class FPS extends Sprite{
		
		private var _danger : int;
		private var label : TextField;
		private var lastFrameTime : Number;
		private var frames : Number = 0;
		
		/**
		 * The FPS class is a simple FPS and MB viewer for offline applications. 
		 * @param p_danger Percent of the danger value of fps in application.
		 * @default <code>65</code>
		 * @see int
		 * 
		 */
		public function FPS(p_danger:int=65){
			_danger = p_danger;

			addEventListener(Event.ADDED_TO_STAGE, create);
		}

		private function create(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, create);
			
			var host : LocalConnection = new LocalConnection();
			var offline : Boolean = String(host.domain).indexOf("localhost") != -1 ? true : false;
			
			label = new TextField();
			label.width = 70;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.height = 20;
			label.selectable = false;
			
			var style:StyleSheet = new StyleSheet();
			style.parseCSS('p {font-family:Arial;font-size:10px;color:#000000}');
			label.styleSheet = style;
			
			lastFrameTime = getTimer();
			
			show(offline);
		}
		
		/**
		 * 
		 * If <code>true</code> or <code>false</code> to show, but it's only can show offline.
		 * for example, development is <code>true</code> and online is <code>false</code>.
		 * 
		 * @param p_debugger
		 * 
		 */
		public function show(p_debugger:Boolean):void{
			if(!p_debugger) return;
			
			addEventListener(Event.ENTER_FRAME, check);
			addEventListener(MouseEvent.MOUSE_DOWN, down);
			addEventListener(MouseEvent.MOUSE_UP, up);
			
			addChild(label);
		}
		
		private function down(evt:Event):void{
			startDrag();
		}
		
		private function up(evt:Event):void{
			stopDrag();
		}		
		
		private function get danger():int{
			var result : int =  int(stage.frameRate*_danger/100);
			return result;
		}
		
		private function check(evt:Event):void{
			frames++;
			
			var time : Number = getTimer();
			
			if (time - lastFrameTime >= 1000){
				var memory : String = String(Number(System.totalMemory/1024/1024).toFixed(1)) + "MB";
				var player : String = Capabilities.isDebugger ? "Debug Player :)" : "Single Player :(";
				
				label.htmlText = "<p>" + player + "\n" + Capabilities.version + "\n" + String(frames) + "FPS / " + memory + "</p>";
				
				graphics.clear();
				frames>danger ? graphics.beginFill(0xCFFCE0) : graphics.beginFill(0xFFCCCC);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
				
				frames = 0;
				lastFrameTime = time;
			}
		}
	}
}