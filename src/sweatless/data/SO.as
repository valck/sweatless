package sweatless.data{
    import flash.events.NetStatusEvent;
    import flash.net.SharedObject;
    import flash.net.SharedObjectFlushStatus;
 
    public class SO{
 
        private var saved : SharedObject;

        public function SO(p_name:String="sweatless_cookie") {
            saved = SharedObject.getLocal(p_name);
            //trace("loaded value: " + saved.data.value);
        }
 
		public function set data(p_value:String):void {
            clear();

            saved.data.value = p_value;
 
            var flushStatus:String;
 
            try{
                flushStatus = saved.flush(10000);
            } catch (error:Error) {
				
            }
 
            if(flushStatus) {
                switch (flushStatus) {
                    case SharedObjectFlushStatus.PENDING:
                        //trace("saved");
                        saved.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
                        break;
                    case SharedObjectFlushStatus.FLUSHED:
                        //trace("flushed");
                        break;
                }
            }
        }
 
		public function get data():*{
			if(!saved.data.value) return null;
			return saved.data.value;
		}
		
        public function clear():void {
            if(saved.data.value) delete saved.data.value;
        }
		
        private function onFlushStatus(event:NetStatusEvent):void {
            switch (event.info.code) {
                case "SharedObject.Flush.Success":
                    //trace("value saved");
                    break;
                case "SharedObject.Flush.Failed":
                    //trace("value not saved");
                    break;
            }
			
            saved.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
        }
    }
}	