package game.module.formation.headPanel {
	import game.manager.SignalBusManager;
	import gameui.manager.GToolTipManager;
	import com.commUI.tooltip.SimpleHeroTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.HeroUtils;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import game.core.hero.HeroConfigManager;
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.module.formation.drageAvatear.FMDrageAvatar;
	import gameui.containers.GPanel;
	import gameui.controls.GImage;
	import gameui.data.GImageData;
	import gameui.data.GPanelData;
	import gameui.drag.IDragSource;
	import gameui.skin.SkinStyle;
	import net.AssetData;
	import net.RESManager;




	/**
	 * @author Lv
	 */
	public class HeadItem extends GPanel implements IDragSource {
		private var img : GImage;
		public var heroID : int = 0;

		public function HeadItem() : void {
			_data = new GPanelData();
			initData();
			super(_data);
			initView();
			initEvent();
		}

		private function initData() : void {
			_data.width = 65;
			_data.height = 50;
			_data.bgAsset = new AssetData(SkinStyle.emptySkin);
		}

		private function initEvent() : void {
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}

		private function mouseDownHandler(event : MouseEvent) : void {
			if (event.ctrlKey && _hero)
			{
				SignalBusManager.sendToChatHero.dispatch(_hero);
			}
		}
		private var _hero:VoHero;
		override public function get source() : *
		{
			return _hero;
		}

		private function initView() : void {
			addBG();
			ToolTipManager.instance.registerToolTip(this, SimpleHeroTip);
		}

		public function addIMG(hero:VoHero) : void {
			outLook.visible = false;
			bg.visible = true;
			title.visible = true;
			title.war.visible = false;
			title.level.visible = false;
//			title.level.text = String(hero.level);
			if(hero.heroImage)
				img.url = hero.heroImage;
			img.width = 60;
			img.height = 50;
			heroID = hero.id;
			_hero = hero;
		}
		public function setheroLevel(changeheroLevel:VoHero):void{
			_hero = changeheroLevel;
			if(_hero.state != 3)
				title.war.visible = false;
			else
				title.war.visible = true;
			//title.level.text = String(_hero.level);
			if(_hero.heroImage)
				img.url = _hero.heroImage;
			img.width = 60;
			img.height = 50;
			heroID = _hero.id;
		}

		// 1:出战   2：不出战
		public var isWaring : int;

		public function waring() : void {
			title.war.visible = true;
			if(_hero)
				_hero.state = 3;
			isWaring = 1;
		}

		public function UnWaring() : void {
			title.war.visible = false;
			if (_hero)
				_hero.state = 0;
			isWaring = 2;
		}

		private var outLook : MovieClip;
		private var bg : MovieClip;

		private function addBG() : void {
			outLook = RESManager.getMC(new AssetData("HeadOutlook","FMSwf"));
			_content.addChild(outLook);
			outLook.visible = true;
			bg = RESManager.getMC(new AssetData("HeadBG","FMSwf"));
			_content.addChild(bg);
			var data : GImageData = new GImageData();
			data.x = 2;
			data.y = 2;
			data.width = 60;
			data.height = 50;
			img = new GImage(data);
			_content.addChild(img);
			img.mouseEnabled = false;
			img.mouseChildren = false;
			title = bg.Title as MovieClip;
			_content.addChild(title);
			title.mouseEnabled = false;
			title.mouseChildren = false;
			bg.visible = false;
			title.visible = false;
			bg.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			bg.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

		private var title : MovieClip;

		private function onMouseOut(event : MouseEvent) : void {
			mc.headBG.gotoAndStop(1);
		}

		private var mc : MovieClip;

		private function onMouseOver(event : MouseEvent) : void {
			mc = event.currentTarget as MovieClip;
			mc.headBG.gotoAndStop(2);
		}

		private var _avatar : FMDrageAvatar;

		public function get dragImage() : DisplayObject {
			if (!_avatar) {
				_avatar = new FMDrageAvatar();
			}
			return _avatar;
		}
		
		
	}
}
