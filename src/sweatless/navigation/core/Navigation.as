package sweatless.navigation.core{
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.media.SoundLoaderContext;
	import flash.net.LocalConnection;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.Dictionary;
	
	import sweatless.events.Broadcaster;
	import sweatless.layout.Align;
	import sweatless.layout.Layers;
	import sweatless.navigation.basics.BasicArea;
	import sweatless.utils.StringUtils;
	
	public final class Navigation{
		
		private static var loader : BulkLoader;
		private static var broadcaster : Broadcaster;
		
		private static var current : BasicArea;
		private static var last : BasicArea;
		
		public static function init():void{
			if(Config.started) throw new Error("Navigation already initialized.");
			
			broadcaster = Broadcaster.getInstance();
			
			Layers.add("navigation");

			for(var i:uint=0; i<Config.areas.length(); i++){
				var area : String = Config.areas[i].@id;
				
				broadcaster.setEvent("show_" + area);
				broadcaster.setEvent("hide_" + area);
				
				broadcaster.addEventListener(broadcaster.getEvent("show_" + area), hide);
				broadcaster.addEventListener(broadcaster.getEvent("hide_" + area), unload);
			}

			if(ExternalInterface.available && Config.areas..@deeplink.length() > 0){
				SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, change);
			}else{
				if(Config.firstArea){
					Config.currentAreaID = Config.firstArea;
					load(null);
				}
			}

			Config.started = true;
		}

		private static function loaded(evt:Event):void{
			loader.removeEventListener(BulkProgressEvent.PROGRESS, progress);
			loader.removeEventListener(BulkProgressEvent.COMPLETE, loaded);
			
			//Config.getLoading(Config.currentAreaID) ? Config.getLoading(Config.currentAreaID).hide() : null;
			
			ExternalInterface.available && Config.areas..@deeplink.length() > 0 ? setDeeplink() : null;
			
			current = BasicArea(loader.getContent(Config.getInArea(Config.currentAreaID, "@swf")));
			current.id = Config.currentAreaID;
			
			Layers.swapDepth("navigation", Layers.depth("navigation"));
			Layers.get("navigation").addChild(current);
			
			current.addEventListener(BasicArea.READY, show);
			current.create();
			
			align(current, Config.getAreaAdditionals(Config.currentAreaID, "@halign"), Config.getAreaAdditionals(Config.currentAreaID, "@valign"), Number(Config.getAreaAdditionals(Config.currentAreaID, "@width")), Number(Config.getAreaAdditionals(Config.currentAreaID, "@height")));
			
			last = current;
		}
		
		private static function show(evt:Event):void{
			current.removeEventListener(BasicArea.READY, show);
			current.show();
		}
		
		private static function hide(evt:Event):void{
			setID(evt.type);
			
			if(last && last.id == Config.currentAreaID) return;
			
			if(last) {
				last.addEventListener(BasicArea.CLOSED, load);
				last.hide();
			}else{
				load(null);
			}
		}

		private static function load(evt:Event):void{
			if(last){
				last.removeEventListener(BasicArea.CLOSED, load);
				broadcaster.dispatchEvent(new Event(broadcaster.getEvent("hide_" + last.id)));
			}
			
			Config.crossdomain ? Security.loadPolicyFile(Config.crossdomain) : null;
			
			var audioContext : SoundLoaderContext = new SoundLoaderContext(1000, Boolean(Config.crossdomain));
			var imageContext : LoaderContext = new LoaderContext(Boolean(Config.crossdomain), ApplicationDomain.currentDomain);
			
			var swf : String = Config.getInArea(Config.currentAreaID, "@swf");
			var assets : String = Config.getAreaAdditionals(Config.currentAreaID, "@assets");
			
			var videos : Dictionary = Config.getAreaDependencies(Config.currentAreaID, "video");
			var audios : Dictionary = Config.getAreaDependencies(Config.currentAreaID, "audio");
			var images : Dictionary = Config.getAreaDependencies(Config.currentAreaID, "image");
			var others : Dictionary = Config.getAreaDependencies(Config.currentAreaID, "other");
			
			loader = BulkLoader.getLoader(Config.currentAreaID) || new BulkLoader(Config.currentAreaID);
			
			if (loader.hasItem(swf, true)){
				loaded(null);
			}else{
				var id : *;
				for(id in videos) loader.add(videos[id], {id:id, pausedAtStart:true});
				for(id in images) loader.add(images[id], {id:id, context:imageContext});
				for(id in audios) loader.add(audios[id], {id:id, context:audioContext});
				for(id in others) loader.add(others[id], {id:id});
				
				assets ? loader.add(assets, {id:"assets"}) : null;
				loader.add(swf, {id:"swf", priority:loader.itemsTotal});

				loader.addEventListener(BulkProgressEvent.PROGRESS, progress);
				loader.addEventListener(BulkProgressEvent.COMPLETE, loaded);

				loader.sortItemsByPriority();
				loader.start();
				
				if(Config.getLoading(Config.currentAreaID)){
					//Config.getLoading(Config.currentAreaID).create(null);
					//Config.getLoading(Config.currentAreaID).show();
				}
			}
		}
		
		private static function unload(evt:Event):void{
			Align.remove(last, Number(Config.getAreaAdditionals(last.id, "@width")), Number(Config.getAreaAdditionals(last.id, "@height")));
			
			last.destroy();

			StringUtils.toBoolean(Config.getAreaAdditionals(last.id, "@cache")) ? null : removeLoadedItens();
		}
		
		private static function removeLoadedItens():void{
			loader.removeAll();
			
			try{
				new LocalConnection().connect("clear_gc");
				new LocalConnection().connect("clear_gc");
			} catch(e:Error){

			}
		}

		public static function progress(evt:BulkProgressEvent):void{
			Layers.swapDepth("loading", "top");
			Config.getLoading(Config.currentAreaID) ? Config.getLoading(Config.currentAreaID).progress = evt.percentLoaded : null;
		}
		
		
		private static function setDeeplink():void{
			SWFAddress.setTitle(Config.getAreaAdditionals(Config.currentAreaID, "@title"));
			SWFAddress.setValue(Config.getAreaAdditionals(Config.currentAreaID, "@deeplink"));
			
			SWFAddress.getHistory() ? null : SWFAddress.setHistory(true);
		}

		private static function change(evt:SWFAddressEvent):void{
			Config.currentAreaID = Config.getAreaByDeeplink(SWFAddress.getValue());
			broadcaster.dispatchEvent(new Event(broadcaster.getEvent("show_"+Config.currentAreaID)));
		}
		
		private static function setID(p_value:String):void{
			Config.currentAreaID = p_value.slice(5);
		}
		
		private static function align(p_area:BasicArea, p_hanchor:String, p_vanchor:String, p_width:Number=0, p_height:Number=0):void{
			p_hanchor = !p_hanchor ? "NONE" : p_hanchor.toUpperCase();
			p_vanchor = !p_vanchor ? "NONE" : p_vanchor.toUpperCase();
			
			p_width = (p_width==0 || !p_width) ? undefined : p_width;
			p_height = (p_height==0 || !p_height) ? undefined : p_height;

			Align.add(p_area, Align[p_hanchor] + Align[p_vanchor], {width:p_width, height:p_height});
		}
	}
}
