package sweatless.utils{
	public class NumberUtils{
		public static function isEven(p_value:Number):Boolean{
			if (p_value%2==0) {
		 		return true;
			} else {
		 		return false;
			}
		}

		public static function isZero(p_value:Number):Boolean{
			return Math.abs(p_value) < 0.00001;
		}
		
		public static function toRadians(p_value:Number):Number{
			return p_value / 180 * Math.PI;
		}
		
		public static function toDegrees(p_value:Number):Number{
			return p_value * 180 / Math.PI;
		}
		
		public static function rangeRandom(p_low:Number, p_high:Number):Number{
          return Math.round(Math.random() * (p_high - p_low)) + p_low;
        }
	}
}