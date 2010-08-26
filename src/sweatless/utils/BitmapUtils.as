package sweatless.utils{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.StageQuality;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
    
	public class BitmapUtils{
		public static function convertToBitmap(p_target:DisplayObject, p_margin:int=5, p_remove:Boolean=true):Bitmap{
			var qualityStage : String;
			
			if(p_target.stage){
				qualityStage = p_target.stage.quality;
				p_target.stage.quality = StageQuality.BEST;
			}
			
			var targetToDraw : BitmapData = new BitmapData(p_target.width+p_margin, p_target.height+p_margin, true, 0x00000000);
			targetToDraw.draw(p_target, null, null, null, null, true);
			
			var targetDrawed : Bitmap = new Bitmap(targetToDraw, PixelSnapping.ALWAYS, true);
			if(p_target.stage) p_target.stage.quality = qualityStage;
			
			targetDrawed.name = p_target.name;
			targetDrawed.x = p_target.x;
			targetDrawed.y = p_target.y;
			targetDrawed.smoothing = true;
			
			if(p_remove){
				if(p_target.stage){
					p_target.parent.removeChild(p_target);
				};
			}

			return targetDrawed;
		}
		
		public static function specialHitTestObject( target1:DisplayObject, target2:DisplayObject, accuracy:Number = 1 ):Boolean{
			return specialIntersectionRectangle( target1, target2, accuracy ).width != 0;
        }
        
        public static function intersectionRectangle( target1:DisplayObject, target2:DisplayObject ):Rectangle{
            if( !target1.root || !target2.root || !target1.hitTestObject( target2 ) ) return new Rectangle();
            
            var bounds1:Rectangle = target1.getBounds( target1.root );
            var bounds2:Rectangle = target2.getBounds( target2.root );
            
            var intersection:Rectangle = new Rectangle();
            intersection.x = Math.max( bounds1.x, bounds2.x );
            intersection.y = Math.max( bounds1.y, bounds2.y );
            intersection.width = Math.min( ( bounds1.x + bounds1.width ) - intersection.x, ( bounds2.x + bounds2.width ) - intersection.x );
            intersection.height = Math.min( ( bounds1.y + bounds1.height ) - intersection.y, ( bounds2.y + bounds2.height ) - intersection.y );
			
            return intersection;
        }
        
        public static function specialIntersectionRectangle( target1:DisplayObject, target2:DisplayObject, accuracy:Number = 1 ):Rectangle{            
            if( accuracy <= 0 ) throw new Error( "ArgumentError: Error #5001: Invalid value for accuracy", 5001 );
            
            if( !target1.hitTestObject( target2 ) ) return new Rectangle();
            
            var hitRectangle:Rectangle = intersectionRectangle( target1, target2 );
            if( hitRectangle.width * accuracy < 1 || hitRectangle.height * accuracy < 1 ) return new Rectangle();
            
            var bitmapData:BitmapData = new BitmapData( hitRectangle.width * accuracy, hitRectangle.height * accuracy, false, 0x000000 );    
			
            bitmapData.draw( target1, BitmapUtils.getDrawMatrix( target1, hitRectangle, accuracy ), new ColorTransform( 1, 1, 1, 1, 255, -255, -255, 255 ) );
            bitmapData.draw( target2, BitmapUtils.getDrawMatrix( target2, hitRectangle, accuracy ), new ColorTransform( 1, 1, 1, 1, 255, 255, 255, 255 ), BlendMode.DIFFERENCE );
            
            var intersection:Rectangle = bitmapData.getColorBoundsRect( 0xFFFFFFFF,0xFF00FFFF );
            
            bitmapData.dispose();
            
            if( accuracy != 1 ){
                intersection.x /= accuracy;
                intersection.y /= accuracy;
                intersection.width /= accuracy;
                intersection.height /= accuracy;
            }
            
            intersection.x += hitRectangle.x;
            intersection.y += hitRectangle.y;
            
            return intersection;
        }
        
        private static function getDrawMatrix( target:DisplayObject, hitRectangle:Rectangle, accuracy:Number ):Matrix{
            var localToGlobal:Point;;
            var matrix:Matrix;
            
            var rootConcatenatedMatrix:Matrix = target.root.transform.concatenatedMatrix;
            
            localToGlobal = target.localToGlobal( new Point( ) );
            matrix = target.transform.concatenatedMatrix;
            matrix.tx = localToGlobal.x - hitRectangle.x;
            matrix.ty = localToGlobal.y - hitRectangle.y;
            
            matrix.a = matrix.a / rootConcatenatedMatrix.a;
            matrix.d = matrix.d / rootConcatenatedMatrix.d;
            if ( accuracy != 1 ) matrix.scale( accuracy, accuracy );
			
            return matrix;
        }		
		
	}
}