package sweatless.utils
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;

	public class MacMouseWheel
	{
		private static var _instance:MacMouseWheel;
		
		
		private var dummyEvent:MouseEvent;
		private var dummy:DisplayObject;
		
		public static function init( stage:Stage ):void
		{
			var isMac:Boolean = Capabilities.os.toLowerCase().indexOf( "mac" ) != -1;
			
			var js:URLRequest = new URLRequest("javascript:var swfmacmousewheel=function(){if(!swfobject)return null;var u=navigator.userAgent.toLowerCase();var p=navigator.platform.toLowerCase();var d=p?/mac/.test(p):/mac/.test(u);if(!d)return null;var k=[];var r=function(event){var o=0;if(event.wheelDelta){o=event.wheelDelta/120;if(window.opera)o= -o;}else if(event.detail){o= -event.detail;}if(event.preventDefault)event.preventDefault();return o;};var l=function(event){var o=r(event);var c;for(var i=0;i<k.length;i++){c=swfobject.getObjectById(k[i]);if(typeof(c.externalMouseEvent)=='function')c.externalMouseEvent(o);}};if(window.addEventListener)window.addEventListener('DOMMouseScroll',l,false);window.onmousewheel=document.onmousewheel=l;return{registerObject:function(m){k[k.length]=m;}};}();");		
			
			if( isMac ) navigateToURL(js, "_self");
			
			if( isMac ) setTimeout(instance._init , 1000, stage );
		}
		
		private function _init(stage:Stage):void{
			if( ExternalInterface.available )
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, targetGetter);
				ExternalInterface.addCallback('externalMouseEvent', javascriptMouseEvent );	
			}
		}
		
		private function targetGetter(e:MouseEvent):void{
			
			dummyEvent = e;
			dummy = DisplayObject(e.target);
		}
		
		private function javascriptMouseEvent(delta:Number):void{
			if(!dummyEvent || !dummy) return;
			var evt:MouseEvent = new MouseEvent(
				MouseEvent.MOUSE_WHEEL,
				true,
				false,
				dummyEvent.localX,
				dummyEvent.localY,
				dummyEvent.relatedObject,
				dummyEvent.ctrlKey, 
				dummyEvent.altKey, 
				dummyEvent.shiftKey, 
				dummyEvent.buttonDown, 
				int(delta));
			dummy.dispatchEvent(evt);
		}
		
		private static function get instance():MacMouseWheel{
			if(!_instance) _instance = new MacMouseWheel();
			return _instance;
		}
		
	}
}