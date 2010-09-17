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

package sweatless.utils{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	public class DisplayObjectUtils{

		public static function cloneObject(p_target:DisplayObject, p_clone:DisplayObject):DisplayObject{
			var description : XML = describeType(p_target);
	
			for each (var variable:XML in description.variable){
				p_clone.hasOwnProperty(variable.@name) ? p_clone[variable.@name] = p_target[variable.@name] : null;  
			}
				
			for each (var property:XML in description.accessor){
			    property.@access == "readwrite" ? p_clone.hasOwnProperty(property.@name) ? p_clone[property.@name] = p_target[property.@name] : null : null;  
			}
	
			return p_clone;
	    }
		
		public static function getClass(p_source:*, p_class:String):*{
			var reference : Class = p_source.loaderInfo.applicationDomain.getDefinition(p_class) as Class;
			return new reference();
		}

		public static function randomItem(p_array:Array):*{
			return p_array[NumberUtils.rangeRandom(0, p_array.length-1, true)];
		}
		
		public static function removeAll(p_target:*):void{
			if(!p_target) return;
			
			var child:Object;
			while(p_target.numChildren){
				child = p_target.getChildAt(0);
				
				if(!child) continue;
				
				if(child is MovieClip) child.stop();
				if(child.hasOwnProperty("dispose")) child.dispose();
				if(child.hasOwnProperty("destroy")) child.destroy();
				if(child.hasOwnProperty("kill")) child.kill();
				if(child.hasOwnProperty("unload")) child.unload();
				if(child is DisplayObjectContainer) removeAll(child as DisplayObjectContainer);
				if(child.parent && child.stage) child.parent.removeChild(child);
			}
			child = null;
		}
		
		public static function replace(p_new:DisplayObject, p_old:DisplayObject):void{
			if (p_old.parent == null) return;
			
			p_old.parent.addChild(p_new);
			p_old.parent.swapChildren(p_new, p_old);
			
			p_new = cloneObject(p_old, p_new);
			p_old.parent.removeChild(p_old);
			p_old = null;
		}
		
		public static function flip(p_target:DisplayObject, p_horizontal:Boolean=true):void{
			var matrix : Matrix = p_target.transform.matrix;
			
			matrix.transformPoint(new Point(p_target.width/2, p_target.height/2));
			
			if(p_horizontal){
				matrix.a = -1 * matrix.a;
				matrix.tx = matrix.a>0 ? p_target.width + p_target.x : p_target.x - p_target.width;
			}else {
				matrix.d = -1 * matrix.d;
				matrix.ty = matrix.d>0 ? p_target.height + p_target.y : p_target.y - p_target.height;
			}
			
			p_target.transform.matrix = matrix;
		}
		
		public static function skew(p_target:DisplayObject, p_x:Number, p_y:Number):void{
			var mtx:Matrix = new Matrix();
			mtx.b = p_y * Math.PI/180;
			mtx.c = p_x * Math.PI/180;
			mtx.concat(p_target.transform.matrix);
			p_target.transform.matrix = mtx;
		}
	}
}