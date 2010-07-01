package sweatless.utils{
	public class ValidateUtils{
		public static function isUrl(p_value:String):Boolean {
			var validate : RegExp = /^http(s)?:\/\/((\d+\.\d+\.\d+\.\d+)|(([\w-]+\.)+([a-z,A-Z][\w-]*)))(:[1-9][0-9]*)?(\/([\w-.\/:%+@&=]+[\w- .\/?:%+@&=]*)?)?(#(.*))?$/i;
			return validate.test(p_value);
		}

		public static function isEmail(p_value:String):Boolean {
			var validate : RegExp = /^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4})*$/;
			return validate.test(p_value);
		}

	}
}