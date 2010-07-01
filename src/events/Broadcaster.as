package sweatless.events{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public dynamic class Broadcaster extends EventDispatcher{
		
		private static var instance : Broadcaster;
		private static var registeredEvents : Dictionary = new Dictionary();
		
		public function Broadcaster(){
			if(instance) throw new Error("Broadcaster already initialized.");
		}
		
		public static function getInstance():Broadcaster {
			if (!instance) instance = new Broadcaster();
			return instance;
		}
		
		public function getEvent(p_event:String):String {
			if(!hasEvent(p_event)) throw new Error("The event "+ toUppercase(p_event) +" doesn't exists.");
			return registeredEvents[toUppercase(p_event)];
		}
		
		public function setEvent(p_event:String): void{
			if(hasEvent(p_event)) throw new Error("The event "+ toUppercase(p_event) +" already registered.");
			registeredEvents[toUppercase(p_event)] = addEvent(toUppercase(p_event), toLowercase(p_event));
		}

		public function hasEvent(p_event:String):Boolean{
			return registeredEvents[toUppercase(p_event)] ? true : false;
		}

		public function clearEvent(p_event:String): void{
			if(!hasEvent(p_event)){
				throw new Error("The event "+ toUppercase(p_event) +" don't exists or already removed.");
			}else{
				registeredEvents[toUppercase(p_event)] = null;
				delete registeredEvents[toUppercase(p_event)];
			}
		}

		public function clearAllEvents(): void{
			for(var key:* in registeredEvents){
                registeredEvents[key] = null;
                delete registeredEvents[key];
            }
		}

		private function addEvent(p_upper : String, p_lower : String):*{
			return getInstance()[String(p_upper)] = String(p_lower);
		}
		
		private function toLowercase(p_string:String):String{
			return String(p_string.toLowerCase());
		}
		
		private function toUppercase(p_string:String):String{
			return String(p_string.toUpperCase());
		}
	}
}
