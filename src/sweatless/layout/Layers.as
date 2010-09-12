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

package sweatless.layout{
	import flash.display.DisplayObjectContainer;
	
	public final class Layers{

		private static var scope : DisplayObjectContainer;
		private static var layers : Array;
		
		public static function init(p_scope:DisplayObjectContainer):void{
			if(getAll()) return;
			
			scope = p_scope;
			layers = new Array();
		}
		
		public static function add(p_id:String):void{
			if(get(p_id)) throw new Error("The layer " + p_id + " already exists.");
			
			var layer : Layer = new Layer();
			layer.name = p_id.toLowerCase();
			scope.addChild(layer);
			layers.push(layer);
		}
		
		public static function remove(p_id:String):void{
			for (var i:uint=0; i<layers.length; i++) {
				if (layers[i].name == p_id.toLowerCase()) {
					scope.removeChild(layers[i]);
					layers[i] = null;
					break;
				};
			}
			update();
		}
		
		public static function removeAll():void{
			for (var i:uint=0; i<layers.length; i++) {
				scope.removeChild(layers[i]);
				layers[i] = null;
			}
		}
		
		public static function getAll():Array{
			return layers;
		}
		
		public static function get(p_id:String):Layer{
			p_id = p_id.toLowerCase();
			
			for (var i:uint=0; i<layers.length; i++) {
				if (layers[i].name == p_id) {
					return layers[i];
					break;
				}
			}
			return null;
		}
		
		public static function get length():int{
			return layers.length;
		}
		
		public static function swapDepth(p_id:String, p_depth:*):void{
			get(p_id).depth = p_depth;

			update();
		}
		
		public static function update():void{
			layers.sortOn("depth", Array.NUMERIC);

			for (var i:uint=0; i<layers.length; i++) {
				scope.setChildIndex(layers[i], layers[i].depth == -1 ? scope.getChildIndex(layers[i]) : isNaN(layers[i].depth) ? layers[i].depth.toLowerCase() == "top" ? length-1 : layers[i].depth.toLowerCase() == "bottom" ? 0 : layers[i].depth : layers[i].depth >= length-1 ? length-1 : layers[i].depth == -1 ? 0 : layers[i].depth);
			}
		}
	}
}

import flash.display.Sprite;
import flash.events.Event;

internal class Layer extends Sprite{
	private var index : Object = -1;
	
	public function Layer(){
		addEventListener(Event.ADDED_TO_STAGE, created);
	}
	
	private function created(evt:Event):void{
		removeEventListener(Event.ADDED_TO_STAGE, created);

		depth = parent.getChildIndex(this);
	}
	
	public function get depth():Object{
		return index;
	}
	
	public function set depth(p_value:Object):void{
		index = p_value;
	}
}
