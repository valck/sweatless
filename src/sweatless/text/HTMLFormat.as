package sweatless.text{
	/**
	 * The <code>HTMLFormat</code> class defined each of the following methods returns a copy of the string wrapped inside an HTML tag.
	 */
	public class HTMLFormat{
		
		/**
		 * Use the bold method to format and display a string in a document.
		 * 
		 * @param p_str the string to be formatted.
		 * @return the string formatted with the method.
		 */
		public static function bold(p_str:String):String{
			return "<b>" + p_str + "</b>";
		}
		
		/**
		 * Use the italic method to format and display a string in a document.
		 * 
		 * @param p_str the string to be formatted.
		 * @return the string formatted with the method.
		 */
		public static function italic(p_str:String):String{
			return  "<i>" + p_str + "</i>";
		}
		
		/**
		 * Use the fontColor method to format and display a string in a document.
		 * 
		 * @param p_str the string to be formatted.
		 * @param p_color the string hexadecimal RGB triplet with the format #rrggbb.
		 * @return the string formatted with the method.
		 */
		public static function fontColor(p_str:String, p_color:String):String{
			return "<font color='" + p_color + "'>" + p_str + "</font>";
		}
		
		/**
		 * Use the fontColor method to format and display a string in a document.
		 * 
		 * @param p_str the string to be formatted.
		 * @param p_size an Integer representing the size of the font.
		 * @return the string formatted with the method.
		 */
		public static function fontSize(p_str:String, p_size:uint):String{
			return "<font size='" + p_size + "'>" + p_str + "</font>";
		}
		
		/**
		 * Creates an HTML hypertext link that requests another URL.
		 * 
		 * @param p_str the string to be formatted.
		 * @param p_url any string that specifies the HREF of the A tag; it should be a valid URL (relative or absolute).
		 * @param p_target (optional) this value defined to the anchor tag forces the load of that link into the targeted window.
		 * @return the string formatted with the method.
		 */
		public static function href(p_str:String, p_url:String, p_target:String):String{
			return "<a href=\'" + p_url + "\' target=\'" + p_target + "\'>" + p_str + "</a>";
		}
		
		/**
		 * Creates an HTML paragraph HTML string in a document.
		 * 
		 * @param p_str the string to be formatted.
		 * @return the string formatted with the method.
		 */
		public static function paragraph(p_str:String):String{
			return "<p>" + p_str + "</p>";
		}
		
		/**
		 * Creates an HTML span string in a document.
		 * 
		 * @param p_str the string to be formatted.
		 * @param p_style (optional) the style class name of the tag.
		 * @return the string formatted with the method.
		 */
		public static function span(p_str:String, p_style:String):String{
			return "<span" + (p_style ? " class=\'" + p_style + "\'" : "") + ">" + p_str + "</span>";
		}
		
		/**
		 * Use the underline method to format and display a string in a document.
		 * 
		 * @param p_str the string to be formatted.
		 * @return the string formatted with the method.
		 */
		public static function underline(p_str:String):String{
			return "<u>" + p_str + "</u>";
		}
	}
}