package com.utils {
	import gameui.manager.UIManager;

	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-2  ����6:50:33 
	 * 字符格式工具类
	 */
	public class TextFormatUtils {
		private static var _windowTitle : TextFormat;
		private static var _mapTitle : TextFormat;

		public static function get windowTitle() : TextFormat {
			if (_windowTitle) return _windowTitle;
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "STXinwei";
			textFormat.color = 0xFFBB00;
			textFormat.size = 24;
			textFormat.align = TextFormatAlign.CENTER;
			_windowTitle = textFormat;
			return  _windowTitle;
		}

		public static function get mapTitle() : TextFormat {
			if (_mapTitle) return _mapTitle;
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "STXinwei";
			textFormat.color = 0x000000;
			textFormat.size = 24;
			textFormat.leading = 0;
			_mapTitle = textFormat;
			return  _mapTitle;
		}

		private static var _h1 : TextFormat;

		/** 标题1 */
		static public function get h1() : TextFormat {
			if (_h1 == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = "STXinwei";
				textFormat.color = 0xFFBB00;
				textFormat.size = 24;
				textFormat.leading = 0;
				// textFormat.bold = true;
				_h1 = textFormat;
			}
			return _h1;
		}

		private static var _h2 : TextFormat;

		/** 标题2 */
		static public function get h2() : TextFormat {
			if (_h2 == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0x00FFCE3A;
				textFormat.size = 16;
				textFormat.leading = 3;
				textFormat.bold = true;
				_h2 = textFormat;
			}
			return _h2;
		}

		private static var _h3 : TextFormat;

		/** 标题3 */
		static public function get h3() : TextFormat {
			if (_h3 == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0x00FFCE3A;
				textFormat.size = 14;
				textFormat.leading = 3;
				textFormat.bold = true;
				_h3 = textFormat;
			}
			return _h3;
		}

		private static var _content : TextFormat;

		/** 正文 */
		static public function get content() : TextFormat {
			if (_content == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xFFFFFF;
				textFormat.size = 12;
				textFormat.leading = 3;
				_content = textFormat;
			}
			return _content;
		}

		private static var _contentBold : TextFormat;

		/** 正文 */
		static public function get contentBold() : TextFormat {
			if (_contentBold == null) {
				_contentBold = new TextFormat();
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xFFFFFF;
				textFormat.size = 12;
				textFormat.leading = 3;
				textFormat.bold = true;
				_contentBold = textFormat;
			}
			return _contentBold;
		}

		/** 正文 */
		private static var _contentCenter : TextFormat;

		static public function get contentCenter() : TextFormat {
			if (_contentCenter == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.align = TextFormatAlign.CENTER;
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xFFFFFF;
				textFormat.size = 12;
				textFormat.leading = 3;
				_contentCenter = textFormat;
			}
			return _contentCenter;
		}

		/** 正文 */
		private static var _contentRight : TextFormat;

		static public function get contentRight() : TextFormat {
			if (_contentRight == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.align = TextFormatAlign.RIGHT;
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xFFFFFF;
				textFormat.size = 12;
				textFormat.leading = 3;
				_contentRight = textFormat;
			}
			return _contentRight;
		}

		private static var _prompt1 : TextFormat;

		/** 提示1 */
		static public function get prompt1() : TextFormat {
			if (_prompt1 == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xFFFFFF;
				textFormat.size = 12;
				textFormat.leading = 3;
				_prompt1 = textFormat;
			}
			return _prompt1;
		}

		private static var _prompt2 : TextFormat;

		/** 提示2 */
		static public function get prompt2() : TextFormat {
			if (_prompt2 == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0x999999;
				textFormat.size = 12;
				textFormat.leading = 3;
				_prompt2 = textFormat;
			}
			return _prompt2;
		}

		private static var _prompt3 : TextFormat;

		/** 提示3 */
		static public function get prompt3() : TextFormat {
			if (_prompt3 == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xFF0000;
				textFormat.size = 12;
				textFormat.leading = 3;
				_prompt3 = textFormat;
			}
			return _prompt3;
		}

		private static var _linkUp : TextFormat;

		/** 链接Up */
		static public function get linkUp() : TextFormat {
			if (_linkUp == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xd4dc00;
				textFormat.size = 12;
				textFormat.leading = 3;
				textFormat.underline = true;
				_linkUp = textFormat;
			}
			return _linkUp;
		}

		private static var _linkOver : TextFormat;

		/** 链接Over */
		static public function get linkOver() : TextFormat {
			if (_linkOver == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xa5d303;
				textFormat.size = 12;
				textFormat.leading = 3;
				textFormat.underline = true;
				_linkOver = textFormat;
			}
			return _linkOver;
		}

		private static var _linkDown : TextFormat;

		/** 链接Down */
		static public function get linkDown() : TextFormat {
			if (_linkDown == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xa5d303;
				textFormat.size = 12;
				textFormat.leading = 3;
				textFormat.underline = false;
				_linkDown = textFormat;
			}
			return _linkDown;
		}

		private static var _key : TextFormat;

		/** 键词 */
		static public function get key() : TextFormat {
			if (_key == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xFFFFFF;
				textFormat.size = 12;
				textFormat.leading = 3;
				_key = textFormat;
			}
			return _key;
		}

		private static var _val : TextFormat;

		/** 值 */
		static public function get val() : TextFormat {
			if (_val == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xFFFFFF;
				textFormat.size = 12;
				textFormat.leading = 3;
				_val = textFormat;
			}
			return _val;
		}

		private static var _textInputPrompt : TextFormat;

		/** 输入框提示(如:请输入名称) */
		static public function get textInputPrompt() : TextFormat {
			if (_textInputPrompt == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0x666666;
				textFormat.size = 12;
				textFormat.leading = 3;
				_textInputPrompt = textFormat;
			}
			return _textInputPrompt;
		}

		private static var _textInputNormal : TextFormat;

		/** 输入框正常 */
		static public function get textInputNormal() : TextFormat {
			if (_textInputNormal == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xFFFFFF;
				textFormat.size = 12;
				textFormat.leading = 3;
				_textInputNormal = textFormat;
			}
			return _textInputNormal;
		}

		/** 面板二级标题 */
		private static var _panelSubTitle : TextFormat;

		static public function get panelSubTitle() : TextFormat {
			if (_panelSubTitle == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0x2F1F00;
				textFormat.bold = true;
				textFormat.size = 14;
				textFormat.leading = 3;
				_panelSubTitle = textFormat;
			}
			return _panelSubTitle;
		}

		/** 面板二级标题 居中 */
		private static var _panelSubTitleCenter : TextFormat;

		static public function get panelSubTitleCenter() : TextFormat {
			if (_panelSubTitleCenter == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0x2F1F00;
				textFormat.bold = true;
				textFormat.size = 14;
				textFormat.leading = 3;
				textFormat.align = TextFormatAlign.CENTER;
				_panelSubTitleCenter = textFormat;
			}
			return _panelSubTitleCenter;
		}

		/** 面板内容 */
		private static var _panelContent : TextFormat;

		static public function get panelContent() : TextFormat {
			if (_panelContent == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0x2F1F00;
				textFormat.size = 12;
				textFormat.leading = 3;
				_panelContent = textFormat;
			}
			return _panelContent;
		}
		
		
		/** 面板内容 */
		private static var _panelContentNoLeading : TextFormat;

		static public function get panelContentNoLeading() : TextFormat {
			if (_panelContentNoLeading == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0x2F1F00;
				textFormat.size = 12;
				textFormat.leading = 0;
				_panelContentNoLeading = textFormat;
			}
			return _panelContentNoLeading;
		}

		/** 面板内容居中 */
		private static var _panelContentCenter : TextFormat;

		static public function get panelContentCenter() : TextFormat {
			if (_panelContentCenter == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0x2F1F00;
				textFormat.size = 12;
				textFormat.leading = 3;
				textFormat.align = TextFormatAlign.CENTER;
				_panelContentCenter = textFormat;
			}
			return _panelContentCenter;
		}

		/** 面板内容居右 */
		private static var _panelContentRight : TextFormat;

		static public function get panelContentRight() : TextFormat {
			if (_panelContentRight == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0x2F1F00;
				textFormat.size = 12;
				textFormat.leading = 3;
				textFormat.align = TextFormatAlign.RIGHT;
				_panelContentRight = textFormat;
			}
			return _panelContentRight;
		}

		/** ToolTip文本 */
		private static var _toolTipContent : TextFormat;

		static public function get toolTipContent() : TextFormat {
			if (_toolTipContent == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.align = TextFormatAlign.LEFT;
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0x2F1F00;
				textFormat.size = 12;
				textFormat.leading = 4;
				_toolTipContent = textFormat;
			}
			return _toolTipContent;
		}

		/** 图标名字 */
		private static var _iconName : TextFormat;

		static public function get iconName() : TextFormat {
			if (_iconName == null) {
				var format : TextFormat = new TextFormat();
				format.font = UIManager.defaultFont;
				format.color = 0xFFFFFF;
				format.size = 12;
				format.align = TextFormatAlign.CENTER;
				format.leading = 3;
				_iconName = format;
			}
			return _iconName;
		}

		/** 图标名字 */
		private static var _iconLevel : TextFormat;

		static public function get iconLevel() : TextFormat {
			if (_iconLevel == null) {
				var format : TextFormat = new TextFormat();
				format.font = UIManager.defaultFont;
				format.align = TextFormatAlign.LEFT;
				format.color = 0xFFFFFF;
				format.size = 12;
				format.leading = 3;
				_iconLevel = format;
			}
			return _iconLevel;
		}

		/** 图标名字2 */
		private static var _iconName2 : TextFormat;

		static public function get iconName2() : TextFormat {
			if (_iconName2 == null) {
				var format : TextFormat = new TextFormat();
				format.font = UIManager.defaultFont;
				format.color = 0xFFFFFF;
				format.size = 12;
				format.leading = 0;
				format.align = TextFormatAlign.CENTER;
				_iconName2 = format;
			}
			return _iconName2;
		}

		/**竞技场排名*/
		private static var _rankTitle : TextFormat;

		public static function get rankTitle() : TextFormat {
			if (_rankTitle) return _rankTitle;
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "STXinwei";
			textFormat.color = 0x000000;
			textFormat.size = 16;
			textFormat.leading = 0;
			textFormat.align = TextFormatAlign.CENTER;
			_rankTitle = textFormat;
			return  _rankTitle;
		}

		private static var _competeName : TextFormat;

		public static function get competeName() : TextFormat {
			if (_competeName) return _competeName;
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "STXinwei";
			textFormat.color = 0x000000;
			textFormat.size = 36;
			textFormat.leading = 0;
			textFormat.align = TextFormatAlign.CENTER;
			_competeName = textFormat;
			return  _competeName;
		}

		private static var _goldInfo : TextFormat;

		public static function get goldinfo() : TextFormat {
			if (_goldInfo) return _goldInfo;
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "STXinwei";
			textFormat.color = 0xFFCC00;
			textFormat.size = 20;
			textFormat.leading = 0;
			textFormat.align = TextFormatAlign.CENTER;
			_goldInfo = textFormat;
			return  _goldInfo;
		}

		/**锁妖塔副本名**/
		private static var _demonCopyName : TextFormat;

		public static function get demonCopyName() : TextFormat {
			if (_demonCopyName) return _demonCopyName;
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "STXinwei";
			textFormat.color = 0xFFCC00;
			textFormat.size = 22;
			textFormat.leading = 0;
			textFormat.align = TextFormatAlign.CENTER;
			_demonCopyName = textFormat;
			return _demonCopyName;
		}

		// 图形UI字体
		private static var _graphicLabel : TextFormat;

		public static function get graphicLabel() : TextFormat {
			if (_graphicLabel) return _graphicLabel;
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "STXinwei";
			textFormat.color = 0xFFFFFF;
			textFormat.size = 20;
			textFormat.leading = 0;
			textFormat.align = TextFormatAlign.CENTER;
			_graphicLabel = textFormat;
			return  _graphicLabel;
		}
		
		/** 默认字体 */
		private static var _defaultFormat : TextFormat;

		static public function get defaultFormat() : TextFormat {
			if (_defaultFormat == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0x2F1F00;
				textFormat.size = 12;
				textFormat.leading = 0;
				_defaultFormat = textFormat;
			}
			return _defaultFormat;
		}
		
		
		//BOSS | 家族boss 字体
		private static var _bossDamageTitle : TextFormat ;
		static public function get bossDamageTitle():TextFormat{
			if( _bossDamageTitle == null ){
				_bossDamageTitle = new TextFormat();
				_bossDamageTitle.color = ColorUtils.HIGHLIGHT_DARK0X ;
				_bossDamageTitle.font = UIManager.defaultFont ;
				_bossDamageTitle.size = 14 ;
				_bossDamageTitle.bold = true ;
				_bossDamageTitle.align = "center";
			}
			return _bossDamageTitle ;
		}

		private static var _bossDamageContent : TextFormat;

		static public function get bossDamageContent() : TextFormat {
			if (_bossDamageContent == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xFFFF80;
				textFormat.size = 12;
				textFormat.leading = 3;
				_bossDamageContent = textFormat;
			}
			return _bossDamageContent;
		}
		
		private static var _bossDamageContentRight : TextFormat;

		static public function get bossDamageContentRight() : TextFormat {
			if (_bossDamageContentRight == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.align = TextFormatAlign.RIGHT;
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xFFFF80;
				textFormat.size = 12;
				textFormat.leading = 3;
				_bossDamageContentRight = textFormat;
			}
			return _bossDamageContentRight;
		}
		
		private static var _bossDamageSelf : TextFormat;

		/** 正文 */
		static public function get bossDamageSelf() : TextFormat {
			if (_bossDamageSelf == null) {
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.color = 0xFFFF00;
				textFormat.size = 12;
				textFormat.leading = 3;
				_bossDamageSelf = textFormat;
			}
			return _bossDamageSelf;
		}
	}
}
