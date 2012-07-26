package game.module.compete
{
	import game.manager.SignalBusManager;
	import game.module.daily.DailyManage;
	import game.net.data.StoC.SCAthleticsBuy;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.net.core.Common;
	import game.net.data.CtoS.CSAthleticsQuery;
	import game.net.data.CtoS.CSAthleticsReset;

	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.tooltip.CompeteUserTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.StringUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author zheng
	 */
	public class UserList extends GPanel
	{
		// =====================
		// @定义
		// =====================
		// =====================
		// @属性
		// =====================
		public var _userlistPanel : GPanel;
		public var _timePanel : GPanel;
		private var _usersingleover : UserItem;
		private var _usersingledown : UserItem;
		private var _battleTime : int;
		private var _vo : UserData;
		private var userItem_me : UserItem;
		public var timelable : GLabel;
		private var _Ldata : GLabelData;
		private var chlable : GLabel;
		private var _userRanks : Array;
		private var timestr : String;
		private var _timer : int;
		private	var _obtainGoldText : TextField;
		private	var _obtainSilverText : TextField;
		private	var _repair : TextField;
		private	var _obtain : TextField;
		private var _refresh : GButton;
		private var _buyButton : GButton;
		private var _userItems : Array;
		private var _userNameArray : Array;
		private var textField1 : TextField;
		private var _chentime : TextField;

		// =====================
		// @创建
		// =====================
		public function UserList(_uPanelData : GPanelData)
		{
			_vo = UserData.instance;
			_Ldata = new GLabelData();
			_userRanks = new Array();
			_userItems = new Array();
			_userNameArray = new Array();
			textField1 = new TextField();
			_uPanelData.width = 1237.3;
			_uPanelData.height = 270;
			_uPanelData.bgAsset = new AssetData(SkinStyle.emptySkin);
			super(_uPanelData);
			initData();
			initEvent();
			initView();
			return;
		}

		private function initView() : void
		{
			addBg();
			addPanel();
			// addTimePanel();
			addChLabel();
			addRankSort();
			addMoneyLabel();

			addUser();
		}

		private function initData() : void
		{
		}

		private function initEvent() : void
		{
			Common.game_server.addCallback(0x1A4, refreshChTime);
		}

		private function addBg() : void
		{
			var userlist_big_bg : Sprite = UIManager.getUI(new AssetData(UI.COMPETE_USERLIST_BIG_BACKGROUND, "compete"));
			userlist_big_bg.width = 1220.95;
			userlist_big_bg.height = 268.25;
			_content.addChild(userlist_big_bg);

			var userlist_small_bg : Sprite = UIManager.getUI(new AssetData("common_background_13"));
			userlist_small_bg.width = 1205;
			userlist_small_bg.height = 226;
			userlist_small_bg.x = 13;
			userlist_small_bg.y = 22;
			_content.addChild(userlist_small_bg);
		}

		// end function
		/****************************************
		 * 时间面板相关的创建
		 ***************************************/
		// public function addTimePanel() : void
		// {
		// _data = new GPanelData();
		// _data.width = 110;
		// _data.height = 28;
		// _data.x = 935;
		// _data.y = 212;
		// _data.toolTipData = new GToolTipData();
		// _data.bgAsset = new AssetData(SkinStyle.emptySkin);
		// _timePanel = new GPanel(_data);
		// _content.addChild(_timePanel);
		//   //  addTimeBg();
		// _timePanel.toolTip.source = "消除CD需要10元宝";
		// addTimeLabel();
		// addTimeRefButton();
		// }
		//
		// public function addTimeLabel() : void
		// {
		// var _data:GLabelData = new GLabelData();
		// _data.width = 120;
		// _data.height = 17.35;
		// _data.x = 1;
		// _data.y = 5;
		//  //  _data.toolTipData = new GToolTipData();
		// _data.textFieldFilters = [];
		// timelable = new GLabel(_data);
		//          //  timelable.addEventListener(MouseEvent.CLICK, clearClock);
		// _timePanel.addChild(timelable);
		// _timePanel.hide();
		// return;
		// }
		//
		// //		public function addTimeBg() : void
		// //        {
		// //            var time_panelbg:Sprite = UIManager.getUI(new AssetData(UI.COMPETE_CLICKPANEL));
		// //            time_panelbg.width = 100;
		// //            time_panelbg.height = 24;
		// //            time_panelbg.x = 80;
		// //            time_panelbg.y = 0;
		// //            _timePanel.addChild(time_panelbg);
		// //        }
		//
		// private function addTimeRefButton() : void
		// {
		// var buttonData:GButtonData = new GButtonData();
		// buttonData.width = 28;
		// buttonData.height = 22;
		// buttonData.x = 120;
		// buttonData.y = 3;
		// buttonData.upAsset = new AssetData(UI.COMPETE_TIMECLEARBTN_UP);
		// buttonData.overAsset = new AssetData(UI.COMPETE_TIMECLEARBTN_OVER);
		// buttonData.downAsset = new AssetData(UI.COMPETE_TIMECLEARBTN_DOWN);
		//	//  buttonData.disabledAsset = new AssetData("EnterButtonSkin_Disable");
		//
		// _refresh = new GButton(buttonData);
		// _refresh.addEventListener(MouseEvent.CLICK, clearClock);
		// _timePanel.addChild(_refresh);
		// return;
		// }
		/******************************************
		 * 结束
		 *****************************************/
		public function addPanel() : void
		{
			_data = new GPanelData();
			_data.width = 1237.3;
			_data.height = 249.05;
			_data.x = 5;
			_data.y = 5;
			_data.bgAsset = new AssetData(SkinStyle.emptySkin);
			_userlistPanel = new GPanel(_data);
			_content.addChild(_userlistPanel);
			return;
		}

		// end function
		public function addChLabel() : void
		{
			_Ldata.textColor = 0;
			_Ldata.width = 140;
			_Ldata.height = 18;
			_Ldata.x = 950;
			_Ldata.y = 217.8;
			_Ldata.textFormat.size = 12;
			_Ldata.textFieldFilters = [];
			_Ldata.clone();
			chlable = new GLabel(_Ldata);
			chlable.mouseEnabled = false;
			chlable.htmlText = "剩余挑战次数：   次";
			_content.addChild(chlable);

			var _format : TextFormat = new TextFormat();
			_format.size = 12;
			_format.color = 0x007616;
			_format.align = TextFormatAlign.CENTER;

			_chentime = new TextField();
			_chentime.defaultTextFormat = _format;
			_chentime.width = 17;
			_chentime.height = 18;
			_chentime.x = 1035;
			_chentime.y = 217.5;
			_chentime.text = "";
			_chentime.mouseEnabled = false;
			addChild(_chentime);

			var data : KTButtonData = new KTButtonData(KTButtonData.SMALL_BUTTON);
			data.width = 51;
			data.height = 24;
			data.x = 1075;
			data.y = 215;
			_buyButton = new GButton(data);
			_buyButton.text = "购买";
			addChild(_buyButton);
			_buyButton.addEventListener(MouseEvent.CLICK, buyChTime);
		}

		private function buyChTime(event : MouseEvent) : void
		{
			StateManager.instance.checkMsg(124, [13], okFun);
		}

		private function addRankSort() : void
		{
			var _data : GLabelData = new GLabelData();
			_data.textColor = 0xFF924F;
			_data.width = 66.4;
			_data.height = 17.35;
			_data.x = 1130;
			_data.y = 217;
			_data.textFormat.size = 12;
			_data.textFieldFilters = [];
			_data.clone();
			var lable : GLabel = new GLabel(_data);
			var rankSortString : String;
			rankSortString = StringUtils.addLine("查看排行榜");
			lable.htmlText = rankSortString;
			// lable.addEventListener(MouseEvent.CLICK,openRank);
			_content.addChild(lable);
		}

		private static const MaxUser : int = 8;

		// ////////////////////////////////////////////////////////////////////////////////////
		/*************新用户头像*******************/
		// ////////////////////////////////////////////////////////////////////////////////////
		public function addUser() : void
		{
			var _userItem : UserItem ;
			var vx : int = 0;
			var i : int = 0;

			while (i < MaxUser)                                    // 创建8个头像
			{
				_userItem = new UserItem(40 + 144 * vx);
				_userItem.x = 40 + 144 * vx;
				_userItem.y = 20;
				_userlistPanel.add(_userItem);
				_userItems.push(_userItem);
				vx++;
				i++;
			}
		}

		public function onOrderChange(competePlayers : Array) : void
		{
			var i : int;
			// source[i] as VoCompetePlayer;
			_competePlayers = competePlayers;
			sortRank();
			moveCard();
			updateCard();
		}

		private function updateCard() : void
		{
			var i : int = 0;
			var j : int = 0;

			while (i < _competePlayers.length)
			{
				var job : int = (_competePlayers[i] as VoCompetePlayer).playerJop;
				var name : String = (_competePlayers[i] as VoCompetePlayer).playName;
				var rank : int = (_competePlayers[i] as VoCompetePlayer).playerRank;
				var level : int = (_competePlayers[i] as VoCompetePlayer).playerLevel;
				var color : int = (_competePlayers[i] as VoCompetePlayer).playerColor;
				var battlePoints : int = (_competePlayers[i] as VoCompetePlayer).battlePoints;
				if ((_competePlayers[i] as VoCompetePlayer).playerRank == (_competePlayers[i] as VoCompetePlayer).myPlayerRank)
				{
					(_userItems[i] as UserItem).upDateUserItem(job, name, rank.toString(), level, color,battlePoints,true);
				}
				else
				{
					(_userItems[i] as UserItem).upDateUserItem(job, name, rank.toString(), level, color,battlePoints);
				}
				i++;
			}
			while (i < MaxUser)
			{
				(_userItems[i] as UserItem).upDateUserItem(0, "", "", 0, 0, 0,false, false, false);
				i++;
			}
		}

		private function moveCard() : void
		{
			// teween
			var i : int;
			var j : int;
			var vx : int;
			for (i = 0;i < _competePlayers.length;i++)
			{
				// if(index)
				vx = (_userItems[i] as UserItem).index - 1;

				// TweenLite.to((_userItems[i] as UserItem),2,{x:40 + 144 * vx});
				(_userItems[i] as UserItem).x = 40 + 144 * vx;
			}
			while (i < MaxUser)
			{
				// vx=i;
				(_userItems[i] as UserItem).x = 40 + 144 * i;
				i++;
			}
		}

		private function beautyMove() : void
		{
			var i : int;
			var vx : int;
			for (i = 0;i < MaxUser;i++)
			{
				// if(index)
				vx = (_userItems[i] as UserItem).index - 1;
			}
		}

		private var _competePlayers : Array;

		private function sortRank() : void
		{
			var i : int = 0;
			var j : int;
			// var max_Pos:int=0;
			// var tempPlayer:VoCompetePlayer=new VoCompetePlayer();
			var sort : int;
			// 冒了个泡
			// for(i=0;i<_competePlayers.length;i++)
			// {
			// for(j=_competePlayers.length-1;j>i;j--)
			// {
			// if((_competePlayers[j] as VoCompetePlayer).playerRank<(_competePlayers[j-1] as VoCompetePlayer).playerRank);
			// tempPlayer=_competePlayers[j] as VoCompetePlayer;
			// _competePlayers[j] as VoCompetePlayer=_competePlayers[j-1] as VoCompetePlayer;
			// _competePlayers[j-1] as VoCompetePlayer=tempPlayer;
			// }
			// }
			for (i = 0;i < _competePlayers.length;i++)
			{
				sort = 1;
				for (j = 0;j < _competePlayers.length;j++)
				{
					if ((_competePlayers[i] as VoCompetePlayer).playerRank > (_competePlayers[j] as VoCompetePlayer).playerRank)
					{
						sort++;
					}
				}
				(_userItems[i] as UserItem).index = sort;
			}
		}

		// ////////////////////////////////////////////////////////////////////////////////////
		/*************新用户头像*******************/
		// ////////////////////////////////////////////////////////////////////////////////////
		// 获取金银币信息
		private function addMoneyLabel() : void
		{
			var _format : TextFormat = new TextFormat();
			_format.size = 12;
			_format.color = 0x000000;
			_format.align = TextFormatAlign.CENTER;

			_obtain = new TextField();
			_obtain.defaultTextFormat = _format;
			_obtain.width = 80;
			_obtain.height = 18;
			_obtain.x = 45;
			_obtain.y = 217;
			_obtain.text = "今日可得银币:";
			_obtain.mouseEnabled = false;
			addChild(_obtain);

			_repair = new TextField();
			_repair.defaultTextFormat = _format;
			_repair.width = 30;
			_repair.height = 18;
			_repair.x = 210;
			_repair.y = 217;
			_repair.text = "修为:";
			_repair.mouseEnabled = false;
			addChild(_repair);

			_format.align = TextFormatAlign.LEFT;
			_obtainGoldText = new TextField();
			_obtainGoldText.defaultTextFormat = _format;
			_obtainGoldText.width = 60;
			_obtainGoldText.height = 18;
			_obtainGoldText.x = 130;
			_obtainGoldText.y = 217;
			_obtainGoldText.text = "";
			_obtainGoldText.mouseEnabled = false;
			addChild(_obtainGoldText);

			_obtainSilverText = new TextField();
			_obtainSilverText.defaultTextFormat = _format;
			_obtainSilverText.width = 60;
			_obtainSilverText.height = 18;
			_obtainSilverText.x = 240;
			_obtainSilverText.y = 217;
			_obtainSilverText.text = "";
			_obtainSilverText.mouseEnabled = false;
			addChild(_obtainSilverText);
		}

		// =====================
		// @更新
		// =====================
		public function updateData() : void
		{
			_battleTime = VoCompete.todayCountLeft;
			if (_battleTime == 0)
			{
				chlable.htmlText = "今日挑战次数已用完";
				_chentime.visible = false;
			}
			else
			{
				chlable.htmlText = "剩余挑战次数：   次";
				_chentime.text = _battleTime.toString();
				_chentime.visible = true;
			}
			
			updateDaily();
			return;
		}

		public function updateUserInfo() : void
		{
			var str : String;
			str = VoCompete.silverGot.toString() + "/" + VoCompete.silverTotal.toString();
			_obtainGoldText.text = str;
			str = VoCompete.honorGot.toString() + "/" + VoCompete.honorTotal.toString();
			_obtainSilverText.text = str;
		}

		private function refreshChTime(msg : SCAthleticsBuy) : void
		{
//			if (msg.todayCountLeft == 0)
//				return;
			VoCompete.todayCountLeft = msg.todayCountLeft;
			// _chentime.text=count.toString();


			updateData();
		}

		private function updateDaily() : void
		{
//			if (VoCompete.todayCountLeft > 0)
				SignalBusManager.updateDaily.dispatch(DailyManage.ID_COMPETE, DailyManage.STATE_OPENED, VoCompete.todayCountLeft);
//			else
//				SignalBusManager.updateDaily.dispatch(DailyManage.ID_FISHING, DailyManage.STATE_ENDED, VoCompete.todayCountLeft);
		}

		// private function resetTime(_uPanelData:SCAthleticsReset):void
		// {
		// if (_uPanelData.result == true)
		// {
		// updateTimeLabel(0);
		// }
		// return;
		// }// end function
		//
		// public function updateTimeLabel(_time:int) : void
		// {
		// if (_time != 0)
		// {
		// _timePanel.show();
		// _timer = _time;
		// VoCompete.getTimeGap=_timer;
		// SecondsTimer.addFunction(timeFun);
		// }
		// else
		// {
		// VoCompete.getTimeGap=0;
		// _timePanel.hide();
		// }
		// return;
		// }// end function
		public function upDateUserList() : void
		{
		}

		// =====================
		// @交互
		// =====================
		// =====================
		// @其他
		// =====================
		// private function timeFun() : void
		// {
		// if (_timer != 0)
		// {
		// _timer--;
		// }
		// else
		// {
		// _timePanel.hide();
		// VoCompete.getTimeGap=0;
		// }
		// timestr = TimeUtil.secondsToTime(_timer);
		// timestr = timestr.substring(3, 8);
		// timelable.text = "<font size=\'12\' color=\'#000000\'>下次挑战时间 " + timestr + "</font>";
		// return;
		// }
		private function refreshBtDown(event : MouseEvent) : void
		{
			var cmd : CSAthleticsQuery = new CSAthleticsQuery();
			Common.game_server.sendMessage(416, cmd);
			return;
		}

		// end function
		// private function clearClock(event:MouseEvent) : void
		// {
		// StateManager.instance.checkMsg(124, [12], okFun);
		// return;
		// }// end function
		private function okFun(type : String) : Boolean
		{
			var cmd : CSAthleticsReset = null;
			switch(type)
			{
				case Alert.OK_EVENT:
				{
					cmd = new CSAthleticsReset();
					Common.game_server.sendMessage(0x1A4, cmd);
				}
				// case Alert.YES_EVENT:
				// {
				// cmd = new CSAthleticsReset();
				// Common.game_server.sendMessage(0x1A4, cmd);
				// break;
				// }
				default:
				{
					break;
				}
			}
			return true;
		}

		// end function
		private function addFaultPanel() : void
		{
			return;
		}

		// end function
		private function provideToolTipData() : String
		{
			var str : String = "花费" + "<font color='#FFCC00'>5</font>" + "元宝购买" + "<font color='#FFCC00'>1</font>" + "次挑战次数";
			return str;
		}

		override protected function onShow() : void
		{
			super.onShow();
			ToolTipManager.instance.registerToolTip(_buyButton, null, provideToolTipData);
		}

		override protected function onHide() : void
		{
			ToolTipManager.instance.destroyToolTip(this);
			super.onHide();
		}

		override public function show() : void
		{
			super.show();
			GLayout.layout(this);
			return;
		}

		// end function
		override public function hide() : void
		{
			super.hide();
			return;
		}
		// end function
	}
}
		
		
		
	
