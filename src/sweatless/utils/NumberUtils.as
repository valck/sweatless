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
		
		public static function toPercent(p_value:Number, p_min:Number, p_max:Number):Number{
			return ((p_value - p_min) / (p_max - p_min)) * 100;
		}
		
		public static function percentToValue(p_percent:Number, p_min:Number, p_max:Number):Number{
			return (((p_max - p_min) / 100) * p_percent) + p_min;
		}
				
		public static function rangeRandom(p_low:Number, p_high:Number, p_rounded:Boolean=false):Number{
          return !p_rounded ? (Math.random() * (p_high - p_low)) + p_low : Math.round(Math.round(Math.random() * (p_high - p_low)) + p_low);
        }
	}
}