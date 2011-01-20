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

			addWrappers();
			
			config.setVar("CONFIG", p_config);
			
			for(var i:String in loaderInfo.parameters){
				config.setVar(i, loaderInfo.parameters[i]);
			}
			
			loadConfig();
		}
		
		private function loadConfig():void{
			loader = new BulkLoaderXMLPlugin(String(config.getVar("CONFIG")), "sweatless");
			loader.addEventListener(LazyBulkLoader.LAZY_COMPLETE, ready);
			loader.addEventListener(BulkProgressEvent.PROGRESS, progress);
			loader.addEventListener(BulkProgressEvent.COMPLETE, removeLoadListeners);
			loader.start();
		}
		
		private function addWrappers():void{
			_loadings = Loadings.instance;
			_config = Configuration.instance;
			_navigation = Navigation.instance;
			_tracking = Tracking.instance;
			_assets = Assets.instance;
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
		
		private function ready(evt:Event):void{
			loader.removeEventListener(LazyBulkLoader.LAZY_COMPLETE, ready);
			
			config.source = loader.source;
			
			addFonts();
			addLayers();
			addLoading();
			addFPS();
		}
		
		private function addLayers():void{
			layers = new Layers(this, "sweatless");
			
						
			layers.add("navigation");
			
			layers.add("loading");
			layers.get("loading").mouseChildren = false;
			
			for(var i:uint=0; i<config.layers.length(); i++) {
				layers.add(config.layers[i]["@id"]);
				config.layers[i]["@depth"] ? layers.get(config.layers[i]["@id"]).depth = config.layers[i]["@depth"] : null;
			};
			
			layers.add("tracking");
			layers.add("debug");
		}
		
		private function removeLoadListeners(evt:Event):void{
			loader.removeEventListener(LazyBulkLoader.LAZY_COMPLETE, ready);
			loader.removeEventListener(BulkProgressEvent.PROGRESS, progress);
			loader.removeEventListener(BulkProgressEvent.COMPLETE, removeLoadListeners);
			
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


import br.com.stimuli.loading.lazyloaders.LazyBulkLoader;
import br.com.stimuli.string.printf;

import flash.display.InteractiveObject;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import sweatless.utils.StringUtils;

internal class Signature extends EventDispatcher{
	
	private var menu : ContextMenu = new ContextMenu();
	private var scope : InteractiveObject;
	
	public function Signature(p_scope : InteractiveObject){
		scope = p_scope;
		
		menu.hideBuiltInItems();
		
		var label : ContextMenuItem = new ContextMenuItem("© Sweatless Framework", true);
		label.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, goto);
		menu.customItems.push(label);
		
		scope.contextMenu = menu;
	}
	
	private function goto(event:ContextMenuEvent):void {
		navigateToURL(new URLRequest("http://code.google.com/p/sweatless/"), "_blank");
	}
}

dynamic internal class BulkLoaderXMLPlugin extends LazyBulkLoader{
	
	namespace lazy_loader = "http://code.google.com/p/bulk-loader/"
		
		public var source : XML;
	
	function BulkLoaderXMLPlugin(url:*, name:String){
		super (url, name);
	}
	
	lazy_loader override function _lazyParseLoader(p_data:String):void{
		var substitutions : Object = new Object();
		
		for each (var variable:* in new XML(p_data)..globals.variable){
			substitutions[String(variable.@name)] = String(variable.@value);
		}
		
		source = new XML(printf(StringUtils.replace(StringUtils.replace(p_data, "{", "%("), "}", ")s"), substitutions));
		
		source..fixed.asset == undefined ? add(lazy_loader::_lazyTheURL, new Object()) : null;
		source..tracking.@file != undefined ? add(String(source..tracking.@file), {id:String("tracking")}) : null;
		
		for each (var asset:XML in source..fixed.asset) {
			add(String(asset.@url), {id:String(asset.@id), pausedAtStart:asset.@paused ? true : false});
		}
	}
}
