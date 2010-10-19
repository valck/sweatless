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

package sweatless.effects{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObjectContainer;
	import flash.filters.BlurFilter;

	/**
	 * 
	 * A easily way to creates a noise effect.
	 * 
	 * @see BitmapData#noise()
	 * 
	 */
	public class Noise{
		private var scope : DisplayObjectContainer;
		private var statics : Bitmap;
		
		/**
		 * 
		 * A easily way to creates a noise effect.
		 * 
		 * @see BitmapData#noise()
		 * 
		 */
		public function Noise(){
		}

		/**
		 * Sets the scope of effect and create a noise dependencies.
		 *  
		 * @param p_scope The scope of effect.
		 * @param p_width The <code>width</code> of effect.
		 * @param p_height The <code>height</code> of effect.
		 * @param p_blur_x The <code>blurX</code> of effect.
		 * @param p_blur_y The <code>blurY</code> of effect.
		 * 
		 * @see DisplayObjectContainer
		 * 
		 */
		public function create(p_scope:DisplayObjectContainer, p_width:Number=0, p_height:Number=0, p_blur_x:Number=0, p_blur_y:Number=0):void{
			scope = p_scope;
			
			statics = new Bitmap();
			add(p_width, p_height);
			scope.addChild(statics);
			
			if(p_blur_x || p_blur_y) statics.filters = [new BlurFilter(p_blur_x, p_blur_y, 2)]; 
		}
		
		/**
		 * Adds replace the noise layer.
		 *  
		 * @param p_width The <code>width</code> of effect.
		 * @param p_height The <code>height</code> of effect.
		 * 
		 */
		public function add(p_width:Number=0, p_height:Number=0):void{
			if(!statics) return;
			statics.bitmapData = new BitmapData(p_width == 0 ? scope.width : p_width, p_height == 0 ? scope.height : p_height, true, 0x000000);
		}
		
		/**
		 * Dispose the noise layer
		 * 
		 * @see BitmapData#dispose()
		 * 
		 */
		public function dispose():void{
			if(!statics) return;
			statics.bitmapData.dispose();
		}
		
		/**
		 * Render the effect
		 *  
		 * @param p_random The random seed number to use. If you keep all other parameters the same, you can generate different pseudo-random results by varying the random seed value. The noise function is a mapping function, not a <code>true</code> random-number generation function, so it creates the same results each time from the same random seed.
		 * @param p_min The lowest value to generate for each channel (0 to 255).
		 * @param p_max The highest value to generate for each channel (0 to 255).
		 * @param p_channel A number that can be a combination of any of the four color channel values (<code>BitmapDataChannel.RED, BitmapDataChannel.BLUE, BitmapDataChannel.GREEN, and BitmapDataChannel.ALPHA</code>). You can use the logical OR operator (|) to combine channel values.
		 * @param p_grayscale A Boolean value. If the value is <code>true</code>, a grayscale image is created by setting all of the color channels to the same value. The alpha channel selection is not affected by setting this parameter to <code>true</code>.
		 * 
		 * @see BitmapDataChannel#RED
		 * @see BitmapDataChannel#BLUE
		 * @see BitmapDataChannel#GREEN
		 * @see BitmapDataChannel#ALPHA
		 * 
		 */
		public function render(p_random:int=-1, p_min:uint=0, p_max:uint=0xFFFFFF, p_channel:uint=BitmapDataChannel.ALPHA, p_grayscale:Boolean=true):void{
			if(!statics) return;
			try{
				statics.bitmapData.noise(p_random == -1 ? int(Math.random() * int.MAX_VALUE) : p_random, p_min, p_max, p_channel, p_grayscale);
			}catch(e:Error){
				throw new Error("Use the add method before the render.");
			}
		}
		
		/**
		 * Destroy remove the noise layer and call <code>dispose</code> method.
		 * @see BitmapData#dispose()
		 * @see DisplayObjectContainer#removeChild()
		 * 
		 */
		public function destroy():void{
			dispose();
			
			statics ? scope.removeChild(statics) : null;
			statics = null;
		}				
	}
}
