package sweatless.utils{
	import flash.utils.Dictionary;

	public class DictionaryUtils{
		public static function length(p_item:Dictionary):int{
			var result : int = 0;
			for (var key:* in p_item) {
				result++;
			}
			return result;
		}

	}
}