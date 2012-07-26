package game.module.chat
{
	import com.utils.DrawUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import game.module.chat.config.ChannelColor;
	import game.module.chat.config.ChannelName;
	import gameui.manager.UIManager;
	import net.AssetData;
	import net.RESManager;





	public class ChatUntils
	{
		public static var channelLabelBg : BitmapData;
		public static var channelLabelDic : Dictionary = new Dictionary();

		/** 获取频道标签图形 */
		public static function getChannelLabelGraphic(channelId : uint) : Bitmap
		{
			if (channelLabelBg == null)
			{
				var sprite : Sprite = RESManager.getMC(new AssetData("ChannelLabelBg"));
				sprite.height = 16;
				channelLabelBg = DrawUtils.drawBitmapData(sprite);
			}
			var bitmapData : BitmapData = channelLabelDic[channelId];
			if (channelLabelDic[channelId] == null)
			{
				bitmapData = channelLabelBg.clone();
				var textFormat : TextFormat = new TextFormat();
				textFormat.size = 12;
//				textFormat.kerning = true;
				textFormat.font = ChatUntils.font;
				var textField : TextField = new TextField();
				textField.text = ChannelName.dic[channelId];
				textField.textColor = ChannelColor.dic[channelId];
				textField.defaultTextFormat = textFormat;
				textField.filters = ChatUntils.textEdgeFilter;
				textField.x = 2;
				if ( Capabilities.os.indexOf("Mac") == -1)
				{
					textField.y = -2;
				}

				sprite = new Sprite();
				sprite.addChild(textField);
				bitmapData.draw(sprite);
				channelLabelDic[channelId] = bitmapData;
			}

			// var bitmap:Bitmap = new Bitmap(bitmapData);
			// bitmap.x = 300;
			// bitmap.y = 100;
			// MapUtil.stage.addChild(bitmap);
			return new Bitmap(bitmapData);
		}

		public static function get font() : String
		{
			if (Capabilities.os.indexOf("Mac") == -1)
			{
				return UIManager.defaultFont;
			}
			else
			{
				return "Hei";
			}
		}

		private static var _textEdgeFilter : Array;

		public static function get textEdgeFilter() : Array
		{
			if (_textEdgeFilter == null)
			{
				if (Capabilities.os.indexOf("Mac") == -1)
				{
					_textEdgeFilter = [new DropShadowFilter(0, 0, 0x000000, 1, 2, 2, 13, 1, false, false)];
				}
				else
				{
					return [];
					_textEdgeFilter = [new DropShadowFilter(0, 0, 0x000000, 0.3, 2, 2, 13, 1, false, false)];
				}
			}
			return _textEdgeFilter;
		}
	}
}