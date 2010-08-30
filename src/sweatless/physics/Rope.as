/**
 * Licensed under the MIT License
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
 * http://code.google.com/p/sweatless/
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * @author Valério Oliveira (valck)
 * 
 */

package sweatless.physics{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.cove.ape.APEngine;
	import org.cove.ape.CircleParticle;
	import org.cove.ape.CollisionEvent;
	import org.cove.ape.Group;
	import org.cove.ape.SpringConstraint;
	import org.cove.ape.VectorForce;
	
	import sweatless.extras.ape.InteractiveParticle;
	import sweatless.utils.NumberUtils;
	
	public class Rope extends Sprite{
		private var neb : InteractiveParticle; 
		private var texture : DisplayObject;
		
		private var distanceBetween : uint = 1;
		
		public function Rope(){
			config();			
		}
		
		protected function config():void{
			APEngine.init();
			APEngine.container = this;
			APEngine.addForce(new VectorForce(false, 0, 3));
			APEngine.damping = .98;
			APEngine.constraintCollisionCycles = 5;
		}
		
		public function create(p_texture:DisplayObject, p_nodes:uint=50, p_interactive:Boolean=false):void{
			var group : Group = new Group();
			var pin : CircleParticle = new CircleParticle(0, -10, 1, true);
			var node : CircleParticle;
			var last : CircleParticle;
			var link : SpringConstraint;
			
			group.addParticle(pin);
			
			last = pin;
			texture = p_texture;
			texture.stage ? texture.parent.removeChild(texture) : null;
			
			for(var i:uint=0; i<p_nodes; i++){
				if(i == (p_nodes-1)){
					node = new InteractiveParticle(0, 0, 1, false, 10);
					
					neb = InteractiveParticle(node);
					neb.setDisplay(texture);
					neb.py = -texture.height;
					p_interactive ? neb.addListeners() : null;
					
					TweenMax.to(neb, .5,{
						px:NumberUtils.rangeRandom(50, -50),
						angle:-1
					});
					
					TweenMax.to(neb.sprite, .5,{
						rotation:-15
					});
					
				}else{
					node = new CircleParticle(0, 0, 1, false, 5, .5, 1);
					node.visible = false;
				}
				
				group.addParticle(node);
				
				link = new SpringConstraint(last, node, .7, false);
				link.restLength = distanceBetween;
				link.setStyle(2, 0x2e1903);
				
				group.addConstraint(link);
				
				last = node;
			}
			
			APEngine.addGroup(group);
		}
		
		public function startRender():void{
			addEventListener(Event.ENTER_FRAME, rendering);
		}
		
		public function stopRender():void{
			removeEventListener(Event.ENTER_FRAME, rendering);
		}
		
		public function destroy() : void{
			stopRender();
		}
		
		protected function rendering(evt:Event):void{
			APEngine.step();
			APEngine.paint();
		}
	}
}
