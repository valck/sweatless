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

package sweatless.media{

	import sweatless.events.CustomEvent;
	import sweatless.graphics.SmartRectangle;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Dictionary;

	public class YoutubeTrack extends Sprite {
		public static const READY : String = "ready";
		public static const PAUSED : String = "paused";
		public static const STARTED : String = "started";
		public static const CUEPOINT : String = "cuepoint";
		public static const COMPLETE : String = "complete";
		public static const UNSTARTED : String = "unstarted";
		public static const BUFFERING : String = "buffering";
		
		public static const TYPE_EMBEDDED : String = "embedded";
		public static const TYPE_CHROMELESS : String = "chromeless";
		
		private static const ON_READY : String = "onReady";
		private static const ON_STATE_CHANGE : String = "onStateChange";
		
		public static const RESOLUTION_QUALITY_AUTO : String = "default";
		public static const RESOLUTION_QUALITY_240 : String = "240";
		public static const RESOLUTION_QUALITY_360 : String = "360";
		public static const RESOLUTION_QUALITY_480 : String = "480";
		public static const RESOLUTION_QUALITY_720 : String = "720";
		public static const RESOLUTION_QUALITY_1080 : String = "1080";
		
		private var _id : String;
		private var _type : String;
		
		private var _playing : Boolean;
		
		private var _height : int;
		private var _width : int;
		
		private var player : Object;
		private var loader : Loader;
		
		private var endAt : Number;
		
		private var cuepointPosition : Number;
		private var currentVolume : Number;
		private var currentPosition : Number;
		private var currentCuepoints : Dictionary;
		
		private var background : SmartRectangle;

		public function YoutubeTrack(p_type : String = YoutubeTrack.TYPE_CHROMELESS) : void {
			_type = p_type;
			
			
			try{
				Security.loadPolicyFile('http://i.ytimg.com/crossdomain.xml');
				Security.loadPolicyFile('http://s.ytimg.com/crossdomain.xml');
				Security.loadPolicyFile('http://gdata.youtube.com/crossdomain.xml');
				
				Security.allowInsecureDomain("*");
				Security.allowDomain('gdata.youtube.com');
				Security.allowDomain('www.youtube.com');
				Security.allowDomain('youtube.com');
				Security.allowDomain('s.ytimg.com');
				Security.allowDomain('i.ytimg.com');
			}catch(err:Error){
				
			}
			
			currentCuepoints = new Dictionary();
			
			background = new SmartRectangle();
			addChild(background);
			background.colors = [0];
			
			loader = new Loader();
			addChild(loader);
			loader.contentLoaderInfo.addEventListener(Event.INIT, create);

			var request : URLRequest = new URLRequest("http://www.youtube.com/apiplayer?version=3");
			loader.load(request);
			
			mouseEnabled = false;
		}

		public function load(p_id : String, p_startAt : int = -1, p_endAt : int = -1, p_quality : String = null) : void {
			_id = p_id;
			
			cuepointPosition = 0;
			currentVolume = 50;
			currentPosition = 0;
			
			var request : URLRequest;
			switch(_type){
				case TYPE_CHROMELESS:
						if(player && loader.content) {
							var data : Object = new Object();
							data.videoId = p_id;
							data.startSeconds = p_startAt != -1 ? p_startAt : 0;
							data.suggestedQuality = p_quality ? p_quality : RESOLUTION_QUALITY_AUTO;
							if(p_endAt != -1) data.endSeconds = endAt = p_endAt;
							
							player.loadVideoById(data);
							isPlaying = true;
						}else{
							loader.contentLoaderInfo.addEventListener(Event.INIT, create);
							
							request = new URLRequest("http://www.youtube.com/apiplayer?video_id="+_id+"&version=3");
							loader.load(request);
						};
						
						mouseChildren = false;
					break;
				case TYPE_EMBEDDED:
					if(loader.content){
						loader.content.removeEventListener(ON_READY, ready);
						loader.content.removeEventListener(ON_STATE_CHANGE, state);
						loader.contentLoaderInfo.removeEventListener(Event.INIT, create);
						loader.unloadAndStop(true);
						loader.unload();
					}
					
					loader.contentLoaderInfo.addEventListener(Event.INIT, create);

					request = new URLRequest("http://www.youtube.com/v/"+_id+"?version=3");
					loader.load(request);
					break;
			}
			
			clearAllCuePoints();
		}
		
		private function create(event : Event) : void {
			loader.contentLoaderInfo.removeEventListener(Event.INIT, create);
			
			loader.content.addEventListener(ON_READY, ready);
			loader.content.addEventListener(ON_STATE_CHANGE, state);
		}
		
		private function ready(event : Event) : void {
			loader.content.removeEventListener(ON_READY, ready);
			
			if(player){
				player.destroy();
				player = null;
			}
			
			player = loader.content;
			player.setSize(_width ? _width : 0, _height ? _height : 0);
			
			background.width = _width ? _width : 0;
			background.height = _height ? _height : 0;
			
			dispatchEvent(new Event(READY));
			
			if(_id && _type == TYPE_CHROMELESS) play();
		}
		
		private function state(evt : Event) : void {
			switch(Object(evt).data) {
				case -1:
				dispatchEvent(new Event(UNSTARTED));
					break;
				case 0:
				dispatchEvent(new Event(COMPLETE));
					break;
				case 1:
				dispatchEvent(new Event(STARTED));
					break;
				case 2:
				dispatchEvent(new Event(PAUSED));
					break;
				case 3:
				dispatchEvent(new Event(BUFFERING));
					break;
				case 5:
				//TODO video cued (5)
					break;
			}
		}
		
		public function get isMute():Boolean{
			if(!player) {
				return false;
			}else{
				return player.isMuted();
			}
		}
		
		public function get isPlaying():Boolean{
			return _playing;
		}
		
		public function set isPlaying(p_value:Boolean):void{
			_playing = p_value;
			_playing && currentCuepoints ? addEventListener(Event.ENTER_FRAME, dispatchCuePoints) : removeEventListener(Event.ENTER_FRAME, dispatchCuePoints);
		}
		
		public function get type() : String {
			return _type;
		}

		public function set type(p_type : String) : void {
			_type = p_type;
		}
				
		public function set track(p_id:String):void{
			_id = p_id;

			load(_id);
		}
		
		public function get track() : String {
			return _id;
		}
		
		public function get percentLoaded():Number{
			if(!player) {
				return 0;
			}else{
				return player.getVideoBytesLoaded()/player.getVideoBytesTotal();
			}
		}
		
		public function get availableQuality():String{
			if(!player) {
				return null;
			}else{
				return player.getAvailableQualityLevels();
			}
		}

		public function get quality():String{
			if(!player) {
				return null;
			}else{
				return player.getPlaybackQuality();
			}
		}

		public function set quality(p_quality:String):void{
			if(!player) return;
			
			switch(p_quality){
				case RESOLUTION_QUALITY_240:
					player.setPlaybackQuality("small");
					player.setSize(_width ? _width : 320, _height ? _height : 240);
					
					background.width = _width ? _width : 320;
					background.height = _height ? _height : 240;
					break;
				case RESOLUTION_QUALITY_360:
					player.setPlaybackQuality("medium");
					player.setSize(_width ? _width : 640, _height ? _height : 360);
					
					background.width = _width ? _width : 640;
					background.height = _height ? _height : 360;
					break;
				case RESOLUTION_QUALITY_480:
					player.setPlaybackQuality("large");
					player.setSize(_width ? _width : 853, _height ? _height : 480);

					background.width = _width ? _width : 853;
					background.height = _height ? _height : 480;
					break;
				case RESOLUTION_QUALITY_720:
					player.setPlaybackQuality("hd720");
					player.setSize(_width ? _width : 1280, _height ? _height : 720);

					background.width = _width ? _width : 1280;
					background.height = _height ? _height : 720;
					break;
				case RESOLUTION_QUALITY_1080:
					player.setPlaybackQuality("hd1080");
					player.setSize(_width ? _width : 1920, _height ? _height : 1080);

					background.width = _width ? _width : 1920;
					background.height = _height ? _height : 1080;
					break;
				case RESOLUTION_QUALITY_AUTO:
					player.setPlaybackQuality("default");

					background.width = _width ? _width : player.width;
					background.height = _height ? _height : player.height;
					break;
					default:
					player.setPlaybackQuality("default");
			}
			
			player.setPlaybackQuality(p_quality);
		}
		
		public function set seek(p_offset:Number):void{
			if(!player) return;
			
			player.seekTo(p_offset, true);
		}
		
		public function get seek():Number{
			if(!player) {
				return 0;
			}else{
				return player.getCurrentTime();
			}
		}

		public function seekToCuepoint(p_name:String):void{
			if(!currentCuepoints) throw new Error("No metadata was assigned to this VideoTrack");
			if(!currentCuepoints[p_name]) throw new Error("The requested cuepoint does not exist");
			
			seek = Number(currentCuepoints[p_name].time);
		}
		
		public function get duration():Number{
			if(!player) {
				return 0;
			}else{
				return endAt ? endAt : player.getDuration();
			}
		}
		
		public function playAt(p_position:Number):void{
			isPlaying = true;
			player.seekTo(p_position, true);
		}
		
		public function play():void{
			if(!player) return;
			if(isPlaying) return;
			
			isPlaying = true;
			player.playVideo();
			
			currentPosition = seek;
			volume = currentVolume;
		}
		
		public function stop():void{
			if(!player) return;
			
			isPlaying = false;
			player.stopVideo();
		}
		
		public function pauseToggle():void {
			if(!isPlaying) {
				isPlaying = true;
				resume();
			}else {
				isPlaying = false;
				pause();
			}
		}
		
		public function pause():void {
			if(!player) return;

			isPlaying = false;
			player.pauseVideo();
			
			currentPosition = seek;
		}
		
		public function resume():void {
			if(!player) return;
			
			isPlaying = true;
			
			player.seekTo(currentPosition, true);
			player.playVideo();
			
			volume = currentVolume;
		}
		
		public function set volume(p_volume:Number):void {
			if(!player) return;
			player.setVolume(p_volume);
			
			currentVolume = volume;
		}
		
		public function get volume():Number {
			if(!player) {
				return 0;
			}else{
				return player.getVolume();
			}
		}
		
		public function muteToggle():void {
			if(!isMute){
				mute();
			}else{
				unmute();
			}
		}
		
		public function mute():void {
			if(!player) return;
			player.mute();
		}
		
		public function unmute():void {
			if(!player) return;
			player.unMute();
		}
		
		public function addCuePoint(p_id:String, p_time:String):void {
			if(hasCuePoint(p_id)) throw new Error("The cuepoint "+ p_id +" already exists.");
			
			var cuePoint : CuePoint = new CuePoint(p_id, p_time);
			currentCuepoints[p_id] = cuePoint;
		}
		
		public function getCuePoint(p_id:String):CuePoint{
			if(!hasCuePoint(p_id)) throw new Error("The cuepoint "+ p_id +" don't exists.");
			return currentCuepoints[p_id];
		}
		
		public function hasCuePoint(p_id:String):Boolean{
			return currentCuepoints[p_id] ? true : false;
		}
		
		public function clearCuePoint(p_id:String): void{
			if(hasCuePoint(p_id)) throw new Error("The cuepoint "+ p_id +" already exists.");
			
			currentCuepoints[p_id] = null;
			delete currentCuepoints[p_id];
		}
		
		public function clearAllCuePoints():void{
			for(var key:* in currentCuepoints){
				currentCuepoints[key] = null;
				delete currentCuepoints[key];
			}
		}
		
		private function dispatchCuePoints(evt : Event):void {
			for(var key:* in currentCuepoints){
				if(seek*1000 >= getCuePoint(key).miliseconds && cuepointPosition < getCuePoint(key).miliseconds) {
					dispatchEvent(new CustomEvent(CUEPOINT, currentCuepoints[key]));
				}
			}
			cuepointPosition = seek*1000;
		}
		
		private function cuePointSort(a:CuePoint, b:CuePoint):int{
			if(int(a.time) > int(b.time)){
				return 1;
			}else if(int(a.time) == int(b.time)){
				return 0;
			}else{
				return -1;
			}
		}
			
		public function get cuepoints():Array{
			var result : Array = new Array();
			if(!currentCuepoints) return result;
			for(var prop:String in currentCuepoints) result.push(new CuePoint(prop, currentCuepoints[prop].time));
			return result.sort(cuePointSort);
		}
		
		override public function set width(p_value:Number):void{
			_width = int(p_value);
			if(!player) return;
			player.setSize(_width, _height ? _height : 0);
			background.width = _width;
		}
		
		override public function set height(p_value:Number):void{
			_height = int(p_value);
			if(!player) return;
			player.setSize(_width ? _width : 0, _height);
			background.height = _height;
		}
		
		override public function get width():Number{
			return _width;
		}
		
		override public function get height():Number{
			return _height;
		}
		
		public function destroy():void{
			if(loader.content){
				loader.content.removeEventListener(ON_READY, ready);
				loader.content.removeEventListener(ON_STATE_CHANGE, state);
				loader.contentLoaderInfo.removeEventListener(Event.INIT, create);
				loader.unloadAndStop(true);
				loader.unload();
			}

			removeEventListener(Event.ENTER_FRAME, dispatchCuePoints);
			
			clearAllCuePoints();
			stop();
			
			background.destroy();
			removeChild(background);
			background = null;
			
			player.destroy();
			player = null;
			
			removeChild(loader);
			loader = null;
		}
	}
}		