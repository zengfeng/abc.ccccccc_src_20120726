package game.module.recruitHero
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	import com.greensock.layout.AlignMode;
	import com.utils.StringUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.user.UserData;
	import game.manager.ViewManager;
	import game.module.quest.guide.GuideMange;
	import game.net.core.Common;
	import game.net.data.CtoC.CCTeamChange;

	import gameui.controls.GButton;
	import gameui.controls.GImage;
	import gameui.controls.GTextArea;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GImageData;
	import gameui.data.GTextAreaData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	/**
	 * @author yangyiqiang
	 */
	public class QuestRecruitPanel extends GComponent
	{
		public function QuestRecruitPanel()
		{
			_base = new GComponentData();
			_base.width = 200;
			_base.height = 275;
			_base.parent = UIManager.root;
			_base.align = new GAlign(-1, -1, -1, -1, 0, 0);
			super(_base);
		}

		private var _summonButton : GButton;
		private var _text : GTextArea;
		private var _back : Sprite;
		private var _img : GImage;
		private var _mc : Sprite;
		// 存储玩家职业的Sp  k是玩家职业名称
		private var playerJobDic : Dictionary = new Dictionary();

		override protected function create() : void
		{
			_back = UIManager.getUI(new AssetData("panel", "quest"));
			addChild(_back);
			_mc = UIManager.getUI(new AssetData("reTitalMC", "quest"));
			_mc.x = 9;
			_mc.y = 21;
			playerJobDic[1] = UIManager.getUI(new AssetData("jingang", "quest"));
			playerJobDic[2] = UIManager.getUI(new AssetData("xiuluo", "quest"));
			playerJobDic[3] = UIManager.getUI(new AssetData("tianshi", "quest"));
			var imgData : GImageData = new GImageData();
			imgData.iocData.align = new GAlign();
			_img = new GImage(imgData);
			_img.addEventListener(Event.COMPLETE, onComplete);
			addChild(_img);
			addChild(_mc);

			var areaData : GTextAreaData = new GTextAreaData();
			areaData.backgroundAsset = new AssetData(SkinStyle.emptySkin, AssetData.AS_LIB);
			areaData.selectable = false;
			areaData.editable = false;
			areaData.width = this.width;
			areaData.y = 206;
			areaData.textFormat = new TextFormat("", null, null, null, null, null, null, null, AlignMode.CENTER);
			areaData.textFieldFilters = [];
			_text = new GTextArea(areaData);
			addChild(_text);
			GLayout.layout(_text);
			var data : GButtonData = new GButtonData();
			// data.align = new GAlign(-1, 30, -1, 10);
			data.y = 232;
			_summonButton = new GButton(data);
			_summonButton.text = "确定";
			_summonButton.x = (this.width - _summonButton.width) / 2;
			addChild(_summonButton);
			GLayout.layout(_summonButton);
		}

		private function onComplete(event : Event) : void
		{
			_img.x = 8.7;
			_img.y = 200 - _img.height;
		}

		private var playerJobSP : Sprite;
		private var _hero : VoHero;

		override public function set source(value : *) : void
		{
			_img.url = "";
			_source = value;
			_hero = HeroManager.instance.newHero(Number(_source));
			_text.htmlText = _hero == null ? StringUtils.addColor(_source + "无名勇士" + "加入你的队伍!", "#2f1f00") : _hero.htmlName + StringUtils.addColor("加入你的队伍!", "#2f1f00");
			if (!_hero) return;
			_img.url = _hero.halfImage;
			onComplete(new Event(""));
			playerJobSP = playerJobDic[_hero.job] as Sprite;
			playerJobSP.x = 15;
			playerJobSP.y = 54;
			addChild(playerJobSP);
			if (UserData.instance.level < 20)
				GuideMange.getInstance().moveTo(-100, 215, "点击招幕", this);
		}

		public function showHero(id : int, type : uint = 0) : void
		{
			_img.url = "";
			_hero = HeroManager.instance.newHero(Number(id));
			_text.htmlText = _hero == null ? StringUtils.addColor("无名勇士" + "加入你的队伍!", "#2f1f00") : _hero.htmlName + StringUtils.addColor("加入你的队伍!", "#2f1f00");
			if (!_hero) return;
			_img.url = _hero.halfImage;
			onComplete(new Event(""));
			playerJobSP = playerJobDic[type] as Sprite;
			playerJobSP.x = 15;
			playerJobSP.y = 54;
			addChild(playerJobSP);
			if (UserData.instance.level < 20)
				GuideMange.getInstance().moveTo(-100, 215, "点击招幕", this);

			// UIManager.root.addEventListener(MouseEvent.CLICK, onClick_recruit);
			_summonButton.addEventListener(MouseEvent.CLICK, onClick_recruit);
		}

		private function onClick_recruit(event : MouseEvent) : void
		{
			ViewManager.instance.playAnimation("recruit");
			this.hide();
		}

		private function onClick(event : MouseEvent) : void
		{
			if (getTimer() - _time < 500) return;
			RecruitManager.instance.sendHeroSummonMessage(_source);
			event.stopPropagation();
		}

		private var _time : uint;

		private function onHeroSummon(msg : CCTeamChange) : void
		{
			if (msg.uuid != Number(_source) || msg.type != 0) return;
			ViewManager.instance.playAnimation("recruit");
			UserData.instance.userPanel.lockHeros(true);

			var cell : GComponent = UserData.instance.userPanel.getNextHeroCell();
			cell.source = _hero;
			var oldPoint : Point = new Point(cell.x, cell.y);
			cell.x = (UIManager.stage.stageWidth - cell.width) / 2;
			cell.y = (UIManager.stage.stageHeight - cell.height) / 2;
			UIManager.root.addChild(cell);
			TweenLite.to(cell, 1, {delay:0.5, x:oldPoint.x, y:oldPoint.y, overwrite:0, onComplete:end, onCompleteParams:[oldPoint.x, oldPoint.y, cell], ease:Quint.easeOut});
			TweenLite.to(this, 0.5, {alpha:0, onComplete:hide});
		}

		private function end(x : Number, y : Number, sprite : Sprite) : void
		{
			UserData.instance.userPanel.showEnd(x - 75, y - 50, sprite);
		}

		override protected function onShow() : void
		{
			super.onShow();
			GLayout.layout(this);
			_time = getTimer();
			UIManager.root.addEventListener(MouseEvent.CLICK, onClick);
			Common.game_server.addCallback(0xfff4, onHeroSummon);
		}

		override protected function onHide() : void
		{
			super.onHide();
			UIManager.root.removeEventListener(MouseEvent.CLICK, onClick);
			Common.game_server.removeCallback(0xfff4, onHeroSummon);
			
			_img.removeEventListener(Event.COMPLETE, onComplete);
			_summonButton.removeEventListener(MouseEvent.CLICK, onClick_recruit);
		}
	}
}
