package sweatless.debug {

	import flash.display.DisplayObjectContainer;
	/**
	 * @author valck
	 */
	public class GetContents {
		public static function scope(p_scope:*):void {
			trace("- parent:", p_scope.parent, "name:", p_scope.parent.name, "name:", p_scope.parent.name);
			trace("--- child:", p_scope, ", name:", p_scope.name, " - length:", p_scope.numChildren);
			trace(" ");

			for (var i : uint = 0; i<p_scope.numChildren; i++) {
				if(p_scope.getChildAt(i) is DisplayObjectContainer) {
					GetContents.scope(p_scope.getChildAt(i));
				}
			}
		}
	}
}
