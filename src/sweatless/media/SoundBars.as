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

package sweatless.media{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	import sweatless.graphics.SmartRectangle;
	
	
	public class SoundBars extends Sprite{
		
		private var bytes : ByteArray;
		
		private var bars : Array;
		
		private var offset : Number;
		private var amplitude : Number;
		
		public function SoundBars(){
		}
		
		public function create(p_amount:uint, p_width:Number, p_amplitude:Number=30):void{
			amplitude = p_amplitude;
			
			bytes = new ByteArray();
			bars = new Array();
			
			var last : SmartRectangle;
			for(var i:uint=0; i<p_amount; i++){
				var bar : SmartRectangle = new SmartRectangle();
				addChild(bar);
				
				bar.width = p_width;
				bar.x = last ? last.x + last.width + 2 : 0;
				
				bars.push(bar);
				
				last = bar;
			}
		}
		
		public function on():void{
			addEventListener(Event.ENTER_FRAME, draw);		
		}
		
		public function off():void{
			removeEventListener(Event.ENTER_FRAME, draw);
			reset();
		}
		
		private function reset():void{
			for (var i:uint=0; i<bars.length; i++) {
				bars[i].height = 1; 
				bars[i].y = 0;
			}
		}
		
		private function draw(evt:Event):void{
			try{
				SoundMixer.computeSpectrum(bytes, true);
				
				for (var i:uint=0; i<bars.length; i++) {
					bytes.position = i * 4;
					offset = Math.round(bytes.readFloat()*amplitude);
					
					bars[i].height = offset == 0 ? 1 : offset; 
					bars[i].y = offset == 0 ? -offset : -(offset-1);
				}
			} catch(err:Error){
				
			}
		}
	}
}