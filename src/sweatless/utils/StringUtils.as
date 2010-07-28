package sweatless.utils{
	public class StringUtils{
		public static function reverse(p_string:String):String {
			if (p_string == null) return "";
			
			return p_string.split("").reverse().join("");
		}
		
		public static function removeWhiteSpace(p_string:String):String {
			if (p_string == null) return "";
			
			return trim(p_string).replace(/\s+/g, " ");
		}		

		public static function isEmpty(p_string:String):Boolean {
			if (p_string == null || p_string == "") return true;
			
			return !p_string.length;
		}

		public static function toCapitalizeCase(p_string:String, ...args):String {
			var str:String = trimLeft(p_string);

			return args[0] === true ? str.replace(/^.|\b./g, _upperCase) : str.replace(/(^\w)/, _upperCase);
		}
		
		public static function toHTMLSmartCaps(p_string:String, minSize:int=10, maxSize:int=15):String{
			var pattern:RegExp = /[a-z]*?([A-Z])/g;
			var str:String = p_string.replace(pattern, "<font size='"+maxSize+"'>$1<font size='"+minSize+"'>");
			return str.toUpperCase();
		}
			
		public static function addDecimalZero(p_value:Number):String{
			var result : String = String(p_value);
			
			if(p_value < 10 && p_value > -1) result = "0" + result;
			
			return result;
		}
		
		public static function abbreviate(p_string:String, p_max_length:Number=50, p_indicator:String='...', p_split:String=' '):String {
                if(p_string == null) return "";
                if(p_string.length < p_max_length) return p_string;
        
                var result : String='';
                var n : int = 0;
                var pieces : Array = p_string.split(p_split);      

                var charCount : int = pieces[n].length;                     
        
                while(charCount < p_max_length && n < pieces.length) {
                    result += pieces[n] + p_split;                                   

                    charCount += pieces[++n].length + p_split.length;
                }
        
                if(n < pieces.length) {
                    //trace(result.length + 'chars : '+result);
                    
                    // TODO - maybe we should use regex for this ?
                    var badChars:Array=['-', '—', ',', '.', ' ', ':', '?', '!', ';', "\n", ' ', String.fromCharCode(10), String.fromCharCode(13)];
                    while( badChars.indexOf(result.charAt(result.length - 1)) != -1 ) {
                        result = result.slice(0, -1);
                    }

                    result = trim(result) + p_indicator;
                }
                
                if(n == 0) {
                    result = p_string.slice(0, p_max_length) + p_indicator;
                }
                
                return result;
        }
		
		public static function toBoolean(p_string:String):Boolean{
			p_string = p_string.toLocaleLowerCase();
			
			return p_string == "yes" || p_string == "true" || p_string == "1" ? true : false;
		}
		
		private static function trim(p_string:String):String {
			if (p_string == null) return "";
			
			return p_string.replace(/^\s+|\s+$/g, "");
		}
		
		private static function trimLeft(p_string:String):String {
			if (p_string == null) return "";
			
			return p_string.replace(/^\s+/, "");
		}

		private static function _upperCase(p_char:String, ...args):String {
			return p_char.toUpperCase();
		}

	}
}