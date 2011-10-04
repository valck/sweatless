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

package sweatless.utils {

	import flash.utils.getDefinitionByName;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
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
		 * @deprecated
		 */
		public static function cloneProperties(p_target:DisplayObject, p_clone:DisplayObject):DisplayObject{
			var description : XML = describeType(p_target);
			
			for each (var variable:XML in description.variable){
				p_clone.hasOwnProperty(variable.@name) ? p_clone[variable.@name] = p_target[variable.@name] : null;  
			}
			
			for each (var property:XML in description.accessor){
				property.@access == "readwrite" || property.@access == "write-only" ? p_clone.hasOwnProperty(property.@name) ? p_clone[property.@name] = p_target[property.@name] : null : null;  
			}
			return p_clone;
		}
		
		/**
		 * Duplicates a instance of the <code>DisplayObject</code>.
		 * @param p_target The <code>DisplayObject</code> object to duplicate.
		 * @return The clone of target.
		 */
		public static function duplicate(p_target:*):DisplayObject{
			var clone : * = DisplayObjectUtils.cloneProperties(p_target, new (Object(p_target).constructor)());
			clone.name = p_target.name + "_copy";
			
			if(p_target is DisplayObjectContainer){
				var child : Object;
				var index : int = p_target.numChildren;
				
				for(var i:uint; i<index; i++){
					child = p_target.getChildAt(i);
					
					var newChild : * = DisplayObjectUtils.cloneProperties(DisplayObject(child), new (Object(child).constructor)());
					newChild.name = child.name + "_copy";
					clone.addChild(newChild);
					
					if(child is DisplayObjectContainer) duplicate(child);
				}

				child = null;
			}
			
			return clone;
		}
		
		/**
		 * Get the reference class from a SWF.
		 * @param p_source The object.
		 * @param p_class The <code>String</code> class name.
		 * @return The resulting <code>Class</code> object.
		 * @see Class
		 */
		public static function getClassFromSWF(p_class:String, p_source:DisplayObject):Class{
			return Class(p_source.loaderInfo.applicationDomain.getDefinition(p_class));
		}
		
		/**
		 * Get the reference class.
		 * @param p_class The class name in <code>String</code>.
		 * @return The resulting <code>Class</code> object.
		 * @see Class
		 */
		public static function getClass(p_class:String):Class{
			return Class(getDefinitionByName(p_class));
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
				
				remove(child);
				if(child is DisplayObjectContainer) removeAll(child as DisplayObjectContainer);
				if(child.parent && child.stage) child.parent.removeChild(child);
			}
			child = null;
		}
		
		/**
		 * A safe method to remove a <code>DisplayObject</code>. inside a <code>DisplayObjectContainer</code>.
		 * @param p_target The object to clean.
		 */
		public static function remove(p_target : *, p_self:Boolean=false) : void {
			if(!p_target || !p_target.stage) return;
			
			if(p_target is MovieClip) p_target.stop();
			if(p_target.hasOwnProperty("dispose")) p_target.dispose();
			if(p_target.hasOwnProperty("destroy")) p_target.destroy();
			if(p_target.hasOwnProperty("kill")) p_target.kill();
			if(p_target.hasOwnProperty("unload")) p_target.unload();
			
			if(p_self){
				if(p_target.parent && p_target.stage) p_target.parent.removeChild(p_target);
				p_target = null;
			}
		}
		
		/**
		 * replace one by another <code>DisplayObject</code>.
		 * @param p_new The <code>DisplayObject</code> to add.
		 * @param p_old The <code>DisplayObject</code> to remove.
		 */
		public static function replace(p_new:DisplayObject, p_old:DisplayObject):DisplayObject{
			if (p_old.parent == null) return null;
			
			p_old.parent.addChild(p_new);
			p_old.parent.swapChildren(p_new, p_old);
			
			p_new = cloneProperties(p_old, p_new);
			p_old.parent.removeChild(p_old);
			p_old = null;
			return p_new;
		}
	}
}
