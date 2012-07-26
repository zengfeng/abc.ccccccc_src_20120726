package game.core.menu
{
	import game.manager.SoundManager;
	import game.manager.ViewManager;

	import gameui.controls.GButton;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;

	import net.AssetData;
	import net.RESManager;

	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;
	import worlds.maps.configs.structs.MapStruct;

	import com.utils.TextFormatUtils;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;

	/**
	 * @author yangyiqiang
	 */
	public class MapMenu extends GComponent
	{
		public function MapMenu()
		{
			_base = new GComponentData();
			_base.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
			_base.width = 180;
			_base.height = 92;
			_base.align = new GAlign(-1, 1, 0);
			super(_base);
			initView();
		}

		private var _titleLabel : TextField;
		private var _openMusicBt : GButton;
		private var _closeMusicBt : GButton;

		private function initView() : void
		{
			addChild(new Bitmap(RESManager.getBitmapData(new AssetData("MinimapBack"))));
			_titleLabel = new TextField();
			_titleLabel.x = -20;
			_titleLabel.y = 15;
			_titleLabel.embedFonts = true;
			_titleLabel.selectable = false;
			_titleLabel.mouseEnabled = false;
			_titleLabel.autoSize = TextFieldAutoSize.CENTER;
			_titleLabel.defaultTextFormat = TextFormatUtils.mapTitle;
			_titleLabel.filters = [new DropShadowFilter(0, 45, 0xFFBB00, 0.8, 3, 3, 2)];
			_titleLabel.width = 120;
			_titleLabel.height = 28;
			if (MapUtil.currentMapStruct)
				_titleLabel.htmlText = MapUtil.currentMapStruct.name;
			addChild(_titleLabel);

			var _data : GButtonData = new GButtonData();
			_data.width = _data.height = 23;
			_data.downAsset = new AssetData("musicClick");
			_data.overAsset = new AssetData("musicOver");
			_data.upAsset = new AssetData("music");
			_data.width = 31;
			_data.height = 31;
			_data.x = 91;
			_data.y = 50;
			_closeMusicBt = new GButton(_data);
			_data = _data.clone();
			_data.downAsset = new AssetData("musicOpenClick");
			_data.overAsset = new AssetData("musicOpenOver");
			_data.upAsset = new AssetData("musicOpen");
			_openMusicBt = new GButton(_data);
			addChild(_closeMusicBt);
			addChild(_openMusicBt);
			_closeMusicBt.hide();
			MWorld.sInstallComplete.add(changeMapId);
		}

		public function  changeMapId() : void
		{
			var mapStruct : MapStruct = MapUtil.currentMapStruct;
			_titleLabel.htmlText = mapStruct.name;
			_titleLabel.setTextFormat(TextFormatUtils.mapTitle);
		}

		private var _time : uint;

		private function onClick(event : MouseEvent) : void
		{
			if (getTimer() - _time > 500)
			{
				if (_openMusicBt.parent != null)
				{
					SoundManager.instance.playSound(SoundManager.EVIL);
					_openMusicBt.hide();
					_closeMusicBt.show();
				}
				else
				{
					SoundManager.instance.pauseSound(SoundManager.EVIL);
					_openMusicBt.show();
					_closeMusicBt.hide();
				}
			}
			event.stopPropagation();
		}

		override protected function onShow() : void
		{
			_openMusicBt.addEventListener(MouseEvent.CLICK, onClick);
			_closeMusicBt.addEventListener(MouseEvent.CLICK, onClick);
		}

		override protected function onHide() : void
		{
			_openMusicBt.removeEventListener(MouseEvent.CLICK, onClick);
			_closeMusicBt.removeEventListener(MouseEvent.CLICK, onClick);
		}
	}
}
