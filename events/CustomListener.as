package sweatless.events{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;

    public class CustomListener{
        private static var targetMap : Dictionary = new Dictionary();
		
        public static function addListener(p_target:IEventDispatcher, p_type:String, p_listener:Function, ...args):void{
            var targetEventMap : Dictionary;

            targetEventMap = targetMap[p_target] == undefined ? new Dictionary : targetMap[p_target];
            
            targetEventMap[p_type] = {listener:p_listener, args:args};
            targetMap[p_target] = targetEventMap;
            
            p_target.addEventListener(p_type, onEvent);
        }
        
        public static function dispatch(p_target:IEventDispatcher, p_type:String, p_data:Object=null) : void{
            p_target.dispatchEvent(new CustomEvent(p_type, p_data));
        }
        
        public static function removeListener(p_target:IEventDispatcher, p_type:String) : void{
            var targetEventMap : Dictionary = targetMap[p_target];
            
            targetEventMap[p_type] = null;
            delete targetEventMap[p_type];
            
            p_target.removeEventListener(p_type, onEvent);
        }
        
        private static function onEvent (evt:Event):void{
            var target : IEventDispatcher = evt.currentTarget as IEventDispatcher;
            
            var targetEventMap : Dictionary = targetMap[target];
            var eventType : String = evt.type;
            
            var listener : Function = targetEventMap[eventType].listener;
            var args:Array = targetEventMap[eventType].args;
            
            if (args[0] is Event) args.shift();
            
            args.unshift(evt);

            listener.apply(target, args);
        }

    }
}
