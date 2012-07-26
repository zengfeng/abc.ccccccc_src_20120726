package game.module.pack.merge
{
	import flash.text.TextFormatAlign;
	import game.definition.UI;

	import gameui.manager.UIManager;

	import net.AssetData;

	import flash.display.Sprite;

	/**
	 * @author jian
	 */
	public class FrameArea extends Sprite
	{
		public function FrameArea(title : String, width : int, height : int, align:String = TextFormatAlign.LEFT)
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.AREA_BACKGROUND));
			bg.width = width;
			bg.height = height;
			addChild(bg);

			var header:FrameHeader = new FrameHeader(title, width -4, 24, align);
			header.x = 2;
			header.y = 2;
			addChild(header);
		}
	}
}
