package game.core.item.prof {
	/**
	 * @author Lv
	 */
	public class ProfItem {
		/*阶数*/
		public var step:Number;
		/*修为值*/
		public var proValue:Number;
		/*累计修为值*/
		public var totalProValue:Number;
		
		private var count : int = 0;
		public function parse(arr : Array) : void
		{
			if (!arr) return;
			step = arr[count++];
			proValue = arr.length > count ? arr[count++] :0;
			totalProValue = arr.length > count ? arr[count++] :0;
		}
	}
}
