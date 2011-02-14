package sweatless.layout{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import sweatless.utils.DictionaryUtils;
	import sweatless.utils.StringUtils;

	public class Grid{
		
		private var _index : Array;
		private var _matrix : Dictionary;
		private var _columns : uint;
		private var _rows : uint;
		
		public function Grid(p_columns:uint, p_rows:uint, p_toLeft:Boolean=true, p_data:Array=null){
			_index = new Array();
			_matrix = new Dictionary(true);
			_columns = p_columns;
			_rows = p_rows;
			
			if(p_data && p_data.length>length) throw new Error("The length of data is different a total length.");
			
			for (var i:uint=0; i<length; i++){
				var row : uint;
				var column : uint;
				var position : Point = new Point();

				if(p_toLeft){
					row = (i%_columns);
					column = Math.floor(i/_columns);
					
					position.x = row;
					position.y = column;
				}else{
					row = uint(i%_rows);
					column = Math.floor(i/_rows);
					
					position.x = column;
					position.y = row;
				}
				
				_index.push(position);
				_matrix[String(position)] = p_data ? p_data[i] : null;
			}
		}

		public function get matrix():Array{
			return DictionaryUtils.toArray(_matrix).sort();
		}

		public function get index():Array{
			return _index.sort();
		}

		public function get columns():uint{
			return _columns;
		}
		
		public function set columns(p_value:uint):void{
			_columns = p_value;
		}
		
		public function get rows():uint{
			return _rows;
		}
		
		public function set rows(p_value:uint):void{
			_rows = p_value;
		}

		public function addCell(p_cell:Point, p_value:*):void{
			_matrix[String(p_cell)] = p_value;
		}
		
		public function getCell(p_cell:Point):*{
			return _matrix[String(p_cell)] == undefined ? null : _matrix[String(p_cell)];
		}
		
		public function getRow(p_row:uint):Array{
			var result : Array = new Array();
			for (var i:* in _matrix){
				String(p_row) == StringUtils.replace(StringUtils.replace(StringUtils.replace(StringUtils.replace(i, ")", ""), "y=", ""), "(x=", ""), " ", "").split(",")[1] ? result.push(_matrix[i]) : null;
			}
			return result.sort();
		}
		
		public function getColumn(p_column:uint):Array{
			var result : Array = new Array();
			for (var i:* in _matrix){
				String(p_column) == StringUtils.replace(StringUtils.replace(StringUtils.replace(i, ")", ""), "y=", ""), "(x=", "").split(",")[0] ? result.push(_matrix[i]) : null;
			}
			return result.sort();
		}
		
		public function get length():uint{
			return uint(_columns * _rows);
		}
		
		public function rearrange():void{
			
		}
		
		public function destroy():void{
			for(var key:* in _matrix){
				_matrix[key] = null;
				delete _matrix[key];
			}
			
			_index = null;
		}

	}
}