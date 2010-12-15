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

package sweatless.utils{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.describeType;
	
	/**
	 * The <code>DisplayObjectUtils</code> class have support methods for easier manipulation of
	 * the native <code>DisplayObject</code> Class.
	 * @see DisplayObject
	 */
	public class DisplayObjectUtils{
		
		/**
		 * Clone a properties of the <code>DisplayObject</code>.
		 * @param p_target The <code>DisplayObject</code> object to clone.
		 * @param p_clone The target to clone.
		 * @return The clone object with the target properties.
		 * @see Stage
		 */
		public static function cloneProperties(p_target:DisplayObject, p_clone:DisplayObject):DisplayObject{
			var description : XML = describeType(p_target);
			
			for each (var variable:XML in description.variable){
				p_clone.hasOwnProperty(variable.@name) ? p_clone[variable.@name] = p_target[variable.@name] : null;  
			}
			
			for each (var property:XML in description.accessor){
				property.@access == "readwrite" ? p_clone.hasOwnProperty(property.@name) ? p_clone[property.@name] = p_target[property.@name] : null : null;  
			}
			
			return p_clone;
		}
		
		
		/**
		 * Duplicates a instance of the <code>DisplayObject</code>.
		 * @param p_target The <code>DisplayObject</code> object to duplicate.
		 * @return The clone of target.
		 */
		public static function duplicate(p_target:*):DisplayObject{
			var clone : * = new (Object(p_target).constructor)();
			
			if(p_target is DisplayObjectContainer){
				var child : Object;
				var index : int = p_target.numChildren;
				
				while(index){
					child = p_target.getChildAt(0);

					if(!child) continue;
					if(child is DisplayObjectContainer) duplicate(child);
					
					clone.addChild(DisplayObjectUtils.cloneProperties(DisplayObject(child), new (Object(child).constructor)()));
					
					index--;
				}
				child = null;
			}
			
			return DisplayObjectUtils.cloneProperties(p_target, clone);
		}
		
		/**
		 * Get the reference class of a Object.
		 * @param p_source The object.
		 * @param p_class The class name in <code>String</code>.
		 * @return The resulting <code>Class</code> object.
		 * @see Class
		 */
		public static function getClass(p_source:*, p_class:String):*{
			var reference : Class = p_source.loaderInfo.applicationDomain.getDefinition(p_class) as Class;
			return new reference();
		}
		
		/**
		 * A heavy method to remove all itens inside a <code>Object</code>.
		 * @param p_target The object to clean.
		 */
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
		
		/**
		 * replace one by another <code>DisplayObject</code>.
		 * @param p_new The <code>DisplayObject</code> to add.
		 * @param p_old The <code>DisplayObject</code> to remove.
		 */
		public static function replace(p_new:DisplayObject, p_old:DisplayObject):void{
			if (p_old.parent == null) return;
			
			p_old.parent.addChild(p_new);
			p_old.parent.swapChildren(p_new, p_old);
			
			p_new = cloneProperties(p_old, p_new);
			p_old.parent.removeChild(p_old);
			p_old = null;
		}
		
		/**
		 * Flip horizontally or vertically a <code>DisplayObject</code>.
		 * @param p_target The <code>DisplayObject</code> to flip.
		 * @param p_horizontal Flip horizontally.
		 */
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
		
		/**
		 * Flip horizontally or vertically a <code>DisplayObject</code>.
		 * @param p_target The <code>DisplayObject</code> to skew.
		 * @param p_x The <code>Number</code> of x property of p_target.
		 * @param p_y The <code>Number</code> of y property of p_target.
		 */
		public static function skew(p_target:DisplayObject, p_x:Number, p_y:Number):void{
			var matrix : Matrix = new Matrix();
			matrix.b = p_y * Math.PI/180;
			matrix.c = p_x * Math.PI/180;
			matrix.concat(p_target.transform.matrix);
			p_target.transform.matrix = matrix;
		}
	}
}
