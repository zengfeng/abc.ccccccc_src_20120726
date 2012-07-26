package com.commUI.icon
{
	import com.utils.FilterUtils;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import game.module.enhance.EnhanceUtils;
	import gameui.controls.GImage;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GIconData;
	import gameui.data.GImageData;





	/**
	 * @author verycd
	 */
	public class CommonIcon extends GComponent
	{
		// =====================
		// @属性
		// =====================
		// 主图片
		protected var _iconBitmap : GImage;
		// 边框
		protected var _border : Sprite;
		// 可交易图标
		protected var _tradeIcon : Sprite;
		// 底板
		protected var _background : Sprite;
		// 物品或人物等级
		protected var _levelText : TextField;
		// 堆叠数量
		protected var _pileNumText : TextField;
		// 所有者名字
		protected var _ownerText : TextField;
		// 物品名称
		protected var _nameText : TextField;

		// =====================
		// Setter/Getter
		// =====================
		/*
		 * 根据url载入图片
		 */
		public function set iconUrl(iconUrl : String) : void
		{
			if (iconUrl)
				_iconBitmap.url = iconUrl;
			else
				_iconBitmap.clearUp();
		}

		/*
		 * 设置边框
		 */
		public function set border(border : Sprite) : void
		{
			if (_border)
				removeChild(_border);

			_border = border;

			if (_border)
			{
				_border.width = width;
				_border.height = height;
				_border.mouseEnabled = false;
				addChild(_border);
			}
		}

		/*
		 * 设置背景
		 */
		public function set background(background : Sprite) : void
		{
			if (_background)
				removeChild(_background);

			_background = background;

			if (_background)
			{
				_background.width = width;
				_background.height = height;
				_background.mouseEnabled = false;
				addChildAt(_background, 0);
			}
		}

		/*
		 * 设置交易图标
		 */
		public function set tradeIcon(bindIcon : Sprite) : void
		{
			if (_tradeIcon)
				removeChild(_tradeIcon);

			_tradeIcon = bindIcon;

			if (_tradeIcon)
			{
				_tradeIcon.x = width - 12;
				_tradeIcon.y = 2;
				_tradeIcon.mouseEnabled = false;
				addChild(_tradeIcon);
			}
		}

		/*
		 * 设置强化等级
		 */
		public function set level(value : String) : void
		{
			if (!_levelText)
			{
				_levelText = new TextField();
				_levelText.x = 0;
				_levelText.y = 0;
				_levelText.width = _width;
				_levelText.height = 20;
				_levelText.mouseEnabled = false;
				_levelText.defaultTextFormat = TextFormatUtils.content;
				_levelText.filters = [FilterUtils.iconTextEdgeFilter];
				addChild(_levelText);
			}

			if (value)
				_levelText.htmlText = value;
			else
				_levelText.htmlText = "";
		}

		/*
		 * 设置堆叠个数
		 */
		public function set pileNums(str : String) : void
		{
			if (!_pileNumText)
			{
				_pileNumText = new TextField();
				_pileNumText.x = width - 26;
				_pileNumText.y = height - 20;
				_pileNumText.width = 25;
				_pileNumText.height = 20;
				_pileNumText.mouseEnabled = false;
				_pileNumText.defaultTextFormat = TextFormatUtils.content;
				_pileNumText.autoSize = TextFieldAutoSize.RIGHT;
				_pileNumText.filters = [FilterUtils.iconTextEdgeFilter];
				addChild(_pileNumText);
			}
			_pileNumText.htmlText = str;
		}

		/*
		 * 设置所有者
		 */
		public function set owner(value : String) : void
		{
			// 创建对象
			if (!_ownerText)
			{
				_ownerText = new TextField();
				_ownerText.x = (width - 16) / 2;
				_ownerText.y = height - 18;
				_ownerText.mouseEnabled = false;
				_ownerText.width = 20;
				_ownerText.height = 16;
				_ownerText.defaultTextFormat = TextFormatUtils.content;
				_ownerText.filters = [FilterUtils.iconTextEdgeFilter];

				addChild(_ownerText);
			}

			_ownerText.htmlText = EnhanceUtils.getOwnerFirstCharHtmlText(value);
		}

		public function set htmlName(value : String) : void
		{
			if (!_nameText)
			{
				_nameText = new TextField();
				_nameText.x = 1;
				_nameText.y = height - 14;
				_nameText.mouseEnabled = false;
				_nameText.width = width;
				_nameText.height = 16;
				_nameText.defaultTextFormat = TextFormatUtils.iconName;
				_nameText.filters = [FilterUtils.iconTextEdgeFilter];

				addChild(_nameText);
			}

			_nameText.htmlText = value;
		}

		// =====================
		// @方法
		// =====================
		public function CommonIcon(data : GComponentData)
		{
			super(data);
		}

		/*
		 * 创建
		 */
		override protected function create() : void
		{
			super.create();

			var imageData : GImageData = new GImageData();
			imageData.x = 0;
			imageData.y = 0;
			imageData.iocData.align = new GAlign(0, -1, 0, -1);
			_iconBitmap = new GImage(imageData);
			addChild(_iconBitmap);
		}

		/*
		 * 清除图标
		 */
		public function clear() : void
		{
			_iconBitmap.clearUp();
			this.border = null;
			if (_tradeIcon && _tradeIcon.parent) removeChild(_tradeIcon);
			if (_levelText) _levelText.htmlText = "";
			if (_levelText) _levelText.htmlText = "";
			if (_pileNumText) _pileNumText.htmlText = "";
			if (_ownerText) _ownerText.htmlText = "";
			if (_nameText) _nameText.htmlText = "";
		}
	}
}
