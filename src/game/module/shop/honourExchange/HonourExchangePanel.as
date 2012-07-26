package game.module.shop.honourExchange {
	import flash.utils.Dictionary;
	import game.module.shop.itemVo.GoodItem;
	import game.module.shop.staticValue.ShopStaticValue;
	import game.net.core.Common;
	import game.net.data.StoC.SCStoreQuery;
	import gameui.containers.GPanel;
	import gameui.data.GPanelData;
	import gameui.skin.SkinStyle;
	import net.AssetData;

	/**
	 * @author Lv 声望兑换
	 */
	public class HonourExchangePanel extends GPanel {
		
		private var listPanel:GPanel;
		private var honourItem:GoodItem;
		private var honourGoodsListVe:Vector.<GoodItem> = new Vector.<GoodItem>();
		private var honourGoodsDic:Dictionary = new Dictionary();
		
		public function HonourExchangePanel() {
			_data = new GPanelData();
			initData();
			super(_data);
			initView();
			initEvent();
		}

		private function initData() : void {
			_data.width = 611.35;
			_data.height = 325;
			_data.bgAsset=new AssetData(SkinStyle.emptySkin);   //取消背景
		}

		private function initEvent() : void {
			Common.game_server.addCallback(0x1C0, sCStoreQuery);
		}
		private function sCStoreQuery(e:SCStoreQuery) : void {
			addListe();
		}

		private function initView() : void {
			addPanel();
			addListe();
		}

		private function addListe() : void {
			if(honourGoodsListVe.length != 0)removeMC();
			var vx:int = 0;
			var vy:int = 0;
			var goodsID:Vector.<uint> = ShopStaticValue.honourGoodsIDList;
			var goodsPir:Dictionary = ShopStaticValue.honourPriceDic;
			var max:int = goodsID.length;
			for(var i:int = 0; i < max; i++)
			{
				if(vx > 2){
					vx = 0;
					vy++;
				}
				var id:int = goodsID[i];
				var pri:int = goodsPir[id];
				honourItem = new GoodItem(id,3,2);
				honourItem.x = 5 + (honourItem.width + 3) * vx;
				honourItem.y = 5 + (honourItem.height + 3) * vy;
				honourGoodsListVe.push(honourItem);
				honourItem.setPic(pri);
				honourGoodsDic[id] = honourItem;
				listPanel.add(honourItem);			
				vx++;
			}
		}

		private function removeMC() : void {
			while (honourGoodsListVe.length > 0) {
				honourGoodsListVe[0].hide();		
				honourGoodsListVe.splice(0, 1);
			}
		}

		private function addPanel() : void {
			var data:GPanelData = new GPanelData();
			data.width = 611.35-11;
			data.height = 320;
			data.x = data.y = 5;
			data.bgAsset=new AssetData(SkinStyle.emptySkin);   //取消背景
			listPanel = new GPanel(data);
			_content.addChild(listPanel);
		}
	}
}
