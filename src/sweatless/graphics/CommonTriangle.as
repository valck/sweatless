package sweatless.graphics{
	
	public class CommonTriangle extends CommonGraphic{
		
		public function CommonTriangle(){
		}
		
		override protected function addGraphic():void{
			graphics.moveTo(width/2, 0);
			graphics.lineTo(width, height);
			graphics.lineTo(0, height);
			graphics.lineTo(width/2, 0);
		}
	}
}
