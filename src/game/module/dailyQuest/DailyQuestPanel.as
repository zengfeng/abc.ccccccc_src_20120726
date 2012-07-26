package game.module.dailyQuest
{
	import com.utils.UrlUtils;

	import framerate.SecondsTimer;

	import game.config.StaticConfig;
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.manager.SignalBusManager;
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.module.quest.QuestManager;
	import game.module.quest.QuestUtil;
	import game.module.quest.VoQuest;
	import game.net.core.Common;
	import game.net.data.StoC.SCLoopQuestDataRes;
	import game.net.data.StoC.SCLoopQuestSubmitRes;

	import gameui.controls.GImage;
	import gameui.core.GAlign;
	import gameui.data.GImageData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import log4a.Logger;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;

	import com.commUI.GCommonWindow;
	import com.utils.FilterUtils;
	import com.utils.StringUtils;
	import com.utils.TimeUtil;
	import com.utils.UICreateUtils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;

	/**
	 * @author ME
	 */
	public class DailyQuestPanel extends GCommonWindow implements IModuleInferfaces, IAssets
	{
		// ===============================================================
		// 属性
		// ===============================================================
		/** 宝箱品质 0--白色 1--绿色 2--蓝色 3--紫色 **/
		private static const BOX_WHITE : int = 0;
		private static const BOX_GREEN : int = 1;
		private static const BOX_BLUE : int = 2;
		private static const BOX_PURPLE : int = 3;
		/** 悬赏令的状态 0--不可接 1--可接 2--已接 3--已提交 **/
		private static const WANTED_NO_RECEIVE : int = 0;
		private static const WANTED_CAN_RECEIVE : int = 1;
		private static const WANTED_HAD_RECEIVE : int = 2;
		private static const WANTED_HAD_SUBMIT : int = 3;
		/** 悬赏令卷轴动画 **/
		private var _wantedMc : MovieClip;
		/** 悬赏令背景(容器) **/
		private var _wantedBg : Sprite;
		/** 点击接取和领取奖励下面的墨迹动画 **/
		private var _inkMarksMovie : MovieClip;
		/** 点击接取 字样 **/
		private var _receiveWanted : Sprite;
		/** 领取奖励 字样 **/
		private var _receiveAward : Sprite;
		/** 悬赏令人物头像 **/
		private var _wantedHeroImage : GImage;
		/** 未发布默认人物头像 **/
		private var _noWantedHeroImage : Sprite;
		/** 悬赏令类型图标 **/
		private var _wantedTypeIcon : Sprite;
		/** 所接任务说明 **/
		private var _wantedMissionText : TextField;
		/** 接取印章 **/
		private var _wantedReceiveMovie : MovieClip;
		/** 宝箱 **/
		private var _treasureBox : MovieClip = new MovieClip();
		/** 悬赏令剩余次数文本 **/
		private var _remainNumText : TextField;
		/** 悬赏令发布倒计时文本 **/
		private var _timeText : TextField;
		/** 距离下一次放榜还需的时间 **/
		private var _nextWantedTime : uint = 0;
		/** 悬赏令剩余数量 **/
		private var _remainWantedNum : uint;
		/** 悬赏令上线数量 **/
		private var _maxWantedNum : uint;
		/** 下次发布悬赏令数量 **/
		private var _nextWantedNum : uint;
		/** 当前已接任务ID **/
		private var _questId : int;
		/** 当前已接任务品质 **/
		private var _questQuality : int;
		/** 获得的经验 **/
		private var _awardExp : uint;
		/** 获得的物品 **/
		private var _awardItem : Array = [];
		/** 获得物品数量 **/
		private var _awardItemNum : Array = [];
		/** 开启宝箱所获奖励滚屏 **/
		private var _rollPanel : RollTexts = new RollTexts();
		/** 任务VO **/
		private var _voQuest : VoQuest;
		/** 悬赏令的状态 0--不可接 1--可接 2--已接 3--已提交 **/
		private var _state : int;

		// ===============================================================
		// Getter/Setter
		// ===============================================================
		public function get state() : int
		{
			Logger.debug("悬赏令，读取状态 " + _state);
			return _state;
		}

		public function set state(value : int) : void
		{
			_state = value;
			if (value == 1)
			{
				trace("kdkd");
			}
			Logger.debug("悬赏令，设置状态 " + _state);
		}

		// ===============================================================
		// 方法
		// ===============================================================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function DailyQuestPanel()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 485;
			data.height = 324;
			data.parent = ViewManager.instance.uiContainer;
			data.align = new GAlign(-1, -1, -1, -1, 1, 1);
			super(data);
		}

		public function initModule() : void
		{
			this.title = "悬赏榜";
			addBackground();
			addTimeHintText();
			addRemainWantedNumText();
			addWantedBg();
			addNoWantedHeroImage();
			addWantedHeroImage();
			addInkMarksMovie();
			addReceiveTextPic();
			addWantedMissionText();
			addWantedTypeIcon();
			addWantedReceiveMovie();
			addRollText();
		}

		public function getResList() : Array
		{
			var arr : Array = new Array();
			arr.push(new LibData(VersionManager.instance.getUrl("assets/swf/wantedReward.swf"), "wantedReward"));
			arr.push(new LibData(UrlUtils.getLangSWF("dailyQuest.swf"), "dailyQuest"));

			return arr;
		}

		// 悬赏面板背景
		private function addBackground() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData("Daily_Quest_Wanted_Panel_Bg", "wantedReward"));
			bg.x = 5;
			bg.y = 0;
			addChildAt(bg, 1);
		}

		// 下次放榜倒计时时间
		private function addTimeHintText() : void
		{
			var textFormat : TextFormat = new TextFormat();
			textFormat.bold = true;

			_timeText = UICreateUtils.createTextField(null, "", 300, 25, 208, 10, UIManager.getTextFormat(12, 0x2F1F00, TextFormatAlign.LEFT));
			_timeText.defaultTextFormat = textFormat;
			_timeText.htmlText = "距离下次发布悬赏令的时间:";
			addChild(_timeText);
		}

		// 剩余悬赏令数量
		private function addRemainWantedNumText() : void
		{
			var textFormat : TextFormat = new TextFormat();
			textFormat.bold = false;

			_remainNumText = UICreateUtils.createTextField(null, "", 300, 25, 216, 284, UIManager.getTextFormat(12, 0x2F1F00, TextFormatAlign.LEFT));
			_remainNumText.defaultTextFormat = textFormat;
			_remainNumText.htmlText = "当前已累积10/10张悬赏榜(下次发布1张)";
			addChild(_remainNumText);
		}

		// 悬赏令背景
		private function addWantedBg() : void
		{
			_wantedMc = RESManager.getMC(new AssetData("Wanted_Open_Mc", "dailyQuest"));
			_wantedMc.x = 220;
			_wantedMc.y = 32;
			_wantedMc.mouseEnabled = true;
			_wantedMc.gotoAndStop(29);
			addChild(_wantedMc);

			_wantedBg = _wantedMc["WantedContainer"];
			_wantedBg.x = 0;
			_wantedBg.y = 0;
		}

		// 未发布悬赏令
		private function addNoWantedHeroImage() : void
		{
			_noWantedHeroImage = UIManager.getUI(new AssetData("No_Wanted_Hero_Image", "dailyQuest"));
			_noWantedHeroImage.x = 35;
			_noWantedHeroImage.y = 65;
			_noWantedHeroImage.visible = false;
			_wantedBg.addChild(_noWantedHeroImage);
		}

		// 悬赏令头像
		private function addWantedHeroImage() : void
		{
			var data : GImageData = new GImageData();
			_wantedHeroImage = new GImage(data);
			_wantedHeroImage.url = StaticConfig.cdnRoot + "assets/ico/wantedHeadIco/106.jpg";
			_wantedHeroImage.x = 82;
			_wantedHeroImage.y = 60;
			_wantedHeroImage.visible = false;
			_wantedBg.addChild(_wantedHeroImage);
		}

		// 点击接取和领取奖励下面的墨迹动画
		private function addInkMarksMovie() : void
		{
			_inkMarksMovie = RESManager.getMC(new AssetData("Daily_Quest_Wanted_InkMarks", "wantedReward"));
			_inkMarksMovie.x = 108;
			_inkMarksMovie.y = 198 + 8;
			_inkMarksMovie.gotoAndStop(1);
			_wantedBg.addChild(_inkMarksMovie);
		}

		// 点击接取 或者 领取奖励 的字样
		private function addReceiveTextPic() : void
		{
			_receiveWanted = UIManager.getUI(new AssetData("Click_And_Receive_Wanted", "dailyQuest"));
			_receiveWanted.x = 58;
			_receiveWanted.y = 185 + 8;
			_receiveWanted.width = 93;
			_receiveWanted.height = 25;
			_receiveWanted.visible = false;
			_wantedBg.addChild(_receiveWanted);

			_receiveAward = UIManager.getUI(new AssetData("Receive_Wanted_Award", "dailyQuest"));
			_receiveAward.x = 58;
			_receiveAward.y = 185 + 8;
			_receiveAward.width = 93;
			_receiveAward.height = 25;
			_receiveAward.visible = false;
			_wantedBg.addChild(_receiveAward);
		}

		// 已接悬赏任务的简介
		private function addWantedMissionText() : void
		{
			_wantedMissionText = new TextField();
			_wantedMissionText.setTextFormat(UIManager.getTextFormat());
			_wantedMissionText.wordWrap = true;
			_wantedMissionText.mouseEnabled = false;
			_wantedMissionText.selectable = false;
			_wantedMissionText.autoSize = TextFieldAutoSize.LEFT;
			_wantedMissionText.htmlText = "";
			_wantedMissionText.x = 60;
			_wantedMissionText.y = 180;
			_wantedMissionText.visible = false;
			_wantedBg.addChild(_wantedMissionText);
		}

		// 已接任务类型ICON
		private function addWantedTypeIcon() : void
		{
			_wantedTypeIcon = UIManager.getUI(new AssetData("Talk_Wanted", "wantedReward"));
			_wantedTypeIcon.x = 38;
			_wantedTypeIcon.y = 185;
			_wantedTypeIcon.width = 22;
			_wantedTypeIcon.height = 22;
			_wantedTypeIcon.visible = false;
			_wantedBg.addChild(_wantedTypeIcon);
		}

		// 悬赏令接取印章
		private function addWantedReceiveMovie() : void
		{
			_wantedReceiveMovie = RESManager.getMC(new AssetData("quest_alreadypick_mc", "dailyQuest"));
			_wantedReceiveMovie.x = 135;
			_wantedReceiveMovie.y = 45;
			_wantedBg.addChild(_wantedReceiveMovie);
		}

		// 宝箱滚屏文字
		private function addRollText() : void
		{
			_rollPanel = new RollTexts();
			_rollPanel.x = 50 + 220;
			_rollPanel.y = 100 + 32;
			addChild(_rollPanel);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		// 更新悬赏头像
		private function updateWantedHeroImage() : void
		{
			_wantedHeroImage.url = StaticConfig.cdnRoot + "assets/ico/wantedHeadIco/" + _voQuest.base.headId.toString() + ".jpg";
		}

		// 更新下次放榜时间
		private function updateTimeHintText() : void
		{
			SecondsTimer.addFunction(countDown);
		}

		// 倒计时，当时间归零以后才再次向服务器请求下次悬赏令发布时间
		private function countDown() : void
		{
			_nextWantedTime--;
			if (_nextWantedTime <= 0)
			{
				SecondsTimer.removeFunction(countDown);
				Common.game_server.sendMessage(0xD7);
			}
			_timeText.htmlText = "距离下次发布悬赏令的时间:" + StringUtils.addColor(TimeUtil.toHHMMSS(_nextWantedTime), "#FF3300");
		}

		// 更新当前悬赏令数量
		private function updateRemainWantedNumText() : void
		{
			_remainNumText.htmlText = "当前已累积" + StringUtils.addColor(_remainWantedNum.toString() + "/" + _maxWantedNum.toString(), "#FF3300") + "张悬赏令" + "（下次发布" + StringUtils.addColor(_nextWantedNum.toString(), "#FF3300") + "张）";
		}

		// 更新所接悬赏令的任务描述文本
		private function updateWantedMissionText() : void
		{
			_wantedMissionText.htmlText = _voQuest.parseQuestDesc();
		}

		// 更新所接悬赏任务的类型图标
		private function updateWantedTypeIcon() : void
		{
			if (_wantedTypeIcon && _wantedBg.contains(_wantedTypeIcon))
				_wantedBg.removeChild(_wantedTypeIcon);

			var type : int = _voQuest.base.getCompleteTry();
			if (type == 1 || type == 7 || type == 8 || type == 10)
			{
				_wantedTypeIcon = UIManager.getUI(new AssetData("Talk_Wanted", "wantedReward"));
			}
			else if (type == 4 || type == 5 || type == 6)
			{
				_wantedTypeIcon = UIManager.getUI(new AssetData("Catch_Wanted", "wantedReward"));
			}
			else if (type == 9)
			{
				_wantedTypeIcon = UIManager.getUI(new AssetData("Search_Wanted", "wantedReward"));
			}
			else
			{
				_wantedTypeIcon = UIManager.getUI(new AssetData("Kill_Wanted", "wantedReward"));
			}
			_wantedTypeIcon.x = 38;
			_wantedTypeIcon.y = 185;
			_wantedTypeIcon.width = 22;
			_wantedTypeIcon.height = 22;
			_wantedBg.addChild(_wantedTypeIcon);
		}

		// 更新悬赏令信息
		private function updateWanted() : void
		{
			// 防止出现宝箱未移除的BUG，在刷新悬赏令的时候，再判断一次
			if (_treasureBox && _wantedBg.contains(_treasureBox))
			{
				_wantedBg.removeChild(_treasureBox);
			}

			Logger.debug("悬赏令，更新面板");
			// 未发布，悬赏令不可接
			if (state == WANTED_NO_RECEIVE)
			{
				_receiveWanted.visible = false;
				_receiveAward.visible = false;
				_wantedHeroImage.visible = false;
				_noWantedHeroImage.visible = true;
				_wantedTypeIcon.visible = false;
				_wantedMissionText.visible = false;
				_wantedReceiveMovie.visible = false;
				_inkMarksMovie.visible = false;
			}
			// 可接
			else if (state == WANTED_CAN_RECEIVE)
			{
				updateWantedHeroImage();

				_receiveWanted.visible = true;
				_receiveAward.visible = false;
				_wantedHeroImage.visible = true;
				_noWantedHeroImage.visible = false;
				_wantedTypeIcon.visible = false;
				_wantedMissionText.visible = false;
				_wantedReceiveMovie.visible = false;
				_inkMarksMovie.visible = true;
			}
			// 已接
			else if (state == WANTED_HAD_RECEIVE)
			{
				// 已接，但未完成
				if (_voQuest.isCompleted == false)
				{
					_wantedReceiveMovie.gotoAndStop(_wantedReceiveMovie.totalFrames);
					updateWantedHeroImage();
					updateWantedMissionText();
					updateWantedTypeIcon();

					_receiveWanted.visible = false;
					_receiveAward.visible = false;
					_wantedHeroImage.visible = true;
					_noWantedHeroImage.visible = false;
					_wantedTypeIcon.visible = true;
					_wantedMissionText.visible = true;
					_wantedReceiveMovie.visible = true;
					_inkMarksMovie.visible = false;
				}
				// 已接，且完成
				else if (_voQuest.isCompleted == true)
				{
					updateTreasureBox();

					_receiveWanted.visible = false;
					_receiveAward.visible = true;
					_wantedHeroImage.visible = false;
					_noWantedHeroImage.visible = false;
					_wantedTypeIcon.visible = false;
					_wantedMissionText.visible = false;
					_wantedReceiveMovie.visible = false;
					_inkMarksMovie.visible = true;
				}
			}
			// 已提交
			else if (state == WANTED_HAD_SUBMIT)
			{
				updateWantedHeroImage();

				_receiveWanted.visible = true;
				_receiveAward.visible = false;
				_wantedHeroImage.visible = true;
				_noWantedHeroImage.visible = false;
				_wantedTypeIcon.visible = false;
				_wantedMissionText.visible = false;
				_wantedReceiveMovie.visible = false;
				_inkMarksMovie.visible = true;
			}
		}

		// 更新宝箱动画
		private function updateTreasureBox() : void
		{
			switch(_questQuality)
			{
				case BOX_WHITE :
					_treasureBox = RESManager.getMC(new AssetData("Wanted_White_Treasure_Box", "wantedReward"));
					break;
				case BOX_GREEN :
					_treasureBox = RESManager.getMC(new AssetData("Wanted_Green_Treasure_Box", "wantedReward"));
					break;
				case BOX_BLUE :
					_treasureBox = RESManager.getMC(new AssetData("Wanted_Blue_Treasure_Box", "wantedReward"));
					break;
				case BOX_PURPLE :
					_treasureBox = RESManager.getMC(new AssetData("Wanted_Purple_Treasure_Box", "wantedReward"));
					break;
			}
			_treasureBox.x = 15;
			_treasureBox.y = 18;
			_treasureBox.gotoAndPlay(1);
			_wantedBg.addChild(_treasureBox);
		}

		// 宝箱奖励滚屏
		private function updateAwardRollText() : void
		{
			for (var i : int = 0; i < _awardItem.length; i++)
			{
				_rollPanel.addText((_awardItem[i] as Item).htmlName + StringUtils.addColorById(" × " + String(_awardItemNum[i]), (_awardItem[i] as Item).color));
			}
			_rollPanel.addText(StringUtils.addColor("经验值:" + _awardExp.toString(), "#FFFF00"));
			_rollPanel.startRoll();
		}

		private function updateModel() : void
		{
			switch(state)
			{
				// 悬赏令还未发布不可接时
				case WANTED_NO_RECEIVE :
					break;
				// 悬赏令可接取时
				case WANTED_CAN_RECEIVE :
					var dailyPanelSub : DailyQuestPanelSub = new DailyQuestPanelSub();
					dailyPanelSub.targetQuestId = _questId;
					dailyPanelSub.preWindow = this;
					dailyPanelSub.show();
					break;
				// 悬赏令已接取时
				case WANTED_HAD_RECEIVE :
					// 已接，但未完成，点击后去做任务
					if (_voQuest.isCompleted == false)
					{
						MenuManager.getInstance().closeMenuView(MenuType.DAILY_QUEST);
						QuestUtil.questAction(_questId);
					}
					// 已接，且已完成，点击领取奖励，播放宝箱动画
					else if (_voQuest.isCompleted == true)
					{
						QuestUtil.sendTaskOperateReq(_questId, QuestUtil.SUBMIT);
						_treasureBox.gotoAndPlay(3);
						_wantedMc.mouseEnabled = false;
						_wantedMc.mouseChildren = false;
						var intervalId : uint = setTimeout(removeTreasureBoxMc, 1400);
						// updateAwardRollText();
					}
					break;
				// 悬赏令已提交
				case WANTED_HAD_SUBMIT :
					break;
			}
		}

		private function removeTreasureBoxMc() : void
		{
			_wantedMc.mouseEnabled = true;
			_wantedMc.mouseChildren = true;
			if (_treasureBox && _wantedBg.contains(_treasureBox))
			{
				_wantedBg.removeChild(_treasureBox);
				Logger.debug("宝箱移除 ", _treasureBox.name);
			}
			updateWanted();
			// trace("Before");
			// Toolbox.forEachChildIn(_wantedMc, onChild);
			_wantedMc.gotoAndPlay(1);
			_wantedMc.addEventListener(Event.ENTER_FRAME, onMCEnterFrame);
			// trace("After");
			// Toolbox.forEachChildIn(_wantedMc, onChild);
		}

		private function onMCEnterFrame(event : Event) : void
		{
			if (_wantedMc.currentFrame >= 29)
			{
				_wantedMc.gotoAndStop(29);
				_wantedMc.removeEventListener(Event.ENTER_FRAME, onMCEnterFrame);
			}

			// trace("Frame" + _wantedMc.currentFrame);
			// Toolbox.forEachChildIn(_wantedMc, onChild);
		}

		// private function onChild(child : DisplayObject, currentDepth : int) : Boolean
		// {
		// trace("child" + child + " depth" + currentDepth);
		// return true;
		// }
		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			Common.game_server.sendMessage(0xD7);
			Common.game_server.addCallback(0xD7, loopQuestDataRes);
			Common.game_server.addCallback(0xD8, loopQuestSubmitRes);
			_wantedMc.addEventListener(MouseEvent.CLICK, wantedClickHandler);
			_wantedMc.addEventListener(MouseEvent.ROLL_OVER, wantedRollOverHandler);
			_wantedMc.addEventListener(MouseEvent.ROLL_OUT, wantedRollOutHandler);
			SignalBusManager.questPanelAcceptMissionUpdate.add(onAcceptMission);
			SignalBusManager.questPanelEndMissionUpdate.add(onEndMission);
			SignalBusManager.questPanelSubmitMissionUpdate.add(onSubmitMission);
		}

		override protected function onHide() : void
		{
			Common.game_server.removeCallback(0xD7, loopQuestDataRes);
			Common.game_server.removeCallback(0xD8, loopQuestSubmitRes);
			_wantedMc.removeEventListener(MouseEvent.CLICK, wantedClickHandler);
			_wantedMc.removeEventListener(MouseEvent.ROLL_OVER, wantedRollOverHandler);
			_wantedMc.removeEventListener(MouseEvent.ROLL_OUT, wantedRollOutHandler);
			SignalBusManager.questPanelAcceptMissionUpdate.remove(onAcceptMission);
			SignalBusManager.questPanelEndMissionUpdate.remove(onEndMission);
			SignalBusManager.questPanelSubmitMissionUpdate.remove(onSubmitMission);
			super.onHide();
		}

		// 0xD7 协议
		private function loopQuestDataRes(msg : SCLoopQuestDataRes) : void
		{
			_remainWantedNum = msg.leftNum;
			_maxWantedNum = msg.maxNum;
			_questId = msg.questId;
			_questQuality = msg.quality;
			_nextWantedNum = msg.nextNum;
			_nextWantedTime = msg.nextTime;

			_voQuest = QuestManager.getInstance().search(_questId);

			if (_questId == 0)
			{
				state = WANTED_NO_RECEIVE;
			}
			else
			{
				if (_questQuality == 0xFF)
				{
					state = WANTED_CAN_RECEIVE;
				}
				else
				{
					state = WANTED_HAD_RECEIVE;
				}
			}

			updateWanted();
			updateRemainWantedNumText();
			updateTimeHintText();
		}

		// 0xD8 协议
		private function loopQuestSubmitRes(msg : SCLoopQuestSubmitRes) : void
		{
			_remainWantedNum = msg.leftNum;
			_questId = msg.questId;
			_awardItem = [];
			_awardItemNum = [];
			if (msg.hasAwardExp)
			{
				_awardExp = msg.awardExp;
			}
			for (var i : int = 0; i < msg.awardItem.length; i++)
			{
				var id : uint = msg.awardItem[i] & 0xffff;
				_awardItem.push(ItemManager.instance.newItem(id) as Item);
				_awardItemNum.push(msg.awardItem[i] >> 16);
			}

			updateAwardRollText();

			if (msg.hasQuestId)
			{
				_voQuest = QuestManager.getInstance().search(_questId);
				if (_questId == 0)
				{
					state = WANTED_NO_RECEIVE;
				}
				else
				{
					state = WANTED_CAN_RECEIVE;
				}
				// updateWanted();
			}
			else
			{
				state = WANTED_NO_RECEIVE;
				// updateWanted();
			}
			updateRemainWantedNumText();
			updateTimeHintText();
		}

		private function wantedClickHandler(event : MouseEvent) : void
		{
			updateModel();
		}

		private function wantedRollOverHandler(event : MouseEvent) : void
		{
			_wantedMc.filters = [FilterUtils.defaultGlowFilter];
			_inkMarksMovie.gotoAndPlay(2);
			// _inkMarksMovie.addEventListener(Event.ENTER_FRAME, inkMarksMovieEnterFrame);
		}

		// private function inkMarksMovieEnterFrame(event:Event) : void
		// {
		// Logger.debug("遮罩动画" + _inkMarksMovie.x + " " + _inkMarksMovie.y + " " + _inkMarksMovie.width + " " +_inkMarksMovie.height);
		// }
		private function wantedRollOutHandler(event : MouseEvent) : void
		{
			_wantedMc.filters = [];
			_inkMarksMovie.gotoAndStop(1);
			// _inkMarksMovie.removeEventListener(Event.ENTER_FRAME, inkMarksMovieEnterFrame);
		}

		private function onAcceptMission(questId : uint, quality : uint) : void
		{
			if (questId != _questId)
				return;
			_questId = questId;
			_questQuality = quality;
			state = WANTED_HAD_RECEIVE;
			updateWanted();
			_wantedReceiveMovie.gotoAndPlay(2);
		}

		private function onEndMission(questId : uint) : void
		{
			if (questId != _questId )
				return;
			// state = WANTED_HAD_SUBMIT;
			updateWanted();
		}

		private function onSubmitMission(questId : uint) : void
		{
			if (questId != _questId)
				return;
			Common.game_server.addCallback(0xD8, loopQuestSubmitRes);
		}
	}
}

