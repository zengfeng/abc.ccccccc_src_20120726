package game.module.recruitHero
{
	import game.core.hero.HeroConfigManager;
	import game.core.hero.HeroManager;
	import game.core.hero.JobType;
	import game.core.hero.VoHero;
	import game.core.user.StateManager;
	import game.definition.UI;
	import game.net.core.Common;
	import game.net.data.StoC.SCHeroDonate;
	import game.net.data.StoC.SCHeroSummonStatus;

	import gameui.cell.GCell;
	import gameui.cell.GCellData;
	import gameui.controls.GButton;
	import gameui.controls.GImage;
	import gameui.data.GButtonData;
	import gameui.data.GImageData;
	import gameui.manager.UIManager;

	import log4a.Logger;

	import net.AssetData;

	import com.commUI.button.KTButtonData;
	import com.commUI.tooltip.RecruitHeroTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	/**
	 * @author Lv
	 */
	public class RecruitHeroCell extends GCell
	{
		// =====================
		// 属性
		// =====================
		private var _heroNameText : TextField;
		private var _heroImage : GImage;
		private var _heroJobIcon : Sprite;
		private var _warningBg : Sprite;
		private var _warningText : TextField;
		private var _finishText : TextField;
		private var _actionButton : GButton;

		// private var _heroMovie : MovieClip;
		// =====================
		// Getter/Setter
		// =====================
		override public function set source(value : *) : void
		{
			_source = value;

			if (_source)
				this.enabled = true;
			else
				this.enabled = false;

			updateHeroNameText();
			updateHeroImage();
			updateActionButton();
			updateHeroJobIcon();
			updateWarningText();
		}

		public function set hero(value : VoHero) : void
		{
			this.source = value;
		}

		public function get hero() : VoHero
		{
			return _source as VoHero;
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function RecruitHeroCell(data : GCellData)
		{
			super(data);
		}

		override protected function create() : void
		{
			super.create();

			addHeroNameBg();
			addHeroNameText();
			addBaGuaBg();
			addHeroImage();
			addDarkLine();
			addWarningText();
			addFinishText();
			addActionButton();
		}

		private function addHeroNameBg() : void
		{
			var bgHead : Sprite = UIManager.getUI(new AssetData(UI.RECRUIT_ITEM_HEAD_BG));
			bgHead.x = 4;
			bgHead.y = 4;
			bgHead.width = 120;
			bgHead.height = 22;
			addChild(bgHead);
		}

		private function addBaGuaBg() : void
		{
			var bgBaGua : Sprite = UIManager.getUI(new AssetData(UI.RECRUIT_ITEM_BAGUA_BG));
			bgBaGua.x = 12;
			bgBaGua.y = 37;
			bgBaGua.width = 105;
			bgBaGua.height = 105;
			bgBaGua.alpha = 0.2;
			addChild(bgBaGua);
		}

		private function addHeroNameText() : void
		{
			_heroNameText = UICreateUtils.createTextField(null, "", 120, 20, 3, 5, UIManager.getTextFormat(12, 0xffffffff, TextFormatAlign.CENTER));
			addChild(_heroNameText);
		}

		private function addHeroImage() : void
		{
			_heroImage = new GImage(new GImageData());
			_heroImage.x = 50;
			_heroImage.y = 25;
			_heroImage.scaleX = 0.66;
			_heroImage.scaleY = 0.66;
			addChild(_heroImage);
		}

		private function addDarkLine() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData("Recruit_Item_Dark_Line"));
			bg.x = 4;
			bg.y = 141;
			bg.width = 121;
			bg.height = 3;
			addChild(bg);
		}

		private function addWarningText() : void
		{
			_warningBg = UIManager.getUI(new AssetData(UI.RECRUIT_ITEM_WARNNING_BG));
			_warningBg.x = 4;
			_warningBg.y = 149;
			_warningBg.width = 120;
			_warningBg.height = 27;
			_warningBg.visible = false;
			// addChild(_warningBg);

			_warningText = UICreateUtils.createTextField(null, "", 128, 25, 0, 155 - 4, UIManager.getTextFormat(12, 0xff2f1f00, TextFormatAlign.CENTER));
			_warningText.visible = false;
			addChild(_warningText);
		}

		private function addFinishText() : void
		{
			_finishText = UICreateUtils.createTextField("已招募", null, 128, 25, 0, 155 - 4, UIManager.getTextFormat(12, 0xff339900, TextFormatAlign.CENTER));
			_finishText.visible = false;
			addChild(_finishText);
		}

		private function addActionButton() : void
		{
			var dataBtn : GButtonData = new KTButtonData(2);
			dataBtn.labelData.text = "招募";
			dataBtn.x = 40;
			dataBtn.y = 150 - 2;
			dataBtn.width = 50;
			_actionButton = new GButton(dataBtn);
			addChild(_actionButton);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateHeroNameText() : void
		{
			if (hero.potential == 0)
			{
				hero.potential = HeroConfigManager.instance.getPropById(hero.id).potential;
				_heroNameText.htmlText = hero.htmlName;
			}
			else
				_heroNameText.htmlText = hero.htmlName;
		}

		private function updateHeroImage() : void
		{
			_heroImage.url = hero.halfImage;
		}

		private function updateActionButton() : void
		{
			// 0 - 已招募   1 - 可归队   2 - 可招募   3 - 铸炼中
			if (hero.recruitState == 0)
			{
				_finishText.visible = true;
				_warningText.visible = false;
				_warningBg.visible = false;
				_actionButton.visible = false;
			}
			else if (hero.recruitState == 1)
			{
				_finishText.visible = false;
				_warningText.visible = false;
				_warningBg.visible = false;
				_actionButton.text = "归队";
				_actionButton.visible = true;
			}
			else if (hero.recruitState == 2)
			{
				_finishText.visible = false;
				_warningText.visible = false;
				_warningBg.visible = false;
				_actionButton.text = "招募";
				_actionButton.visible = true;
			}
			else if (hero.recruitState == 3)
			{
				if (hero.sutra.stepValue == hero.sutra.stepMaxValue)
				{
					_finishText.visible = false;
					_warningText.visible = false;
					_warningBg.visible = false;
					_actionButton.text = "招募";
					_actionButton.visible = true;
				}
				else
				{
					_finishText.visible = false;
					_warningText.visible = false;
					_warningBg.visible = false;
					_actionButton.text = "结交";
					_actionButton.visible = true;
				}
			}

			var _myHero : VoHero = HeroManager.instance.myHero;
			if (_myHero.level >= hero.preRecruitLevel && _myHero.level < hero.recruitLevel)
			{
				_finishText.visible = false;
				_warningText.visible = true;
				_warningBg.visible = true;
				_actionButton.visible = false;
			}
		}

		private function updateHeroJobIcon() : void
		{
			if (_heroJobIcon)
				removeChild(_heroJobIcon);

			if (hero.job == JobType.TIAN_SHI)
				_heroJobIcon = UIManager.getUI(new AssetData(UI.RECRUIT_ITEM_TIANSHI_ICON));
			else if (hero.job == JobType.JIN_GANG)
				_heroJobIcon = UIManager.getUI(new AssetData(UI.RECRUIT_ITEM_JINGANG_ICON));
			else if (hero.job == JobType.XIU_LUO)
				_heroJobIcon = UIManager.getUI(new AssetData(UI.RECRUIT_ITEM_XIULUO_ICON));

			_heroJobIcon.x = 8;
			_heroJobIcon.y = 30;
			addChild(_heroJobIcon);
		}

		private function updateWarningText() : void
		{
			_warningText.htmlText = StringUtils.addColor(String(hero.recruitLevel), "#BD0000") + StringUtils.addColor(" 级可结交", "#2F1F00");
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();

			Common.game_server.addCallback(0x18, onHeroSummonStatus);
			Common.game_server.addCallback(0x17, onHeroDonate);
			ToolTipManager.instance.registerToolTip(_heroImage, RecruitHeroTip, provideHero);
			_actionButton.addEventListener(MouseEvent.CLICK, actionButton_clickHandler);
			// _heroImage.addEventListener(MouseEvent.CLICK, heroMovie_clickHandler);
		}

		override protected function onHide() : void
		{
			Common.game_server.removeCallback(0x18, onHeroSummonStatus);
			Common.game_server.removeCallback(0x17, onHeroDonate);
			ToolTipManager.instance.destroyToolTip(_heroImage);
			_actionButton.removeEventListener(MouseEvent.CLICK, actionButton_clickHandler);
			// _heroImage.removeEventListener(MouseEvent.CLICK, heroMovie_clickHandler);

			super.onHide();
		}

		// 获取英雄招募的状态
		private function onHeroSummonStatus(e : SCHeroSummonStatus) : void
		{
			Logger.debug("RecruitHeroCell:英雄招募状态 " + e.newStatus);
			if (e.id == hero.id)
				updateActionButton();
		}

		// 改变铸宝进度 材料
		private function onHeroDonate(msg : SCHeroDonate) : void
		{
			if (msg.totalCount == hero.sutra.stepMaxValue)// 材料提交已满
				updateActionButton();
		}

		private function provideHero() : VoHero
		{
			return hero;
		}

		// private function provideTipString() : String
		// {
		// var text : String = "";
		//
		// //  text += '<font size="14"><b>' + StringUtils.addColorById(hero._name + " " + hero.level + "级", hero.color) + '</b></font>' + "\r";
		// text += '<font size="14"><b>' + StringUtils.addColorById(hero._name, hero.color) + '</b></font>' + "\r";
		// text += "职业：" + hero.jobName + "\r";
		//			//  text += "潜力：" + StringUtils.addColorById(String(hero.potential), hero.color) + "\r";
		// text += "技能：" + hero.sutra.skill + "\r";
		// text += hero.sutra.story + "\r";
		//
		// return text;
		// }
		private function actionButton_clickHandler(event : MouseEvent) : void
		{
			if (_actionButton.label.text == "招募")
			{
				if (HeroManager.instance.teamHeroes.length < 8)
				{
					RecruitManager.instance.sendHeroSummonMessage(hero.id);
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
			else if (_actionButton.label.text == "归队")
			{
				if (HeroManager.instance.teamHeroes.length < 8)
				{
					RecruitManager.instance.sendHeroSummonMessage(hero.id);
					// StateManager.instance.checkMsg(100, [hero.htmlName]);
				}
				else
				{
					StateManager.instance.checkMsg(99);
				}
			}
			else if (_actionButton.label.text == "结交")
			{
				var myEvent : RecruitEvent = new RecruitEvent(RecruitEvent.PASS_TO_HERO_GET_ID, true);
				myEvent.heroID = hero.id;
				dispatchEvent(myEvent);
			}
		}
		// private function heroMovie_clickHandler(event : MouseEvent) : void
		// {
		// _heroImage.visible = false;
		//
		// if (_heroMovie)
		// {
		// _heroMovie.gotoAndPlay(1);
		//				//  _heroMovie.gotoAndStop(1);
		//				//  addChildAt(_heroMovie, 6);
		// addChild(_heroMovie);
		// }
		// else
		// RESManager.instance.load(new LibData(hero.heroMovie, key), loadEnd);
		// }

		// private function loadEnd() : void
		// {
		// _heroMovie = RESManager.getMC(new AssetData("mc", key)) as MovieClip;
		// _heroMovie.x = 3 + 66;
		// _heroMovie.y = 15 + 80;
		// _heroMovie.gotoAndPlay(1);
		//			//  _heroMovie.gotoAndStop(1);
		//			//  addChildAt(_heroMovie, 6);
		// addChild(_heroMovie);
		//
		//			//  "end"事件为.swf中MC末尾帧中抛出的一个事件，用于侦听动画是否播放完毕
		// _heroMovie.addEventListener("end", onEnd);
		// }

		// private function onEnd(event : Event) : void
		// {
		// _heroMovie.stop();
		//			//  if (_heroMovie.parent) _heroMovie.parent.removeChild(this);
		// removeChild(_heroMovie);
		// _heroImage.visible = true;
		// RESManager.instance.remove(key);
		// }
		
		//		//  生成一个特有的key，防止与别处的load中的key相冲突
		// private function get key() : String
		// {
		// return "recruitHeroId" + hero.id;
		// }
	}
}
