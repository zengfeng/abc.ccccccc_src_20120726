package game.module.shop.strengthen {
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import game.definition.UI;
	import game.module.shop.itemVo.GoodItem;
	import game.module.shop.loaderTimerToShap.ShopSecondsTimer;
	import game.module.shop.staticValue.ShopStaticValue;
	import game.net.core.Common;
	import game.net.data.StoC.SCStoreQuery;
	import gameui.containers.GPanel;
	import gameui.data.GPanelData;
	import gameui.data.GScrollBarData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;

	/**
	 * @author Lv  强化物品
	 */
	public class StrengthenPanel extends GPanel {
		
		private var listPanel:GPanel;
		private var strengthenItem:GoodItem;
		private var strengthenGoodsListVe:Vector.<GoodItem> = new Vector.<GoodItem>();
		private var strengthenGoodsDic:Dictionary = new Dictionary();
		
		public function StrengthenPanel() {
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
		private var goodsIDVec:Vector.<uint>	;
		private var goodsPirDic:Dictionary	;
			
		private var goodsStrIDVec:Vector.<uint>	;
		private var goodsstrPirDic:Dictionary	;
		
		private var max1:int	;
		private var max:int	;
		
		private var ix:int= 0;
		private var iy:int= 0;
		
		
		public function addListe() : void {
			oneTime = false;
			if(strengthenGoodsListVe.length != 0)removeMC();
			
			goodsIDVec	 = ShopStaticValue.strengthGoodsVec;
		    goodsPirDic	 = ShopStaticValue.strenghtGoodsDic;
			
			goodsStrIDVec	= ShopStaticValue.hotStrGoodsVec;
			goodsstrPirDic	 = ShopStaticValue.hotStrGoodsPicDic;
			
			max1	= goodsStrIDVec.length;
		 	max	= goodsIDVec.length;
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
			var id1:int = goodsStrIDVec[i];
			var pri1:int = goodsstrPirDic[id1];
			strengthenItem = new GoodItem(id1,1,0);
			strengthenItem.x = 2 + (strengthenItem.width + 2) * vx;
			strengthenItem.y = 2 + (strengthenItem.height + 4) * vy;
			strengthenItem.setHot();
			strengthenGoodsListVe.push(strengthenItem);
			strengthenGoodsDic[id1] = strengthenItem;
			strengthenItem.setPic(pri1);
			listPanel.add(strengthenItem);			
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
			strengthenItem = new GoodItem(id,1,1);
			strengthenItem.x = 2 + (strengthenItem.width + 2) * vx;
			strengthenItem.y = 2 + (strengthenItem.height + 4) * vy;
			strengthenGoodsListVe.push(strengthenItem);
			strengthenGoodsDic[id] = strengthenItem;
			strengthenItem.setPic(pri);
			listPanel.add(strengthenItem);			
			vx++;
			iy++;
		}

		private function removeMC() : void {
			while (strengthenGoodsListVe.length > 0) {
				strengthenGoodsListVe[0].hide();		
				strengthenGoodsListVe.splice(0, 1);
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
			data.x = 5;
			data.y = 37;
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
