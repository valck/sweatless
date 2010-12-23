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
 * http://code.google.com/p/sweatless/
 * 
 * @author Valério Oliveira (valck)
 * 
 */

package sweatless.text{
	/**
	 * The <code>HTMLFormat</code> class defined each of the following methods returns a copy of the string wrapped inside an HTML tag.
	 */
	public class HTMLFormat{
		
		/**
		 * Use the bold method to format and display a HTML string in a document.
		 * 
		 * @param p_str the string to be formatted.
		 * @return the string formatted with the method.
		 */
		public static function bold(p_str:String):String{
			return "<b>" + p_str + "</b>";
		}
		
		/**
		 * Use the italic method to format and display a HTML string in a document.
		 * 
		 * @param p_str the string to be formatted.
		 * @return the string formatted with the method.
		 */
		public static function italic(p_str:String):String{
			return  "<i>" + p_str + "</i>";
		}
				
		/**
		 * Use the HTML font method to format and display a string in a document.
		 * 
		 * @param p_str the string to be formatted.
		 * @param p_face (optional) specifies the name of the font to use, you can specify a list of comma-delimited font names, in which case Flash Player selects the first available font.
		 * @param p_size (optional) an Integer representing the size of the font.
		 * @param p_color (optional) the string hexadecimal RGB triplet with the format #rrggbb.
		 * @return the string formatted with the method.
		 */
		public static function font(p_str:String, p_face:String=null, p_size:String=null, p_color:String=null):String{
			return "<font" + (p_face ? " face=\'" + p_face + "\'" : "") + (p_size ? " size=\'" + p_size + "\'" : "") + (p_color ? " color=\'" + p_color + "\'" : "") + ">" + p_str + "</font>";;
		}
		
		/**
		 * Creates an HTML hypertext link that requests another URL.
		 * 
		 * @param p_str the string to be formatted.
		 * @param p_url any string that specifies the HREF of the A tag; it should be a valid URL (relative or absolute).
		 * @param p_target (optional) this value defined to the anchor tag forces the load of that link into the targeted window.
		 * @return the string formatted with the method.
		 */
		public static function href(p_str:String, p_url:String, p_target:String="_blank"):String{
			return "<a href=\'" + p_url + "\' target=\'" + p_target + "\'>" + p_str + "</a>";
		}
		
		/**
		 * Creates an HTML paragraph string in a document.
		 * 
		 * @param p_str the string to be formatted.
		 * @param p_style (optional) the style class name of the tag.
		 * 
		 * @return the string formatted with the method.
		 */
		public static function paragraph(p_str:String, p_style:String=null):String{
			return "<p" + (p_style ? " class=\'" + p_style + "\'" : "") + ">" + p_str + "</p>";
		}
		
		/**
		 * Creates an HTML span string in a document.
		 * 
		 * @param p_str the string to be formatted.
		 * @param p_style the style class name of the tag.
		 * @return the string formatted with the method.
		 */
		public static function span(p_str:String, p_style:String):String{
			return "<span class=\'" + p_style + "\'>" + p_str + "</span>";
		}
		
		/**
		 * Use the underline method to format and display a HTML string in a document.
		 * 
		 * @param p_str the string to be formatted.
		 * @return the string formatted with the method.
		 */
		public static function underline(p_str:String):String{
			return "<u>" + p_str + "</u>";
		}
	}
}