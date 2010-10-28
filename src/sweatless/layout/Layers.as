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
			
			update();
		}
		
		public static function remove(p_id:String):void{
			for (var i:uint=0; i<layers.length; i++) {
				if (layers[i].name == p_id.toLowerCase()) {
					scope.removeChild(layers[i]);
					layers[i] = null;
					layers.splice(i, 1);
					break;
				};
			}
			update();
		}
		
		public static function removeAll():void{
			for (var i:uint=0; i<layers.length; i++) {
				scope.removeChild(layers[i]);
				layers[i] = null;
				layers.splice(i, 1);
			}
		}
		
		public static function getAll():Array{
			return layers;
		}
		
		public static function debug():void{
			trace("[START LAYERS DEBUG]");
			trace("Layers length:"+length);
			for (var i:uint=0; i<getAll().length; i++) {
				trace("	{Layer:"+Layer(layers[i]).name+", layer depth:"+ Layer(layers[i]).depth+", real stage depth:"+scope.getChildIndex(layers[i])+"}");
			}
			trace("[END LAYERS DEBUG]");
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
				(layers[i].depth==undefined) ? layers[i].depth = scope.getChildIndex(layers[i]) : null;
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
		mouseEnabled = false;
		depth = parent.getChildIndex(this);
	}
	
	public function get depth():Object{
		return index;
	}
	
	public function set depth(p_value:Object):void{
		index = p_value;
	}
}
