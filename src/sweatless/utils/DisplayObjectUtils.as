package sweatless.utils{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
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
		
		public static function skew(p_target:DisplayObject, p_x:Number, p_y:Number):void{
			var mtx:Matrix = new Matrix();
			mtx.b = p_y * Math.PI/180;
			mtx.c = p_x * Math.PI/180;
			mtx.concat(p_target.transform.matrix);
			p_target.transform.matrix = mtx;
		}
	}
}