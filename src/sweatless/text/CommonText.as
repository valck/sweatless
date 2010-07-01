package sweatless.text{
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.describeType;
	
	import sweatless.graphics.CommonRectangle;
	
	public class CommonText extends Sprite{
		private var selection : TextField = new TextField();
		private var visualBounds : Rectangle;
		private var format : TextFormat;
		private var sheet : String;
		private var css : StyleSheet;
		private var box : Shape;
		private var first : Boolean;
		
		public var field : TextField = new TextField();
		public var selectionColor : uint = 0X333333;
		public var size : uint = 10;
		public var kerning : Number = 0;
		public var letterSpacing : Number = 0;
		public var lineSpacing : Number = 0;
		public var sharpness : Number = 0;
		public var thickness : Number = 0;
		public var restrict : String;
		public var maxChars : int;
		public var bold : Boolean;
		public var type : String = "dynamic";
		public var align : String = "left";
		public var color : uint = 0x000000;
		public var displayAsPassword : Boolean;
		public var multiline : Boolean;
		public var font : String;
		public var gradient : CommonRectangle;

		public function CommonText(){
		}
		
		public function create(p_format:TextFormat=null, p_sheet:String=null):void{
            sheet = p_sheet;
            format = p_format;
            
            field.name = "field";
			field.maxChars = maxChars;
            field.thickness = thickness;
            field.sharpness = sharpness;
			field.displayAsPassword = displayAsPassword;
			field.restrict = restrict;
			field.embedFonts = true;
			
			if(multiline){
				field.multiline = true;
				field.wordWrap = true;
			}else{
			    field.autoSize = align;
			}
			
            if(format){
	            field.defaultTextFormat = format;
            }else if(sheet){
				css = new StyleSheet();
				css.parseCSS(sheet);
				field.styleSheet = css;
            }else{
	 			format = new TextFormat();
	            format.font = font;
	            format.size = size;
	            format.color = color;
	            format.align = align;
				format.letterSpacing = letterSpacing;
				format.leading = lineSpacing;
				format.kerning = kerning;
				format.bold = bold;
	            field.defaultTextFormat = format;
            }
            
            if(type.toLowerCase() == "input"){
            	field.antiAliasType = AntiAliasType.NORMAL;
				field.type = "input";
				field.selectable = true;
				field.mouseEnabled = true;

				addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				addEventListener(MouseEvent.MOUSE_DOWN, onKeyDown);
   			}else if(type.toLowerCase() == "dynamic"){
            	field.antiAliasType = AntiAliasType.ADVANCED;
   				field.type = "dynamic";
				field.mouseEnabled = false;
				field.selectable = false;
			
                if(hasEventListener(KeyboardEvent.KEY_DOWN)){
					removeEventListener(MouseEvent.MOUSE_DOWN, onKeyDown);
                   	removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
                }
   			}
            
			addChildAt(field, 0);
		}
		
		public function set colors(p_value:Array):void{
			if(gradient) return;
			if(p_value.length>2) throw new Error("CommonText can't support more of 2 colors");
			
			field.mouseEnabled = false;
			field.selectable = false;
			
			if(type == "input") addChild(selection);
			
			gradient = new CommonRectangle();
			gradient.colors = p_value;
			addChild(gradient);
			
			addEventListener(Event.CHANGE, updateMask);
		}
		
		public function get colors():Array{
			return gradient.colors;
		}
		
		override public function set width(p_value:Number):void{
			if(!field) return;
			
			field.width = p_value;
		}
		
		override public function get width():Number{
			if(field.text.length == 0) return 0;
			
			return bounds.width;
		}
		
		override public function set height(p_value:Number):void{
			if(!field) return;
			
			field.height = p_value;
		}
		
		override public function get height():Number{
			if(field.text.length == 0) return 0;
			
			return bounds.height;
		}
		
		public function set text(p_text:String):void{
			if(!field) return;
			
			field.text = p_text;
			bounds = getVisualBounds(field);

			field.x = int(-bounds.x);
			field.y = int(-bounds.y);

			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get text():String{
			if(!field) return "";
			
			return field.text;
		}

		public function set htmlText(p_text:String):void{
			if(!field) return;
			
			field.htmlText = p_text;
			bounds = getVisualBounds(field);
			
			field.x = int(-bounds.x);
			field.y = int(-bounds.y);

			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get htmlText():String{
			if(!field) return "";
			
			return field.htmlText;
		}
		
		public function destroy():void{
			if(hasEventListener(KeyboardEvent.KEY_DOWN)){
				removeEventListener(MouseEvent.MOUSE_DOWN, onKeyDown);
               	removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            }
		
			removeChild(field);
			
			if(selection.stage) removeChild(selection);
			if(gradient) gradient.destroy();
			if(stage) parent.removeChild(this);
			
		}
		
		private function updateMask(evt:Event):void{
			if(selection && type == "input"){
				
				if(!first){
					first = true;
					if(field.text != "") selection.htmlText = field.htmlText;
				}
				
				field.htmlText = selection.htmlText;
				
				cloneProps(selection);
			}
			
			gradient.width = field.width;
			gradient.height = field.height;
			
			gradient.mask = field;
		}
		
		private function cloneProps(p_clone:TextField):void{
			var description:XML = describeType(field);

			for each (var item:XML in description.accessor){
			    if (item.@access != "readonly") p_clone[item.@name] = field[item.@name];
			}
			
			p_clone.blendMode = BlendMode.MULTIPLY;
			p_clone.selectable = true;
			
			var cloneColor : TextFieldColor = new TextFieldColor(p_clone, 0xffffff, selectionColor, selectionColor);
	    }
		
	    private function get bounds():Rectangle{
            return visualBounds;
	    }
	    
	    private function set bounds(p_value:Rectangle):void{
            visualBounds = p_value;
            
            if(box == null) {
                box = new Shape();
                box.visible = false;
                addChild(box);
            }
            
            with(box.graphics){
            	clear();
            	lineStyle(1, 0xCC0000, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER, 1);
            	drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
            }
	    }
	    
		private function onKeyDown(evt:Event):void{
			if(gradient) gradient.mask = null;
			
            bounds = getVisualBounds(field);
			
            dispatchEvent(new Event(Event.CHANGE));
	    }

		/**
		 * getVisualBounds
		 * 
		 * Original method getVisualBounds from gringo.nu thanks to patota!
		 * 
		 * @authors Rafael Rinaldi, Arthur Debert and Gabriel Laet.
		 * 
		 */
		private function getVisualBounds( p_source : DisplayObject ):Rectangle{
			var rect : Rectangle;
			var data : BitmapData;
			
			const CANVAS_WIDTH : int = 2000;
			const CANVAS_HEIGHT : int = 2000;
			
			data = new BitmapData(CANVAS_WIDTH, CANVAS_HEIGHT, true, 0x00000000);
			data.draw(p_source);
			
			rect = data.getColorBoundsRect(0xff000000, 0x00000000, false);
			
			if(rect == null) rect = new Rectangle();
			
			data.dispose();
			data = null;
			
			return rect;
		}	 
	    
	}
}	

/**
 * TextFieldColor
 * 
 * Original class TextFieldColor from hellokeita.com thanks keita!
 * 
 * @author keita kuroki.
 * 
 */
 
import flash.filters.ColorMatrixFilter;
import flash.text.TextField;

internal class TextFieldColor {
	
	private static const byteToPerc:Number = 1 / 0xff;

	private var $textField:TextField;
	private var $textColor:uint;
	private var $selectedColor:uint;
	private var $selectionColor:uint;
	private var colorMatrixFilter:ColorMatrixFilter;
	
	public function TextFieldColor(textField:TextField, textColor:uint = 0x000000, selectionColor:uint = 0x000000, selectedColor: uint = 0x000000) {
		
		$textField = textField;
		
		colorMatrixFilter = new ColorMatrixFilter();
		$textColor = textColor;
		$selectionColor = selectionColor;
		$selectedColor = selectedColor;
		updateFilter();
	}
	
	public function set textField(tf:TextField):void {
		$textField = tf;
	}
	public function get textField():TextField {
		return $textField;
	}
	public function set textColor(c:uint):void {
		$textColor = c;
		updateFilter();
	}
	public function get textColor():uint {
		return $textColor;
	}
	public function set selectionColor(c:uint):void {
		$selectionColor = c;
		updateFilter();
	}
	public function get selectionColor():uint {
		return $selectionColor;
	}
	public function set selectedColor(c:uint):void {
		$selectedColor = c;
		updateFilter();
	}
	public function get selectedColor():uint {
		return $selectedColor;
	}
	
	private function updateFilter():void {
		
		$textField.textColor = 0xff0000;

		var o:Array = splitRGB($selectionColor);
		var r:Array = splitRGB($textColor);
		var g:Array = splitRGB($selectedColor);
		
		var ro:int = o[0];
		var go:int = o[1];
		var bo:int = o[2];
		
		var rr:Number = ((r[0] - 0xff) - o[0]) * byteToPerc + 1;
		var rg:Number = ((r[1] - 0xff) - o[1]) * byteToPerc + 1;
		var rb:Number = ((r[2] - 0xff) - o[2]) * byteToPerc + 1;

		var gr:Number = ((g[0] - 0xff) - o[0]) * byteToPerc + 1 - rr;
		var gg:Number = ((g[1] - 0xff) - o[1]) * byteToPerc + 1 - rg;
		var gb:Number = ((g[2] - 0xff) - o[2]) * byteToPerc + 1 - rb;
		
		colorMatrixFilter.matrix = [rr, gr, 0, 0, ro, rg, gg, 0, 0, go, rb, gb, 0, 0, bo, 0, 0, 0, 1, 0];
		
		$textField.filters = [colorMatrixFilter];
		
	}
	
	private static function splitRGB(color:uint):Array {
		
		return [color >> 16 & 0xff, color >> 8 & 0xff, color & 0xff];
	}
}
