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

package sweatless.utils {

	import sweatless.geom.Point3D;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**
	 * 
	 * The <code>GeometryUtils</code> class have support methods for easier trigonometry in 3D vectors.
	 * 
	 */	
	public class GeometryUtils {
		
		/**
		 * 
		 * Returns the distance between two vectors. 
		 * 
		 * @param point1 The first vector.
		 * @param point2 The second vector.
		 * @return <code>Number</code> 
		 * 
		 */
		public static function getDistance(point1:Vector3D, point2:Vector3D):Number{
			return Math.sqrt(Math.pow(point1.x - point2.x, 2) + Math.pow(point1.y - point2.y, 2) + Math.pow(point1.z - point2.z, 2));
		}
		
		/**
		 * 
		 * Returns the middle point of two vectors.
		 * 
		 * @param point1 The first vector.
		 * @param point2 The second vector.
		 * @return <code>Vector3D</code> 
		 * 
		 */
		public static function getMiddlePoint(point1:Vector3D, point2:Vector3D):Vector3D{
			return new Vector3D(point1.x + (point2.x - point1.x)/2, point1.y + (point2.y - point1.y)/2, point1.z + (point2.z - point1.z)/2);
		}
		
		/**
		 * 
		 * Returns the yaw of two vectors.
		 * 
		 * @param origin The origin vector.
		 * @param target The target vector.
		 * @param degrees If <code>true</code> return this value in degrees, else return in radians.
		 * @param baseAxis_1 The first axis parameter to be used. Defaults to x.
		 * @param baseAxis_2 the second axis parameter to be used. Defaults to z.
		 * @return <code>Number</code>
		 * 
		 */
		public static function getYaw(origin:Vector3D, target:Vector3D, degrees:Boolean=true , baseAxis_1:String="x", baseAxis_2:String="z"):Number{
			var value:Number = Math.atan2(target[baseAxis_1] - origin[baseAxis_1], target[baseAxis_2] - origin[baseAxis_2]);
			return degrees ? toDegrees(value) : value;
		}
		
		/**
		 * 
		 * Returns the pitch of two vectors.
		 * 
		 * @param origin The origin vector.
		 * @param target The target vector.
		 * @param degrees If <code>true</code> return this value in degrees, else return in radians.
		 * @param baseAxis_1 The first axis parameter to be used. Defaults to x.
		 * @param baseAxis_2 the second axis parameter to be used. Defaults to y.
		 * @param baseAxis_3 the second axis parameter to be used. Defaults to z.
		 * @return <code>Number</code>
		 * 
		 */
		public static function getPitch(origin:Vector3D, target:Vector3D, degrees:Boolean=true, baseAxis_1:String="x", baseAxis_2:String="y", baseAxis_3:String="z"):Number{
			var value:Number = Math.atan2(origin[baseAxis_2]-target[baseAxis_2], Math.sqrt(Math.pow(origin[baseAxis_1] - target[baseAxis_1], 2) + Math.pow(origin[baseAxis_3] - target[baseAxis_3],2)));
			return degrees ? toDegrees(value) : value;
		}
		
		/**
		 * Returns the value in radians of a <code>Number</code>.
		 * @param p_value The <code>Number</code> to check.
		 * @return The resulting <code>Number</code> object.
		 * @see Number
		 */
		public static function toRadians(p_value:Number):Number{
			return p_value / 180 * Math.PI;
		}
		
		/**
		 * Returns the value in degress of a <code>Number</code>.
		 * @param p_value The <code>Number</code> to check.
		 * @return The resulting <code>Number</code> object.
		 * @see Number
		 */
		public static function toDegrees(p_value:Number):Number{
			return p_value * 180 / Math.PI;
		}
		
		/**
		 * Returns the value in radians of a degress <code>Number</code>.
		 * @param p_value The <code>Number</code> to check.
		 * @return The resulting <code>Number</code> object.
		 * @see Number
		 */
		public static function degreesToRadians(p_value:Number):Number{
			return (2 * Math.PI * p_value) / 360;
		}
		
		/**
		 * 
		 * Returns the relative position of a target object in a source coordination space.
		 * 
		 * @param target the object to be converted.
		 * @param source the source space to be used as reference.
		 * @return <code>Number</code>
		 * 
		 */
		public static function getRelativePosition(target:Vector3D, source:Point3D):Vector3D{
			var mat:Matrix3D = new Matrix3D();
			
			mat = euler2Matrix(new Vector3D(source.rotationX, source.rotationY, source.rotationZ));
			mat.position = new Vector3D(source.x, source.y, source.z);
			mat.appendScale(1, 1, 1);
			
			mat.appendTranslation(-target.x, -target.y, -target.z);
			mat.invert();	
			return mat.position;
		}
		
		private static function euler2Matrix(euler:Vector3D):Matrix3D{
			var ax:Number = toRadians(euler.y);
			var ay:Number = toRadians(euler.z);
			var az:Number = toRadians(-euler.x);
			var fSinPitch : Number = Math.sin(ax * 0.5);
			var fCosPitch : Number = Math.cos(ax * 0.5);
			var fSinYaw : Number = Math.sin(ay * 0.5);
			var fCosYaw : Number = Math.cos(ay * 0.5);
			var fSinRoll : Number = Math.sin(az * 0.5);
			var fCosRoll : Number = Math.cos(az * 0.5);
			var fCosPitchCosYaw : Number = fCosPitch * fCosYaw;
			var fSinPitchSinYaw : Number = fSinPitch * fSinYaw;

			var x : Number = fSinRoll * fCosPitchCosYaw - fCosRoll * fSinPitchSinYaw;
			var y : Number = fCosRoll * fSinPitch * fCosYaw + fSinRoll * fCosPitch * fSinYaw;
			var z : Number = fCosRoll * fCosPitch * fSinYaw - fSinRoll * fSinPitch * fCosYaw;
			var w : Number = fCosRoll * fCosPitchCosYaw + fSinRoll * fSinPitchSinYaw;
			
			var xx:Number = x * x;
            var xy:Number = x * y;
            var xz:Number = x * z;
            var xw:Number = x * w;
    
            var yy:Number = y * y;
            var yz:Number = y * z;
            var yw:Number = y * w;
    
            var zz:Number = z * z;
            var zw:Number = z * w;
            
			return new Matrix3D(Vector.<Number>([1 - 2 * (yy + zz), 2 * (xy + zw), 2 * (xz - yw), 0, 2 * (xy - zw), 1 - 2 * (xx + zz), 2 * (yz + xw), 0, 2 * (xz + yw), 2 * (yz - xw), 1 - 2 * (xx + yy), 0, 0, 0, 0, 1]));
		}
	}
}