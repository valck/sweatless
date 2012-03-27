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
 * @author João Marquesini
 * 
 */

package sweatless.geom {

	import sweatless.utils.GeometryUtils;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * Creates an instance of a Point3D object. 
	 * @see Point
	 */	
	public class Point3D{
		private var _matrix3D : Matrix3D;
		
		private var _rotationX : Number;
		private var _rotationY : Number;
		private var _rotationZ : Number;
		private var _x : Number;
		private var _y : Number;
		private var _z : Number;
		
		private var rotationDirty:Boolean;
		
		/**
		 * 
		 * Creates an instance of a Point3D object. If you do not specify a parameter for the constructor, a Point3D object is created with the elements (0.0, 0.0, 0.0, 0.0, 0.0, 0.0). 
		 * 
		 * @param p_x The first element of a Point3D object, such as the x coordinate of a point in the three-dimensional space. The default value is 0.0.
		 * @param p_y The second element of a Point3D object, such as the y coordinate of a point in the three-dimensional space. The default value is 0.0. 
		 * @param p_z The third element of a Point3D object, such as the z coordinate of a point in three-dimensional space. The default value is 0.0.
		 * @param p_rotationX The fourth element of a Point3D object, such as the rotationX coordinate of a point in three-dimensional space. The default value is 0.0.
		 * @param p_rotationY The fifth element of a Point3D object, such as the rotationY coordinate of a point in three-dimensional space. The default value is 0.0.
		 * @param p_rotationZ The sixth element of a Point3D object, such as the rotationZ coordinate of a point in three-dimensional space. The default value is 0.0.
		 * 
		 */
		public function Point3D(p_x:Number=0.0, p_y:Number=0.0, p_z:Number=0.0, p_matrix3x3:String=null){
			_x = p_x;
			_y = p_y;
			_z = p_z;
					
			if(p_matrix3x3) matrix3x3ToMatrix3D(p_matrix3x3);
		}
		
		/**
		 * 
		 * Returns an instance of a Vector3D object.
		 * 
		 * @return <code>Vector3D</code>
		 * 
		 */
		public function get vector3D():Vector3D{
			return new Vector3D(x, y, z);
		}
		
		private function matrix3x3ToMatrix3D(p_array:String):void {
			if(!p_array) return;
			
		     var m3 : Array = p_array.split(",");
		    
		    var v:Vector.<Number> = new Vector.<Number>();
		    v.push(Number(m3[0]),Number(m3[1]),Number(m3[2]),0, Number(m3[3]),Number(m3[4]),Number(m3[5]), 0, Number(m3[6]),Number(m3[7]),Number(m3[8]),0,0,0,0,1);     
		     _matrix3D = new Matrix3D(v);
		     
		     rotationDirty=true;
		};
		
		/**
		 * 
		 * Returns an instance of a matrix3D object.
		 * 
		 * @return <code>Matrix3D</code>
		 * 
		 */
		public function get matrix3D():Matrix3D{
			return _matrix3D;
		}
		
		/**
		 * 
		 * Indicates the x axis coordinate of the point.  
		 * 
		 * @return <code>Number</code> 
		 * 
		 */
		public function get x():Number{
			return _x;
		}
		
		/**
		 * 
		 * Indicates the x axis coordinate of the point.  
		 * 
		 * @param p_value The <code>Number</code> to set. 
		 * 
		 */
		public function set x(p_value:Number):void{
			_x = p_value;
		}
		
		/**
		 * 
		 * Indicates the y axis coordinate of the point.
		 * 
		 * @return <code>Number</code> 
		 * 
		 */
		public function get y():Number{
			return _y;
		}
		
		/**
		 * 
		 * Indicates the y axis coordinate of the point.
		 * 
		 * @param p_value The <code>Number</code> to set. 
		 * 
		 */
		public function set y(p_value:Number):void{
			_y = p_value;
		}
		
		/**
		 * 
		 * Indicates the z axis coordinate of the point.
		 * 
		 * @return <code>Number</code> 
		 * 
		 */
		public function get z():Number{
			return _z;
		}
		
		/**
		 * 
		 * Indicates the z axis coordinate of the point.
		 * 
		 * @param p_value The <code>Number</code> to set. 
		 * 
		 */
		public function set z(p_value:Number):void{
			_z = p_value;
		}
		
		/**
		 * 
		 * Indicates the x rotation coordinate of the point.
		 * 
		 * @return <code>Number</code> 
		 * 
		 */
		public function get rotationX():Number{
			if(rotationDirty) refreshRotations();
			return _rotationX;
		}
		
		/**
		 * 
		 * Indicates the x rotation coordinate of the point.
		 * 
		 * @param p_value The <code>Number</code> to set. 
		 * 
		 */
		public function set rotationX(p_value:Number):void{
			_rotationX = p_value;
		}
		
		/**
		 * 
		 * Indicates the y rotation coordinate of the point.
		 * 
		 * @return <code>Number</code> 
		 * 
		 */
		public function get rotationY():Number{
			if(rotationDirty) refreshRotations();
			return _rotationY;
		}
		
		/**
		 * 
		 * Indicates the y rotation coordinate of the point.
		 * 
		 * @param p_value The <code>Number</code> to set. 
		 * 
		 */
		public function set rotationY(p_value:Number):void{
			_rotationY = p_value;
		}
		
		/**
		 * 
		 * Indicates the z rotation coordinate of the point.
		 * 
		 * @return <code>Number</code> 
		 * 
		 */
		public function get rotationZ():Number{
			if(rotationDirty) refreshRotations();
			return _rotationZ;
		}
		
		/**
		 * 
		 * Indicates the z rotation coordinate of the point.
		 * 
		 * @param p_value The <code>Number</code> to set. 
		 * 
		 */
		public function set rotationZ(p_value:Number):void{
			_rotationZ = p_value;
		}
		
		private function refreshRotations():void{
			rotationDirty = false;
			
			if(!_matrix3D){
				rotationX = 0;
				rotationY = 0;
				rotationZ = 0;
			}
			
            var m2:Matrix3D = new Matrix3D();
            
		 	rotationX = -Math.atan2(_matrix3D.rawData[6], _matrix3D.rawData[10]);
			
			m2.appendRotation(rotationX*180/Math.PI, new Vector3D(1, 0, 0));
			m2.append(_matrix3D);
			
			var cy:Number = Math.sqrt(m2.rawData[0]*m2.rawData[0] + m2.rawData[1]*m2.rawData[1]);
			
			rotationY = Math.atan2(-m2.rawData[2], cy); 
			rotationZ = Math.atan2(-m2.rawData[4], m2.rawData[5]); 
			
			if(Math.round(rotationZ/Math.PI) == 1) {
				
				rotationY = -rotationY + (rotationY>0 ? 0: -Math.PI*2);
				rotationX += rotationX>0 ? -Math.PI : Math.PI;
				
			} else if(Math.round(rotationZ/Math.PI) == -1) {
				
				rotationY = -rotationY + (rotationY>0 ? Math.PI : -Math.PI);
				rotationZ += Math.PI;
				rotationX += rotationX>0 ? -Math.PI :Math.PI;
				
			} else if(Math.round(rotationX/Math.PI) == 1) {
				rotationY = -rotationY + (rotationY>0 ? Math.PI : -Math.PI);
				rotationX -= Math.PI;
				rotationZ += rotationZ>0 ? -Math.PI :Math.PI;
				
			} else if(Math.round(rotationX/Math.PI) == -1) {
				rotationY = -rotationY + (rotationY>0 ? Math.PI : -Math.PI);
				rotationX += Math.PI;
				rotationZ += rotationZ>0 ? -Math.PI :Math.PI;
			}
			
			rotationX = -GeometryUtils.toDegrees(rotationX);
			rotationY = -GeometryUtils.toDegrees(rotationY);
			rotationZ = -GeometryUtils.toDegrees(rotationZ);
		}
		
		/**
		 * 
		 * Returns a string that contains the values of the x, y and z coordinates. The string has the form "(x=x, y=y, z=z, rotationX=rotationX, rotationY=rotationY, rotationZ=rotationZ)".
		 *  
		 * @return <code>String</code>
		 * 
		 */
		public function toString():String{
			return "(x="+x+", y="+y+", z="+z+", rotationX="+rotationX+", rotationY="+rotationY+", rotationZ="+rotationZ+")";
		}
	}
}
