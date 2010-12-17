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

package sweatless.effects{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sweatless.layout.Layers;
	
	public class Parallax extends Sprite {
		private var middle : Point;
		private var position : Point;
		
		private var thrust : Number;
		private var layers : Layers;
		private var repeat : Boolean;
		
		public function Parallax(p_limit:Rectangle, p_thrust:Number=.02, p_repeat:Boolean=false) {
			layers = new Layers(this, name);
			
			repeat = p_repeat;
			scrollRect = p_limit;
			thrust = p_thrust;
			middle = new Point(scrollRect.width/2, scrollRect.height/2);
		}
		
		public function add(p_id:String, p_layer:DisplayObject, p_depth:Number):void{
			layers.add(p_id, CustomLayer);
			layers.get(p_id).create(p_layer, p_depth, scrollRect, repeat);
		}

		public function remove(p_id:String):void{
			layers.remove(p_id);
		}
		
		public function removeAll():void{
			layers.removeAll();
		}
		
		public function get(p_id:String):CustomLayer{
			return layers.get(p_id);
		}
		
		public function getDepth(p_id:String):Object{
			return layers.get(p_id).depth;
		}
		
		public function changeDepth(p_id:String, p_depth:int):void{
			layers.swapDepth(p_id, p_depth);
		}
		
		public function destroy():void {
			removeAll();
		}
		
		public function scrollXY(p_x:Number, p_y:Number):void{
			position = new Point();
			
			p_x >= scrollRect.width - middle.x ? position.x += Math.ceil(((scrollRect.width / 2) - p_x) * thrust) : null;
			p_x <= middle.x ? position.x -= Math.ceil((p_x - (scrollRect.width / 2)) * thrust) : null;
			
			p_y >= scrollRect.height - middle.y ? position.y += Math.ceil(((scrollRect.height / 2) - p_y) * thrust) : null;
			p_y <= middle.y ? position.y -= Math.ceil((p_y - (scrollRect.height / 2)) * thrust) : null;
			
			for each(var layer:* in layers.layers){
				get(layer.id).scroll((position.x * layer.depth), (position.y * layer.depth));
			}
		}
		
		public function scrollX(p_x:Number):void{
			position = new Point();
			
			p_x >= scrollRect.width - middle.x ? position.x += Math.ceil(((scrollRect.width / 2) - p_x) * thrust) : null;
			p_x <= middle.x ? position.x -= Math.ceil((p_x - (scrollRect.width / 2)) * thrust) : null;
			
			for each(var layer:* in layers.layers){
				get(layer.id).scroll((position.x * layer.depth/2), 0);
			}
		}
		
		public function scrollY(p_y:Number):void{
			position = new Point();
			
			p_y >= scrollRect.height - middle.y ? position.y += Math.ceil(((scrollRect.height / 2) - p_y) * thrust) : null;
			p_y <= middle.y ? position.y -= Math.ceil((p_y - (scrollRect.height / 2)) * thrust) : null;

			for each(var layer:* in layers.layers){
				get(layer.id).scroll(0, (position.y * layer.depth));
			}
		}
	}
}
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

import sweatless.interfaces.ILayer;
import sweatless.utils.DisplayObjectUtils;

internal class CustomLayer extends Sprite implements ILayer{
	private var contents : Sprite;
	
	private var repeat : Boolean;
	private var size : Rectangle;
	
	private var _id : String;
	private var _depth : Object = -1;
	
	public function CustomLayer() {
	}
	
	public function create(p_asset:DisplayObject, p_depth:*, p_area:Rectangle, p_repeat:Boolean=false):void {
		size = new Rectangle(0, 0, p_asset.width, p_asset.height);
		depth = p_depth ? p_depth : parent.getChildIndex(this);
		repeat = p_repeat;
		
		contents = new Sprite();
		addChild(contents);
		
		if(p_repeat){
			var amount : Point = new Point(Math.ceil(p_area.width/size.width) + 1, Math.ceil(p_area.height/size.height) + 1);
			
			for(var i:uint=0; i<amount.x; i++) {
				for(var j:uint=0; j<amount.y; j++) {
					var clone : DisplayObject = DisplayObjectUtils.duplicate(p_asset);
					contents.addChild(clone);
					
					clone.x = size.width * i;
					clone.y = size.height * j;
				}
			}

			p_asset.stage ? p_asset.parent.removeChild(p_asset) : null;
		}else{
			contents.addChild(p_asset);
		}
	}
	
	public function get depth():Object{
		return _depth;
	}
	
	public function set depth(p_value:Object):void{
		_depth = p_value;
	}
	
	public function get id():String{
		return _id;
	}
	
	public function set id(p_id:String):void{
		_id = p_id;
	}
	
	public function scroll(p_x:Number, p_y:Number):void {
		repeat && contents.x < -size.width ? contents.x = 0 : repeat && contents.x > 0 ? contents.x = -size.width : null;
		repeat && contents.y < -size.height ? contents.y = 0 : repeat && contents.y > 0 ? contents.y = -size.height : null;
		
		contents.x += p_x;
		contents.y += p_y;
	}
}