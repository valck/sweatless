package sweatless.debug{
	import flash.utils.getQualifiedClassName;
	
	import sweatless.utils.StringUtils;

	public final class Logger{
		
		public static const DEBUG : uint = 0;
		public static const INFO : uint = 1;
		public static const WARNING : uint = 2;
		public static const ERROR : uint = 3;

		private var level : String;
		private var scope : String;
		
		public function Logger(p_scope:Object){
			scope = getQualifiedClassName(p_scope);
		}
		
		public function log(p_level:uint, ...p_message):void{
			switch (p_level){
				case Logger.DEBUG:
					level = "DEBUG";
					break;
				case Logger.INFO:
					level = "INFO";
					break;
				case Logger.WARNING:
					level = "WARNING";
					break;
				case Logger.ERROR:
					level = "ERROR";
					break;
			}
			
			message(p_message);
		}

		public function debug(p_message:String):void{
			log(Logger.DEBUG, p_message);
		}
		
		public function info(p_message:String):void{
			log(Logger.INFO, p_message);
		}
		
		public function warning(p_message:String):void{	
			log(Logger.WARNING, p_message);
		}
		
		public function error(p_message:String):void{
			log(Logger.ERROR, p_message);
		}

		private function message(...p_message):void{
			trace("["+level+" # "+scope+"]", StringUtils.replace(String(p_message), ",", " "));
		}
	}
}
