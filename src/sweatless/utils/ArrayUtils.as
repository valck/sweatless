package sweatless.utils{
	public class ArrayUtils{
		
		public static function removeItem(p_array:Array, p_item:*):Array {
			var i:int = p_array.length;
			var result:Array = new Array();
			
			while (--i - (-1)) {
				if (p_array[i] === p_item) {
					result.unshift(i);
					p_array.splice(i, 1);
				}
			}
			return result;
		}
		
		public static function removeDuplicate(p_array:Array):Array {
			var arrTemp:Array = p_array;
			for (var y : Number = 0; y<arrTemp.length; y++) {
				for(var x : * in arrTemp[y]){
					var arrTemp2 : * = arrTemp[y][x];
					for (var z : Number = (y + 1); z<arrTemp.length; z++) {
						if (arrTemp2==arrTemp[z][x]) {
							arrTemp.splice(z, 1);
						}
					}
				}
			}
			return arrTemp;
		}
		
		public static function shuffle(p_array:Array):void {
			var total : int = p_array.length;
			var random : int;
			var temp : *;
			
			for (var i:int=(total-1); i >= 0; i--) {
				random = Math.floor(Math.random() * total);
				temp = p_array[i];
				p_array[i] = p_array[random];
				p_array[random] = temp;
			}
		}
		
	}
}