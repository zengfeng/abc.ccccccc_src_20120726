package game.module.compete {
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.core.menu.IMenu;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.module.chat.ManagerChat;
	import game.net.core.Common;
	import game.net.data.CtoS.CSAthleticsHistory;
	import game.net.data.CtoS.CSAthleticsQuery;
	import game.net.data.StoC.SCAthleticsChallenge;
	import game.net.data.StoC.SCAthleticsHistory;
	import game.net.data.StoC.SCAthleticsHistory.AthleticsRecord;
	import game.net.data.StoC.SCAthleticsQuery;
	import game.net.data.StoC.SCAthleticsQuery.AthleticsPlayer;

	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.core.GAlign;
	import gameui.data.GPanelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.LibData;

	import com.commUI.MoneyBoard;
	import com.commUI.button.KTButtonData;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;








	/**
	 * @author zheng
	 */
	public class CompeteView extends GPanel implements IModuleInferfaces, IAssets, IMenu
	{
		// =====================
		// @定义
		// =====================
		public static const startN : int = 81;

		public static const endN : int = 86;
		// =====================
		// @属性
		// =====================
		// ------------------------------------------------
		// View
		// ------------------------------------------------
		private var _UserList : UserList;
		private var _goldInfo : GoldInfo;
		private var _battledata : BattleInfo;
		private var _compete_bg : Sprite;
		private var bg_huazhou_left : Sprite;
		private var bg_huazhou_right : Sprite;
		private var bg_infotitle_backgroud : Sprite;
		private var loadInfo_data : GPanelData;
		private var _moneyBoard : MoneyBoard;
		private var _exitButton : GButton;
		// ------------------------------------------------
		// Control
		// ------------------------------------------------
		private var _loaded : Boolean = false;
		// ------------------------------------------------
		// Model
		// ------------------------------------------------
		private var _competePlayers:Array /* of VoCompetePlayer */;


		// =====================
		// @创建
		// =====================
		public function CompeteView()
		{
			_data = new GPanelData();
			_data.x = 0;
			_data.y = 0;
			_data.verticalScrollPolicy=GPanelData.OFF;
			_data.horizontalScrollPolicy=GPanelData.OFF;
			_data.width=UIManager.stage.stageWidth;
			_data.height=UIManager.stage.stageHeight;
			_data.bgAsset = new AssetData(UI.COMPETE_BLACK_BACKGOUND);
			_data.parent = ViewManager.instance.getContainer(ViewManager.FULL_SCREEN_UI);
			_data.align = new GAlign(0, 0, 0, 0);
//			initData();
			super(_data);
		}
		override protected function create() : void
		{
			super.create();
		}


		private function initEvents() : void
		{
			Common.game_server.addCallback(0x1A0, updateUserHead);
			// 监听排名信息
			Common.game_server.addCallback(0x1A2, getBattleData);
			// 监听战斗信息
			Common.game_server.addCallback(0x1A1, updatabattleover);
			// 监听战斗结束信息
			var cmd : CSAthleticsQuery = new CSAthleticsQuery();
			Common.game_server.sendMessage(0x1A0, cmd);
			var cmd1 : CSAthleticsHistory = new CSAthleticsHistory();
			Common.game_server.sendMessage(0x1A2, cmd1);
		}

		private function addBg() : void
		{
			_compete_bg = new Sprite();
            _compete_bg =UIManager.getUI(new AssetData("competeBg", "compete"));
		    _compete_bg.x = (UIManager.stage.stageWidth - _compete_bg.width) / 2;
			_compete_bg.y = (UIManager.stage.stageHeight - _compete_bg.height) / 2;
			_content.addChildAt(_compete_bg, 0);
		}

		private function addTopBg() : void
		{
			// 画轴背景
			bg_huazhou_left = UIManager.getUI(new AssetData(UI.COMPETE_HUAZHOU,"compete"));
			bg_huazhou_left.width = 28.8;
			bg_huazhou_left.height = 307.45;
			_content.addChild(bg_huazhou_left);

			bg_huazhou_right = UIManager.getUI(new AssetData(UI.COMPETE_HUAZHOU,"compete"));
			bg_huazhou_right.width = 28.8;
			bg_huazhou_right.height = 307.45;
			bg_huazhou_right.scaleX *= -1;
			_content.addChild(bg_huazhou_right);
			_moneyBoard = new MoneyBoard();
			_content.addChild(_moneyBoard);

			// 信息背景
			bg_infotitle_backgroud = UIManager.getUI(new AssetData(UI.COMPETE_INFOTITLE_BACKGROUND,"compete"));
			bg_infotitle_backgroud.width = 581;
			bg_infotitle_backgroud.height = 43;
			_content.addChildAt(bg_infotitle_backgroud, 0);
		}

		private function addButton() : void
		{
            _exitButton = UICreateUtils.createGButton(null, 0, 0, 20, 20, KTButtonData.EXIT_BUTTON);
			addChild(_exitButton);
		}

		private function addPanel() : void
		{
			// 战斗信息面板
			var battleinfo_data : GPanelData = new GPanelData();
			battleinfo_data.parent = this._content;
			battleinfo_data.align = new GAlign(-1, -1, -1, -1, 350, 200);
			_battledata = new BattleInfo(battleinfo_data);
			_battledata.show();

			// 创建英雄列表
			var UserList_data : GPanelData = new GPanelData();
			UserList_data.parent = this._content;
			UserList_data.align = new GAlign(-1, -1, -1, -1, 1, -80);
			_UserList = new UserList(UserList_data);
			_UserList.show();

			// 竞技场战斗信息

			loadInfo_data = new GPanelData();
			loadInfo_data.parent = this._content;
			_goldInfo = new GoldInfo(loadInfo_data);
			_goldInfo.show();
		}

		// =====================
		// @刷新
		// =====================
        override protected function onShow() : void
		{
			_exitButton.addEventListener(MouseEvent.CLICK, onOutPanel);
			var cmd : CSAthleticsQuery = new CSAthleticsQuery();
			Common.game_server.sendMessage(0x1A0, cmd);
			MenuManager.getInstance().setShowList([MenuType.HERO_PANEL, MenuType.PACK, 3, 4, 5, 6, 7]);
			
			
			this.addChild(MenuManager.getInstance().getMenu());
			ManagerChat.instance.moveViewToUIContainer();
			layout();		
		}
		
		override protected function onHide():void
		{
				
			_exitButton.removeEventListener(MouseEvent.CLICK, onOutPanel);

			this.removeChild(MenuManager.getInstance().getMenu());
			MenuManager.getInstance().setShowList();
			ViewManager.instance.uiContainer.addChild(MenuManager.getInstance().getMenu());
		    ManagerChat.instance.moveViewToAutoContainer();
			MenuManager.getInstance().getMenu().x = UIManager.stage.stageWidth - MenuManager.getInstance().getMenu().width;
			MenuManager.getInstance().getMenu().y = UIManager.stage.stageHeight - MenuManager.getInstance().getMenu().height;
		}


		private function updateUserHead(query : SCAthleticsQuery) : void
		{
			var i : int = 0;

			VoCompete.voPlayer = new Vector.<AthleticsPlayer>();
              _competePlayers=new Array();
			/////////////////测试用///////////////////
			//todo 测试用
			 while (i < query.players.length)
			 {
                var playerVO:VoCompetePlayer=new VoCompetePlayer();
				
				playerVO.playName = query.players[i].name;
				playerVO.playerRank = query.players[i].rank;
				playerVO.playerColor = query.players[i].color;
				playerVO.playerJop = query.players[i].job;
				playerVO.playerLevel = query.players[i].level;
				playerVO.battlePoints = query.players[i].battlePoints;
				
//				var bp:int=playerVO.battlePoints;
				_competePlayers.push(playerVO);
				i++;				
			 }
			  var playerVO1:VoCompetePlayer=new VoCompetePlayer(); 
			  var _userData:UserData=UserData.instance;
			    playerVO1.playName =_userData.playerName;
				playerVO1.playerRank = query.myRank;
				playerVO1.playerColor =0;
				playerVO1.playerJop = _userData.myHero.id;
				playerVO1.playerLevel = _userData.level;
				playerVO1.battlePoints=_userData.getBattlePoint();
				playerVO1.myPlayerRank=query.myRank;
				
			   _competePlayers.push(playerVO1);
			 
			   _UserList.source=_competePlayers;
			 
			 
			/////////////////测试用////////////////////////

		     while (i < query.players.length)
			{
				var voPlayer : AthleticsPlayer = new AthleticsPlayer();

				voPlayer.name = query.players[i].name;
				voPlayer.rank = query.players[i].rank;
				voPlayer.color = query.players[i].color;
				voPlayer.job = query.players[i].job;
				voPlayer.level = query.players[i].level;
				VoCompete.voPlayer.push(voPlayer);
				i++;
			}

			VoCompete.myRank = query.myRank;
		    VoCompete.todayCountLeft = query.todayCountLeft;

			VoCompete.winStreak = query.winStreak;
			VoCompete.honorGot = query.honorGot;
			VoCompete.honorTotal = query.honorTotal;
			VoCompete.silverGot = query.silverGot;
			VoCompete.silverTotal = query.silverTotal;
			VoCompete.bestRank = query.bestRank;
			VoCompete.bonusTime=query.nextRewardTime;
			var time:uint=query.nextRewardTime;

			_UserList.updateData();
            _UserList.onOrderChange(_competePlayers);
			_goldInfo.refreshInfoText();
			_UserList.updateUserInfo();
		}

		private function updatabattleover(battle : SCAthleticsChallenge) : void
		{
			VoCompete.voNewBattle.name = battle.name;
			VoCompete.voNewBattle.color = battle.color;
			VoCompete.voNewBattle.challengeTime = battle.challengeTime;
			VoCompete.voNewBattle.result = battle.result;
            VoCompete.voNewBattle.battleId=battle.battleId;
			if (battle.hasNewRank)
			{
				VoCompete.voNewBattle.newRank = battle.newRank;
			}	
			var cmd : CSAthleticsQuery = new CSAthleticsQuery();
			Common.game_server.sendMessage(0x1A0, cmd);
			_battledata.addNewBattleInfo();
		}

		// =====================
		// @交互
		// =====================
		private function getBattleData(historty : SCAthleticsHistory) : void
		{
			var i : int = 0;
			while (i < historty.records.length)
			{
				var Record : AthleticsRecord = new AthleticsRecord();
				Record.name = historty.records[i].name;
				Record.color = historty.records[i].color;
				Record.challengeTime = historty.records[i].challengeTime;
				Record.result = historty.records[i].result;
				Record.battleId=historty.records[i].battleId;
				if (Record.result == 0 || Record.result == 3)
				{
					Record.newRank = historty.records[i].newRank;
				}
				VoCompete.record.push(Record);
				i++;
			}
			_battledata.refreshBattleInfo();
		}

		private function onOutPanel(even : MouseEvent) : void
		{
			_exitButton.removeEventListener(MouseEvent.CLICK, onOutPanel);
			MenuManager.getInstance().closeMenuView(MenuType.COMPETE);
		}

		override protected function layout() : void
		{
			if (!_loaded)
				return;
			this.width=UIManager.root.stage.stageWidth;
			this.height=UIManager.root.stage.stageHeight;
			super.layout();
//			GLayout.layout(this);
//			GLayout.layout(_UserList);
//			GLayout.layout(_battledata);
			GLayout.update(UIManager.root,_UserList);
			GLayout.update(UIManager.root,_battledata);

			bg_huazhou_left.x = _UserList.x - 10;
			bg_huazhou_left.y = _UserList.y - 25;
			bg_huazhou_right.x = _UserList.x + _UserList.width + 5;
			bg_huazhou_right.y = _UserList.y - 25;
			bg_infotitle_backgroud.x = _UserList.x + 320;
			bg_infotitle_backgroud.y = _UserList.y - 22;
			_compete_bg.x = (UIManager.root.stage.stageWidth - _compete_bg.width) / 2;
			_compete_bg.y = (UIManager.root.stage.stageHeight - _compete_bg.height) / 2;
			
			
            if(UIManager.root.stage.stageWidth>=_compete_bg.width)
			{
			_exitButton.x = _compete_bg.x+_compete_bg.width-_exitButton.width-20;
			_moneyBoard.x = _compete_bg.x+1;
		    MenuManager.getInstance().getMenu().x =_compete_bg.x+_compete_bg.width - MenuManager.getInstance().getMenu().width;
			
			}
			else
			{
			_exitButton.x =UIManager.root.stage.stageWidth-_exitButton.width-20;
			_moneyBoard.x =1;
			MenuManager.getInstance().getMenu().x =UIManager.root.stage.stageWidth - MenuManager.getInstance().getMenu().width;
			}
			
			_moneyBoard.y = 1;
			MenuManager.getInstance().getMenu().y = UIManager.stage.stageHeight - MenuManager.getInstance().getMenu().height;
			_goldInfo.x = _UserList.x + 309;
			_goldInfo.y = _UserList.y - 27;
		}
		
//		override public function stageResizeHandler() : void
//        {
//              _stateW = Math.min(UIManager.stage.stageWidth, _compete_bg.width);
//				_stateH = Math.min(UIManager.stage.stageHeight, _compete_bg.height); 
//				MenuManager.getInstance().getMenu().x=_compete_bg.x+_stateW- MenuManager.getInstance().getMenu().width;
//		        MenuManager.getInstance().getMenu().y = UIManager.stage.stageHeight - MenuManager.getInstance().getMenu().height;
//		}
		
		// ------------------------------------------------
		// 模块
		// ------------------------------------------------		
		public function getResList() : Array
		{
			return [new LibData(VersionManager.instance.getUrl("assets/swf/compete.swf"), "compete")];
		}

		public function initModule() : void
		{
			_loaded = true;
		    addPanel();
			addTopBg();
			addButton();
			addBg();
			initEvents();
			layout();
			
		}
		
		public function get menuId() :int
		{
			return MenuType.COMPETE;
		}
	}
}
