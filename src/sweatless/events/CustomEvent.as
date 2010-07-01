package sweatless.events{
	import flash.events.Event;
	
	public dynamic class CustomEvent extends Event{
		
		public var data : Object;
		
		public function CustomEvent(p_type:String, p_data:Object=null, p_bubbles:Boolean=false, p_cancelable:Boolean=false){
			super(p_type, p_bubbles, p_cancelable);
			
			data = p_data;
		}
		
		public override function clone():Event{
            return new CustomEvent(type, data, bubbles, cancelable);
        }
		
        public override function toString():String{
            return formatToString("CustomEvent", "type", "data", "bubbles", "cancelable");
        }
	}
}