package com.utils
{
	import game.definition.UI;

	import gameui.controls.GButton;
	import gameui.controls.GCheckBox;
	import gameui.controls.GComboBox;
	import gameui.controls.GGradientLabel;
	import gameui.controls.GImage;
	import gameui.controls.GLabel;
	import gameui.controls.GRadioButton;
	import gameui.controls.GTextInput;
	import gameui.core.GAlign;
	import gameui.core.ScaleMode;
	import gameui.data.GButtonData;
	import gameui.data.GCheckBoxData;
	import gameui.data.GComboBoxData;
	import gameui.data.GGradientLabelData;
	import gameui.data.GImageData;
	import gameui.data.GLabelData;
	import gameui.data.GListData;
	import gameui.data.GRadioButtonData;
	import gameui.data.GTabData;
	import gameui.data.GTextInputData;
	import gameui.data.GToolTipData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.button.KTButtonData;
	import com.commUI.herotab.HeroTabListData;
	import com.commUI.icon.ItemIcon;
	import com.commUI.icon.ItemIconData;
	import com.commUI.labelButton.LabelButtonData;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;





	/**
	 * @author jian
	 */
	public class UICreateUtils
	{
		public static function createGImage(url : String = null, width : int = 0, height : int = 0, x : int = 0, y : int = 0, toolTipClass : Class = null) : GImage
		{
			var data : GImageData = new GImageData();
			if (width)
				data.width = width;
			if (height)
				data.height = height;
			data.x = x;
			data.y = y;
			// if (toolTipClass)
			// {
			// data.toolTipData = new GToolTipData();
			// data.toolTip = toolTipClass;
			// }
			var image : GImage = new GImage(data);

			if (url)
			{
				image.url = url;
			}

			return image;
		}

		public static function createGButton(text : String = null, width : int = 0, height : int = 0, x : int = 0, y : int = 0, type : uint = 0) : GButton
		{
			var data : GButtonData = new KTButtonData(type);
			if (width) data.width = width;
			if (height) data.height = height;
			data.x = x;
			data.y = y;

			var button : GButton = new GButton(data);
			if (text)
				button.text = text;
			button.mouseChildren = false;
			return button;
		}

		public static function createRedButton(text : String = null, width : int = 0, height : int = 0, x : int = 0, y : int = 0) : GButton
		{
			var data : GButtonData = new KTButtonData(KTButtonData.NORMAL_RED_BUTTON);
			if (width) data.width = width;
			if (height) data.height = height;
			data.x = x;
			data.y = y;

			var button : GButton = new GButton(data);
			button.text = text;
			button.mouseChildren = false;
			return button;
		}

		public static function createGRadioButton(text : String = null, width : int = 0, height : int = 0, x : int = 0, y : int = 0) : GRadioButton
		{
			var data : GRadioButtonData = new GRadioButtonData();
			if (height) data.height = height;
			data.x = x;
			data.y = y;
			if (width)
				data.labelData.width = width;
			data.labelData.text = text;

			var rbutton : GRadioButton = new GRadioButton(data);

			return rbutton;
		}

		public static function createGCheckBox(text : String = null, width : int = 0, height : int = 0, x : int = 0, y : int = 0) : GCheckBox
		{
			var data : GCheckBoxData = new GCheckBoxData();
			if (height) data.height = height;
			data.x = x;
			data.y = y;
			if (width)
				data.labelData.width = width;
			if (text)
				data.labelData.text = text;

			var checkBox : GCheckBox = new GCheckBox(data);

			return checkBox;
		}

		public static function createTextField(text : String = null, htmlText : String = null, width : int = 0, height : int = 0, x : int = 0, y : int = 0, textFormat : TextFormat = null) : TextField
		{
			var textField : TextField = UIManager.getTextField();
			if (textFormat)
				textField.defaultTextFormat = textFormat;
			else
				textField.defaultTextFormat = TextFormatUtils.defaultFormat;
			if (text)
				textField.text = text;
			if (htmlText)
				textField.htmlText = htmlText;
			if (width > 0)
				textField.width = width;
			if (height > 0)
				textField.height = height;
			textField.x = x;
			textField.y = y;
			textField.mouseEnabled = false;

			return textField;
		}

		public static function createTextInput(text : String, /*align:String,*/
		width : int = 0, height : int = 0, x : int = 0, y : int = 0, size : int = 0, maxChars : int = 0) : TextField // cnt2表示数量 3表示价格框
		{
			var textField : TextField = new TextField();
			var format : TextFormat = new TextFormat();

			format.size = size;
			// format.color = color;
			// format.align = align;
			textField.mouseEnabled = true;
			textField.wordWrap = false;

			textField.width = width;
			textField.height = height;
			textField.text = text;

			textField.setTextFormat(format);
			textField.x = x;
			textField.y = y;
			textField.maxChars = maxChars;

			return textField;
		}

		public static function createGComboBox(source : Array /* of LabelSources */, width : uint = 0, listWidth : uint = 0, listHeight : uint = 0, x : int = 0, y : int = 0) : GComboBox
		{
			var listData : GListData = new GListData();
			listData.rows = source.length;
			if (listWidth)
				listData.width = listWidth;
			if (listHeight)
				listData.height = listHeight;

			var comboBoxData : GComboBoxData = new GComboBoxData();
			comboBoxData.x = x;
			comboBoxData.y = y;
			comboBoxData.listData = listData;
			if (width)
				comboBoxData.width = width;

			var comboBox : GComboBox = new GComboBox(comboBoxData);

			comboBox.model.source = source;
			comboBox.selectionModel.index = 0;

			return comboBox;
		}

		public static function createItemIcon(params : Object) : ItemIcon
		{
			var data : ItemIconData = new ItemIconData();
			for (var key:String in params)
			{
				data[key] = params[key];
			}

			return new ItemIcon(data);
		}

		public static function createGLabel(dataParams : Object, compoParams : Object = null) : GLabel
		{
			var data : GLabelData = new GLabelData();

			var param : String;
			for (param in dataParams)
			{
				data[param] = dataParams[param];
			}

			var compo : GLabel = new GLabel(data);

			if (compoParams)
				for (param in compoParams)
				{
					compo[param] = compoParams[param];
				}

			return compo;
		}

		public static function createGradientLabel(dataParams : Object, compoParams : Object = null) : GGradientLabel
		{
			var data : GGradientLabelData = new GGradientLabelData();

			var param : String;
			for (param in dataParams)
			{
				data[param] = dataParams[param];
			}

			var compo : GGradientLabel = new GGradientLabel(data);

			if (compoParams)
				for (param in compoParams)
				{
					compo[param] = compoParams[param];
				}

			return compo;
		}

		public static function createGTextInput(dataParams : Object, compoParams : Object = null) : GTextInput
		{
			var data : GTextInputData = new GTextInputData();

			var param : String;
			for (param in dataParams)
			{
				data[param] = dataParams[param];
			}

			var compo : GTextInput = new GTextInput(data);

			if (compoParams)
				for (param in compoParams)
				{
					compo[param] = compoParams[param];
				}

			return compo;
		}

		/** 帮助按钮 */
		public static function createHelpGbutton(width : int = 18, height : int = 18) : GButton
		{
			var data : GButtonData = new GButtonData();
			if (width) data.width = width;
			if (height) data.height = height;
			data.upAsset = new AssetData("help_button_up_skin");
			data.overAsset = new AssetData("help_button_over_skin");
			data.downAsset = new AssetData("help_button_down_skin");
			data.disabledAsset = new AssetData("help_button_disable_skin");
			data.toolTipData = new GToolTipData();
			var button : GButton = new GButton(data);
			return button;
		}

		// 两列方形将领页签
		private static var _tabDataHeroBox : GTabData;

		public static function get tabDataHeroBox() : GTabData
		{
			if (!_tabDataHeroBox)
			{
				var data : GTabData = new GTabData();
				data.scaleMode = ScaleMode.AUTO_WIDTH;
				data.width = 65;
				data.height = 50;

				data.upAsset = new AssetData(UI.BUTTON_BOXTAB_UNSEL_UP);
				data.overAsset = new AssetData(UI.BUTTON_BOXTAB_UNSEL_OVER);
				data.disabledAsset = new AssetData(SkinStyle.emptySkin);
				data.selectedUpAsset = new AssetData(UI.BUTTON_BOXTAB_SEL_UP);
				data.selectedDisabledAsset = new AssetData(SkinStyle.emptySkin);

				data.labelData.textColor = 0xBEBEBE;
				data.labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
				data.textRollOverColor = 0xFFFFFF;
				data.textSelectedColor = 0xEFEFEF;
				data.selected = false;
				data.padding = 7;
				data.gap = 5;

				_tabDataHeroBox = data;
			}
			return _tabDataHeroBox;
		}

		// 右侧将领页签
		private static var _tabDataHeroRight : GTabData;

		public static function get tabDataHeroRight() : GTabData
		{
			if (!_tabDataHeroRight)
			{
				var data : GTabData = new GTabData();
				data.scaleMode = ScaleMode.AUTO_WIDTH;
				data.width = 75;
				data.height = 47;

				data.upAsset = new AssetData(UI.BUTTON_RIGHTTAB_UNSEL_UP);
				data.overAsset = new AssetData(UI.BUTTON_RIGHTTAB_UNSEL_OVER);
				data.disabledAsset = new AssetData(SkinStyle.emptySkin);
				data.selectedUpAsset = new AssetData(UI.BUTTON_RIGHTTAB_SEL_OVER);
				data.selectedDisabledAsset = new AssetData(SkinStyle.emptySkin);

				// data.labelData.textColor = 0xBEBEBE;
				// data.labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
				// data.textRollOverColor = 0xFFFFFF;
				// data.textSelectedColor = 0xEFEFEF;
				data.selected = false;
				data.padding = 7;
				data.gap = 2;

				_tabDataHeroRight = data;
			}

			return _tabDataHeroRight;
		}

		// 左侧将领页签
		private static var _tabDataHeroLeft : GTabData;

		public static function get tabDataHeroLeft() : GTabData
		{
			if (!_tabDataHeroLeft)
			{
				var data : GTabData = new GTabData();
				data.scaleMode = ScaleMode.AUTO_WIDTH;
				data.width = 75;
				data.height = 47;

				data.upAsset = new AssetData(UI.BUTTON_LEFTTAB_UNSEL_UP);
				data.overAsset = new AssetData(UI.BUTTON_LEFTTAB_UNSEL_OVER);
				data.disabledAsset = new AssetData(SkinStyle.emptySkin);
				data.selectedUpAsset = new AssetData(UI.BUTTON_LEFTTAB_SEL_UP);
				data.selectedDisabledAsset = new AssetData(SkinStyle.emptySkin);

				data.labelData.textColor = 0xBEBEBE;
				data.labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
				data.textRollOverColor = 0xFFFFFF;
				data.textSelectedColor = 0xEFEFEF;
				data.selected = false;
				data.padding = 7;
				data.gap = 2;

				_tabDataHeroLeft = data;
			}

			return _tabDataHeroLeft;
		}

		// 左侧将领列表
		private static var _heroListDataLeft : HeroTabListData;

		public static function get heroListDataLeft() : HeroTabListData
		{
			if (!_heroListDataLeft)
			{
				_heroListDataLeft = new HeroTabListData();
				_heroListDataLeft.rows = 8;
				_heroListDataLeft.cols = 1;
				_heroListDataLeft.showDisable = false;
				_heroListDataLeft.tabData = tabDataHeroLeft;
			}

			return _heroListDataLeft;
		}

		// 窗口关闭按钮
		private static var _buttonDataCloseWindow : GButtonData;

		public static function get buttonDataCloseWindow() : GButtonData
		{
			if (!_buttonDataCloseWindow)
			{
				_buttonDataCloseWindow = new GButtonData();
				_buttonDataCloseWindow.width = 16;
				_buttonDataCloseWindow.height = 16;
				_buttonDataCloseWindow.upAsset = new AssetData(UI.COMMON_WINDOW_BUTTON_CLOSE_UP);
				_buttonDataCloseWindow.downAsset = new AssetData(UI.COMMON_WINDOW_BUTTON_CLOSE_DOWN);
				_buttonDataCloseWindow.overAsset = new AssetData(UI.COMMON_WINDOW_BUTTON_CLOSE_OVER);
			}

			return _buttonDataCloseWindow;
		}

		// 标准按钮
		private static var _buttonDataNormal : GButtonData;

		public static function get buttonDataNormal() : GButtonData
		{
			if (!_buttonDataNormal)
			{
				_buttonDataNormal = new GButtonData();
				_buttonDataNormal.height = 30;
				_buttonDataNormal.width = 80;
				_buttonDataNormal.upAsset = new AssetData(UI.BUTTON_NORAML_UP);
				_buttonDataNormal.overAsset = new AssetData(UI.BUTTON_NORMAL_OVER);
				_buttonDataNormal.downAsset = new AssetData(UI.BUTTON_NORMAL_DOWN);
				_buttonDataNormal.disabledAsset = new AssetData(UI.BUTTON_NORMAL_DISABLE);
			}

			return _buttonDataNormal;
		}

		// 小号按钮
		private static var _buttonDataSmall : GButtonData;

		public static function get buttonDataSmall() : GButtonData
		{
			if (!_buttonDataSmall)
			{
				_buttonDataSmall = new GButtonData();
				_buttonDataSmall.height = 30;
				_buttonDataSmall.width = 50;
				_buttonDataSmall.upAsset = new AssetData(UI.BUTTON_SMALL_UP);
				_buttonDataSmall.overAsset = new AssetData(UI.BUTTON_SMALL_OVER);
				_buttonDataSmall.downAsset = new AssetData(UI.BUTTON_SMALL_DOWN);
				_buttonDataSmall.disabledAsset = new AssetData(UI.BUTTON_SMALL_DISABLE);
			}

			return _buttonDataSmall;
		}

		// 左移三角按钮
		private static var _buttonDataShiftLeft : GButtonData;

		public static function get buttonDataShiftLeft() : GButtonData
		{
			if (!_buttonDataShiftLeft)
			{
				_buttonDataShiftLeft = new GButtonData();
				_buttonDataShiftLeft.height = 21;
				_buttonDataShiftLeft.width = 14;
				_buttonDataShiftLeft.upAsset = new AssetData(UI.BUTTON_PAGE_LEFT_UP);
				_buttonDataShiftLeft.overAsset = new AssetData(UI.BUTTON_PAGE_LEFT_OVER);
				_buttonDataShiftLeft.downAsset = new AssetData(UI.BUTTON_PAGE_LEFT_DOWN);
				_buttonDataShiftLeft.disabledAsset = new AssetData(UI.BUTTON_PAGE_LEFT_DISABLE);
			}

			return _buttonDataShiftLeft;
		}

		// 右移三角按钮
		private static var _buttonDataShiftRight : GButtonData;

		public static function get buttonDataShiftRight() : GButtonData
		{
			if (!_buttonDataShiftRight)
			{
				_buttonDataShiftRight = new GButtonData();
				_buttonDataShiftRight.height = 21;
				_buttonDataShiftRight.width = 14;
				_buttonDataShiftRight.upAsset = new AssetData(UI.BUTTON_PAGE_RIGHT_UP);
				_buttonDataShiftRight.overAsset = new AssetData(UI.BUTTON_PAGE_RIGHT_OVER);
				_buttonDataShiftRight.downAsset = new AssetData(UI.BUTTON_PAGE_RIGHT_DOWN);
				_buttonDataShiftRight.disabledAsset = new AssetData(UI.BUTTON_PAGE_RIGHT_DISABLE);
			}

			return _buttonDataShiftRight;
		}

		// 文字按钮
		private static var _labelButtonData : LabelButtonData;

		public static function get labelButtonData() : LabelButtonData
		{
			if (!_labelButtonData)
			{
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = UIManager.defaultFont;
				textFormat.size = 12;
				textFormat.leading = 3;
				textFormat.color = 0xFFFFFF;
				textFormat.align = TextFormatAlign.CENTER;
				textFormat.underline = true;

				_labelButtonData = new LabelButtonData();
				_labelButtonData.upLabelData.autoSize = TextFieldAutoSize.CENTER;
				_labelButtonData.upLabelData.scaleMode = ScaleMode.AUTO_WIDTH;
				_labelButtonData.upLabelData.textFormat = textFormat;
				_labelButtonData.overLabelData.autoSize = TextFieldAutoSize.CENTER;
				_labelButtonData.overLabelData.scaleMode = ScaleMode.AUTO_WIDTH;
				_labelButtonData.overLabelData.filters = [FilterUtils.textOverFilter];
				_labelButtonData.overLabelData.textFormat = textFormat;
			}

			return _labelButtonData;
		}
		
		// 暗底checkbox
		private static var _checkBoxDataDark : GCheckBoxData;
		
		public static function get checkBoxDataDark() : GCheckBoxData
		{
			if (!_checkBoxDataDark)
			{
				_checkBoxDataDark = new GCheckBoxData();
				_checkBoxDataDark.labelData.textColor = 0xFFFFFF;
				_checkBoxDataDark.labelData.filters = [FilterUtils.defaultTextEdgeFilter];
			}
			
			return _checkBoxDataDark;
		}
		
		public static function createSprite(assetname:String = null, width:int = 0,height:int = 0,x:int = 0,y:int = 0):Sprite
		{
			var ui:Sprite = assetname == null ? new Sprite() : UIManager.getUI(new AssetData(assetname));
			if( ui != null )
			{
				ui.width = width ;
				ui.height = height ;
				ui.x = x ;
				ui.y = y ;
			}
			return ui ;
		}
//		// 暗底白色文字
//		private static var _labelDataWhiteCenter : GLabelData;
//		
//		public static function get labelDataWhiteCenter():GLabelData
//		{
//			if (!_labelDataWhiteCenter)
//			{
//				_labelDataWhiteCenter = new GLabelData();
//				_labelDataWhiteCenter.textFormat = TextFormatUtils.graphicLabel;
//			}
//			return _labelDataWhiteCenter;
//		}
	}
}
