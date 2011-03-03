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
	import flash.utils.Dictionary;
	
	import sweatless.utils.DictionaryUtils;
	
	public final class Layers{

		private var _id : String;

		private static var instances : Dictionary = new Dictionary(true);
		
		public function Layers(p_scope:DisplayObjectContainer, p_id:String){
			p_id = p_id.toLowerCase();
			
			if (!p_scope) throw new Error ("Cannot create a Layers instance without a scope.");
			if (hasInstance(p_id)) throw new Error ("The Layers instance with id "+p_id+" has already been created.");
			
			instances[p_id] = {id:p_id, scope:p_scope, layer:this, contents:new Array()};
			
			_id = p_id;
		}

		public static function getInstance(p_id:String):Layers{
			p_id = p_id.toLowerCase();
			
			return Layers.instances[p_id].layer as Layers;
		}
		
		public static function getAllInstances():Dictionary{
			return instances;
		}
		
		public static function getTotalInstances():int{
			return DictionaryUtils.length(instances);
		}
		
		public static function hasInstance(p_id:String):Boolean{
			p_id = p_id.toLowerCase();
			
			return instances[p_id] ? true : false;
		}
		
		public static function removeInstance(p_id:String):Boolean{
			p_id = p_id.toLowerCase();
			
			getInstance(p_id).removeAll();
			
			instances[p_id] = null;
			delete instances[p_id];

			return hasInstance(p_id);
		}
		
		public static function removeAllInstances():void{
			for(var id:* in instances){
				removeInstance(id);
			}
		}
		
		public function get id():String{
			return _id;
		}

		public function get scope():DisplayObjectContainer{
			return Layers.instances[id].scope;
		}

		public function get layers():Array{
			return Layers.instances[id].contents;
		}

		public function add(p_id:String, p_custom:Object=null):void{
			p_id = p_id.toLowerCase();
			if(get(p_id)) throw new Error("The layer " + p_id + " already exists.");
						
			var layer : * = p_custom ? new p_custom() : new Layer();
			
			layer.name = layer.id = p_id;
			scope.addChild(layer);
			layers.push(layer);
			
			update();
		}
		
		public function remove(p_id:String):void{
			p_id = p_id.toLowerCase();
			
			for (var i:uint=0; i<length; i++) {
				if (layers[i].id == p_id) {
					scope.removeChild(layers[i]);
					layers[i] = null;
					layers.splice(i, 1);
					break;
				};
			}
			
			update();
		}
		
		public function removeAll():void{
			for (var i:uint=0; i<length; i++) {
				scope.removeChild(layers[i]);
				layers[i] = null;
				layers.splice(i, 1);
			}
		}
		
		public function debug():void{
			trace("[==== LAYERS DEBUG ====]");
			trace("Layers length:"+length);
			for (var i:uint=0; i<length; i++) {
				trace("	{Layer:"+Layer(layers[i]).id+", layer depth:"+ Layer(layers[i]).depth+", real stage depth:"+scope.getChildIndex(layers[i])+"}");
			}
			trace("[==== LAYERS DEBUG ====]");
		}
		
		public function get(p_id:String):*{
			p_id = p_id.toLowerCase();
			
			for (var i:uint=0; i<length; i++) {
				if (layers[i].id == p_id) {
					return layers[i];
					break;
				}
			}
			return null;
		}

		public function get length():int{
			return layers.length;
		}
		
		public function swapDepth(p_id:String, p_depth:*):void{
			get(p_id).depth = p_depth;

			update();
		}
		
		public function update():void{
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

import sweatless.interfaces.ILayer;

internal class Layer extends Sprite implements ILayer{
	
	private var _id : String;
	private var index : Object = -1;
	private var created : Boolean; 
	
	public function Layer(){
		addEventListener(Event.ADDED_TO_STAGE, create);
	}
	
	public function create(evt:Event):void{
		if(created) return;
		created = true;
		
		removeEventListener(Event.ADDED_TO_STAGE, create);
		
		mouseEnabled = false;
		depth = parent.getChildIndex(this);
	}
	
	public function get depth():Object{
		return index;
	}
	
	public function set depth(p_value:Object):void{
		index = p_value;
	}

	public function get id():String{
		return _id;
	}
	
	public function set id(p_id:String):void{
		_id = p_id;
	}
}
