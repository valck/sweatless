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
 * http://www.sweatless.as/
 * 
 * @author Valério Oliveira (valck)
 * 
 */

package sweatless.navigation.core {

	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	import sweatless.events.Broadcaster;
	import sweatless.layout.Align;
	import sweatless.layout.Layers;
	import sweatless.navigation.primitives.Area;
	import sweatless.navigation.primitives.Loading;
	import sweatless.utils.StringUtils;

	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;

	import flash.display.DisplayObjectContainer;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.media.SoundLoaderContext;
	import flash.net.LocalConnection;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	
	internal final class Navigation{
		
		private static var _nav : Navigation;
		
		private static var loading : Loading;
		private static var queue : BulkLoader;
		private static var broadcaster : Broadcaster;
		
		private static var current : Area;
		private static var last : Area;
		
		public function Navigation(){
			if(_nav) throw new Error("Navigation already initialized.");
		}
		
		public static function get instance():Navigation{
			_nav = _nav || new Navigation();
			
			return _nav;
		}
		
		public function init():void{
			if(Sweatless.config.started) throw new Error("Navigation already initialized.");
			
			broadcaster = Broadcaster.getInstance();

			broadcaster.setEvent("change_menu");
			
			for(var i:uint=0; i<Sweatless.config.areas.length(); i++){
				var area : String = Sweatless.config.areas[i].@id;
				
				broadcaster.setEvent("show_" + area);
				broadcaster.setEvent("hide_" + area);
				
				broadcaster.addEventListener(broadcaster.getEvent("show_" + area), hide);
				broadcaster.addEventListener(broadcaster.getEvent("hide_" + area), unload);
			}

			Sweatless.config.tracking ? Sweatless.tracking.add() : null;
			
			if(ExternalInterface.available && XMLList(Sweatless.config.areas..@deeplink).length() > 0){
				 SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, onChange);
			}else if(Sweatless.config.firstArea){
				Sweatless.config.currentAreaID = Sweatless.config.firstArea;
				load(null);
			}
			
			Sweatless.config.started = true;
		}
		
		private function onLoadComplete(evt:Event):void{
			queue.removeEventListener(BulkLoader.ERROR, onError);
			queue.removeEventListener(BulkProgressEvent.PROGRESS, onProgress);
			queue.removeEventListener(BulkProgressEvent.COMPLETE, onLoadComplete);
			
			if(loading){
				loading.addEventListener(Loading.HIDDEN, loaded);
				loading.hide();
			}else{
				loaded(null);
			}
		}
		
		private function loaded(evt:Event):void{
			try{
				loading ? loading.removeEventListener(Loading.HIDDEN, loaded) : null;
				
				ExternalInterface.available && XMLList(Sweatless.config.areas..@deeplink).length() > 0 ? setDeeplink() : null;
				
				current = Area(queue.getContent(Sweatless.config.getInArea(Sweatless.config.currentAreaID, "@swf")));
				current.id = Sweatless.config.currentAreaID;
				
				DisplayObjectContainer(Layers.getInstance("sweatless").get("navigation")).addChild(current);
				
				current.addEventListener(Area.READY, show);
				current.create();
				
				align(current, Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@halign"), Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@valign"), Number(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@width")), Number(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@height")), Number(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@top")), Number(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@bottom")), Number(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@right")), Number(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@left")));
				
				last = current;
			}catch(e:Error){
				trace(e.getStackTrace());
			}
		}
		
		private function show(evt:Event):void{
			current.removeEventListener(Area.READY, show);
			current.show();
		}
		
		private function hide(evt:Event):void{
			loading && loading.stage ? DisplayObjectContainer(Layers.getInstance("sweatless").get("loading")).removeChild(loading) : null;
			queue && queue.isRunning ? queue.pauseAll() : null;
			
			setID(evt.type);
			Sweatless.config.firstArea == "" ? Sweatless.config.firstArea = Sweatless.config.currentAreaID : null;
			
			if(last) {
				last.addEventListener(Area.HIDDEN, load);
				last.hide();
			}else{
				load(null);
			}
		}
		
		private function load(evt:Event):void{
			loading && loading.stage ? DisplayObjectContainer(Layers.getInstance("sweatless").get("loading")).removeChild(loading) : null;
			
			if(last){
				last.removeEventListener(Area.HIDDEN, load);
				broadcaster.dispatchEvent(new Event(broadcaster.getEvent("hide_" + last.id)));
			}
			
			var cache : Boolean = StringUtils.toBoolean(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@cache"));
			var audioContext : SoundLoaderContext = new SoundLoaderContext(1000, Boolean(Sweatless.config.crossdomain));
			var imageContext : LoaderContext = new LoaderContext(Boolean(Sweatless.config.crossdomain), ApplicationDomain.currentDomain);
			
			var swf : String = Sweatless.config.getInArea(Sweatless.config.currentAreaID, "@swf");
			var assets : String = Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@assets");
			
			var videos : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "video");
			var audios : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "audio");
			var images : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "image");
			var swfs : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "swf");
			var others : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "other");
			
			queue = BulkLoader.getLoader(Sweatless.config.currentAreaID) || new BulkLoader(Sweatless.config.currentAreaID, 666);
			queue.maxConnectionsPerHost = 666;
			queue.resumeAll();
			
			if (queue.itemsTotal > 0 && queue.isFinished){
				loaded(null);
			}else{
				var id : *;
				for(id in videos) queue.add(videos[id], {id:id, pausedAtStart:true, preventCache:!cache});
				for(id in images) queue.add(images[id], {id:id, context:imageContext, preventCache:!cache});
				for(id in audios) queue.add(audios[id], {id:id, context:audioContext, preventCache:!cache});
				for(id in swfs) queue.add(swfs[id], {id:id, preventCache:!cache});
				for(id in others) queue.add(others[id], {id:id, preventCache:!cache});
				
				assets ? queue.add(assets, {id:"assets", preventCache:!cache}) : null;
				queue.add(swf, {id:"swf", priority:queue.highestPriority, preventCache:!cache});
				
				queue.addEventListener(BulkLoader.ERROR, onError);
				queue.addEventListener(BulkProgressEvent.PROGRESS, onProgress);
				queue.addEventListener(BulkProgressEvent.COMPLETE, onLoadComplete);
				
				loading = Sweatless.loadings.exists(Sweatless.config.currentAreaID) ? Sweatless.loadings.get(Sweatless.config.currentAreaID) : Sweatless.loadings.exists("default") ? Sweatless.loadings.get("default") : null; 
				loading && !loading.stage ? DisplayObjectContainer(Layers.getInstance("sweatless").get("loading")).addChild(loading) : null;
				loading ? loading.show() : null;
				
				queue.sortItemsByPriority();
				queue.start();
			}
		}

		private function unload(evt:Event):void{
			Align.remove(last, Number(Sweatless.config.getAreaAdditionals(last.id, "@width")), Number(Sweatless.config.getAreaAdditionals(last.id, "@height")), Number(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@top")), Number(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@bottom")), Number(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@right")), Number(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@left")));
			
			last.stage ? DisplayObjectContainer(Layers.getInstance("sweatless").get("navigation")).removeChild(last) : null;
			
			!StringUtils.toBoolean(Sweatless.config.getAreaAdditionals(last.id, "@cache")) ? removeLoadedItens() : last = null;
		}
		
		private function removeLoadedItens():void{
			queue.removeAll();
			
			try{
				new LocalConnection().connect("clear_gc");
				new LocalConnection().connect("clear_gc");
			} catch(e:Error){
				
			}
		}
		
		private function onError(evt:ErrorEvent) : void {
			throw new Error("BulkLoader error occured:\n"+evt);
		}
		
		private function onProgress(evt:BulkProgressEvent):void{
			loading ? loading.progress = evt.percentLoaded : null;
		}
		
		private function setDeeplink():void{
			SWFAddress.setTitle(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@title"));
			Sweatless.config.getAreaByDeeplink(SWFAddress.getPath()) != Sweatless.config.currentAreaID ? SWFAddress.setValue(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@deeplink")) : null;
			
			SWFAddress.getHistory() ? null : SWFAddress.setHistory(true);
		}
		
		private function onChange(evt:SWFAddressEvent):void{
			Sweatless.config.currentAreaID = Sweatless.config.getAreaByDeeplink(SWFAddress.getPath());
			if(Sweatless.config.currentAreaID == "") return;
			
			broadcaster.dispatchEvent(new Event(broadcaster.getEvent("show_"+Sweatless.config.currentAreaID)));
			broadcaster.dispatchEvent(new Event(broadcaster.getEvent("change_menu")));
		}
		
		private function setID(p_value:String):void{
			Sweatless.config.currentAreaID = p_value.slice(5);
		}
		
		private function align(p_area:Area, p_hanchor:String, p_vanchor:String, p_width:Number=0, p_height:Number=0, p_top:Number=0, p_bottom:Number=0, p_right:Number=0, p_left:Number=0):void{
			p_hanchor = !p_hanchor ? "NONE" : p_hanchor.toUpperCase();
			p_vanchor = !p_vanchor ? "NONE" : p_vanchor.toUpperCase();
			
			p_top = !p_top ? 0 : p_top;
			p_bottom = !p_bottom ? 0 : p_bottom;
			p_right = !p_right ? 0 : p_right;
			p_left = !p_left ? 0 : p_left;
			
			Align.add(p_area, Align[p_hanchor] + Align[p_vanchor], {width:p_width, height:p_height, margin_bottom:p_bottom, margin_top:p_top, margin_left:p_left, margin_right:p_right});
		}
	}
}
