package com.commUI
{


	import gameui.manager.UIManager;

	import net.AssetData;

	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * @author jian
	 */
	public class RemindBubble extends Sprite
	{
		private static const BG_ASSET:AssetData = new AssetData("numberMount");
		
		private var _tf:TextField;
		private var _bg:Sprite;
		
		public function RemindBubble(text:String = "")
		{
			_bg = UIManager.getUI(BG_ASSET);
			addChild(_bg);
			

			_tf = UICreateUtils.createTextField(null, null, _bg.width, _bg.height, 0, 0, TextFormatUtils.iconName2);
			_tf.wordWrap = false;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			addChild(_tf);
			
			this.text = text;
		}
		
		public function set text (value:String):void
		{
			_tf.text = value;
			_bg.visible = (value != "");
			

			if (value)
			{
				_tf.x = (_bg.width - _tf.textWidth) * 0.5 - 1;
				_tf.y = (_bg.height - _tf.textHeight) * 0.5 - 1;
			}
		}
	}
}
