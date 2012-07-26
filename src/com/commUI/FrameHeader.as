package com.commUI
{
	import game.definition.UI;

	import gameui.manager.UIManager;

	import net.AssetData;

	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	/**
	 * @author jian
	 */
	public class FrameHeader extends Sprite
	{
		public function FrameHeader(title : String, width : int, height : int, align:String = TextFormatAlign.LEFT)
		{
//			var shadow:Sprite = UIManager.getUI(new AssetData(UI.FRAME_HEADER_SHADOW));
//			shadow.width = width;
//			shadow.y = height+1;
//			addChild(shadow);
			
			var bg : Sprite = UIManager.getUI(new AssetData(UI.FRAME_HEADER_BACKGROUND));
			bg.width = width;
			bg.height = height;
			addChild(bg);

			var titleTF : TextField;
			if (align == TextFormatAlign.LEFT)
				titleTF = UICreateUtils.createTextField(title, null, width - 4, height - 2, 2, 2, TextFormatUtils.panelSubTitle);
			else
				titleTF = UICreateUtils.createTextField(title, null, width - 4, height - 2, 2, 2, TextFormatUtils.panelSubTitleCenter);
			addChild(titleTF);
		}
	}
}
