package game.core.item.functionItem {
	/**
	 * @author Lv
	 */
	public class FunItem {
		/*主将等级*/
		public var level:int;
		/*潜力上线*/
		public var potentialUp:int;
		/*将领个数上线*/
		public var heroNumUp:int;
		/*法宝阶数上线*/
		public var sutraStepUp:int;
		/*创建家族*/
		public var greatFamUp:int;
		
		private var count : int = 0;
		public function parse(arr : Array) : void
		{
			if (!arr) return;
			level = arr[count++];
			potentialUp = arr.length > count ? arr[count++] :0;
			heroNumUp = arr.length > count ? arr[count++] :0;
			sutraStepUp = arr.length > count ? arr[count++] :0;
			greatFamUp = arr.length > count ? arr[count++] :0;
		}
	}
}
