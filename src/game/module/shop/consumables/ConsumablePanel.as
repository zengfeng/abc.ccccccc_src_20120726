package game.module.shop.consumables {
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import framerate.SecondsTimer;
	import game.definition.UI;
	import game.module.shop.itemVo.GoodItem;
	import game.module.shop.loaderTimerToShap.ShopSecondsTimer;
	import game.module.shop.staticValue.ShopStaticValue;
	import game.net.core.Common;
	import game.net.data.StoC.SCStoreQuery;
	import gameui.containers.GPanel;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;

	/**
	 * @author Lv 消耗品
	 */
	public class ConsumablePanel extends GPanel {
		
		private var listPanel:GPanel;
		private var consumItem:GoodItem;
		private var consumGoodsListVe:Vector.<GoodItem> = new Vector.<GoodItem>();
		private var consumGoodsDic:Dictionary = new Dictionary();
		
		public function ConsumablePanel() {
			_data = new GPanelData();
			initData();
			super(_data);
			initView();
			initEvent();
		}

		private function initData() : void {
			_data.width = 600;
			_data.height = 358;
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
			//addListe();
		}
		private var _oneTime:Boolean = true;
		private var vx:int = 0;
		private var vy:int = 0;
		private var goodsIDVec:Vector.<uint>;
		private var goodsPirDic:Dictionary;
			
		private var goodsHotIDVec:Vector.<uint>;
		private var goodsHotPirDic:Dictionary;
		private var ix:int= 0;
		private var iy:int= 0;
		private var max1:int;
		private var max:int;
		public function addListe() : void {
			oneTime = false;
			if(consumGoodsListVe.length != 0)removeMC();
			goodsIDVec = ShopStaticValue.consumablesGoodsVec;
			goodsPirDic = ShopStaticValue.consumablesGoodsDic;
			
			goodsHotIDVec = ShopStaticValue.hotConsumGoodsVec;
			goodsHotPirDic = ShopStaticValue.hotConsumPicDic;
			
			max1 = goodsHotIDVec.length;
			max = goodsIDVec.length;
			ShopSecondsTimer.addFunction(refershTimer);
		}
		
		private function refershTimer():void{
			if(ix<max1)
				loader1(ix);
			else{
				if(iy<max)
					loader2(iy);
				else{
					ix = 0;
					iy = 0;
					vx = 0;
					vy = 0;
					ShopSecondsTimer.removeFunction(refershTimer);
				}
			}
		}
		
		private function loader1(i:int):void{
			if(vx > 2){
				vx = 0;
				vy++;
			}
			var id1:int = goodsHotIDVec[i];
			var pri1:int = goodsHotPirDic[id1];
			consumItem = new GoodItem(id1,1,0);
			consumItem.x = 2 + (consumItem.width + 2) * vx;
			consumItem.y = 2 + (consumItem.height + 4) * vy;
			consumItem.setPic(pri1);
			consumItem.setHot();
			consumGoodsListVe.push(consumItem);
			consumGoodsDic[id1] = consumItem;
			listPanel.add(consumItem);		
			vx++;
			ix++;
		}
		private function loader2(i:int):void{
			if(vx > 2){
				vx = 0;
				vy++;
			}
			var id:int = goodsIDVec[i];
			var pri:int = goodsPirDic[id];
			consumItem = new GoodItem(id,1,1);
			consumItem.x = 2 + (consumItem.width + 2) * vx;
			consumItem.y = 2 + (consumItem.height + 4) * vy;
			consumItem.setPic(pri);
			consumGoodsListVe.push(consumItem);
			consumGoodsDic[id] = consumItem;
			listPanel.add(consumItem);
			vx++;
			iy++;
		}


		private function removeMC() : void {
			while (consumGoodsListVe.length > 0) {
				consumGoodsListVe[0].hide();		
				consumGoodsListVe.splice(0, 1);
			}
		}

		private function addPanel() : void {
			
			var bg:Sprite = UIManager.getUI(new AssetData(UI.COMMON_BACKGROUND03));
			bg.width = 600;
			bg.height = 326;
			bg.y = 32;
			_content.addChild(bg);
			
			var data:GPanelData = new GPanelData();
			data.width = 600-11;
			data.height = 318;
			data.x =  5;
			data.y = 37;
			data.scrollBarData.wheelSpeed = 10;
			data.bgAsset=new AssetData(SkinStyle.emptySkin);   //取消背景
			listPanel = new GPanel(data);
			_content.addChild(listPanel);
		}

		public function get oneTime() : Boolean {
			return _oneTime;
		}

		public function set oneTime(oneTime : Boolean) : void {
			_oneTime = oneTime;
		}
	}
}