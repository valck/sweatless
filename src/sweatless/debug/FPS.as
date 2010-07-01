package sweatless.debug{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;

	public class FPS extends Sprite{
		private var cautionPercent : int;
		private var dangerPercent : int;
		
		private var label : TextField;
		private var lastFrameTime : Number;
		private var frames : Number = 0;
		
		public function FPS(p_danger_percent:int=70, p_caution_percent:int=40):void{
			dangerPercent = p_danger_percent;
			cautionPercent = p_caution_percent;

			addEventListener(Event.ADDED_TO_STAGE, create);
		}
		
		private function create(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, create);
			
			var host : LocalConnection = new LocalConnection();
			var offline : Boolean = String(host.domain).indexOf("localhost") != -1 ? true : false;
			
			label = new TextField();
			label.width = 70;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.height = 20;
			label.selectable = false;
			
			var style:StyleSheet = new StyleSheet();
			style.parseCSS('p {font-family:Arial;font-size:10px;color:#000000}');
			label.styleSheet = style;
			
			lastFrameTime = getTimer();
			
			show(offline);
		}
		
		public function show(p_debugger:Boolean):void{
			if(!p_debugger) return;
			
			addEventListener(Event.ENTER_FRAME, check);
			addEventListener(MouseEvent.MOUSE_DOWN, down);
			addEventListener(MouseEvent.MOUSE_UP, up);
			
			addChild(label);
		}
		
		private function down(evt:Event):void{
			startDrag();
		}
		
		private function up(evt:Event):void{
			stopDrag();
		}		
		
		private function caution():int{
			var result : int =  int(stage.frameRate*cautionPercent/100);
			return result;
		}
		
		private function danger():int{
			var result : int =  int(stage.frameRate*dangerPercent/100);
			return result;
		}
		
		private function check(evt:Event):void{
			frames ++;
			var time:Number = getTimer();
			if (time - lastFrameTime >= 1000){
				var lsMem:String = String(Number(System.totalMemory/1024/1024).toFixed(1))+"MB";
				
				var debugger : String = Capabilities.isDebugger == true ? "Debug Player :)" : "Single Player :(";
				
				label.htmlText = "<p>" + debugger + "\n" + Capabilities.version + "\n" + String(frames) + "FPS / " + lsMem + "</p>";
				
				graphics.clear();
				if(frames>caution()){
					graphics.beginFill(0xCFFCE0);
				}else if(frames<=caution() && frames>danger()){
					graphics.beginFill(0xFAF1AF);
				}else if(frames<=danger()){
					graphics.beginFill(0xFFCCCC);
				}
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
				
				frames = 0;
				lastFrameTime = time;
			}
		}
	}
}