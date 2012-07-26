package game.module.formation.formationManage {
	import flash.geom.Point;
	/**
	 * @author Lv
	 */
	public class VoFM {
		//阵形id
		public var fm_id:int;
		//阵形名称
		public var fm_name:String;
		//阵形等级
		public var fm_level:int;
		//阵型开放等级
		public var fm_shwoLevel:int;
		//阵形1级的位置
		public var fm_Point1Vec:Vector.<Point> = new Vector.<Point>();
		//阵形2级的位置
		public var fm_Point2Vec:Vector.<Point> = new Vector.<Point>();
		/**跳转帧**/
		public  var fm_frameArr : Array = new Array();
		/**阵形效果**/
		public var fm_Effect:String;
		/**阵眼效果**/
		public var fm_eyeEffEct:String;	
		
		public function parse(xml : XML) : void
		{
			if (xml.@id == undefined) return;
			fm_id = xml.@id;
			fm_name = xml.@name;
			fm_level = xml.@level;
			fm_shwoLevel = xml.@showLevel;
			var level1:String = xml.@level1;
			var level2:String = xml.@level2;
			var frame : String = xml.@frame;
			fm_Effect = xml.@formation1;
			fm_eyeEffEct = xml.@formation2;
			
			fm_Point1Vec = changeStrToPoint(level1,fm_Point1Vec);
			fm_Point2Vec = changeStrToPoint(level2,fm_Point2Vec);
			fm_frameArr = changeStrToArr(frame,fm_frameArr);
		}
		//frame解析
		private function changeStrToArr(str : String, Arr : Array) : Array {
			var n : int = str.split(",").length;
			Arr = str.split(",",n);
			return Arr;
		}
		//位置解析
		private function changeStrToPoint(str : String, vec : Vector.<Point>) : Vector.<Point> {
			var arr:Array = new Array();
			var n : int = str.split("|").length;
			arr = str.split("|",n);
			for each(var poinStr:String in arr){
				var x:int = int(poinStr.split(",")[0]);
				var y:int = int(poinStr.split(",")[1]);
				var pot:Point = new Point(x,y);
				vec.push(pot);
			}
			return vec;
		}
	}
}
