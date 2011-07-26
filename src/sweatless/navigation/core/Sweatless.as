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

	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.lazyloaders.LazyBulkLoader;

	import sweatless.debug.FPS;
	import sweatless.events.Broadcaster;
	import sweatless.events.CustomEvent;
	import sweatless.layout.Layers;
	import sweatless.utils.StringUtils;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class Sweatless extends Sprite{
		
		private var queue : BulkLoaderXMLPlugin;
		
		private static var _broadcaster : Broadcaster;
		private static var _config : Configuration;
		private static var _assets : Assets;
		private static var _loader : FileLoader;
		private static var _tracking : Tracking;
		private static var _loadings : Loadings;
		private static var _navigation : Navigation;
		private static var _layers : Layers;
		
		public static const READY : String = "ready";
		public static const SHOWED: String = "showed";
		
		public function Sweatless(p_config:String=null){
			new Signature(this);
			
			stage.addEventListener(Event.RESIZE, resize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.stageFocusRect = false;

			_broadcaster = Broadcaster.getInstance();
			_layers = new Layers(this, "sweatless");
			
			_loadings = Loadings.instance;
			_config = Configuration.instance;
			_navigation = Navigation.instance;
			_tracking = Tracking.instance;
			_assets = Assets.instance;
			_loader = FileLoader.instance;
			
			_layers.add("navigation");
			_layers.add("loading");
			_layers.add("debug");
			
			addFonts();
			addLoading();
			
			config.setVar("CONFIG", p_config);
			
			for(var i:String in loaderInfo.parameters){
				config.setVar(i, loaderInfo.parameters[i]);
			}
			
			loadConfig();
		}
		
		public static function get config():Configuration{
			return _config;
		}
		
		public static function get loadings():Loadings{
			return _loadings;
		}
		
		public static function get assets():Assets{
			return _assets;
		}
		
		public static function get loader():FileLoader{
			return _loader;
		}
		
		public static function get tracking():Tracking{
			return _tracking;
		}
		
		public static function get layers() : Layers {
			return _layers;
		}
		
		public static function get broadcaster() : Broadcaster {
			return _broadcaster;
		}

		public static function navigateTo(p_areaID:String):void{
			_broadcaster.hasEvent("show_"+p_areaID) ? _broadcaster.dispatchEvent(new Event(_broadcaster.getEvent("show_"+p_areaID))) : null;
			_broadcaster.hasEvent("show_"+p_areaID) ? _broadcaster.dispatchEvent(new CustomEvent(_broadcaster.getEvent("change_menu"), p_areaID)) : null;
		}
		
		private function loadConfig():void{
			config.debug = StringUtils.toBoolean(String(config.getVar("DEBUG")));
			
			queue = new BulkLoaderXMLPlugin(String(config.getVar("CONFIG")), "sweatless");
			
			queue.addEventListener(LazyBulkLoader.LAZY_COMPLETE, configLoaded);
			queue.addEventListener(BulkLoaderXMLPlugin.PROGRESS, progress);
			queue.addEventListener(BulkLoaderXMLPlugin.FINISHED, removeLoadListeners);
			queue.start();
		}
		
		private function configLoaded(evt:Event):void{
			queue.removeEventListener(LazyBulkLoader.LAZY_COMPLETE, configLoaded);
			
			addExternalLayers();
		}
		
		private function addExternalLayers():void{
			for(var i:uint=0; i<config.layers.length(); i++) {
				_layers.add(config.layers[i]["@id"]);
				config.layers[i]["@depth"] ? _layers.swapDepth(config.layers[i]["@id"], config.layers[i]["@depth"]) : null;
			};
		}
		
		private function removeLoadListeners(evt:Event):void{
			queue.removeEventListener(BulkLoaderXMLPlugin.PROGRESS, progress);
			queue.removeEventListener(BulkLoaderXMLPlugin.FINISHED, removeLoadListeners);
			
			_navigation.addConfig();
			
			addEventListener(READY, show);
			addEventListener(SHOWED, startNavigation);
			
			create();
		}
		
		private function startNavigation(evt:Event):void{
			removeEventListener(SHOWED, startNavigation);
			
			_navigation.start();
		}
		
		public function addFPS():void{
			DisplayObjectContainer(_layers.get("debug")).addChild(new FPS());
		}
		
		public function resize(evt:Event=null):void{
			scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		}
		/*
		 * 
		 * @depracated
		 * 
		 */
		public function build():void{
		}
		
		public function create(evt:Event=null):void{
			dispatchEvent(new Event(READY));
		}

		public function show(evt:Event=null):void{
			removeEventListener(READY, show);
			
			dispatchEvent(new Event(SHOWED));
		}
		
		public function addFonts():void{
			throw new Error("Please, override this method.");
		}
		
		public function addLoading():void{
			throw new Error("Please, override this method.");			
		}
		
		public function progress(evt:BulkProgressEvent):void{
			throw new Error("Please, override this method.");
		}
	}
}

import br.com.stimuli.loading.BulkLoader;
import br.com.stimuli.loading.BulkProgressEvent;
import br.com.stimuli.loading.lazyloaders.LazyBulkLoader;
import br.com.stimuli.loading.loadingtypes.LoadingItem;
import br.com.stimuli.string.printf;

import sweatless.layout.Layers;
import sweatless.navigation.core.Sweatless;
import sweatless.navigation.primitives.Loading;
import sweatless.utils.ArrayUtils;
import sweatless.utils.StringUtils;

import com.asual.swfaddress.SWFAddress;
import com.asual.swfaddress.SWFAddressEvent;

import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.ContextMenuEvent;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.external.ExternalInterface;
import flash.media.SoundLoaderContext;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.Security;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import flash.utils.Dictionary;

internal class Signature extends EventDispatcher{
	
	private var menu : ContextMenu = new ContextMenu();
	
	public function Signature(p_scope : InteractiveObject){
		menu.hideBuiltInItems();
		
		var label : ContextMenuItem = new ContextMenuItem("Build with Sweatless Framework", true);
		label.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, goto);
		menu.customItems.push(label);
		
		p_scope.contextMenu = menu;
	}
	
	private function goto(evt:ContextMenuEvent):void {
		navigateToURL(new URLRequest("http://www.sweatless.as"), "_blank");
	}
}

dynamic internal class BulkLoaderXMLPlugin extends LazyBulkLoader{
	
	public static const PROGRESS : String = "progress";
	public static const FINISHED : String = "finished";
	
	namespace lazy_loader = "http://code.google.com/p/bulk-loader/";
		
	private var count : uint;
	private var source : XML;
	private var queue : BulkLoader;
	private var loading : Loading;
	
	public function BulkLoaderXMLPlugin(url:*, name:String){
		count = 0;
		super (url, name, 666);
	}
	
	public override function _lazyParseLoader(p_data:String):void{
		var substitutions : Object = new Object();
		
		for each (var variable:* in new XML(p_data)..variables.variable){
			substitutions[String(variable.@name)] = String(variable.@value);
		}
		
		source = new XML(printf(StringUtils.replace(StringUtils.replace(p_data, "{", "%("), "}", ")s"), substitutions));
		
		source..files.file == undefined ? add(_lazyTheURL, new Object()) : null;
		source..tracking.@file != undefined ? add(String(source..tracking.@file), {id:String("tracking")}) : null;
		source..crossdomain.@file != undefined ? Security.loadPolicyFile(source..crossdomain.@file) : null;

		Sweatless.config.source = source;
		
		maxConnectionsPerHost = 666;
		for each (var asset:XML in source..files.file) {
			add(String(asset.@url), {id:String(asset.@id), pausedAtStart:asset.@paused ? true : false});
		}
		
		loading = Sweatless.loadings.exists(Sweatless.config.currentAreaID) ? Sweatless.loadings.get(Sweatless.config.currentAreaID) : Sweatless.loadings.exists("default") ? Sweatless.loadings.get("default") : null; 
		loading && !loading.stage ? DisplayObjectContainer(Layers.getInstance("sweatless").get("loading")).addChild(loading) : null;
		loading ? loading.show() : null;
		
		if(ExternalInterface.available && XMLList(Sweatless.config.areas..@deeplink).length() > 0 && Sweatless.config.getAreaByDeeplink(SWFAddress.getPath()) != ""){
			SWFAddress.addEventListener(SWFAddressEvent.INIT, ready);
		}else if(Sweatless.config.firstArea){
			ready();
		}else{
			prepared();
		}

		addEventListener(BulkProgressEvent.COMPLETE, removeProgress);
	}
	
	private function ready(evt:Event=null):void{
		evt ? SWFAddress.removeEventListener(SWFAddressEvent.INIT, ready) : null;
		
		Sweatless.config.currentAreaID = evt ? Sweatless.config.getAreaByDeeplink(SWFAddress.getPath()) : Sweatless.config.firstArea;
		
		queue = new BulkLoader(Sweatless.config.currentAreaID, 666);
		queue.maxConnectionsPerHost = 666;
		
		var cache : Boolean = StringUtils.toBoolean(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@cache"));
		var audioContext : SoundLoaderContext = new SoundLoaderContext(1000, Boolean(Sweatless.config.crossdomain));
		var imageContext : LoaderContext = new LoaderContext(Boolean(Sweatless.config.crossdomain), ApplicationDomain.currentDomain);
		
		var swf : String = Sweatless.config.getInArea(Sweatless.config.currentAreaID, "@swf");
		var assets : String = Sweatless.config.getInArea(Sweatless.config.currentAreaID, "@assets");
		
		var videos : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "video");
		var audios : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "audio");
		var images : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "image");
		var swfs : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "swf");		
		var others : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "other");
		
		queue.addEventListener(BulkLoader.ERROR, onError);
		queue.addEventListener(BulkProgressEvent.PROGRESS, _onProgress);
		queue.addEventListener(BulkProgressEvent.COMPLETE, removeProgress);
		
		var id : *;
		for(id in videos) queue.add(videos[id], {id:id, pausedAtStart:true, preventCache:!cache});
		for(id in images) queue.add(images[id], {id:id, context:imageContext, preventCache:!cache});
		for(id in audios) queue.add(audios[id], {id:id, context:audioContext, preventCache:!cache});
		for(id in swfs) queue.add(swfs[id], {id:id, preventCache:!cache});		
		for(id in others) queue.add(others[id], {id:id, preventCache:!cache});
		
		assets ? queue.add(assets, {id:"assets", preventCache:!cache}) : null;
		queue.add(swf, {id:"swf", priority:highestPriority, preventCache:!cache});
		
		queue.start();
		prepared();
	}
	
	private function onError(evt:ErrorEvent) : void {
		throw new Error("BulkLoader error occured:\n"+evt);
	}
	
	private function _onComplete(evt:Event):void{
		loading ? loading.removeEventListener(Loading.HIDDEN, _onComplete) : null;
		
		var complete : BulkProgressEvent = new BulkProgressEvent(FINISHED);
		complete.setInfo(_bytesLoaded, _bytesTotal, _bytesTotalCurrent, _itemsLoaded, _itemsTotal, _weightPercent);
		
		if(queue.isFinished && isFinished){
			
			queue.removeEventListener(BulkLoader.ERROR, onError);
			queue.removeEventListener(BulkProgressEvent.COMPLETE, removeProgress);
			queue.removeEventListener(BulkProgressEvent.PROGRESS, _onProgress);
			
			removeEventListener(BulkLoader.ERROR, onError);
			removeEventListener(BulkProgressEvent.COMPLETE, removeProgress);
			removeEventListener(BulkProgressEvent.PROGRESS, _onProgress);
			
			dispatchEvent(complete);
		}
	}
	
	private function removeProgress(evt:Event):void{
		
		if(loading){
			loading.addEventListener(Loading.HIDDEN, _onComplete);
			loading.hide();
		}else{
			_onComplete(null);
		}
	}
	
	override public function get items():Array{
		return queue ? ArrayUtils.merge(_items, queue.items) : _items;
	}
	
	override public function _onProgress(evt : Event=null):void{
		var itemsStarted : int = 0;
		
		var localWeightLoaded : Number = 0;
		var localWeightTotal : int = 0;
		var localWeightPercent : Number = 0;
		
		var localItemsLoaded : int = 0;
		var localItemsTotal : int = 0;
		
		var localBytesLoaded : int = 0;
		var localBytesTotal : int = 0;
		var localBytesTotalCurrent : int = 0;

		for each (var key : * in items){
			var item : LoadingItem = get(key);
			
			if(!item || item.bytesTotal == -1 || item.bytesTotal == 0) continue;
			
			localItemsTotal++;
			localWeightTotal += item.weight;
			
			if (item.status == LoadingItem.STATUS_STARTED || item.status == LoadingItem.STATUS_FINISHED || item.status == LoadingItem.STATUS_STOPPED){
				localBytesLoaded += item._bytesLoaded;
				localBytesTotalCurrent += item._bytesTotal;
				
				item._bytesTotal > 0 ? localWeightLoaded += (item._bytesLoaded / item._bytesTotal) * item.weight : null;
				item.status == LoadingItem.STATUS_FINISHED ? localItemsLoaded++ : null;
				
				itemsStarted ++;
			}
		}

		itemsStarted != localItemsTotal ? localBytesTotal = Number.POSITIVE_INFINITY : localBytesTotal = localBytesTotalCurrent;
		localWeightPercent = localWeightLoaded / localWeightTotal;
		
		var progress : BulkProgressEvent = new BulkProgressEvent(PROGRESS);
		progress.setInfo(localBytesLoaded, localBytesTotal, localBytesTotalCurrent, localItemsLoaded, localItemsTotal, localWeightPercent);
		
		_itemsLoaded = progress.itemsLoaded;
		_itemsTotal = progress.itemsTotal;
		
		_bytesLoaded = progress.bytesLoaded;
		_bytesTotal = progress.bytesTotal;
		_bytesTotalCurrent = progress.bytesTotalCurrent;
		
		_weightPercent = progress.weightPercent;
		_percentLoaded = progress.percentLoaded;
		
		_loadedRatio = progress.ratioLoaded;
		
		dispatchEvent(progress);
	}
}
