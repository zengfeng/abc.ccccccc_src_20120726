package game.module.recruitHero
{
	import game.core.avatar.AvatarFight;
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarType;
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.sutra.Sutra;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;
	import game.net.data.CtoC.CCUserDataChangeUp;
	import game.net.data.CtoS.CSHeroDonate;
	import game.net.data.CtoS.CSHeroSummon;
	import game.net.data.StoC.SCHeroDonate;
	import game.net.data.StoC.SCHeroSummonStatus;

	import gameui.controls.GButton;
	import gameui.controls.GProgressBar;
	import gameui.controls.GTextInput;
	import gameui.data.GButtonData;
	import gameui.data.GProgressBarData;
	import gameui.data.GTextInputData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import log4a.Logger;

	import net.AssetData;

	import com.commUI.GCommonSmallWindow;
	import com.commUI.icon.ItemIcon;
	import com.utils.HeroUtils;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	/**
	 * @author 1
	 */
	public class CastPanel extends GCommonSmallWindow
	{
		// =====================
		// 定义
		// =====================
		public static const RECRUIT_FINISHED : uint = 0;
		public static const BACK_TEAM : uint = 1;
		public static const CAST_FINISHED : uint = 2;
		public static const CAST_UNFINISHED : uint = 3;
		// =====================
		// 属性
		// =====================
		private var _heroName : TextField;
		// private var _heroMovie : MovieClip;
		private var _progressBar : GProgressBar;
		private var _cueText : TextField;
		private var _resourceInput : GTextInput;
		private var _castFinishText : TextField;
		private var _taskFinishText : TextField;
		private var _recruitFinishText : TextField;
		private var _preRecruitWarningText : TextField;
		private var _resourceIcon : ItemIcon;
		private var _submitButton : GButton;
		private var _status : uint;
		private var _resourceNum : int;
		private var _resourceInputAdvanceNum : int;
		private var _linkText : TextField;

		// =====================
		// Getter/Setter
		// =====================
		override public function set source(value : *) : void
		{
			super.source = value;
			updateStatus();
			updateHeroName();
			updateHeroMovie();
			updateProgressBar();
			updateResourceIcon();
			updateButton();
			updateTitle();
			updateFrameUI();
			updateResourceInput();
			updatePreRecruitWarningText();
			updataLinkText();
		}

		public function set hero(value : VoHero) : void
		{
			this.source = value;
		}

		public function get hero() : VoHero
		{
			return _source as VoHero;
		}

		public function get sutra() : Sutra
		{
			if (_source)
				return (_source as VoHero).sutra;

			return null;
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function CastPanel()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 180;
			data.height = 410;
			data.allowDrag = false;
			data.parent = ViewManager.instance.uiContainer;
			super(data);
		}

		override protected function create() : void
		{
			super.create();

			// title = "法宝铸炼";
			addBg();
			addWhiteLine();
			addHeroName();
			addFrameSkin();
			addCueText();
			addProgressBar();
			addResourceInput();
			addResourceIcon();
			addButton();
			addCastFinishText();
			addTaskFinishText();
			addRecruitFinishText();
			addPreRecruitWarningText();
			addLinkText();
		}

		// =====================================================
		// 连接进入高级寻仙
		// =====================================================
		private function addLinkText() : void
		{
			// var dataText : GLabelData = new GLabelData();
			// dataText.text = StringUtils.addColor(StringUtils.addLine("进入高级寻仙"), "#ff3300");
			// dataText.y = 325;
			// dataText.x = 52;
			// dataText.textFieldFilters = [];
			// _linkText = new GLabel(dataText);
			// _contentPanel.addChild(_linkText);
			// _linkText.visible = false;

			_linkText = UICreateUtils.createTextField(null, "", 100, 20, 46, 326);
			_linkText.textColor = 0xff3300;
			_linkText.htmlText = "<b><u>进入高级寻仙</u></b>";
			_linkText.mouseEnabled = true;
			_linkText.selectable = false;
			_linkText.visible = false;
			_contentPanel.addChild(_linkText);
		}

		private function updataLinkText() : void
		{
			if (!_linkText) return;
			if (HeroUtils.isHighFindHero(hero.id))
			{
				_linkText.visible = true;

				if (MenuManager.getInstance().getMenuState(MenuType.FINDHERO))
					_linkText.visible = false;
				else
					_linkText.visible = true;
			}
			else
				_linkText.visible = false;
		}

		// ===========================================================================
		private function addBg() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.CAST_SUTRA_PANEL_BG));
			bg.x = 5;
			bg.y = 0;
			bg.width = 170;
			bg.height = 405;
			_contentPanel.addChild(bg);
		}

		private function addWhiteLine() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.CAST_SUTRA_PANEL_WHITE_LINE));
			bg.x = 29;
			bg.y = 29;
			bg.width = 119;
			bg.height = 1;
			_contentPanel.addChild(bg);
		}

		private function addHeroName() : void
		{
			_heroName = UICreateUtils.createTextField(null, "", 180, 25, 0, 8, UIManager.getTextFormat(12, 0xffffffff, TextFormatAlign.CENTER));
			_contentPanel.addChild(_heroName);
		}

		private function addFrameSkin() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.CAST_SUTRA_PANEL_FRAME_SKIN));
			bg.x = 10;
			bg.y = 265;
			bg.width = 160;
			bg.height = 80;
			_contentPanel.addChild(bg);
		}

		private function addCueText() : void
		{
			_cueText = new TextField();
			_cueText.x = 10;
			_cueText.y = 230;
			_cueText.textColor = 0x2F1F00;
			_cueText.text = "交情：";
			_cueText.selectable = false;
			_contentPanel.addChild(_cueText);
		}

		private function addProgressBar() : void
		{
			var data : GProgressBarData = new GProgressBarData();
			data.x = 10;
			data.y = 250;
			data.width = 160;
			data.height = 14;
			data.padding = 4;
			data.paddingY = 4;
			data.paddingX = 4;
			data.trackAsset = new AssetData(UI.CAST_SUTRA_PANEL_PROGRESSBAR_TRACKSKIN);
			data.barAsset = new AssetData(UI.CAST_SUTRA_PANEL_PROGRESSBAR_BARSKIN);
			_progressBar = new GProgressBar(data);
			_contentPanel.addChild(_progressBar);
		}

		private function addResourceInput() : void
		{
			var data : GTextInputData = new GTextInputData();
			data.x = 75;
			data.y = 290;
			data.width = 70;
			data.height = 22;
			data.restrict = "0-9";
			data.maxChars = 6;
			data.maxNum = 999999;
			_resourceInput = new GTextInput(data);
			_contentPanel.addChild(_resourceInput);
		}

		private function addResourceIcon() : void
		{
			_resourceIcon = UICreateUtils.createItemIcon({x:22, y:275, showBorder:true, showBg:true, showToolTip:true, showNums:true});
			_resourceIcon.x = 22;
			_resourceIcon.y = 275;
			_contentPanel.addChild(_resourceIcon);
		}

		private function addButton() : void
		{
			var data : GButtonData = new GButtonData();
			data.x = 50;
			data.y = 358;
			data.width = 80;
			data.height = 30;
			data.labelData.text = "结交";
			_submitButton = new GButton(data);
			_submitButton.visible = false;
			_contentPanel.addChild(_submitButton);
		}

		private function addCastFinishText() : void
		{
			_castFinishText = UICreateUtils.createTextField("结交完成", null, 180, 25, 0, 295, UIManager.getTextFormat(12, 0xff2f1f00, TextFormatAlign.CENTER));
			_castFinishText.visible = false;
			_contentPanel.addChild(_castFinishText);
		}

		private function addTaskFinishText() : void
		{
			_taskFinishText = UICreateUtils.createTextField("任务已完成", null, 180, 25, 0, 295, UIManager.getTextFormat(12, 0xff2f1f00, TextFormatAlign.CENTER));
			_taskFinishText.visible = false;
			_contentPanel.addChild(_taskFinishText);
		}

		private function addRecruitFinishText() : void
		{
			_recruitFinishText = UICreateUtils.createTextField("已招募", null, 180, 25, 0, 360, UIManager.getTextFormat(12, 0xff339900, TextFormatAlign.CENTER));
			_recruitFinishText.visible = false;
			_contentPanel.addChild(_recruitFinishText);
		}

		private function addPreRecruitWarningText() : void
		{
			_preRecruitWarningText = UICreateUtils.createTextField(null, "", 180, 25, 0, 360, UIManager.getTextFormat(12, 0xff2f1f00, TextFormatAlign.CENTER));
			_preRecruitWarningText.visible = false;
			_contentPanel.addChild(_preRecruitWarningText);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateStatus() : void
		{
			_status = hero.recruitState;
		}

		private function updateHeroName() : void
		{
			_heroName.htmlText = hero.htmlName;
		}

		private function updateHeroMovie() : void
		{
			// if (_heroMovie)
			// {
			// _contentPanel.removeChild(_heroMovie);
			// _heroMovie = null;
			// }

			loadEnd();

			// RESManager.instance.load(new LibData(hero.heroMovie, key), loadEnd);
		}

		private function updateProgressBar() : void
		{
			if (_status == CAST_FINISHED || _status == RECRUIT_FINISHED || _status == BACK_TEAM)
			{
				_progressBar.value = 100;
				_progressBar.text = String(sutra.stepMaxValue) + "/" + String(sutra.stepMaxValue);
			}
			else
			{
				_progressBar.value = sutra.stepValue / sutra.stepMaxValue * 100;
				_progressBar.text = String(sutra.stepValue) + "/" + String(sutra.stepMaxValue);
			}
		}

		private function updateResourceIcon() : void
		{
			// _resourceIcon.source = ItemManager.instance.getPileItem(hero.relic);
			var item : Item = ItemManager.instance.getPileItem(sutra.relic);
			_resourceIcon.source = item;
			if (item == null) return;
			_resourceNum = item.nums;

			updateResourceInput();
		}

		private function updateButton() : void
		{
			if (_status == RECRUIT_FINISHED)
			{
				_submitButton.visible = false;
				_recruitFinishText.visible = true;
				_preRecruitWarningText.visible = false;
			}
			else if ( _status == BACK_TEAM)
			{
				_submitButton.text = "归队";
				_submitButton.visible = true;
				_recruitFinishText.visible = false;
				_preRecruitWarningText.visible = false;
			}
			else if (_status == CAST_FINISHED)
			{
				_submitButton.text = "招募";
				_submitButton.visible = true;
				_recruitFinishText.visible = false;
				_preRecruitWarningText.visible = false;
			}
			else if (_status == CAST_UNFINISHED)
			{
				_submitButton.text = "结交";
				_submitButton.visible = true;
				_recruitFinishText.visible = false;
				_preRecruitWarningText.visible = false;
			}

			//			//  判断材料数量
			// if (_resourceNum == 0)
			// _submitButton.enabled = false;
			// else
			// _submitButton.enabled = true;

			if (sutra.stepValue == sutra.stepMaxValue && _status == CAST_UNFINISHED)
			{
				_submitButton.text = "招募";
				_submitButton.visible = true;
			}
		}

		private function updateTitle() : void
		{
			if (_status == RECRUIT_FINISHED)
			{
				title = "名仙结交";
			}
			else if ( _status == BACK_TEAM)
			{
				title = "名仙归队";
			}
			else if (_status == CAST_FINISHED)
			{
				title = "名仙招募";
			}
			else if (_status == CAST_UNFINISHED)
			{
				title = "名仙结交";
			}

			if (sutra.stepValue == sutra.stepMaxValue && _status == CAST_UNFINISHED)
			{
				title = "名仙结交";
			}
		}

		private function updateFrameUI() : void
		{
			if (_status == RECRUIT_FINISHED)
			{
				_resourceIcon.visible = false;
				_resourceInput.visible = false;
				_castFinishText.visible = true;
				_taskFinishText.visible = false;
				_progressBar.visible = true;
				_cueText.visible = true;
			}
			else if ( _status == BACK_TEAM)
			{
				// 按钮显示为归队时，若为任务名仙则显示任务已完成，否则为铸炼已完成
				if (hero.id == 11 || hero.id == 12 || hero.id == 13)
				{
					_cueText.visible = false;
					_progressBar.visible = false;
					_resourceIcon.visible = false;
					_resourceInput.visible = false;
					_castFinishText.visible = false;
					_taskFinishText.visible = true;
				}
				else
				{
					_resourceIcon.visible = false;
					_resourceInput.visible = false;
					_castFinishText.visible = true;
					_taskFinishText.visible = false;
					_progressBar.visible = true;
					_cueText.visible = true;
				}
			}
			else if (_status == CAST_FINISHED )
			{
				_resourceIcon.visible = false;
				_resourceInput.visible = false;
				_castFinishText.visible = true;
				_taskFinishText.visible = false;
				_progressBar.visible = true;
				_cueText.visible = true;
			}
			else if (_status == CAST_UNFINISHED )
			{
				_resourceIcon.visible = true;
				_resourceInput.visible = true;
				_castFinishText.visible = false;
				_taskFinishText.visible = false;
				_progressBar.visible = true;
				_cueText.visible = true;
			}

			if (sutra.stepValue == sutra.stepMaxValue && _status == CAST_UNFINISHED)
			{
				_resourceIcon.visible = false;
				_resourceInput.visible = false;
				_castFinishText.visible = true;
				_progressBar.visible = true;
				_cueText.visible = true;
			}

			if (hero.id == 11 || hero.id == 12 || hero.id == 13)
			{
				_cueText.visible = false;
				_progressBar.visible = false;
				_resourceIcon.visible = false;
				_resourceInput.visible = false;
				_castFinishText.visible = false;
				_taskFinishText.visible = true;
			}
		}

		private function updateResourceInput() : void
		{
			if (_resourceNum > (sutra.stepMaxValue - sutra.stepValue))
				_resourceInputAdvanceNum = sutra.stepMaxValue - sutra.stepValue;
			else
				_resourceInputAdvanceNum = _resourceNum;

			_resourceInput.text = _resourceInputAdvanceNum.toString();
		}

		private function updatePreRecruitWarningText() : void
		{
			_preRecruitWarningText.htmlText = StringUtils.addColor(String(hero.recruitLevel), "#BD0000") + StringUtils.addColor(" 级可结交", "#2F1F00");
			if (HeroManager.instance.myHero.level < hero.recruitLevel)
			{
				_resourceIcon.visible = true;
				_resourceInput.visible = true;
				_resourceInput.enabled = false;
				_resourceInput.text = "";
				_submitButton.visible = false;
				_recruitFinishText.visible = false;
				_castFinishText.visible = false;
				_preRecruitWarningText.visible = true;
			}
			else
			{
				_resourceInput.enabled = true;
				_preRecruitWarningText.visible = false;
			}
		}

		override protected function layout() : void
		{
			super.layout();
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();

			Common.game_server.addCallback(0x17, onHeroDonate);
			Common.game_server.addCallback(0x18, onHeroSummonStatus);
			Common.game_server.addCallback(0xFFF2, onPackChange);
			Common.game_server.addCallback(0xFFF1, cCUserDataChangeUp);
			_submitButton.addEventListener(MouseEvent.MOUSE_DOWN, submitBtn_clickHandler);
			_resourceInput.addEventListener(Event.CHANGE, resourceInput_changeOutHandler);
			_linkText.addEventListener(MouseEvent.CLICK, buyChTime);
			_linkText.addEventListener(MouseEvent.ROLL_OVER, linkTextRollOverHandler);
			_linkText.addEventListener(MouseEvent.ROLL_OUT, linkTextRollOutHandler);
		}

		override protected function onHide() : void
		{
			Common.game_server.removeCallback(0x17, onHeroDonate);
			Common.game_server.removeCallback(0x18, onHeroSummonStatus);
			Common.game_server.removeCallback(0xFFF2, onPackChange);
			Common.game_server.removeCallback(0xFFF1, cCUserDataChangeUp);
			_submitButton.removeEventListener(MouseEvent.MOUSE_DOWN, submitBtn_clickHandler);
			_resourceInput.removeEventListener(Event.CHANGE, resourceInput_changeOutHandler);
			_linkText.removeEventListener(MouseEvent.CLICK, buyChTime);
			_linkText.removeEventListener(MouseEvent.ROLL_OVER, linkTextRollOverHandler);
			_linkText.removeEventListener(MouseEvent.ROLL_OUT, linkTextRollOutHandler);

			_player.player.removeEventListener(Event.COMPLETE, playerOnCompleteHandler);

			anounceHide();
			super.onHide();
		}

		private function cCUserDataChangeUp(msg : CCUserDataChangeUp) : void
		{
			updataLinkText();

			if (msg.level == hero.recruitLevel)
			{
				_status = CAST_UNFINISHED;
				updateFrameUI();
				updateButton();
				updatePreRecruitWarningText();
			}
		}

		// 改变铸宝进度 材料
		private function onHeroDonate(msg : SCHeroDonate) : void
		{
			if (msg.totalCount == sutra.stepMaxValue)// 材料提交已满
			{
				_status = CAST_FINISHED;
			}
			else
			{
				_status = CAST_UNFINISHED;
			}
			updateFrameUI();
			updateProgressBar();
			updateButton();
			updateResourceInput();
		}

		// 获取英雄招募的状态
		private function onHeroSummonStatus(e : SCHeroSummonStatus) : void
		{
			Logger.debug("英雄招募状态 " + e.newStatus);
			if (e.id == hero.id)
			{
				_status = e.newStatus;
				_submitButton.visible = false;
				updateFrameUI();
				updateProgressBar();
				updateButton();
			}
		}

		private function onPackChange(msg : CCPackChange) : void
		{
			if (msg.topType | Item.JEWEL)
			{
				updateResourceIcon();
			}
		}

		private function submitBtn_clickHandler(event : MouseEvent) : void
		{
			var str : String = _submitButton.label.text;

			if (str == "招募")
			{
				if (HeroManager.instance.teamHeroes.length < 8)
				{
					sendHeroSummonMessage();
					_submitButton.visible = false;
					_recruitFinishText.visible = true;
					// StateManager.instance.checkMsg(100, [hero.htmlName]);
					var panel : QuestRecruitPanel = new QuestRecruitPanel();
					panel.showHero(hero.id, hero.job);
					panel.show();
				}
				else
				{
					StateManager.instance.checkMsg(98);
				}
			}
			else if (str == "归队")
			{
				if (HeroManager.instance.teamHeroes.length < 8)
				{
					sendHeroSummonMessage();
					_submitButton.visible = false;
					_recruitFinishText.visible = true;
					// StateManager.instance.checkMsg(100, [hero.htmlName]);
				}
				else
				{
					StateManager.instance.checkMsg(99);
				}
			}
			else if (str == "结交")
			{
				if ((_resourceInput.text == "") || (int(_resourceInput.text) == 0) || (int(_resourceInput.text) > _resourceNum))
				{
					StateManager.instance.checkMsg(178);
				}
			}

			sendHeroDonateMessage();
			// updateResourceInput();
		}

		private function resourceInput_changeOutHandler(event : Event) : void
		{
			updateResourceInputText();
		}

		private function buyChTime(event : MouseEvent) : void
		{
			MenuManager.getInstance().openMenuView(MenuType.FINDHERO);
		}

		private function linkTextRollOverHandler(event : MouseEvent) : void
		{
			_linkText.textColor = 0xff6633;
		}

		private function linkTextRollOutHandler(event : MouseEvent) : void
		{
			_linkText.textColor = 0xff3300;
		}

		private function anounceHide() : void
		{
			var myEvent : Event = new Event("HideCentPanel");
			this.dispatchEvent(myEvent);
		}

		private function updateResourceInputText() : void
		{
			var num : int = int(_resourceInput.text);
			if (_resourceInput.text == "")
				_resourceInput.text = "1";
			else if (num >= _resourceNum || num >= sutra.stepMaxValue - sutra.stepValue)
				_resourceInput.text = _resourceNum < (sutra.stepMaxValue - sutra.stepValue) ? String(_resourceNum) : String(sutra.stepMaxValue - sutra.stepValue);
			else
				_resourceInput.text = num.toString();
		}

		// -------------------------------------------------
		// 其他
		// -------------------------------------------------
		// 提交材料
		private function sendHeroDonateMessage() : void
		{
			var cmd : CSHeroDonate = new CSHeroDonate();
			cmd.id = hero.id;
			cmd.count = int(_resourceInput.text);
			Common.game_server.sendMessage(0x17, cmd);
		}

		// 招募将领
		private function sendHeroSummonMessage() : void
		{
			var cmd : CSHeroSummon = new CSHeroSummon();
			cmd.id = hero.id;
			cmd.summon = true;
			updateFrameUI();
			Common.game_server.sendMessage(0x18, cmd);
		}

		//		//  生成一个特有的key，防止与别处的load中的key相冲突
		// private function get key() : String
		// {
		// return "recruitHeroId" + hero.id;
		// }
		//
		// 名仙动画
		private var _player : AvatarFight;
		// 名仙动画播放状态 _playerStatus = true,则表示可以开始播放;_playerStatus = false,则表示动画还未播放完，不可以进行新的一次播放
		private var _playerStatus : Boolean = true;

		private function loadEnd() : void
		{
			if (!_player)
			{
				_player = new AvatarFight();
				_player.x = 95;
				_player.y = 190;
				addChild(_player);
			}

			// 判断当前播放动画的id的是不是与（所选择将领的id）根据所选择将领的id拿到的动画id一致
			if (_player.uuid != AvatarManager.instance.getUUId(hero.id, AvatarType.PLAYER_BATT_FRONT))
			{
				_playerStatus = false;

				_player.initAvatar(hero.id, AvatarType.PLAYER_BATT_FRONT);
				_player.showNameAndHPbar(false);
				_player.setAction(AvatarManager.MAGIC_ATTACK);
			}
			else if (_playerStatus)
			{
				_playerStatus = false;

				_player.initAvatar(hero.id, AvatarType.PLAYER_BATT_FRONT);
				_player.showNameAndHPbar(false);
				_player.setAction(AvatarManager.MAGIC_ATTACK);
			}

			_player.player.addEventListener(Event.COMPLETE, playerOnCompleteHandler);

			// _heroMovie = RESManager.getMC(new AssetData("mc", key)) as MovieClip;
			// _heroMovie.x = 20 + 70;
			// _heroMovie.y = 50 + 100;
			// _heroMovie.gotoAndPlay(1);
			// _contentPanel.addChild(_heroMovie);

			//			//  "end"事件为.swf中MC末尾帧中抛出的一个事件，用于侦听动画是否播放完毕
			// _heroMovie.addEventListener("end", onEnd);
		}

		private function playerOnCompleteHandler(event : Event) : void
		{
			_playerStatus = true;
		}
		//
		// private function onEnd(event : Event) : void
		// {
		// _heroMovie.gotoAndStop(1);
		// }
	}
}
