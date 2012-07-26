package game.core.user
{
	/**
	 * @author 1
	 */
	public class VoFunction
	{
		// 将领等级
		public var heroLevel : int;
		// 潜力上线
		public var potentialOnLine : int;
		// 武将数量上线
		public var heroNumOnLine : int;
		// 法宝阶数上线
		public var sutraStepOnLine : int;
		
		private var count : int = 0;

		public  function VoFunction() : void
		{
		}

		public function parse(arr : Array) : void
		{
			if (!arr) return;
			heroLevel = arr[count++];
			potentialOnLine = arr.length > count ? arr[count++] : 0;
			heroNumOnLine = arr.length > count ? arr[count++] : 0;
			sutraStepOnLine = arr.length > count ? arr[count++] : 0;
		}
	}
}
