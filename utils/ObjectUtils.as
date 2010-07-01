package sweatless.utils{
	import flash.utils.describeType;
	public class ObjectUtils{
		
		public static function getProperties(p_obj:*):Array {
			var properties : XMLList = describeType(p_obj)..variable;
			var result : Array = new Array();
			
			for(var i:uint; i<properties.length(); i++){
				trace("instance name =", properties[i].@name, ":", p_obj[properties[i].@name], "-> type", properties[i].@type);
				result.push({name:properties[i].@name, type:properties[i].@type});
			}
			
			return result;
		}
		
		public static function getMethods(p_obj:*):void {
			for each (var m:XML in describeType(p_obj).method) {
				trace(m.@name+" : "+m.@returnType);
				if (m.parameter != undefined) {
					trace("     arguments:");
					for each (var p:XML in m.parameter) trace("               - "+p.@type);
				}
			}
		}
	}
}

