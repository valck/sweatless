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

package sweatless.navigation.core{
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.lazyloaders.LazyBulkLoader;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import sweatless.debug.FPS;
	import sweatless.layout.Layers;
	
	public class Sweatless extends Sprite{
		
		private var loader : BulkLoaderXMLPlugin;
		private var layers : Layers;
		
		private static var _config : Configuration;
		private static var _assets : Assets;
		private static var _tracking : Tracking;
		private static var _loadings : Loadings;
		private static var _navigation : Navigation;
		
		public function Sweatless(p_config:String=null){
			var signature : Signature = new Signature(this);
			
			stage.addEventListener(Event.RESIZE, resize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.stageFocusRect = false;

			layers = new Layers(this, "sweatless");
			
			_loadings = Loadings.instance;
			_config = Configuration.instance;
			_navigation = Navigation.instance;
			_tracking = Tracking.instance;
			_assets = Assets.instance;
			
			layers.add("navigation");
			layers.add("loading");
			layers.add("debug");
			
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
		
		public static function get tracking():Tracking{
			return _tracking;
		}
		
		private function loadConfig():void{
			loader = new BulkLoaderXMLPlugin(String(config.getVar("CONFIG")), "sweatless");
			
			loader.addEventListener(LazyBulkLoader.LAZY_COMPLETE, ready);
			loader.addEventListener(BulkLoaderXMLPlugin.PROGRESS, progress);
			loader.addEventListener(BulkLoaderXMLPlugin.FINISHED, removeLoadListeners);
			loader.start();
		}
		
		private function ready(evt:Event):void{
			loader.removeEventListener(LazyBulkLoader.LAZY_COMPLETE, ready);
			
			addExternalLayers();
		}
		
		private function addExternalLayers():void{
			for(var i:uint=0; i<config.layers.length(); i++) {
				layers.add(config.layers[i]["@id"]);
				config.layers[i]["@depth"] ? layers.get(config.layers[i]["@id"]).depth = config.layers[i]["@depth"] : null;
			};
		}
		
		private function removeLoadListeners(evt:Event):void{
			loader.removeEventListener(BulkLoaderXMLPlugin.PROGRESS, progress);
			loader.removeEventListener(BulkLoaderXMLPlugin.FINISHED, removeLoadListeners);
			
			_navigation.init();
			
			build();
		}
		
		public function addFPS():void{
			layers.get("debug").addChild(new FPS());
		}
		
		public function resize(evt:Event):void{
			scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
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
		
		public function build():void{
			throw new Error("Please, override this method.");			
		}
	}
}

import br.com.stimuli.loading.BulkLoader;
import br.com.stimuli.loading.BulkProgressEvent;
import br.com.stimuli.loading.lazyloaders.LazyBulkLoader;
import br.com.stimuli.loading.loadingtypes.LoadingItem;
import br.com.stimuli.string.printf;

import com.asual.swfaddress.SWFAddress;
import com.asual.swfaddress.SWFAddressEvent;

import flash.display.InteractiveObject;
import flash.events.ContextMenuEvent;
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

import sweatless.layout.Layers;
import sweatless.navigation.core.Sweatless;
import sweatless.navigation.primitives.Loading;
import sweatless.utils.ArrayUtils;
import sweatless.utils.StringUtils;

internal class Signature extends EventDispatcher{
	
	private var menu : ContextMenu = new ContextMenu();
	
	public function Signature(p_scope : InteractiveObject){
		menu.hideBuiltInItems();
		
		var label : ContextMenuItem = new ContextMenuItem("© Sweatless Framework", true);
		label.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, goto);
		menu.customItems.push(label);
		
		p_scope.contextMenu = menu;
	}
	
	private function goto(evt:ContextMenuEvent):void {
		navigateToURL(new URLRequest("http://code.google.com/p/sweatless/"), "_blank");
	}
}

dynamic internal class BulkLoaderXMLPlugin extends LazyBulkLoader{
	
	public static const PROGRESS : String = "progress";
	public static const FINISHED : String = "finished";
	
	namespace lazy_loader = "http://code.google.com/p/bulk-loader/"
		
	private var source : XML;
	private var loader : BulkLoader;
	private var loading : Loading;
	private var progressEvent : BulkProgressEvent;
	private var completeEvent : BulkProgressEvent;
	
	public function BulkLoaderXMLPlugin(url:*, name:String){
		super (url, name, 666);
	}
	
	lazy_loader override function _lazyParseLoader(p_data:String):void{
		var substitutions : Object = new Object();
		
		for each (var variable:* in new XML(p_data)..globals.variable){
			substitutions[String(variable.@name)] = String(variable.@value);
		}
		
		source = new XML(printf(StringUtils.replace(StringUtils.replace(p_data, "{", "%("), "}", ")s"), substitutions));
		
		source..fixed.asset == undefined ? add(lazy_loader::_lazyTheURL, new Object()) : null;
		source..tracking.@file != undefined ? add(String(source..tracking.@file), {id:String("tracking")}) : null;
		source..crossdomain.@file != undefined ? Security.loadPolicyFile(source..crossdomain.@file) : null;

		Sweatless.config.source = source;
		
		maxConnectionsPerHost = 666;
		for each (var asset:XML in source..fixed.asset) {
			add(String(asset.@url), {id:String(asset.@id), pausedAtStart:asset.@paused ? true : false});
		}
		
		loading = Sweatless.loadings.exists(Sweatless.config.currentAreaID) ? Sweatless.loadings.get(Sweatless.config.currentAreaID) : Sweatless.loadings.exists("default") ? Sweatless.loadings.get("default") : null; 
		loading && !loading.stage ? Layers.getInstance("sweatless").get("loading").addChild(loading) : null;
		loading ? loading.show() : null;

		if(ExternalInterface.available && Sweatless.config.areas..@deeplink.length() > 0){
			SWFAddress.addEventListener(SWFAddressEvent.INIT, ready);
		}else if(Sweatless.config.firstArea){
			ready();
		}else{
			prepared();
		}
	
	}
	
	private function ready(evt:Event=null):void{
		evt ? SWFAddress.removeEventListener(SWFAddressEvent.INIT, ready) : null;
		
		Sweatless.config.currentAreaID = evt ? Sweatless.config.getAreaByDeeplink(SWFAddress.getPath()) : Sweatless.config.firstArea;
		
		loader = new BulkLoader(Sweatless.config.currentAreaID, 666);
		loader.maxConnectionsPerHost = 666;
		
		var cache : Boolean = StringUtils.toBoolean(Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@cache"));
		var audioContext : SoundLoaderContext = new SoundLoaderContext(1000, Boolean(Sweatless.config.crossdomain));
		var imageContext : LoaderContext = new LoaderContext(Boolean(Sweatless.config.crossdomain), ApplicationDomain.currentDomain);
		
		var swf : String = Sweatless.config.getInArea(Sweatless.config.currentAreaID, "@swf");
		var assets : String = Sweatless.config.getAreaAdditionals(Sweatless.config.currentAreaID, "@assets");
		
		var videos : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "video");
		var audios : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "audio");
		var images : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "image");
		var others : Dictionary = Sweatless.config.getAreaDependencies(Sweatless.config.currentAreaID, "other");
		
		var id : *;
		for(id in videos) loader.add(videos[id], {id:id, pausedAtStart:true, preventCache:!cache});
		for(id in images) loader.add(images[id], {id:id, context:imageContext, preventCache:!cache});
		for(id in audios) loader.add(audios[id], {id:id, context:audioContext, preventCache:!cache});
		for(id in others) loader.add(others[id], {id:id, preventCache:!cache});
		
		assets ? loader.add(assets, {id:"assets", preventCache:!cache}) : null;
		loader.add(swf, {id:"swf", priority:highestPriority, preventCache:!cache});
		
		loader.addEventListener(BulkProgressEvent.PROGRESS, _onProgress);
		loader.addEventListener(BulkProgressEvent.COMPLETE, removeProgress);
		
		prepared();
		loader.start();
	}
	
	private function onComplete(evt:Event):void{
		loading ? loading.removeEventListener(Loading.HIDDEN, onComplete) : null;
		dispatchEvent(completeEvent);
	}
	
	private function removeProgress(evt:Event):void{
		loader.removeEventListener(BulkProgressEvent.COMPLETE, removeProgress);
		loader.removeEventListener(BulkProgressEvent.PROGRESS, _onProgress);
	}
	
	override public function get items():Array{
		return loader ? ArrayUtils.merge(_items, loader.items) : _items;
	}
	
	override public function _onProgress(evt : Event=null):void{
		_bytesLoaded = 0;
		_bytesTotal = 0; 
		_bytesTotalCurrent = 0;
		
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
			
			localItemsTotal ++;
			localWeightTotal += item.weight;
			
			if (item.status == LoadingItem.STATUS_STARTED || item.status == LoadingItem.STATUS_FINISHED || item.status == LoadingItem.STATUS_STOPPED){
				localBytesLoaded += item._bytesLoaded;
				localBytesTotalCurrent += item._bytesTotal;
				
				item._bytesTotal > 0 ? localWeightLoaded += (item._bytesLoaded / item._bytesTotal) * item.weight : null;
				item.status == LoadingItem.STATUS_FINISHED ? localItemsLoaded ++ : null;
				
				itemsStarted ++;
			}
		}

		itemsStarted != localItemsTotal ? localBytesTotal = Number.POSITIVE_INFINITY : localBytesTotal = localBytesTotalCurrent;
		localWeightPercent = localWeightLoaded / localWeightTotal;
		
		progressEvent = new BulkProgressEvent(PROGRESS);
		progressEvent.setInfo(localBytesLoaded, localBytesTotal, localBytesTotal, localItemsLoaded, localItemsTotal, localWeightPercent);
		
		completeEvent = new BulkProgressEvent(FINISHED);
		completeEvent.setInfo(localBytesLoaded, localBytesTotal, localBytesTotal, localItemsLoaded, localItemsTotal, localWeightPercent);
		
		_itemsLoaded = localItemsLoaded;
		_bytesLoaded = progressEvent.bytesLoaded;
		_bytesTotal = progressEvent.bytesTotal;
		_weightPercent = progressEvent.weightPercent;
		_percentLoaded = progressEvent.percentLoaded;
		_bytesTotalCurrent = progressEvent.bytesTotalCurrent;
		_loadedRatio = progressEvent.ratioLoaded;
		
		if (itemsStarted != 0 && localItemsLoaded == items.length){
			if(loading){
				loading.addEventListener(Loading.HIDDEN, onComplete);
				loading.hide();
			}else{
				onComplete(null);
			}
		}else{
			dispatchEvent(progressEvent);
		}
	}
}
