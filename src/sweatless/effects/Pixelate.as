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
 * @todo convert and asdocs
 * 
 */

package sweatless.effects {

	import sweatless.utils.BitmapUtils;
	import sweatless.utils.NumberUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	
	/**
	 * 
	 * @see BitmapData
	 * 
	 */
	public class Pixelate{
		
		private var source : BitmapData;
		private var clone : BitmapData;
		private var pixelated : BitmapData;
		
		private var amount : Number;
		
		public function Pixelate(){
		}
		
		public function create(p_source:DisplayObject, p_amount:Number=0):void{
			var scope : DisplayObjectContainer = p_source.parent;
			var bmp : Bitmap = BitmapUtils.convertToBitmap(p_source, 0, false);
			
			source = bmp.bitmapData;
			clone = BitmapUtils.convertToBitmap(p_source, 0).bitmapData;
			
			scope.addChild(bmp);
			
			amount = p_amount;
		}
		
		public function get pixelize():Number{
			return amount;
		}
		
		public function set pixelize(p_value:Number):void{
			amount = p_value;
			amount>0 || amount<source.width/2 ? processing() : null;
		}
		
		public function destroy():void{
			source.dispose();
			clone.dispose();
			pixelated.dispose();
			
			source = null;
			clone = null;
			pixelated = null;
			
			amount = 0;
		}
		
		private function processing():void{
			var scale : Number = 1 / amount;
			var width : int = (scale * source.width) > 0 || (scale * source.width) < 2880 ? NumberUtils.isZero(int(scale * source.width)) ? 1 : (scale * source.width) > 2880 ? 2880 : (scale * source.width) : 1;
			var height : int = (scale * source.height) > 0 || (scale * source.height) < 2880 ? NumberUtils.isZero(int(scale * source.height)) ? 1 : (scale * source.height) > 2880 ? 2880 : (scale * source.height) : 1;
			
			var pxMtx : Matrix = new Matrix();
			pxMtx.identity();
			pxMtx.scale(scale, scale);
			
			pixelated = new BitmapData(width, height);
			pixelated.draw(clone, pxMtx);
			
			var mtx : Matrix = new Matrix();
			mtx.identity();
			mtx.scale(source.width/pixelated.width, source.height/pixelated.height);
			
			source.draw(pixelated, mtx);
		}
	}
}