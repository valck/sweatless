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

package sweatless.text {

	import sweatless.utils.ArrayUtils;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;

	public class SmartTextBreaker {
		
		public static const BREAK_CHARACTERS : String = "break_characters";
		public static const BREAK_WORDS : String = "break_words";
		public static const BREAK_LINES : String = "break_lines";
		
		public static const FIRST_TO_LAST : String = "first_to_last";
		public static const LAST_TO_FIRST : String = "last_to_first";
		public static const EDGES_TO_CENTER : String = "edges_to_center";
		public static const CENTER_TO_EDGES : String = "center_to_edges";
		public static const RANDOM : String = "random";
		
		private var _direction : String;
		private var _type : String;
		private var _source : SmartText;
		private var _chars : Array;
		

		public function SmartTextBreaker(p_source : SmartText, p_type : String = BREAK_CHARACTERS, p_direction:String=FIRST_TO_LAST) {
			super();

			_chars = new Array();
			_type = p_type;
			_source = p_source;
			_direction = p_direction;
			
			update();
		}

		private function breakApart() : Array {
			var result : Array = new Array();
			var bounds : Rectangle = _source.field.getBounds(_source.field);
			var position : Point = new Point(0, bounds.y);
			
			var index : uint = 0;
			
			for (var line : uint = 0; line<_source.field.numLines; line++) {
				var lineText : String = _source.field.getLineText(line);
				var lineOffset : uint = _source.field.getLineOffset(line);
				var lineMetrics : TextLineMetrics = _source.field.getLineMetrics(line);

				if (_source.field.text.length <= lineOffset) continue;

				var format : TextFormat = _source.field.getTextFormat(lineOffset, lineOffset + 1);
				switch(format.align) {
					case "left":
						position.x = bounds.x;
						break;
					case "right":
						position.x = bounds.x - 4 + (_source.field.width - lineMetrics.width);
						break;
					case "center":
						position.x = bounds.x - 2 + (_source.field.width - lineMetrics.width) * .5;
						break;
				}

				var split : Array;
				switch(_type) {
					case BREAK_CHARACTERS:
						split = lineText.split("");
						break;
					case BREAK_WORDS:
						split = lineText.split(" ").join(", ,").split(",");
						break;
					case BREAK_LINES:
						split = [lineText];
						break;
				}

				for (var i : uint = 0; i < split.length; i++) {
					if (split[i].length == 0) continue;
					
					var char : Char = new Char();
					char.antiAliasType = _source.alias;
					char.embedFonts = _source.embed;
					char.sharpness = _source.sharpness;
					char.thickness = _source.thickness;
					char.autoSize = "left";
					char.selectable = false;
					char.multiline = false;
					char.wordWrap = false;

					char.text = split[i];

					for (var j : uint = 0; j < split[i].length; j++) {
						format = _source.field.getTextFormat(lineOffset, lineOffset + 1);
						lineOffset += 1;
						format.align = "left";
						char.setTextFormat(format, j, j + 1);
					}

					char.index = i;
					char.x = char.originalX = position.x;
					char.y = char.originalY = position.y;

					var ascent : Number = lineMetrics.ascent - char.getLineMetrics(0).ascent;
					if (ascent) char.y += ascent;

					position.x += char.textWidth;

					if (split[i] != " ") {
						_source.addChild(char);
						result[index++] = char;
					}
				}

				position.y += lineMetrics.height;
			}

			return result;
		}

		public function destroy() : void {
			clear();

			visible = false;
		}

		public function get source() : SmartText {
			return _source;
		}

		public function set source(p_field : SmartText) : void {
			_source = p_field;
			update();
		}

		public function get type() : String {
			return _type;
		}

		public function set type(p_type : String) : void {
			p_type = p_type;
			update();
		}

		public function get direction() : String {
			return _direction;
		}

		public function set direction(p_direction : String) : void {
			_direction = p_direction;
			update();
		}

		public function get visible() : Boolean {
			return Boolean(!source.field.stage);
		}

		public function set visible(p_value : Boolean) : void {
			p_value ? _source.removeChild(_source.field) : _source.addChild(_source.field);
		}

		public function get chars() : Array {
			return _chars;
		}

		private function sort(p_array:Array) : Array{
			var total : int = p_array.length-1;
			var half : uint = Math.floor(total/2);
			var right : Array;
			var left : Array;
			
			switch(_direction) {
				case LAST_TO_FIRST:
					p_array.reverse(); 
					break;
				case CENTER_TO_EDGES:
					right = p_array.slice(half, total);
					left = p_array.slice(0, half).reverse();
					p_array = ArrayUtils.merge(right, left);
					break;
				case EDGES_TO_CENTER:
					right = p_array.slice(half, total).reverse();
					left = p_array.slice(0, half);
					p_array = ArrayUtils.merge(right, left);
					break;
				case RANDOM:
					p_array = ArrayUtils.shuffle(p_array);
					break;
			}
			
			return p_array;
		}
		
		private function update() : void {
			clear();

			visible = true;
			_chars = sort(breakApart());
		}

		private function clear() : void {
			var i : int = _chars.length;
			while (i--) {
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
	
	private var _index : int;
	private var _position : Point;
	
	public function Char(){
		_position = new Point();
	}
	
	public function get index():int{
		return _index;
	}
	
	public function set index(p_value:int):void{
		_index = p_value;
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
