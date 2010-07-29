package sweatless.graphics{
	
	public class CommonRectangle extends CommonGraphic{
		
		private var TLCorner : Number = 0;
		private var TRCorner : Number = 0;
		private var BLCorner : Number = 0;
		private var BRCorner : Number = 0;
		
		public function CommonRectangle(){
		}
		
		override protected function addGraphic():void{
			graphics.drawRoundRectComplex(0, 0, width, height, topLeftCorner, topRightCorner, bottomLeftCorner, bottomRightCorner);
		}
		
		public function set bothCorners(p_value:Number):void{
			TLCorner = p_value;
			TRCorner = p_value;
			BLCorner = p_value;
			BRCorner = p_value;
			update();
		}
		
		public function set topLeftCorner(p_value:Number):void{
			TLCorner = p_value;
			update();
		}
		
		public function get topLeftCorner():Number{
			return TLCorner;
		}
		
		public function set topRightCorner(p_value:Number):void{
			TRCorner = p_value;
			update();
		}
		
		public function get topRightCorner():Number{
			return TRCorner;
		}
		
		public function set bottomLeftCorner(p_value:Number):void{
			BLCorner = p_value;
			update();
		}
		
		public function get bottomLeftCorner():Number{
			return BLCorner;
		}
		
		public function set bottomRightCorner(p_value:Number):void{
			BRCorner = p_value;
			update();
		}
		
		public function get bottomRightCorner():Number{
			return BRCorner;
		}
	}
}
