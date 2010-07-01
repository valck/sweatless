package sweatless.transitions{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import sweatless.effects.Pixelate;
	import sweatless.utils.BitmapUtils;
	
	public class Pixelize{
		public static function start(p_of:DisplayObject, p_to:DisplayObject):void{
			var scopeOut : DisplayObjectContainer = p_of.parent;
			var scopeIn : DisplayObjectContainer = p_to.parent;
			
			var bmpOut : Bitmap = BitmapUtils.convertToBitmap(p_of, 0, true);
			var bmpIn : Bitmap = BitmapUtils.convertToBitmap(p_to, 0, false);
			
			var fxIn : Pixelate = new Pixelate();
			fxIn.create(bmpIn, bmpIn.width);
			scopeIn.parent.addChild(bmpIn);
			
			var fxOut : Pixelate = new Pixelate();
			fxOut.create(bmpOut, bmpOut.width);
			scopeOut.parent.addChild(bmpOut);
			
			TweenMax.to(fxOut, 2,{
				pixelize:10,
				onComplete:fxOut.destroy
			});
			
			TweenMax.to(bmpOut, 2,{
				alpha:0,
				delay:1.5
			});
			
			TweenMax.to(fxIn, 2,{
				pixelize:10,
				yoyo:true,
				repeat:1,
				onComplete:fxIn.destroy
			});
		}
	}
}