package sweatless.navigation{
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.lazyloaders.LazyBulkLoader;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import sweatless.extras.bulkloader.BulkLoaderXMLPlugin;
	import sweatless.layout.Layers;
	import sweatless.navigation.core.Config;
	import sweatless.navigation.core.Navigation;
	import sweatless.ui.LoaderBar;

	public class Sweatless extends Sprite{

		private var loader : BulkLoaderXMLPlugin;
		
		public function Sweatless(){
			stage.addEventListener(Event.RESIZE, resize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.stageFocusRect = false;
			
			tabEnabled = false;
			
			for(var i:String in loaderInfo.parameters){
				Config.setFlashVars(i, loaderInfo.parameters[i]);
			}
			
			loadConfig();
		}
		
		private function resize(evt:Event):void{
			scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		}
		
		private function loadConfig():void{
			var sig : Signature = new Signature(this);

			loader = new BulkLoaderXMLPlugin(String(Config.getFlashVars("CONFIG")), "sweatless");
			loader.addEventListener(LazyBulkLoader.LAZY_COMPLETE, ready);
			loader.addEventListener(BulkProgressEvent.PROGRESS, progress);
			loader.addEventListener(BulkProgressEvent.COMPLETE, removeLoadListeners);
			loader.start();
		}
		
		private function ready(evt:Event):void{
			loader.removeEventListener(LazyBulkLoader.LAZY_COMPLETE, ready);
			
			Config.source = loader.source;
			
			addLayers();
			addLoading();
		}
		
		private function addLayers():void{
			Layers.init(this);
			
			for(var i:uint=0; i<Config.layers.length(); i++) {
				Layers.add(Config.layers[i]["@id"]);
				Config.layers[i]["@depth"] ? Layers.swapDepth(Config.layers[i]["@id"], Config.layers[i]["@depth"]) : null;
			};
		}
		
		private function removeLoadListeners(evt:Event):void{
			loader.removeEventListener(LazyBulkLoader.LAZY_COMPLETE, ready);
			loader.removeEventListener(BulkProgressEvent.PROGRESS, progress);
			loader.removeEventListener(BulkProgressEvent.COMPLETE, removeLoadListeners);
			
			Navigation.init();
			
			build();
		}
		
		public function addLoading():void{
		}
		
		public function progress(evt:BulkProgressEvent):void{
		}
		
		public function build():void{
		}
	}
}


import flash.display.InteractiveObject;
import flash.display.StageDisplayState;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FullScreenEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

internal class Signature extends EventDispatcher{
	private var menu : ContextMenu = new ContextMenu();
	
	private var scope : InteractiveObject;
	
	public function Signature(p_scope : InteractiveObject){
		scope = p_scope;
		
		add();
	}
	
	private function add():void {
		scope.stage.addEventListener(Event.FULLSCREEN, fullScreenToggle);
		
		menu.hideBuiltInItems();
		
		var item1:ContextMenuItem = new ContextMenuItem("View FullScreen" );
		item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, goFullScreen);
		menu.customItems.push(item1);
		
		var item2:ContextMenuItem = new ContextMenuItem("Exit FullScreen");
		item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, exitFullScreen);
		menu.customItems.push(item2);
		
		var item3:ContextMenuItem = new ContextMenuItem("Built with Sweatless Framework", true);
		item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, goto);
		menu.customItems.push(item3);
		
		menu.customItems[0].enabled = true;
		menu.customItems[1].enabled = false;
		
		scope.contextMenu = menu;
	}
	
	private function goto(event:ContextMenuEvent):void {
		navigateToURL(new URLRequest("http://code.google.com/p/sweatless/"), "_blank");
	}
	
	private function goFullScreen(evt:ContextMenuEvent):void {
		scope.stage.displayState = StageDisplayState.FULL_SCREEN;
	}
	
	private function exitFullScreen(evt:ContextMenuEvent):void {
		scope.stage.displayState = StageDisplayState.NORMAL;
	}
	
	private function fullScreenToggle(evt:FullScreenEvent):void {
		if(evt.fullScreen){
			menu.customItems[0].enabled = false;
			menu.customItems[1].enabled = true;
		}else{
			menu.customItems[0].enabled = true;
			menu.customItems[1].enabled = false;
		}
		
	}
}