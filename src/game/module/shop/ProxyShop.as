package game.module.shop
{
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.module.shop.staticValue.ShopStaticValue;
	import game.net.core.Common;
	import game.net.data.StoC.SCStoreQuery;
	import game.net.data.StoC.SCStoreQuery.StoreItem;

	import flash.utils.Dictionary;


	/**
	 * @author Lv 
	 */
	public class ProxyShop
	{
		public function ProxyShop()
		{
			Common.game_server.addCallback(0x1C0, sCStoreQuery);
		}
		private var honourUintListID : Vector.<uint>;
		private var honourPir : Dictionary;

		private var hotGoodsList : Vector.<uint>;
		private var hotPicDic : Dictionary;

		private var hotComlist : Vector.<uint>;
		private var hotccomPicDic : Dictionary;

		private var strengthVec : Vector.<uint>;
		private var strengthDic : Dictionary;

		private var comVec : Vector.<uint>;
		private var comdic : Dictionary;

		// 商店获取物品及物品价格
		private function sCStoreQuery(e : SCStoreQuery) : void
		{
			var honourList : Vector.<StoreItem> = e.storeItems;
			honourUintListID= ShopStaticValue.honourGoodsIDList;
			honourPir= ShopStaticValue.honourPriceDic;

			hotGoodsList= ShopStaticValue.hotStrGoodsVec;
			hotPicDic= ShopStaticValue.hotStrGoodsPicDic;

			hotComlist= ShopStaticValue.hotConsumGoodsVec;
			hotccomPicDic= ShopStaticValue.hotConsumPicDic;

			strengthVec= ShopStaticValue.strengthGoodsVec;
			strengthDic= ShopStaticValue.strenghtGoodsDic;

			comVec= ShopStaticValue.consumablesGoodsVec;
			comdic= ShopStaticValue.consumablesGoodsDic;
			
//			if(hotComlist.length>0||comVec.length>0)removeMC();
			removeMC();
			for each (var i:StoreItem in honourList)
			{
				var goodType : int = i.itemId >> 28;
				var goodID : int = i.itemId & 0xFFFF;
				var goodPir : int = i.itemPrice1;
				var item : Item = ItemManager.instance.newItem(goodID);
				if(!item)continue;
				if (goodType == 2)// 声望
				{
					honourUintListID.push(goodID);
					honourPir[goodID] = goodPir;
				}
				else if (goodType == 0)
				{
					if(!item)return;
					// 热卖
					if (item.topType == Item.EXPEND)
					{
						hotComlist.push(goodID);
						hotccomPicDic[goodID] = goodPir;
					}
					else if (item.topType == Item.ENHANCE)
					{
	//=========================修改过========================================================================			
//						hotGoodsList.push(goodID);
//						hotPicDic[goodID] = goodPir;
						
						hotComlist.push(goodID);
						hotccomPicDic[goodID] = goodPir;
					}
				}
				else if (goodType == 1)
				{
					// 其他物品
					if (item.topType == Item.EXPEND)
					{
						// 消耗品
						comVec.push(goodID);
						comdic[goodID] = goodPir;
						
					}
					else if (item.topType == Item.ENHANCE)// 强化
					{
						strengthVec.push(goodID);
						strengthDic[goodID] = goodPir;
					}
				}
			}
		}

		private function removeMC() : void {
			while(honourUintListID.length>0){
				honourUintListID.splice(0, 1);
			}
			while(hotGoodsList.length>0){
				hotGoodsList.splice(0, 1);
			}
			while(hotComlist.length>0){
				hotComlist.splice(0, 1);
			}
			while(strengthVec.length>0){
				strengthVec.splice(0, 1);
			}
			while(comVec.length>0){
				comVec.splice(0, 1);
			}
			
			
			for each(var k:String in honourPir){
				delete honourPir[k];
			}
			for each(var k1:String in hotPicDic){
				delete hotPicDic[k1];
			}
			for each(var k2:String in hotccomPicDic){
				delete hotccomPicDic[k2];
			}
			for each(var k3:String in strengthDic){
				delete strengthDic[k3];
			}
			for each(var k4:String in comdic){
				delete comdic[k4];
			}
		}
	}
}
