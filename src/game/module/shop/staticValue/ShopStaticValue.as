package game.module.shop.staticValue
{
	import flash.utils.Dictionary;

	/**
	 * @author Lv
	 */
	public class ShopStaticValue
	{
		// 控制跳转那个标签
		public static var goToAndStopLabel : int = 0;
		// 拥有的声望总数
		public static var haveHonour : int;
		// 拥有的元宝总数
		public static var haveGold : int;
		// 拥有的绑定元宝总数
		public static var haveGoldB : int;
		// 声望兑换的物品列表 存储物品ID
		public static var honourGoodsIDList : Vector.<uint> = new Vector.<uint>();
		// 声望兑换物品的单品价格
		public static var honourPriceDic : Dictionary = new Dictionary();
		// 物品alert提示是否打开
		public static var goodsAlertIsOpn : Boolean = false;
		// 神秘商店的物品列表  存储物品ID
		public static var mysteriousShopGoodsIDVe : Vector.<uint> = new Vector.<uint>();
		// 神秘商店物品单价  K：物品id
		public static var mysteriousShopPicDic : Dictionary = new Dictionary();
		// 强化物品列表 存储物品ID
		public static var strengthGoodsVec : Vector.<uint> = new Vector.<uint>();
		// 强化物品单价  K：物品id
		public static var strenghtGoodsDic : Dictionary = new Dictionary();
		// 热卖强化物品列表 存储物品ID
		public static var hotStrGoodsVec : Vector.<uint> = new Vector.<uint>();
		// 热卖强化物品售价  k:物品id
		public static var hotStrGoodsPicDic : Dictionary = new Dictionary();
		// 热卖消耗物品列表  存储物品ID
		public static var hotConsumGoodsVec : Vector.<uint> = new Vector.<uint>();
		// 热卖消耗物品单价  k:物品id
		public static var hotConsumPicDic : Dictionary = new Dictionary();
		// 消耗品列表  存储物品ID
		public static var consumablesGoodsVec : Vector.<uint> = new Vector.<uint>();
		// 消耗物品单价  K:物品ID
		public static var consumablesGoodsDic : Dictionary = new Dictionary();
		// 当前申请物品
		public static var submitGoodsB : Boolean = true;

		public function ShopStaticValue() : void
		{
		}

		/**
		 * 通过物品id获取物品单价 物品不存在返回0
		 * id：商品id
		 */
		public static function getGoodsPic(id : int) : int
		{
			var pic : int;
			if (strenghtGoodsDic[id] != null)
			{
				pic = strenghtGoodsDic[id];
			}
			else if (hotStrGoodsPicDic[id] != null)
			{
				pic = hotStrGoodsPicDic[id];
			}
			else if (hotConsumPicDic[id] != null)
			{
				pic = hotConsumPicDic[id];
			}
			else if (consumablesGoodsDic[id] != null)
			{
				pic = consumablesGoodsDic[id];
			}
			else
			{
				pic = 0;
			}
			return pic;
		}

		/**
		 * 通过物品id判断该物品是否存在
		 * id: 物品id
		 */
		public static function getGoodsIsPresent(id : int) : Boolean
		{
			if (strenghtGoodsDic[id] != null)
			{
				return true;
			}
			else if (hotStrGoodsPicDic[id] != null)
			{
				return true;
			}
			else if (hotConsumPicDic[id] != null)
			{
				return true;
			}
			else if (consumablesGoodsDic[id] != null)
			{
				return true;
			}
			return false;
		}
	}
}
