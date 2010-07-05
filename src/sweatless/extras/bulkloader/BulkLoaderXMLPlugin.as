package sweatless.extras.bulkloader{
    import br.com.stimuli.loading.lazyloaders.LazyBulkLoader;
    
    import sweatless.utils.StringUtils;

    dynamic public class BulkLoaderXMLPlugin extends LazyBulkLoader {

		namespace lazy_loader = "http://code.google.com/p/bulk-loader/"
        
			public var source : XML;
		
    	function BulkLoaderXMLPlugin(url : *, name : String){
    		super (url, name);
    	}
    
    	lazy_loader override function _lazyParseLoader(p_data : String) : void{
    	    var xml : XML = source = new XML(p_data);
    		
			xml..asset == undefined ? add(lazy_loader::_lazyTheURL, new Object()) : null;
			
    		for each (var asset:XML in xml..asset) {
    			add(String(asset.@url), {id:String(asset.@id), pauseAtStart:asset.@paused ? true : false});
    		}
    	}
    }
}

