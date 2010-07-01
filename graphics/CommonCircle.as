package sweatless.graphics{
	
	public class CommonCircle extends CommonGraphic{
		
		public function CommonCircle(){
		}
		
		override protected function addGraphic():void{
			graphics.drawEllipse(0, 0, width, height);
		}
	}
}
