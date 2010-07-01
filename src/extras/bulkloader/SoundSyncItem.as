/**
 *	BulkLoader.registerNewType("mp3", "soundsync", SoundSyncItem);
 * 			 
 */

package sweatless.extras.bulkloader{
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	import sweatless.media.sound.SoundSync;
	
	public class SoundSyncItem extends LoadingItem {
        public var loader : SoundSync;
        
		public function SoundSyncItem(url : URLRequest, type : String, uid : String){
		    specificAvailableProps = [BulkLoader.CONTEXT];

			super(url, type, uid);
		}
		
		override public function _parseOptions(props : Object)  : Array{
		    _context = props[BulkLoader.CONTEXT] || null;
		    
            return super._parseOptions(props);
        }
        
		override public function load() : void{
		    super.load();
			
		    loader = new SoundSync();
		    loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            loader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
            loader.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false, 0, true);
            
			try{
            	loader.load(url, _context);
            }catch( e : SecurityError){
            	onSecurityErrorHandler(_createErrorEvent(e));
            }
		};
		
		override public function onStartedHandler(evt : Event) : void{
            _content = loader;
            super.onStartedHandler(evt);
        };
        
        override public function onErrorHandler(evt : ErrorEvent) : void{
            super.onErrorHandler(evt);
        }
        
        override public function onCompleteHandler(evt : Event) : void {
            _content = loader
            super.onCompleteHandler(evt);
        };
        
        override public function stop() : void{
            try{
                if(loader) loader.close();
            }catch(e : Error){
                
            }

			super.stop();
        };
        
        override public function cleanListeners() : void {
            if (loader){
                loader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
                loader.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
                loader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
                loader.removeEventListener(BulkLoader.OPEN, onStartedHandler, false);
                loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false);
            }
            
        }
        
        override public function isStreamable(): Boolean{
            return true;
        }
        
        override public function isSound(): Boolean{
            return true;
        }
        
        override public function destroy() : void{
            cleanListeners();
            stop();
            _content = null;
            loader = null;
        }
	}
}
