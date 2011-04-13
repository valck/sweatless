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

package sweatless.media {

	import sweatless.utils.BitmapUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Timer;
	
	/**
	 * 
	 * @todo docs 
	 * @author valck
	 * 
	 */
	public class CameraTrack extends Sprite{
		
		public static const USER_DENY : String = "user_deny";
		public static const NOT_FOUND : String = "not_found";
		public static const FOUND : String = "found";
		
		private var index : uint;
		private var timer : Timer;
		
		private var image : Bitmap;
		private var bitmap : BitmapData;
		
		private var matrix : Matrix;
		private var filter : ColorMatrixFilter;
		
		private var camera : Camera;
		private var video : Video;
		
		/*
		Camera automatic detection methods
		Tries to find the correct camera driver by simply testing all cameras and checking the activityLevel and the output bitmap
		*/
		public function CameraTrack(p_width:int=320, p_height:int=240, p_asBitmap:Boolean=false){
			video = new Video(p_width, p_height);
			
			if(p_asBitmap){
				image = new Bitmap();
				addChild(image);
				
				addEventListener(CameraTrack.FOUND, asBitmap);
			}else{
				addChild(video);
			}
			
			index = 0;
			
			tryNext();
		}
		
		private function asBitmap(evt:Event):void{
			removeEventListener(CameraTrack.FOUND, asBitmap);
			
			bitmap = new BitmapData(width, height, false, 0);
			
			matrix = new Matrix(1, 0, 0, 1, 0, 0);

			image.bitmapData = bitmap;
			image.smoothing = smoothing;
			
			timer = new Timer(1000 / fps);
			timer.addEventListener(TimerEvent.TIMER, render);
			timer.start();
		}
		
		public function get track():*{
			return video.stage ? video : image;
		}
		
		public function set colorMatrix(p_filter:Array):void{
			filter = new ColorMatrixFilter();
			filter.matrix = p_filter;
		}
		
		public function get deblocking():int{
			return video.deblocking;
		}
		
		public function set deblocking(p_value:int):void{
			video.deblocking = p_value;
		}
		
		public function get smoothing():Boolean{
			return video.smoothing;
		}
		
		public function set smoothing(p_value:Boolean):void{
			video.smoothing = p_value;
		}
		
		public function get flipHorizontal():Boolean{
			return video.scaleX == -1 ? true : false;
		}
		
		public function set flipHorizontal(p_value:Boolean):void{
			if(p_value){
				video.scaleX = -1;
				video.x = width;
			}else{
				video.scaleX = 1;
				video.x = 0;
			};
		}
		
		public function get flipVertical():Boolean{
			return video.scaleY == -1 ? true : false;
		}
		
		public function set flipVertical(p_value:Boolean):void{
			if(p_value){
				video.scaleY = -1;
				video.y = height;
			}else{
				video.scaleY = 1;
				video.y = 0;
			};
		}
		
		public function get availableCameras():Array{
			return Camera.names;
		}
		
		public function set fps(p_value:int):void{
			camera.setMode(width, height, p_value);
		}
		
		public function get fps():int{
			return camera.fps;
		}
		
		public function set quality(p_value:int):void{
			camera.setQuality(bandwidth, p_value);
		}
		
		public function get quality():int{
			return camera.quality;
		}
		
		public function set bandwidth(p_value:int):void{
			camera.setQuality(p_value, quality);
		}
		
		public function get bandwidth():int{
			return camera.bandwidth;
		}

		/**
		 * 
		 * @param p_value A value of 1 means that every frame is a keyframe, a value of 3 means that every third frame is a keyframe, and so on. Acceptable values are 1 through 48. 
		 * 
		 */
		public function set keyframeInterval(p_value:int):void{
			camera.setKeyFrameInterval(p_value);
		}
		
		public function get keyframeInterval():int{
			return camera.keyFrameInterval;
		}
		
		override public function set height(p_value:Number):void{
			video.height = int(p_value);
		}
		
		override public function get height():Number{
			return video.height;
		}
		
		override public function set width(p_value:Number):void{
			video.width = int(p_value);
		}
		
		override public function get width():Number{
			return video.width;
		}
		
		private function render(evt:TimerEvent):void{
			timer.delay = fps;
			
			bitmap.lock();
			bitmap.draw (video, matrix, null, "normal", null, smoothing);
			
			if(filter) bitmap.applyFilter(bitmap, bitmap.rect, new Point(), filter);
			bitmap.unlock();
			
			dispatchEvent(new Event(Event.RENDER));
		}
		
		private function tryNext():void{
			if(index > availableCameras.length){
				notify(NOT_FOUND);
				return;
			}

			camera = Camera.getCamera(availableCameras[index]);

			if(camera){
				camera.addEventListener(StatusEvent.STATUS, status);
				video.attachCamera(camera);
			}else{
				index++;
				tryNext();
			}
		}

		private function ready(e:ActivityEvent):void{
			camera.removeEventListener(ActivityEvent.ACTIVITY, ready);
			
			!hasCamera(camera) ? tryNext() : notify(FOUND);
		}
		
		private function status(e:StatusEvent):void{
			camera.removeEventListener(StatusEvent.STATUS, status);

			if(e.code == "Camera.Unmuted"){
				camera.addEventListener(ActivityEvent.ACTIVITY, ready);
			}else if ("Camera.Muted"){
				notify(USER_DENY);
			}
		}
		
		private function notify(p_type:String):void{
			switch(p_type){
				case "user_deny":
					dispatchEvent(new Event(USER_DENY));
				break;

				case "not_found":
					dispatchEvent(new Event(NOT_FOUND));
				break;

				case "found":
					dispatchEvent(new Event(FOUND));
				break;
			}
		}

		private function hasCamera(p_camera:Camera):Boolean{
			if(!p_camera) throw new Error("You have to provide a valid Camera instance");
			return p_camera.activityLevel > -1 && BitmapUtils.isEmptyBitmapData(BitmapUtils.convertToBitmap(video, 0, true, false).bitmapData) ? true : false;
		}
		
		public function destroy():void{
			video.clear();
			video.attachCamera(null);
			video && video.stage ? removeChild(video) : null;
			video = null;
			
			if(timer){
				timer.removeEventListener(TimerEvent.TIMER, render);
				timer.stop();
				
				filter = null;
				
				removeChild(image);
				image = null;
			}
			
			camera = null;
		}
	}
}
