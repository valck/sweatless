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

package sweatless.transitions{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import sweatless.effects.Pixelate;
	import sweatless.utils.BitmapUtils;
	
	public class Pixelize{
		public static function start(p_of:DisplayObject, p_to:DisplayObject):void{
			var scopeOut : DisplayObjectContainer = p_of.parent;
			var scopeIn : DisplayObjectContainer = p_to.parent;
			
			var bmpOut : Bitmap = BitmapUtils.convertToBitmap(p_of, 0, true);
			var bmpIn : Bitmap = BitmapUtils.convertToBitmap(p_to, 0, false);
			
			var fxIn : Pixelate = new Pixelate();
			fxIn.create(bmpIn, bmpIn.width);
			scopeIn.parent.addChild(bmpIn);
			
			var fxOut : Pixelate = new Pixelate();
			fxOut.create(bmpOut, bmpOut.width);
			scopeOut.parent.addChild(bmpOut);
			
			TweenMax.to(fxOut, 2,{
				pixelize:10,
				onComplete:fxOut.destroy
			});
			
			TweenMax.to(bmpOut, 2,{
				alpha:0,
				delay:1.5
			});
			
			TweenMax.to(fxIn, 2,{
				pixelize:10,
				yoyo:true,
				repeat:1,
				onComplete:fxIn.destroy
			});
		}
	}
}