package com.commUI
{
	import flash.display.Sprite;
	import game.definition.UI;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;
	import net.AssetData;



	/**
	 * @author jian
	 */
	public class GInfoWindow extends GComponent
	{
		private var _bgSkin:Sprite;
		
		public function GInfoWindow(data:GComponentData)
		{
			super(data);
		}
		
		override protected function create():void
		{
			addBgSkin();
		}
		
		private function addBgSkin():void
		{
			_bgSkin = UIManager.getUI(new AssetData(UI.INFO_WINDOW_BACKGROUND));
			addChild(_bgSkin);
		}
		
		override protected function layout():void
		{
			_bgSkin.width = width + 10;
			_bgSkin.height = height + 10;
			_bgSkin.x = -5;
			_bgSkin.y = -5;
		}
	}
}
