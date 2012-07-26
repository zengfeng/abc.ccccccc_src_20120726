package game.module.mapFeast.ui {
	import game.core.avatar.AvatarManager;
	import game.module.mapFeast.FeastConfig;

	import gameui.controls.BDPlayer;
	import gameui.controls.GButton;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;

	import net.AssetData;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author 1
	 */
	public class UIFeastStartButton extends GButton {
		private var _effect : BDPlayer ;

		public function UIFeastStartButton(data : GButtonData) {
			data.width = 90 ;
			data.height = 90 ;
			data.downAsset = new AssetData(FeastConfig.FEAST_START_DOWN, "mf");
			data.overAsset = new AssetData(FeastConfig.FEAST_START_OVER, "mf");
			data.upAsset = new AssetData(FeastConfig.FEAST_START_UP, "mf");
			
			_effect = AvatarManager.instance.getCommBDPlayer(AvatarManager.COMM_CIRCLEEFFECT, new GComponentData());
			_effect.x = 46 ;
			_effect.y = 43 ;
			super(data);
			_downSkin.width = 82 ;
			_downSkin.height = 82 ;
			_downSkin.x = 4 ;
			_downSkin.y = 4 ;
			_upSkin.width = 82 ;
			_upSkin.height = 82 ;
			_upSkin.x = 4 ;
			_upSkin.y = 4 ;
			_overSkin.width = 82 ;
			_overSkin.height = 82 ;
			_overSkin.x = 4 ;
			_overSkin.y = 4 ;
			addChild(_effect) ;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseLeave);
		}

		private function onMouseOver(evt : Event) : void {
			_effect.y = 41.8 ;
		}

		private function onMouseLeave(evt : Event) : void {
			_effect.y = 43 ;
		}

		public function effectOn() : void {
			_effect.play(80, null, 0);
		}

		public function effectOff() : void {
			_effect.stop();
		}
	}
}
