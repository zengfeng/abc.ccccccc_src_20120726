package game.module.shop.itemVo {
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.module.shop.staticValue.ShopStaticValue;
	import game.net.core.Common;
	import game.net.data.CtoS.CSStoreBuy;

	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.controls.GTextInput;
	import gameui.core.GAlign;
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.data.GTextInputData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.alert.Alert;
	import com.commUI.icon.ItemIcon;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;










	/**
	 * @author Lv
	 */
	public class GoodItem extends GPanel {
		private var honourIcon : Sprite;
		private var goldIcon : Sprite;
		private var goldBIcon : Sprite;
		private var goodsBox : Sprite;
		private var hotGoodsIMG:Sprite;
		private var goodsName : GLabel;
		private var goodsPrice : GLabel;
		private var buyBtn : GButton;
		private var enterText : GTextInput;
		private var soldIcon : Sprite;
		private var selectCurrency : int;
//		private var img:GImage;
		private var img:ItemIcon;
		// 钱币的币种   1：元宝  2：绑定元宝  3：声望
		private var goodsItem : Item;
		private var shopType : int;
		private var textInputVisibel : Boolean;
		private var grid : int;
		private var maskSp : Sprite;
		private var alertitem:AlertItem;
		private var goodsID:int;
		/**
		 * ID:物品ID
		 * icon:钱币的种类  1：元宝  2：绑定元宝  3：声望 
		 * type:商店类型
		 */
		public function GoodItem(ID : int, icon : int, type : int) {
			_data = new GPanelData();
			initData();
			goodsID = ID;
			goodsItem = ItemManager.instance.newItem(goodsID);
			selectCurrency = icon;
			shopType = type;
			super(_data);
			initView();
			initEvent();
			
		}
		private function initData() : void {
			_data.width = 190;
			_data.height = 75;
			_data.bgAsset = new AssetData(SkinStyle.emptySkin);
			// 取消背景
		}

		private function initEvent() : void {
			buyBtn.addEventListener(MouseEvent.MOUSE_DOWN, onSubmit);
			enterText.addEventListener(FocusEvent.FOCUS_OUT, listenerFocus);
			enterText.addEventListener(FocusEvent.FOCUS_IN, onfoucsIN);
			enterText.addEventListener(Event.CHANGE, oncheng);
		}


		private function oncheng(event : Event) : void {
			var textInt : Number =  Number(TextField(event.target).text);
			if(enterText.text != "")
				enterText.text = String(textInt);
			if(textInt > 999){
				enterText.text = String(999);
			}
		}

		private function onfoucsIN(event : FocusEvent) : void {
			enterText.text = "";
		}

		private function listenerFocus(event : FocusEvent) : void {
			if(enterText.text == ""||enterText.text == "0")
				enterText.text = "1";
		}

		private function onSubmit(event : MouseEvent) : void {
			var mygold:int = UserData.instance.gold + UserData.instance.goldB;
			if(mygold<(int(enterText.text) * int(goodsPrice.text))){
				StateManager.instance.checkMsg(4);
				return;
			}
			StateManager.instance.checkMsg(287,null,alertCallFun,[(int(enterText.text) * int(goodsPrice.text)),goodsItem.id,int(enterText.text)]);
		}

		//普通商店
		public function alertCallFun(type : String) : Boolean {
			switch(type) {
				case Alert.OK_EVENT:
					var cmd : CSStoreBuy = new CSStoreBuy();
					cmd.itemId = goodsItem.id;
					cmd.storeType = shopType;
					cmd.itemCount = int(enterText.text);
					Common.game_server.sendMessage(0x1C1, cmd);
					break;
				case Alert.CANCEL_EVENT:
					break;
			}
			return true;
		}

		private function initView() : void {
			addBG();
			addPanel();
			addSoldIcon();
		}

		private function addSoldIcon() : void {
			soldIcon = UIManager.getUI(new AssetData("SoldIcon"));
			soldIcon.x = 15;
			soldIcon.y = 41;
			maskSp = UIManager.getUI(new AssetData("RecruitPullItemPanel"));
			maskSp.width = 190;
			maskSp.height = 75;
			_content.addChild(maskSp);
			maskSp.visible = false;
			_content.addChild(soldIcon);
			soldIcon.visible = false;
			
			hotGoodsIMG = UIManager.getUI(new AssetData("hot​​SellIcon"));
			hotGoodsIMG.x = 0;
			hotGoodsIMG.y = 0;
			_content.addChild(hotGoodsIMG);
			hotGoodsIMG.visible = false;
		}

		// 显示已售出
		public function VisibleIcon() : void {
			soldIcon.visible = true;
			maskSp.visible = true;
		}
		// 设置单价格
		public function setPic(pic : int) : void {
			goodsPrice.text = String(pic);
		}
		public function setHot():void
		{
			hotGoodsIMG.visible = true;
		}

		private function addPanel() : void {
			var data : GLabelData = new GLabelData();
			data.textFieldFilters = [];
			if(goodsItem)
				data.text = goodsItem.htmlName;
			data.textFieldFilters = [];
			data.filters = [];
			data.x = 66.6;
			data.y = 11;
			data.textFormat.size = 12;
			goodsName = new GLabel(data);
			_content.addChild(goodsName);

			data.clone();
			data.textColor = 0x2F1F00;
			data.text = "价格：";
			data.x = 64.35;
			data.y = 26.25;
			var text1 : GLabel = new GLabel(data);
			_content.addChild(text1);

			data.clone();
			if (!textInputVisibel)
				if(goodsItem)
					data.text = String(ShopStaticValue.mysteriousShopPicDic[grid]);
			else
				if(goodsItem)
					data.text = String(goodsItem.price);
			data.x = 116;
			goodsPrice = new GLabel(data);
			_content.addChild(goodsPrice);

			var dataBtn : GButtonData = new GButtonData();
			dataBtn.labelData.text = "购买";
			dataBtn.x = 131.15;
			dataBtn.y = 47.1;
			dataBtn.width = 50;
			dataBtn.height = 22;
			buyBtn = new GButton(dataBtn);
			_content.addChild(buyBtn);

			var dataInput : GTextInputData = new GTextInputData();
			dataInput.align =new GAlign(-1,-1,-1,-1,0,-1);
			dataInput.x = 64.95;
			dataInput.y = 46.1;
			dataInput.width = 62.75;
			dataInput.height = 22;
			dataInput.restrict = "0-9";
			dataInput.maxChars = 6;
			dataInput.maxNum = 999999;
			dataInput.text = "1";
			enterText = new GTextInput(dataInput);
			_content.addChild(enterText);
			alertitem = new AlertItem();
		}

		private function addBG() : void {
			var bg : Sprite = UIManager.getUI(new AssetData(UI.SHOP_ITEM_BACKGROUND));
			bg.width = 190;
			bg.height = 75;
			_content.addChild(bg);

			honourIcon = UIManager.getUI(new AssetData(UI.MONEY_ICON_SILVERS));
			honourIcon.x = 99.4;
			honourIcon.y = 28;
			_content.addChild(honourIcon);
			honourIcon.visible = false;
			goldBIcon = UIManager.getUI(new AssetData(UI.MONEY_ICON_GOLDB));
			goldBIcon.x = 99.4;
			goldBIcon.y = 28;
			_content.addChild(goldBIcon);
			goldBIcon.visible = false;
			goldIcon = UIManager.getUI(new AssetData(UI.MONEY_ICON_GOLD));
			goldIcon.x = 99.4;
			goldIcon.y = 28;
			_content.addChild(goldIcon);
			goldIcon.visible = false;

			switch(selectCurrency) {
				case 1:
					goldIcon.visible = true;
					break;
				case 2:
					goldBIcon.visible = true;
					break;
				case 3:
					honourIcon.visible = true;
					break;
			}

			img = UICreateUtils.createItemIcon({x:11, y:15, showBg:true, showBorder:true, showNums:true, showToolTip:true});
			
			_content.addChild(img);
			img.showNums = false;
			goodsItem.binding = true;
			img.source = goodsItem;
			
		}
	}
}
