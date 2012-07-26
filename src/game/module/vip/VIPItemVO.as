package game.module.vip
{
	/**
	 * @author ME
	 */
	public class VIPItemVO
	{
		public var name : String;
		/** -1：未开启，0：开启，无次数，>=1：开启，有次数 **/
		public var currState : String;
		public var nextState : String;
		/** 选择每个cell的背景，0为浅色，1为深色 **/
		public var bgInt : int;
		/** 下一等级VIP的特权的内容与当前VIP等级有变化时，“开启”文字或者开启数量文字会赋上指定红色 **/
		public var nextLevelColor : uint;
		/** 列表条目数量 **/
		public var vipListNum : int;
	}
}
