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

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sweatless.utils.StringUtils;
	
	/**
	 * The <code>SmartText</code> class have support methods for easier manipulation of
	 * the native <code>TextField</code> Class.
	 * @see TextField
	 * @see TextFormat
	 */
	public class SmartText extends Sprite{
		private var _css : StyleSheet;
		private var _format : TextFormat;
		private var _field : TextField;
		private var _autosize : String;
		private var _selectable : Boolean;
		
		public static const RESTRICT_SPECIAL_CHARS : String = ". \\' \\\" \\- ( ) ? ' , _ ! & : ; @";
		public static const RESTRICT_EMAIL : String = "a-z 0-9 @ _ . \\-";
		public static const RESTRICT_NUMBER : String = "0-9";
		public static const RESTRICT_LOWERCASE : String = "a-z âãàáèéêìíõòôóùûúç";
		public static const RESTRICT_UPPERCASE : String = "A-Z ÂÃÀÁÈÉÊÌÍÕÒÔÓÙÛÚÇ";
		
		public static const ALIAS_SMOOTHING : String = "advanced";
		public static const ALIAS_NORMAL : String = "normal";
		
		/**
		 * The constructor method to create the <code>SmartText</code>.
		 * @param p_format The <code>TextFormat</code> format.
		 * @see TextField
		 * @see TextFormat
		 */
		public function SmartText(p_format:TextFormat=null){
			super();
			_format = p_format || new TextFormat();
			
			_field = new TextField();
			_field.mouseWheelEnabled = false;
			_field.addEventListener(Event.SCROLL, _scroll);

			addChild(_field);
			
			autoSize = "left";
			selectable = false;
			embed = true;
			type = "dynamic";
			
			update();
		}

		private function _scroll(evt:Event) : void {
		    _field.scrollH = _field.scrollV = 0;
		}
		
		private function update(p_begin:int = -1, p_end:int = -1):void{
			if(!_css && _format) _field.setTextFormat(_format, p_begin, p_end);
			_field.autoSize = _autosize;
		}
		
		/**
		 * Specifies whether to render by using embedded font outlines.
		 * @see FontRegister
		 */
		public function set embed(p_value:Boolean):void{
			_field.embedFonts = p_value;
			update();
		}

		public function get embed():Boolean{
			return _field.embedFonts;
		}
		
		/**
		 * Indicates the alignment of the paragraph.
		 * @see TextFormatAlign
		 */
		public function set align(p_value:String):void{
			_format.align = p_value;
			update();
		}

		public function get align():String{
			return _format.align;
		}
		
		/**
		 * Controls automatic sizing and alignment of text fields.
		 * @see TextFieldAutoSize
		 */
		public function set autoSize(p_value:String):void{
			_autosize = p_value;
			
			update();
		}

		public function get autoSize():String{
			return _autosize;
		}
		
		/**
		 * The number of characters in a text field.
		 */
		public function get length():uint{
			return _field.length;
		}
		
		/**
		 * The number of characters in a text field.
		 */
		public function get numChars():uint{
			return _field.length;
		}
		
		/**
		 * The number of lines in a text field.
		 */
		public function get numLines():uint{
			return _field.numLines;
		}
		
		/**
		 * Bounds of text field
		 */
		public function get bounds():Rectangle{
			return _field.getBounds(field);
		}
		
		/**
		 * Specifies whether this object receives mouse messages..
		 */
		override public function set mouseEnabled(p_value:Boolean):void{
		    super.mouseEnabled = false;
		    super.mouseChildren = _field.mouseEnabled = p_value;
		};
		
		override public function get mouseEnabled():Boolean{
		    return _field.mouseEnabled;
		};
		
		/**
		 * Applies styles defined by a style sheet to a text field object.
		 * @see StyleSheet
		 */
		public function get css() : StyleSheet {
			return _css;
		}

		public function set css(p_css:StyleSheet):void{
			_css = p_css;
			_field.styleSheet = _css;
			_field.mouseEnabled = true;
		}
		
		/**
		 * Thismethod changes the text formatting applied to a range of characters or to the entire body of text in a text field. To apply the properties of format to all text in the text field, do not specify values for beginIndex and endIndex. 
		 * To apply the properties of the format to a range of text, specify values for the beginIndex and the endIndex parameters. 
		 * You can use the length property to determine the index values.
		 * 
		 * @see TextFormat
		 */
		public function setTextFormat(p_format:TextFormat, p_begin:int = -1, p_end:int = -1):void{
			_field.setTextFormat(p_format, p_begin, p_end);
			_format = new TextFormat();
			update(p_begin, p_end);
		}
		
		/**
		 * Returns a TextFormat object that contains formatting information for the range of text that the beginIndex and endIndex parameters specify. 
		 * Only properties that are common to the entire text specified are set in the resulting TextFormat object. 
		 * Any property that is mixed, meaning that it has different values at different points in the text, has a value of null.
		 * 
		 * @see TextFormat
		 */
		public function getTextFormat(p_begin:int = -1, p_end:int = -1):TextFormat{
			return _field.getTextFormat(p_begin, p_end);
		}
		
		/**
		 * Applies the text formatting that the format parameter specifies to the specified text in a text field.
		 * @see TextFormat
		 */
		public function set format(p_format:TextFormat):void{
			_format = p_format;
			
			update();
		}
		
		public function get format():TextFormat{
			return _format;
		}
		
		/**
		 * The name of the font for text in this text format, as a string.
		 * @see TextFormat
		 */
		public function set font(p_value:String):void{
			_format.font = p_value;
			
			update();
		}
		
		public function get font():String{
			return _format.font;
		}
		
		/**
		 * The color of text using this text format.
		 * @see TextFormat
		 */
		public function set color(p_value:uint):void{
			_format.color = p_value;
			
			update();
		}
		
		/**
		 * The size in pixels of text in this text format.
		 * @see TextFormat
		 */
		public function set size(p_value:uint):void{
			p_value > 127 ? trace("Unfortunately text fields formatted via TextFormat, CSS, or HTML have an undocumented maximum font size of 127 px. :(") : null;
			
			_format.size = p_value;
			
			update();
		}
		
		/**
		 * A number that indicates the amount of leading vertical space between lines.
		 * @see TextFormat
		 */
		public function set lineSpacing(p_value:Number):void{
			_format.leading = p_value;
			
			update();
		}
		
		/**
		 * A number representing the amount of space that is uniformly distributed between all characters.
		 * @see TextFormat
		 */
		public function set letterSpacing(p_value:Number):void{
			_format.letterSpacing = p_value;
			
			update();
		}
		
		/**
		 * A Boolean value that indicates whether kerning is enabled (true) or disabled (false).
		 * @see TextFormat
		 */
		public function set kerning(p_value:Number):void{
			_format.kerning = p_value;
			
			update();
		}
		
		/**
		 * Specifies the tab ordering of objects in a SWF file.
		 * @see InteractiveObject
		 */
		public function set tab(p_value:int):void{
			_field.tabIndex = p_value;
		}
		
		public function get tab():int{
			return _field.tabIndex;
		}
		
		/**
		 * The type of anti-aliasing used for this text field.
		 * @see TextField
		 */
		public function set alias(p_value:String):void{
			_field.antiAliasType = p_value;
		}
		
		public function get alias():String{
			return _field.antiAliasType;
		}
		
		/**
		 * The maximum number of characters that the text field can contain, as entered by a user.
		 * @see TextField
		 */
		public function set maxChars(p_value:int):void{
			_field.maxChars = p_value;
		}
		
		public function get maxChars():int{
			return _field.maxChars;
		}
		
		/**
		 * Indicates the set of characters that a user can enter into the text field.
		 * @see TextField
		 */
		public function set restrict(p_value:String):void{
			_field.restrict = p_value;
		}
		
		public function get restrict():String{
			return _field.restrict;
		}
		
		/**
		 * The type of the text field.
		 * @see TextField
		 */
		public function set type(p_value:String):void{
			_field.type = p_value;
			
			selectable = p_value == "input" ? true : _selectable;
			_field.tabEnabled = p_value == "input" ? true : _field.tabEnabled;
		}
		
		public function get type():String{
			return _field.type;
		}
		
		/**
		 * A Boolean value that indicates whether the text field is selectable.
		 * @see TextField
		 */
		public function get selectable():Boolean{
			return _selectable;
		}
		
		public function set selectable(p_value:Boolean):void{
			_selectable = _field.mouseEnabled = _field.selectable = p_value;
		}
		
		/**
		 * Specifies whether the text field is a password text field.
		 * @see TextField
		 */
		public function set password(p_value:Boolean):void{
			_field.displayAsPassword = p_value;
		}
		
		public function get password():Boolean{
			return _field.displayAsPassword;
		}
		
		/**
		 * Indicates whether field is a multiline text field.
		 * @see TextField
		 */
		public function set multiline(p_value:Boolean):void{
			_field.multiline = _field.wordWrap = p_value;
		}
		
		public function get multiline():Boolean{
			return _field.multiline;
		}
		
		/**
		 * The thickness of the glyph edges in this text field.
		 * @see TextField
		 */
		public function set thickness(p_value:Number):void{
			_field.thickness = p_value;
		}
		
		public function get thickness():Number{
			return _field.thickness;
		}
		
		/**
		 * The sharpness of the glyph edges in this text field.
		 * @see TextField
		 */
		public function set sharpness(p_value:Number):void{
			_field.sharpness = p_value;
		}
		
		public function get sharpness():Number{
			return _field.sharpness;
		}
		
		/**
		 * Indicates the width of the display object, in pixels.
		 * @see DisplayObject
		 */
		override public function set width(p_value:Number):void{
			_field.width = p_value;
		}
		
		override public function get width():Number{
			return _field.width;
		}
		
		/**
		 * Indicates the height of the display object, in pixels.
		 * @see DisplayObject
		 */
		override public function set height(p_value:Number):void{
			_field.height = p_value;
		}
		
		override public function get height():Number{
			return _field.height;
		}
		
		/**
		 * Indicates the field of the display object, in <code>TextField</code>.
		 * @see TextField
		 */
		public function get field():TextField{
			return _field;
		}
		
		/**
		 * A string that is the current text in the text field.
		 * @see TextField
		 */
		public function set text(p_text:String):void{
			_field.htmlText = StringUtils.replace(p_text, "<br>", "\n");
			
			update();
		}
		
		public function get text():String{
			return _field.text;
		}
		
		/**
		 * Destroy the instance.
		 */
		public function destroy():void{
			_format = null;
			_css = null;

			_field.removeEventListener(Event.SCROLL, _scroll);
			removeChild(_field);
			_field = null;
		}
	}
}	
