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
 * @author Valério Oliveira (valck)
 * 
 */

/**
 * @TODO
 * check and test all mehods
 */

package sweatless.text {

	import sweatless.utils.ArrayUtils;

	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;

	public class SmartTextBreaker {
		
		public static const FIRST_TO_LAST : String = "first_to_last";
		public static const LAST_TO_FIRST : String = "last_to_first";
		public static const EDGES_TO_CENTER : String = "edges_to_center";
		public static const CENTER_TO_EDGES : String = "center_to_edges";
		public static const RANDOM : String = "random";
		
		private var _direction : String;
		private var _source : SmartText;
		private var _chars : Array;

		public function SmartTextBreaker(p_source : SmartText, p_direction : String = FIRST_TO_LAST) {
			_chars = new Array();
			_source = p_source;
			_direction = p_direction;
		}

		public function get characters() : Array {
			clear();
			visible = true;
			
			var result : Array = new Array();
			var bounds : Rectangle;
			var metrics : TextLineMetrics;
			
			var total : int = _source.length - 1;
			var i : int = _source.length;
			while (i-- > 0) {
				if (escape(_source.text.charAt(Math.abs((i - total)))) == "%0D" || !_source.text.charAt(Math.abs((i - total)))) continue;
				
				var char : Char = new Char();
				_source.addChild(char);
				
				char.antiAliasType = _source.alias;
				char.embedFonts = _source.embed;
				char.sharpness = _source.sharpness;
				char.thickness = _source.thickness;
				char.text = _source.text.charAt(Math.abs((i - total)));
				
				var format : TextFormat = _source.field.getTextFormat(Math.abs((i - total)), Math.abs((i - total)) + 1);
				char.setTextFormat(format);

				bounds = _source.field.getCharBoundaries(Math.abs((i - total)));
				metrics = _source.field.getLineMetrics(_source.field.getLineIndexOfChar(Math.abs((i - total))));
				
				//trace((bounds));
				
				bounds ? align(bounds, metrics, format.align) : null;
					
				char.x = char.originalX = bounds ? bounds.x : null;
				char.y = char.originalY = bounds ? bounds.y : null;
				
				result.push(char);
			}
			
			_chars = sort(result);
			return sort(result);
		}
		
		public function get words() : Array {
			clear();
			visible = true;
			
			var result : Array = new Array();
			var bounds : Rectangle;
			var metrics : TextLineMetrics;
			
			var split : Array = _source.text.split(" ").join("† †").split("†");
			var index : int = 0;
			
			var total : int = split.length - 1;
			var i : int = split.length;
			while (i-- > 0) {
				if(split[Math.abs((i - total))] == "\n" || split[Math.abs((i - total))] == String.fromCharCode(13)) continue;
				
				var char : Char = new Char();
				_source.addChild(char);
				
				char.antiAliasType = _source.alias;
				char.embedFonts = _source.embed;
				char.sharpness = _source.sharpness;
				char.thickness = _source.thickness;
				char.text = split[Math.abs((i - total))];
				
				for (var j : uint = 0; j<char.text.length; j++) {
					var format : TextFormat = _source.field.getTextFormat(index+j, (index + j) + 1);
					char.setTextFormat(format, j, j + 1);
				}
				
				bounds = _source.field.getCharBoundaries(index);
				metrics = _source.field.getLineMetrics(_source.field.getLineIndexOfChar(index));
				
				align(bounds, metrics, format.align);
				
				char.x = char.originalX = bounds.x;
				char.y = char.originalY = bounds.y;
				
				result.push(char);
				
				index += char.text.length;
			}
			
			_chars = sort(result);
			return sort(result);
		}
		
		public function get lines() : Array {
			clear();
			visible = true;
			
			var result : Array = new Array();
			var bounds : Rectangle;
			var metrics : TextLineMetrics;
			
			var index : int = 0;
			
			var total : int = _source.numLines - 1;
			var i : int = _source.numLines;
			while (i-- > 0) {
				bounds = _source.field.getCharBoundaries(index);
				if(!bounds) continue;
				
				metrics = _source.field.getLineMetrics(Math.abs((i - total)));
				
				var char : Char = new Char();
				_source.addChild(char);
				
				char.antiAliasType = _source.alias;
				char.embedFonts = _source.embed;
				char.sharpness = _source.sharpness;
				char.thickness = _source.thickness;
				char.text = _source.field.getLineText(Math.abs((i - total)));
				
				for (var j : uint = 0; j<char.text.length; j++) {
					var format : TextFormat = _source.field.getTextFormat(index+j, (index + j) + 1);
					char.setTextFormat(format, j, j + 1);
				}

				align(bounds, metrics, format.align);
				
				char.x = char.originalX = bounds.x;
				char.y = char.originalY = bounds.y;
				
				result.push(char);
				
				index += char.text.length;
			}
			
			_chars = sort(result);
			return sort(result);	
		}

		public function get direction() : String {
			return _direction;
		}

		public function set direction(p_direction : String) : void {
			_direction = p_direction;
		}

		public function get visible() : Boolean {
			return Boolean(!_source.field.stage);
		}

		public function set visible(p_value : Boolean) : void {
			p_value ? _source.field.stage ? _source.removeChild(_source.field) : null : _source.addChild(_source.field);
		}

		public function destroy(p_source:Boolean=false) : void {
			clear();
			visible = false;
			
			if(p_source){
				_source.destroy();
				_source.parent.removeChild(_source);
				_source = null;
			}
		}

		private function align(p_bounds:Rectangle, p_metrics:TextLineMetrics, p_direction:String) : void{	
			switch(p_direction) {
				case "right":
					p_bounds.x -= (_source.field.width - (p_metrics.x + p_metrics.width));
					break;
				case "center":
					p_bounds.x += (p_metrics.width - p_metrics.width - 2);
					break;
				case "left":
				case "justify":
					p_bounds.x -= p_metrics.x;
					break;
			}

			p_bounds.y -= 2;
		}
			
		private function sort(p_array:Array) : Array{
			var total : int = p_array.length;
			var half : uint = Math.floor(total/2);
			
			var right : Array = p_array.slice(half, total);
			var left : Array = p_array.slice(0, half).reverse();
			
			switch(_direction) {
				case LAST_TO_FIRST:
					p_array = p_array.reverse();
					break;
				case CENTER_TO_EDGES:
					p_array = ArrayUtils.merge(right, left);
					break;
				case EDGES_TO_CENTER:
					p_array = ArrayUtils.merge(right, left).reverse();
					break;
				case RANDOM:
					p_array = ArrayUtils.shuffle(p_array);
					break;
			}
			
			return p_array;
		}
		
		private function clear() : void {
			var i : int = _chars.length;
			while (i-- > 0) {
				var field : Char = Char(_chars[i]);
				_source.removeChild(field);
				field = null;
				_chars.pop();
			}
			
			_chars = null;
			_chars = new Array();
		}
	}
}


import flash.geom.Point;
import flash.text.TextField;

internal class Char extends TextField{
	
	private var _position : Point;
	
	public function Char(){
		_position = new Point();
		wordWrap = multiline = mouseWheelEnabled = selectable = mouseEnabled = false;
		autoSize = "left";
	}
	
	public function get originalX() : Number {
		return _position.x;
	}

	public function set originalX(p_x : Number) : void {
		_position.x = p_x;
	}

	public function get originalY() : Number {
		return _position.y;
	}

	public function set originalY(p_y : Number) : void {
		_position.y = p_y;
	}
}
