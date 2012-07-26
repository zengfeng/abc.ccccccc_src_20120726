package game.module.wordDonate.donateManage {
	/**
	 * @author 1
	 */
	public class DonateVo {
		//开天斧的等级
		public var level:int;
		//所需经验值
		public var expVaule:uint;
		//总经验值
		public var expTotalVaule:uint;
		//挂机经验提升(%)
		public var percentageUp:uint;
		public function parse(arr:Array):void{
			level = arr[0];
			expVaule = arr[1];
			expTotalVaule = arr[2];
			percentageUp = arr[3];
		}
	}
}
