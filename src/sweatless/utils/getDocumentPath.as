package sweatless.utils{
	import flash.external.ExternalInterface;

	public function getDocumentPath():String{
		var url:String = "";
		if(ExternalInterface.available) url = ExternalInterface.call("document.URL.toString");
		return url.substr(0, url.lastIndexOf("/")+1);
	}
}