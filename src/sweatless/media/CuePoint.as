package sweatless.media
{
	internal class CuePoint{
		private var _id : String;
		private var _time : String;
		
		public function CuePoint(p_id:String, p_time:String){
			id = p_id;
			time = p_time;
		}
		
		public function get time():String{
			return _time;
		}
		
		public function set time(value:String):void{
			_time = value;
		}
		
		public function get id():String{
			return _id;
		}
		
		public function set id(value:String):void{
			_id = value;
		}
		
	}
}