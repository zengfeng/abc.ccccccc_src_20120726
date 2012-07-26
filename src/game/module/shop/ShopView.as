package game.module.shop {
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.shop.consumables.ConsumablePanel;
	import game.module.shop.staticValue.ShopStaticValue;
	import game.module.shop.strengthen.StrengthenPanel;
	import game.net.core.Common;
	import game.net.data.CtoC.CCUserDataChangeUp;
	import game.net.data.StoC.SCPlayerInfoChange2;

	import gameui.containers.GTabbedPanel;
	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.controls.GTab;
	import gameui.core.GAlign;
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;
	import gameui.data.GTabbedPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.commUI.button.KTButtonData;
	import com.utils.StringUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * @author Lv
	 */
	public class ShopView extends GCommonWindow
	{
		//承载显示面板的容器
		public var tabelPanel : GTabbedPanel;
		//声望
		private var honourText:GLabel;
		//元宝
		private var goldText:GLabel;
		//绑定元宝
		private var goldBText:GLabel;
		//刷新按钮
		private var rechargeBtn:GButton;
		//神秘商城按钮
		private var mysteriousBtn:GButton;
		//声望面板
//		private var honourGoodsPanel:HonourExchangePanel;
		//消耗品面板
		private var consumablepaPanel:ConsumablePanel;
		//热卖面板
		//强化品面板
		private var strengthenPanel:StrengthenPanel;
		private var icon3:Sprite ;
		private var bg3:Sprite;
		private var icon1:Sprite ;
		private var icon2:Sprite ;
		private var bg2:Sprite;
		private var bg1:Sprite;
		
		
		public function ShopView()
		{
			_data = new GTitleWindowData();
			super(_data);
			initEvents();
		}
		
		override protected function initData() : void {
			_data.width = 628;
			_data.height = 431;
			_data.parent = ViewManager.instance.uiContainer;
			_data.allowDrag = true;	
			super.initData();	
		}

		private function initEvents() : void {
			Common.game_server.addCallback(0x1F,playerInfoChange2);
			Common.game_server.addCallback(0xFFF1, cCUserDataChangeUp);
		}

		private function cCUserDataChangeUp(e:CCUserDataChangeUp) : void {
			if(e.level>14)
				mysteriousBtn.visible= true;
		}
		private function onbutn(event : MouseEvent) : void {
			MenuManager.getInstance().changMenu(MenuType.VIP);
		}

		private function playerInfoChange2(e:SCPlayerInfoChange2) : void {
			changeGold();
		}

		override protected function initViews() : void
		{
			title = "商城";
			addBG();
			addMC();
			addPanel();			
			super.initViews();
		}

		private function addMC() : void {
			consumablepaPanel = new ConsumablePanel();
			strengthenPanel = new StrengthenPanel();
		}

		private function addBG() : void {
			var bg:Sprite = UIManager.getUI(new AssetData(UI.CAST_SUTRA_PANEL_BG));
			bg.x = 5;
			bg.y = 24;
			bg.width = 613;
			bg.height = 400;
			_contentPanel.addChild(bg);
		}

		private function addPanel() : void {
			var data : GTabbedPanelData = new GTabbedPanelData();
			data.x = 12;
			data.y = 0;
			data.tabData.padding = 10;
			data.tabData.gap = 2;
			data.tabData.x= -7;
			tabelPanel = new GTabbedPanel(data);
			tabelPanel.addTab("消耗品", consumablepaPanel);
			(tabelPanel.group.model.getLast() as GTab).source = consumablepaPanel.addListe();
			//tabelPanel.addTab("强化",strengthenPanel);
			//tabelPanel.group.selectionModel.index = ShopStaticValue.goToAndStopLabel;
			//tabelPanel.group.selectionModel.addEventListener(Event.CHANGE,selection_changeHandler);
			_contentPanel.addChild(tabelPanel);
			
			bg1= UIManager.getUI(new AssetData("GTextInput_disabledSkin"));
			bg1.x = 23;
			bg1.y = 394;
			bg1.width = 74;
			bg1.height = 20;
			_contentPanel.addChild(bg1);     
			icon1= UIManager.getUI(new AssetData("MoneyIcon_Gold"));
			icon1.x = 28;
			icon1.y = 397;
			_contentPanel.addChild(icon1);          
			var datatext:GLabelData = new GLabelData();
			datatext.y = 394;
			datatext.x = icon1.x +icon1.width +2;
			datatext.width = 62;
			datatext.textFieldFilters =[];
			datatext.textColor = 0x2F1F00;
			datatext.height = 22;
			datatext.text = String(UserData.instance.gold);
			goldText = new GLabel(datatext);
			_contentPanel.addChild(goldText);
			
			
			bg2= UIManager.getUI(new AssetData("GTextInput_disabledSkin"));
			bg2.x = 103;
			bg2.y = 394;
			bg2.width = 74;
			bg2.height = 20;
			_contentPanel.addChild(bg2);
			icon2= UIManager.getUI(new AssetData("MoneyIcon_GoldB"));
			icon2.x = 110;
			icon2.y = 397;
			_contentPanel.addChild(icon2);
			datatext.clone();
			datatext.x = icon2.x + icon2.width + 2;
			datatext.width = 62;
			datatext.height = 22;
			datatext.text = String(UserData.instance.goldB);
			goldBText = new GLabel(datatext);
			_contentPanel.addChild(goldBText);
			
			icon3 = UIManager.getUI(new AssetData("MoneyIcon_Silvers"));
			icon3.x = 20;
			icon3.y = 395;
			_contentPanel.addChild(icon3);
			icon3.visible = false;
			bg3= UIManager.getUI(new AssetData("GTextInput_disabledSkin"));
			bg3.x = 15;
			bg3.y = 392;
			bg3.width = 62;
			bg3.height = 20;
			_contentPanel.addChild(bg3);
			bg3.visible = false;
			
			datatext.clone();
			datatext.x = icon3.x + icon3.width + 7;
			datatext.text = String(UserData.instance.honour);
			honourText = new GLabel(datatext);
			_contentPanel.addChild(honourText);
			honourText.visible = false;
			
			var dataBtn:GButtonData = new KTButtonData(KTButtonData.SMALL_RED_BUTTON);
			dataBtn.x = 190;
			dataBtn.y = 391;
			dataBtn.width = 50;
			dataBtn.height = 24;
			rechargeBtn = new GButton(dataBtn);
			rechargeBtn.text = "充值" ;
			_contentPanel.addChild(rechargeBtn);
			dataBtn.clone();
			dataBtn.x = 530;
			dataBtn.width = 66;
			dataBtn.height = 24;
			mysteriousBtn = new GButton(dataBtn);
			mysteriousBtn.text =  "神秘商店";
		//	_contentPanel.addChild(mysteriousBtn);
		//	mysteriousBtn.visible = false;
			
			var heroLevel:int = UserData.instance.myHero.level;
		//	if(heroLevel>14)
		//		mysteriousBtn.visible= true;
			
			rechargeBtn.addEventListener(MouseEvent.MOUSE_DOWN, onbutn);
//			setTimeout(loaderMC, 20);
			
		}
//		private function loaderMC():void{
//			consumablepaPanel.addListe();
//		}
		//更新货币
		private function changeGold():void
		{
			var honor:int = UserData.instance.honour;
			var goldb:int = UserData.instance.goldB;
			var gold:int = UserData.instance.gold;
			if(honor > 10000)
				honourText.text = StringUtils.numToMillionString(honor);
			else
				honourText.text = String(UserData.instance.honour);
			if(goldb > 10000)
				goldBText.text = StringUtils.numToMillionString(goldb);
			else
				goldBText.text = String(UserData.instance.goldB);
			if(gold > 10000)
				goldText.text = StringUtils.numToMillionString(gold);
			else
				goldText.text = String(UserData.instance.gold) ;

		}

		private function selection_changeHandler(e:Event) : void {
			var n:int = e.currentTarget.index;
			if(n ==1){
				if(strengthenPanel.oneTime)
					strengthenPanel.addListe();
			}
			ChangeIndex(n);
		}

		private function ChangeIndex(n : int) : void {
			hideBGText();
			ShopStaticValue.goToAndStopLabel = n;
			if(n == 2)
			{
				//rechargeBtn.x = 105;
				icon3.visible = true;
				bg3.visible = true;
				honourText.visible = true;
			}else{
				rechargeBtn.x = 190;
				rechargeBtn.visible = true;
				icon1.visible = true;
				icon2.visible = true;
				bg1.visible = true;
				bg2.visible = true;
				goldBText.visible = true;
				goldText.visible = true;
				
			}
		}
		private function hideBGText():void{
			rechargeBtn.visible = false;
			icon1.visible = false;
			icon2.visible = false;
			bg1.visible = false;
			bg2.visible = false;
			icon3.visible = false;
			bg3.visible = false;
			honourText.visible = false;
			goldBText.visible = false;
			goldText.visible = false;
		}
			
		
		override public function show():void
		{
			this.align = new GAlign((UIManager.stage.stageWidth - this.width) / 2,-1,(UIManager.stage.stageHeight - this.height) / 2,-1);
			GLayout.layout(this);
			super.show();
			if(tabelPanel != null){
				tabelPanel.group.selectionModel.index = ShopStaticValue.goToAndStopLabel;
			}
			//initEvents();
			refreshGolds();	
			changeGold();
		}

		private function refreshGolds() : void {
			if(goldBText == null)return;
			goldText.text = String(UserData.instance.gold);
			goldBText.text = String(UserData.instance.goldB);
			honourText.text = String(UserData.instance.honour);
		}
		override public function hide():void{
			super.hide();
			//removeEvent();
		}
		
	}
}
