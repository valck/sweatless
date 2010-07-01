package navigation{
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.lazyloaders.LazyBulkLoader;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import navigation.core.Config;
	import navigation.core.Layers;
	import navigation.core.Navigation;
	
	import sweatless.utils.Signature;
	import sweatless.extras.bulkloader.BulkLoaderXMLPlugin;

	public class Sweatless extends Sprite{

		private var loader : BulkLoaderXMLPlugin;
		
		public function Sweatless(){
			stage.addEventListener(Event.RESIZE, resize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.stageFocusRect = false;

			var sig : Signature = new Signature(this);
			
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
		}
		
		private function addLayers():void{
			Layers.init(this);
			
			for(var i:uint=0; i<Config.layers.length(); i++) {
				Layers.add(Config.layers[i]["@id"]);
				Config.layers[i]["@depth"] ? Layers.swapDepth(Config.layers[i]["@id"], Config.layers[i]["@depth"]) : null;
			};
			
			Layers.add("navigation");
			Layers.add("loading");
			Layers.add("debug");
		}
		
		private function progress(evt:BulkProgressEvent):void{
			//trace("progress:", evt.percentLoaded);
		}
		
		private function removeLoadListeners(evt:Event):void{
			loader.removeEventListener(LazyBulkLoader.LAZY_COMPLETE, ready);
			loader.removeEventListener(BulkProgressEvent.PROGRESS, progress);
			loader.removeEventListener(BulkProgressEvent.COMPLETE, removeLoadListeners);
			
			Navigation.init();
			
			build();
		}
		
		protected function build():void{
			throw new Error("Please, override this method.");
		}
	}
}