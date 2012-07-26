package game.module.formation.formationManage {
	/**
	 * @author Lv
	 */
	public class FMMProp {
		public var name:String;
		public var vaule:int;
		public function parse(arr:Array):void
		{
			if (arr.length < 2)
				throw (Error("parseProperty错误"));
			name = arr[0];
			vaule = arr[1];
		}
	}
}
