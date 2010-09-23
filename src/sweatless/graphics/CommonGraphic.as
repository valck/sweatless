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

package sweatless.graphics{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import sweatless.utils.NumberUtils;
	
	internal class CommonGraphic extends Shape{
		private var matrix : Matrix = new Matrix();
		
		private var _texture : BitmapData;
		private var _repeat : Boolean;
		private var _stroke : Boolean;

		private var _strokeSize : Number = 1;
		private var _strokeAlpha : uint = 1;
		private var _strokeColor : uint = 0x000000;
		private var _strokeMode : String = "normal";
		
		private var _fillColors : Array = new Array(0xff0000, 0x0000ff);
		private var _fillAlphas : Array ;
		
		private var _gradientRatios : Array;
		private var _fillRotation : Number = 0;
		private var _fillTx : Number = 0;
		private var _fillTy : Number = 0;

		private var _width : Number = 0;
		private var _height : Number = 0;
		
		private var _type : String = "linear";
		private var _method : String = "pad";

		public function CommonGraphic(p_width:Number = 0, p_height:Number = 0){
			_width = p_width;
			_height = p_height;
			update();
		}

		protected function update(p_width:Number=NaN, p_height:Number=NaN):void{
			p_width = !p_width ? width : p_width;
			p_height = !p_height ? height : p_height;
			
			graphics.clear();
			
			matrix = new Matrix();
			
			
			
			if(!texture){
				matrix.createGradientBox(p_width, p_height, _fillRotation, _fillTx, _fillTy);
				graphics.beginGradientFill(_type, _fillColors, _fillAlphas ? _fillAlphas : autoAlpha, _gradientRatios ? _gradientRatios : autoRatio, matrix, _method);
			}else{
				matrix.rotate(_fillRotation);
				matrix.translate(_fillTx, _fillTy);
				graphics.beginBitmapFill(_texture, matrix, _repeat, true);
			}
			
			_stroke ? graphics.lineStyle(_strokeSize, _strokeColor, _strokeAlpha, true, _strokeMode): null;
			
			addGraphic();
			
			graphics.endFill();
		}
		
		protected function addGraphic():void{
			
		}
		
		private function get autoAlpha():Array{
			var alphaArray:Array = [];
			for(var i:int = 0; i<_fillColors.length; i++) alphaArray[i] = 1;
			return alphaArray;
		}
		
		private function get autoRatio():Array{
			var ratioArray:Array = [];
			for(var i:int=0; i<_fillColors.length; i++) ratioArray[i] = (i/(_fillColors.length-1)*255);
			return ratioArray;
		}
		
		public function get stroke():Boolean{
			return _stroke;
		}
		
		public function set stroke(p_value:Boolean):void{
			_stroke = p_value;
			update();
		}
		
		public function get strokeMode():String{
			return _strokeMode;
		}
		
		public function set strokeMode(value:String):void{
			_strokeMode = value;
			update();
		}
		
		public function get strokeColor():uint{
			return _strokeColor;
		}
		
		public function set strokeColor(value:uint):void{
			_strokeColor = value;
			update();
		}
		
		public function get strokeAlpha():uint{
			return _strokeAlpha;
		}
		
		public function set strokeAlpha(value:uint):void{
			_strokeAlpha = value;
			update();
		}
		
		public function get strokeSize():Number{
			return _strokeSize;
		}
		
		public function set strokeSize(value:Number):void{
			_strokeSize = value;
			update();
		}

		public function set fillRotation(p_value:Number):void{
			_fillRotation = NumberUtils.toRadians(p_value);
			update();
		}
		
		public function get fillRotation():Number{
			return _fillRotation;
		}
		
		public function set fillTX(p_value:Number):void{
			_fillTx = p_value;
			update();
		}
		
		public function get fillTX():Number{
			return _fillTx;
		}
		
		public function set fillTY(p_value:Number):void{
			_fillTy = p_value;
			update();
		}
		
		public function get fillTY():Number{
			return _fillTy;
		}
		
		public function set colors(p_value:Array):void{
			_fillColors = p_value;
			update();
		}
		
		public function get colors():Array{
			return _fillColors;
		}
		
		public function set alphas(p_value:Array):void{
			if(p_value.length>2) return;
			
			_fillAlphas = p_value;
			update();
		}
		
		public function get alphas():Array{
			return _fillAlphas;
		}
		
		public function set ratios(p_value:Array):void{
			if(p_value.length>2) return;
			
			_gradientRatios = p_value;
			update();
		}
		
		public function get ratios():Array{
			return _gradientRatios;
		}
		
		public function set repeat(p_value:Boolean):void{
			if(!texture) return;
			_repeat = p_value;
			update();
		}
		
		public function get repeat():Boolean{
			return _repeat;
		}
		
		public function set texture(p_value:BitmapData):void{
			_texture = p_value;
			update();
		}
		
		public function get texture():BitmapData{
			return _texture;
		}
		
		
		public function get type():String{
			return _type;
		}
		
		public function set type(p_value:String):void{
			_type = p_value;
			update();
		}
		
		public function get method():String{
			return _method;
		}
		
		public function set method(p_value:String):void{
			_method = p_value;
			update();
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
		
		public function destroy():void{
			_fillColors = new Array(0xff0000, 0x0000ff);
			_fillAlphas = new Array(1, 1);
			_gradientRatios = new Array(0, 255);
			
			_fillRotation = Math.PI / 2;
			_fillTx = 0;
			_fillTy = 0;
			
			_width = 0;
			_height = 0;
			
			_type = "linear";
			_method = "pad";

			graphics.clear();
			if(texture) texture.dispose();
		}
	}
}