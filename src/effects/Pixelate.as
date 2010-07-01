package sweatless.effects{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import sweatless.utils.BitmapUtils;
	
	public class Pixelate{
		
		private var source : BitmapData;
		private var clone : BitmapData;
		private var pixelated : BitmapData;
		
		private var amount : Number;
		
		public function Pixelate(){
		}
		
		public function create(p_source:Bitmap, p_amount:Number=0):void{
			source = p_source.bitmapData;
			clone = BitmapUtils.convertToBitmap(p_source).bitmapData;
			
			amount = p_amount;
		}
		
		public function get pixelize():Number{
			return amount;
		}
		
		public function set pixelize(p_value:Number):void{
			amount = clone.width/p_value;
			amount>0 ? render() : null;
		}
		
		public function destroy():void{
			source.dispose();
			clone.dispose();
			pixelated.dispose();
			
			source = null;
			clone = null;
			pixelated = null;
			
			amount = 0;
		}
		
		private function render():void{
			var scale : Number = 1 / amount;
			var width : int = (scale * source.width) >= 1 ? (scale * source.width) : 1;
			var height : int = (scale * source.height) >= 1 ? (scale * source.height) : 1;
			
			var pxMtx : Matrix = new Matrix();
			pxMtx.identity();
			pxMtx.scale(scale, scale);
			
			pixelated = new BitmapData(width, height);
			pixelated.draw(clone, pxMtx);
			
			var mtx : Matrix = new Matrix();
			mtx.identity();
			mtx.scale(source.width/pixelated.width, source.height/pixelated.height);
			
			source.draw(pixelated, mtx);
		}
	}
}