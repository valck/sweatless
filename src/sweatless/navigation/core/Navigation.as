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
	import sweatless.navigation.primitives.Area;
	import sweatless.navigation.primitives.Loading;
	import sweatless.navigation.primitives.SubArea;
	import sweatless.utils.StringUtils;
	
	public final class Navigation{
		
		private static var loading : Loading;
		private static var loader : BulkLoader;
		private static var broadcaster : Broadcaster;
		
		private static var current : Area;
		private static var last : Area;
		
		public static function init():void{
			if(Config.started) throw new Error("Navigation already initialized.");
			
			broadcaster = Broadcaster.getInstance();

			broadcaster.setEvent("change_menu");
			
			for(var i:uint=0; i<Config.areas.length(); i++){
				var area : String = Config.areas[i].@id;
				
				broadcaster.setEvent("show_" + area);
				broadcaster.setEvent("hide_" + area);
				
				broadcaster.addEventListener(broadcaster.getEvent("show_" + area), hide);
				broadcaster.addEventListener(broadcaster.getEvent("hide_" + area), unload);
			}
			
			if(ExternalInterface.available && Config.areas..@deeplink.length() > 0){
				SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, onChange);
				SWFAddress.setHistory(false);
			}else{
				if(Config.firstArea){
					Config.currentAreaID = Config.firstArea;
					load(null);
				}
			}
			
			Config.tracking ? Config.addAnalytics(Layers.getInstance("sweatless").get("debug")) : null;
			
			Config.started = true;
		}
		
		private static function onLoadComplete(evt:Event):void{
			loader.removeEventListener(BulkProgressEvent.PROGRESS, onProgress);
			loader.removeEventListener(BulkProgressEvent.COMPLETE, onLoadComplete);
			
			if(loading){
				loading.addEventListener(Loading.COMPLETE, loaded);
				loading.hide();
			}else{
				loaded(null);
			}
		}
		
		private static function loaded(evt:Event):void{
			try{
				loading ? loading.removeEventListener(Loading.COMPLETE, loaded) : null;
				
				ExternalInterface.available && Config.areas..@deeplink.length() > 0 ? setDeeplink() : null;
				
				current = Area(loader.getContent(Config.getInArea(Config.currentAreaID, "@swf")));
				current.id = Config.currentAreaID;
				
				Layers.getInstance("sweatless").get("navigation").addChild(current);
				
				current.addEventListener(Area.READY, show);
				current.create();
				
				align(current, Config.getAreaAdditionals(Config.currentAreaID, "@halign"), Config.getAreaAdditionals(Config.currentAreaID, "@valign"), Number(Config.getAreaAdditionals(Config.currentAreaID, "@width")), Number(Config.getAreaAdditionals(Config.currentAreaID, "@height")), Number(Config.getAreaAdditionals(Config.currentAreaID, "@top")), Number(Config.getAreaAdditionals(Config.currentAreaID, "@bottom")), Number(Config.getAreaAdditionals(Config.currentAreaID, "@right")), Number(Config.getAreaAdditionals(Config.currentAreaID, "@left")));
				
				last = current;
			}catch(e:Error){
				trace(e.getStackTrace());
			}
		}
		
		private static function show(evt:Event):void{
			current.removeEventListener(Area.READY, show);
			current.show();
		}
		
		private static function hide(evt:Event):void{
			setID(evt.type);
			
			if(last) {
				last.addEventListener(Area.CLOSED, load);
				last.hide();
			}else{
				load(null);
			}
		}
		
		private static function load(evt:Event):void{
			if(last){
				last.removeEventListener(Area.CLOSED, load);
				broadcaster.dispatchEvent(new Event(broadcaster.getEvent("hide_" + last.id)));
				last = null;
			}
			
			Config.crossdomain ? Security.loadPolicyFile(Config.crossdomain) : null;
			
			var cache : Boolean = StringUtils.toBoolean(Config.getAreaAdditionals(Config.currentAreaID, "@cache"));
			var audioContext : SoundLoaderContext = new SoundLoaderContext(1000, Boolean(Config.crossdomain));
			var imageContext : LoaderContext = new LoaderContext(Boolean(Config.crossdomain), ApplicationDomain.currentDomain);
			
			var swf : String = Config.getInArea(Config.currentAreaID, "@swf");
			var assets : String = Config.getAreaAdditionals(Config.currentAreaID, "@assets");
			var tracking : String = Config.tracking;
			
			var videos : Dictionary = Config.getAreaDependencies(Config.currentAreaID, "video");
			var audios : Dictionary = Config.getAreaDependencies(Config.currentAreaID, "audio");
			var images : Dictionary = Config.getAreaDependencies(Config.currentAreaID, "image");
			var others : Dictionary = Config.getAreaDependencies(Config.currentAreaID, "other");
			
			loader = BulkLoader.getLoader(Config.currentAreaID) || new BulkLoader(Config.currentAreaID);
			
			if (loader.itemsTotal > 0 && loader.isFinished){
				loaded(null);
			}else{
				var id : *;
				for(id in videos) loader.add(videos[id], {id:id, pausedAtStart:true, preventCache:!cache});
				for(id in images) loader.add(images[id], {id:id, context:imageContext, preventCache:!cache});
				for(id in audios) loader.add(audios[id], {id:id, context:audioContext, preventCache:!cache});
				for(id in others) loader.add(others[id], {id:id, preventCache:!cache});
				
				tracking ? loader.add(tracking, {id:"tracking", preventCache:!cache}) : null;
				assets ? loader.add(assets, {id:"assets", preventCache:!cache}) : null;
				loader.add(swf, {id:"swf", priority:loader.highestPriority, preventCache:!cache});
				
				loader.addEventListener(BulkProgressEvent.PROGRESS, onProgress);
				loader.addEventListener(BulkProgressEvent.COMPLETE, onLoadComplete);
				
				loading = Loadings.exists(Config.currentAreaID) ? Loadings.get(Config.currentAreaID) : Loadings.exists("default") ? Loadings.get("default") : null; 
				loading && !loading.stage ? Layers.getInstance("sweatless").get("loading").addChild(loading) : null;
				loading ? loading.show() : null;
				
				loader.sortItemsByPriority();
				loader.start();
			}
		}
		
		private static function unload(evt:Event):void{
			Align.remove(last, Number(Config.getAreaAdditionals(last.id, "@width")), Number(Config.getAreaAdditionals(last.id, "@height")), Number(Config.getAreaAdditionals(Config.currentAreaID, "@top")), Number(Config.getAreaAdditionals(Config.currentAreaID, "@bottom")), Number(Config.getAreaAdditionals(Config.currentAreaID, "@right")), Number(Config.getAreaAdditionals(Config.currentAreaID, "@left")));
			
			Layers.getInstance("sweatless").get("navigation").removeChild(last);
			
			!StringUtils.toBoolean(Config.getAreaAdditionals(last.id, "@cache")) ? removeLoadedItens() : null;
		}
		
		private static function removeLoadedItens():void{
			loader.removeAll();
			
			try{
				new LocalConnection().connect("clear_gc");
				new LocalConnection().connect("clear_gc");
			} catch(e:Error){
				
			}
		}
		
		private static function onProgress(evt:BulkProgressEvent):void{
			loading ? loading.progress = evt.percentLoaded : null;
		}
		
		private static function setDeeplink():void{
			SWFAddress.setTitle(Config.getAreaAdditionals(Config.currentAreaID, "@title"));
			if(SWFAddress.getValue()!=Config.getAreaAdditionals(Config.currentAreaID, "@deeplink") + "/" + Config.getSubAreaParameter(Config.currentAreaID,Config.currentSubareaID, "deeplink")){
				SWFAddress.setValue(Config.getAreaAdditionals(Config.currentAreaID, "@deeplink") + "/" + Config.getSubAreaParameter(Config.currentAreaID,Config.currentSubareaID, "deeplink"));
			}
		}
		
		private static function onChange(evt:SWFAddressEvent):void{
			var newArea:String = Config.getAreaByDeeplink(SWFAddress.getPath().split("/")[1]);
			var newSubArea:String = Config.getSubAreaByDeeplink(SWFAddress.getPath().split("/")[1], SWFAddress.getPath().substr(SWFAddress.getPath().indexOf("/",3)+1));
			if(Config.currentAreaID == newArea && Config.currentSubareaID == newSubArea){
				SWFAddress.setHistory(false);
				setDeeplink();
				SWFAddress.setHistory(true);
				return;
			}
			Config.currentAreaID = newArea;
			Config.currentSubareaID = newSubArea;
			broadcaster.dispatchEvent(new Event(broadcaster.getEvent("show_"+Config.currentAreaID)));
			broadcaster.dispatchEvent(new Event(broadcaster.getEvent("change_menu")));
		}
		
		private static function setID(p_value:String):void{
			Config.currentAreaID = p_value.slice(5);
		}
		
		private static function align(p_area:Area, p_hanchor:String, p_vanchor:String, p_width:Number=0, p_height:Number=0, p_top:Number=0, p_bottom:Number=0, p_right:Number=0, p_left:Number=0):void{
			p_hanchor = !p_hanchor ? "NONE" : p_hanchor.toUpperCase();
			p_vanchor = !p_vanchor ? "NONE" : p_vanchor.toUpperCase();
			
			p_width = (p_width==0 || !p_width) ? undefined : p_width;		
			p_height = (p_height==0 || !p_height) ? undefined : p_height;
			
			p_top = !p_top ? 0 : p_top;
			p_bottom = !p_bottom ? 0 : p_bottom;
			p_right = !p_right ? 0 : p_right;
			p_left = !p_left ? 0 : p_left;
			
			Align.add(p_area, Align[p_hanchor] + Align[p_vanchor], {width:p_width, height:p_height, margin_bottom:p_bottom, margin_top:p_top, margin_left:p_left, margin_right:p_right});
		}
	}
}
