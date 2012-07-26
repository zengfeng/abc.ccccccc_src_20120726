package game.module.wordDonate {
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.wordDonate.donateManage.DonateRewardManager;
	import game.net.core.Common;
	import game.net.data.CtoS.CSDonateList;

	import gameui.controls.GLabel;
	import gameui.core.GAlign;
	import gameui.data.GLabelData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.commUI.pager.Pager;
	import com.commUI.pager.PagerCell;
	import com.commUI.tips.PlayerTip;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.greensock.layout.AlignMode;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;


	/**
	 * @author Lv
	 */
	public class ContributionList extends GCommonWindow {
		private var myRank:TextField;
		private var thisWeek:TextField;
		private var page:Pager;
		private var listItem:Vector.<ContributionItem> = new Vector.<ContributionItem>();
		public function ContributionList() {
			_data = new GTitleWindowData();
			super(_data);
			initEvents();
		}
		
		override protected function initData() : void {
			_data.width = 322;
			_data.height = 365;
			_data.parent = ViewManager.instance.uiContainer;
			_data.panelData.bgAsset = new AssetData(SkinStyle.emptySkin);
			_data.allowDrag = true;	
			super.initData();	
		}

		private function initEvents() : void {
			page.addEventListener(Event.CHANGE, onGetList);
		}
		
		override protected function onClickClose(event : MouseEvent) : void
        {
			MenuManager.getInstance().changMenu(MenuType.DONATECONTRIBUTION);
			DonateControl.instance.setupDonateUI();
        }
		private var nowPage:int = 1;
		private function onGetList(event : Event) : void {
			var totalPage:int;
			if(DonateProxy.contributionNum!=0)
				totalPage = Math.ceil(DonateProxy.contributionNum/10);
			else
				totalPage = 1;
			nowPage = page.model.page;
			page.setPage(nowPage,totalPage);
			var cmd:CSDonateList = new CSDonateList();
			cmd.page = nowPage;
			Common.game_server.sendMessage(0x103,cmd);
			refreshPage();
		}
		
		override protected function initViews() : void
		{
			title = "贡献排行榜";	
			super.initViews();
			addBG();
			addPanel();
		}

		private function addBG() : void {
			var bg:Sprite = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
			bg.x = 5;
			bg.y = 3;
			bg.width = 307;
			bg.height = 357;
			_contentPanel.addChild(bg);
		}
		private var listDic:Dictionary = new Dictionary();
		public function setList():void{
			clearnItem();
			if(DonateProxy.nowWeekRank == 0)
				myRank.htmlText = "我的排名：未贡献";
			else
				myRank.htmlText = "我的排名：" +String(DonateProxy.nowWeekRank);
			thisWeek.htmlText = "本周贡献：" + String(DonateProxy.nowWeekContributionVaule) + " 个";
			var list:Vector.<Object> = DonateProxy.contributionRank;
			var isTrue:Boolean;
			for(var i:int = 0 ; i<list.length; i++){
				var obj:Object = list[i];
				var id:int = obj["id"];
				var name:String = obj["name"];
				var level:int = obj["level"];
				var contr:uint = obj["vaule"];
				var color:uint = obj["color"];
				var rank:int = 10*(nowPage-1) + (i+1);
				listItem[i].setContent(rank, name, level, contr,id,color);
				listItem[i].mouseEnabled = true;
				listItem[i].mouseChildren = true;
				if(i == 1||i==3||i==5||i==7||i==9)
					isTrue = true;
				else
					isTrue = false;
				listItem[i].setBgAlpha(isTrue);
				
				if(id == UserData.instance.playerId){
					listItem[i].setBackGround();
				}
				listDic[listItem[i].nameStr.text] = listItem[i];
				var maxRank:int = DonateRewardManager.saveDonateRewardMaxRank;
				var str:String = "";
				if(rank < maxRank)
					str = DonateRewardManager.saveDonateRewardDic[rank];
				else
					str = DonateRewardManager.saveDonateRewardDic[maxRank];
				str = str.split("：")[1];
//				str = "排名：<font color='#FFF000'>"+rank+"</font>\n每周奖励：\n" + str.split("、")[0] +"、"+ str.split("、")[1];
				str = "排名：<font color='#FFF000'>"+rank+"</font>\n每周奖励：\n" + str;
				str = StringUtils.addSize(StringUtils.addBold(StringUtils.addColorById(name, color)),14) + StringUtils.addSize(StringUtils.addBold(StringUtils.addColorById( " "+level+"级" , color)),14)+"\n\n"+str+"\n\n"+"<font color='#999999'>在周日24:00结算排名奖励 </font>";
				ToolTipManager.instance.registerToolTip(listItem[i], ToolTip, str);
			}
		}
		
		private function clearnItem():void{
			for each(var item:ContributionItem in listItem){
				item.mouseEnabled = false;
				item.mouseChildren = false;
				item.clearAll();
			}
			for(var K:String in listDic) {
				delete listDic[K];
			}
		}
		
		public function refreshPage():void{
			var totalPage:int;
			if(DonateProxy.contributionNum!=0)
				totalPage = Math.ceil(DonateProxy.contributionNum/10);
			else
				totalPage = 1;
			if(nowPage == 0)
				nowPage = 1;
			page.setPage(nowPage, totalPage);
			var w:Number = page.width;
			page.x = (322 -  w) -12;
		}

		private function addPanel() : void {			
			myRank = UICreateUtils.createTextField(null, "我的排名:", 141, 25,0,10, new TextFormat(null,null,"0x2F1F00",null,null,null,null,null,TextFormatAlign.CENTER));
			
			thisWeek = UICreateUtils.createTextField(null, "本周贡献:", 141, 25,161,10, new TextFormat(null,null,"0x2F1F00",null,null,null,null,null,TextFormatAlign.CENTER));
			
			_contentPanel.addChild(thisWeek);
			_contentPanel.addChild(myRank);
			
			var totalPage:int;
			if(DonateProxy.contributionNum!=0)
				totalPage = Math.ceil(DonateProxy.contributionNum/10);
			else
				totalPage = 1;
			page = new Pager(5,true);
			page.setPage(nowPage, totalPage);
			page.y = 332;
			page.x = 322 -  page.width-12;
			_contentPanel.addChild(page);
			
			var title:ContributionItem = new ContributionItem();
			title.getTitle();
			title.x = 9;
			title.y = 38;
			_contentPanel.addChild(title);
			var item:ContributionItem;
			var isTrue:Boolean = true;
			for(var i:int =0; i<10; i++){
				item = new ContributionItem();
				item.x = 9;
				item.y = 65 + (item.height+1)*i;
				if(i == 1||i==3||i==5||i==7||i==9)
					isTrue = true;
				else
					isTrue = false;
				item.setBgAlpha(isTrue);
				listItem.push(item);
				_contentPanel.addChild(item);
				item.mouseEnabled = false;
				item.mouseChildren = false;
				item.nameStr.addEventListener(MouseEvent.CLICK, ondown);
			}
		}

		private function ondown(event : MouseEvent) : void {
			var str:String = event.currentTarget["text"] as String;
			var item:ContributionItem = listDic[str];
			var id:int = item.playerID;
			var myID:int = UserData.instance.playerId;
			if(id == myID)return;
			var name:String = item.nameStr.text;
			PlayerTip.show(id,name,[PlayerTip.NAME_SHISPER,PlayerTip.NAME_TRADE,PlayerTip.NAME_ADD_FRIEND,PlayerTip.NAME_INVITE_CLAN,PlayerTip.NAME_COPY_PLAYER_NAME,PlayerTip.NAME_LOOK_INFO,PlayerTip.NAME_MOVE_TO_BACKLIST]);
		}

		override public function hide():void{
			this.align = new GAlign((UIManager.stage.stageWidth - this.width) / 2,-1,(UIManager.stage.stageHeight - this.height) / 2,-1);
			super.hide();
		}
		override public function show():void{
			this.align = new GAlign((UIManager.stage.stageWidth - this.width) / 2,-1,(UIManager.stage.stageHeight - this.height) / 2,-1);
			super.show();
		}
	}
}
