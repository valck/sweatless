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

package sweatless.display.graphics{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import sweatless.utils.NumberUtils;
	
	/**
	 *
	 * The internal class <code>Graphic</code> contains a set of methods that you can use to create a vector shape easily. 
	 * You can extends a <code>Graphic</code> class and override the <code>addGraphic()</code> for create any shapes with line, fill and gradient fill or fill texture tiled or not. 
	 *  
	 */
	internal class Graphic extends Shape{
		private var matrix : Matrix = new Matrix();
		
		private var _texture : BitmapData;
		private var _repeat : Boolean;
		private var _stroke : Boolean;

		private var _strokeSize : Number = 1;
		private var _strokeAlpha : uint = 1;
		private var _strokeColor : uint = 0x000000;
		private var _strokeMode : String = "normal";
		
		private var _fillColors : Array = new Array(0xff0000, 0x00ff00, 0x0000ff);
		private var _fillAlphas : Array;
		private var _fillRatios : Array;
		
		private var _fillRotation : Number = 0;
		private var _fillTx : Number = 0;
		private var _fillTy : Number = 0;

		private var _width : Number = 0;
		private var _height : Number = 0;
		
		private var _type : String = "linear";
		private var _method : String = "pad";

		/**
		 *
		 * The internal class <code>Graphic</code> contains a set of methods that you can use to create a vector shape easily. 
		 * You can extends a <code>Graphic</code> class and override the <code>addGraphic()</code> for create any shapes with line, fill and gradient fill or fill texture tiled or not. 
		 *  
		 * @param p_width The width of the round rectangle (in pixels). 
		 * @param p_height The height of the round rectangle (in pixels).
		 * 
		 */
		public function Graphic(p_width:Number = 0, p_height:Number = 0){
			_width = p_width;
			_height = p_height;
			update();
		}

		/**
		 *
		 * Update properties.
		 *  
		 * @param p_width The width of the round rectangle (in pixels). 
		 * @param p_height The height of the round rectangle (in pixels).
		 * @default NaN
		 * 
		 */
		protected function update(p_width:Number=NaN, p_height:Number=NaN):void{
			p_width = !p_width ? width : p_width;
			p_height = !p_height ? height : p_height;
			
			graphics.clear();
			
			matrix = new Matrix();
			
			if(!texture){
				matrix.createGradientBox(p_width, p_height, _fillRotation, _fillTx, _fillTy);
				graphics.beginGradientFill(_type, _fillColors, _fillAlphas ? _fillAlphas : autoAlpha, _fillRatios ? _fillRatios : autoRatio, matrix, _method);
			}else{
				matrix.rotate(_fillRotation);
				matrix.translate(_fillTx, _fillTy);
				graphics.beginBitmapFill(_texture, matrix, _repeat, true);
			}
			
			_stroke ? graphics.lineStyle(_strokeSize, _strokeColor, _strokeAlpha, true, _strokeMode): null;
			
			addGraphic();
			
			graphics.endFill();
		}

		/**
		 *
		 * Adds a vector graphic. 
		 * Note: Please override this method. 
		 * 
		 */
		protected function addGraphic():void{
			
		}
		
		private function get autoAlpha():Array{
			var alphaArray : Array = new Array();
			
			for(var i:int=0; i<_fillColors.length; i++) {
				alphaArray.push(1);
			}
			
			return alphaArray;
		}
		
		private function get autoRatio():Array{
			var ratioArray : Array = new Array();

			for(var i:int=0; i<_fillColors.length; i++) {
				ratioArray.push((i/(_fillColors.length-1)*255));
			}
			
			return ratioArray;
		}
		
		/**
		 *
		 * Shows or not the stroke in the graphic.
		 * 
		 * @return 
		 * 
		 */
		public function get stroke():Boolean{
			return _stroke;
		}
		
		public function set stroke(p_value:Boolean):void{
			_stroke = p_value;
			update();
		}
		
		/**
		 *
		 * Sets/Get a value from the <code>LineScaleMode</code> class that specifies which scale mode to use: (<code>LineScaleMode.NONE, LineScaleMode.NORMAL, LineScaleMode.HORIZONTAL and LineScaleMode.VERTICAL</code>)
		 *   
		 * @return 
		 * @default LineScaleMode.NORMAL
		 * 
		 */
		public function get strokeScaleMode():String{
			return _strokeMode;
		}
		
		public function set strokeScaleMode(value:String):void{
			_strokeMode = value;
			update();
		}
		
		/**
		 *
		 * Sets/Get a hexadecimal color value of the line; for example, red is 0xFF0000, blue is 0x0000FF, and so on. If a value is not indicated, the default is 0x000000 (black). Optional.
		 *   
		 * @return 
		 * @default 0x000000
		 * 
		 */
		public function get strokeColor():uint{
			return _strokeColor;
		}
		
		public function set strokeColor(value:uint):void{
			_strokeColor = value;
			update();
		}
		
		/**
		 *
		 * Sets/Get a number that indicates the alpha value of the color of the line; valid values are 0 to 1. If a value is not indicated, the default is 1 (solid). If the value is less than 0, the default is 0. If the value is greater than 1, the default is 1.
		 *   
		 * @return 
		 * @default 1
		 * 
		 */
		public function get strokeAlpha():uint{
			return _strokeAlpha;
		}
		
		public function set strokeAlpha(value:uint):void{
			_strokeAlpha = value;
			update();
		}
		
		/**
		 *
		 * Sets/Get a number that indicates the size of the line in points; valid values are 0-255.
		 *   
		 * @return 
		 * @default 1
		 * 
		 */
		public function get strokeSize():Number{
			return _strokeSize;
		}
		
		public function set strokeSize(value:Number):void{
			_strokeSize = value;
			update();
		}

		/**
		 * 
		 * Sets/Get a rotation transformation in the fill of graphic. 
		 * 
		 * @param p_value The rotation angle in radians.
		 * 
		 */
		public function set fillRotation(p_value:Number):void{
			_fillRotation = NumberUtils.toRadians(p_value);
			update();
		}
		
		public function get fillRotation():Number{
			return _fillRotation;
		}
		
		/**
		 *
		 * Translates the matrix along the x in the fill of the graphic.
		 * 
		 * @param p_value The amount of movement along the x axis to the right, in pixels.
		 * 
		 */
		public function set fillTX(p_value:Number):void{
			_fillTx = p_value;
			update();
		}
		
		public function get fillTX():Number{
			return _fillTx;
		}
		
		/**
		 *
		 * Translates the matrix along the y in the fill of the graphic.
		 * 
		 * @param p_value The amount of movement along the y axis to the right, in pixels.
		 * 
		 */
		public function set fillTY(p_value:Number):void{
			_fillTy = p_value;
			update();
		}
		
		public function get fillTY():Number{
			return _fillTy;
		}
		
		/**
		 *
		 * Sets/Get a <code>Array</code> of one or more hexadecimal colors to be used in the gradient; for example, red and blue is [0xFF0000, 0x0000FF].
		 *   
		 * @param p_value An array of hexadecimal colors to be used in the gradient (for example, red is 0xFF0000, blue is 0x0000FF, and so on).
		 * 
		 */
		public function set colors(p_value:Array):void{
			_fillColors = p_value;
			update();
		}
		
		public function get colors():Array{
			return _fillColors;
		}
		
		/**
		 *
		 * Sets/Get a <code>Array</code> of one or more alpha values to be used in the gradient; for example, 0 and 1 is [0, 1].
		 *   
		 * @param p_value An array of alpha values for the corresponding colors in the colors array; valid values are 0 to 1. If the value is less than 0, the default is 0. If the value is greater than 1, the default is 1. 
		 * 
		 */
		public function set alphas(p_value:Array):void{			
			_fillAlphas = p_value;
			update();
		}
		
		public function get alphas():Array{
			return _fillAlphas;
		}
		
		/**
		 * 
		 * Sets/Get a <code>Array</code> of one or more color distribution ratios to be used in the gradient; for example, from 0 to 255 is [0, 255].
		 * 
		 * @param p_value An array of color distribution ratios; valid values are from 0 to 255. This value defines the percentage of the width where the color is sampled at 100%. The value 0 represents the left position in the gradient box, and 255 represents the right position in the gradient box. This value represents positions in the gradient box, not the coordinate space of the final gradient, which can be wider or thinner than the gradient box. Specify a value for each value in the colors parameter. 
		 * 
		 */
		public function set ratios(p_value:Array):void{			
			_fillRatios = p_value;
			update();
		}
		
		public function get ratios():Array{
			return _fillRatios;
		}
		
		/**
		 *
		 * Sets/Get repeats in a tiled pattern. If false, the bitmap image does not repeat, and the edges of the bitmap are used for any fill area that extends beyond the bitmap. 
		 *  
		 * @param p_value 
		 * 
		 */
		public function set repeat(p_value:Boolean):void{
			if(!texture) return;
			_repeat = p_value;
			update();
		}
		
		public function get repeat():Boolean{
			return _repeat;
		}
		
		/**
		 * 
		 * Fills a drawing area with a bitmap image. The bitmap can be repeated or tiled to fill the area. 
		 * 
		 * @param p_value A transparent or opaque bitmap image that contains the bits to be displayed.
		 * 
		 */
		public function set texture(p_value:BitmapData):void{
			_texture = p_value;
			update();
		}
		
		public function get texture():BitmapData{
			return _texture;
		}
		
		/**
		 *
		 * Sets/Get a value from the <code>GradientType</code> class that specifies which gradient type to use: (<code>GradientType.LINEAR or GradientType.RADIAL</code>).
		 *   
		 * @param p_value 
		 * 
		 */
		public function set type(p_value:String):void{
			_type = p_value;
			update();
		}
		
		public function get type():String{
			return _type;
		}
		
		/**
		 *
		 * Sets/Get a value from the <code>SpreadMethod</code> class that specifies which spread method to use, either: (<code>SpreadMethod.PAD, SpreadMethod.REFLECT, or SpreadMethod.REPEAT</code>).
		 *  
		 * @param p_value 
		 * 
		 */
		public function set method(p_value:String):void{
			_method = p_value;
			update();
		}

		public function get method():String{
			return _method;
		}
		
		public override function set width(p_value:Number):void{
			_width = p_value;
			update(p_value, NaN);
		}
		
		public override function set height(p_value:Number):void{
			_height = p_value;
			update(NaN, p_value);
		}
		
		public override function get width():Number{
			return _width;
		}
		
		public override function get height():Number{
			return _height;
		}
		
		/**
		 *
		 * Clears the graphic that were drawn to this Graphic, and dispose the bitmap fill. 
		 * 
		 */
		public function destroy():void{
			graphics.clear();
			if(texture) texture.dispose();
		}
	}
}