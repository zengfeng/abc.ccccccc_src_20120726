package com.commUI.tooltip
{
	import game.core.hero.VoHero;
	import game.core.item.Item;
	import game.core.user.UserData;
	import game.definition.UI;

	import gameui.controls.GLabel;
	import gameui.core.ScaleMode;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.IconLabel;
	import com.commUI.icon.ItemIcon;
	import com.commUI.icon.ItemIconData;
	import com.utils.ColorUtils;
	import com.utils.StringUtils;

	/**
	 * @author yangyiqiang
	 */
	public class ItemTip extends ToolTip
	{
		protected var _itemIcon : ItemIcon;
		protected var _nameLabel : GLabel;
		protected var _tradeLabel : IconLabel;

		public function ItemTip(data : ToolTipData)
		{
			data.labelData.scaleMode = ScaleMode.SCALE9GRID;
			data.labelData.wordWrap = true;
			super(data);
		}

		override protected function create() : void
		{
			super.create();

			addIcon();
			addNameLabel();
			addTradeLabel();
		}

		private function addIcon() : void
		{
			var data : ItemIconData = new ItemIconData();
			data.showBorder = true;

			_itemIcon = new ItemIcon(data);
			addChild(_itemIcon);
		}

		private function addNameLabel() : void
		{
			_nameLabel = new GLabel(_data.labelData.clone());
			addChild(_nameLabel);
		}
		
		protected function addTradeLabel():void
		{
			_tradeLabel = new IconLabel(_data.labelData.clone());
			_tradeLabel.icon = UIManager.getUI(new AssetData(UI.ICON_TRADABLE));
			_tradeLabel.hgap = 0;
			_tradeLabel.iconX = 2;
			_tradeLabel.iconY = 4;
			addChild(_tradeLabel);
		}

		override public function set source(value : *) : void
		{
			super.source = value;
			updateIcon();
			updateNameLabel();
			updateTradeLabel();
			layout();
		}

		protected function getNameLabelText() : String
		{
			var item : Item = _source;
			var text : String = "";

			if (item)
			{
				text += getItemNameText() + "\r";
				text += getBindingText() + "\r";
				if (item.useLevel > 1)
					text += getLevelText() + "\r";
			}

			return text;
		}

		private function updateNameLabel() : void
		{
			_nameLabel.htmlText = getNameLabelText();
		}

		private function updateTradeLabel() : void
		{
			if (_source)
			{
			_tradeLabel.htmlText = (_source as Item).binding ? "不可交易" : "可交易";
			_tradeLabel.showIcon = !(_source as Item).binding;	
			}
			else
			{
				_tradeLabel.htmlText = "";
				_tradeLabel.showIcon = false;
			}
		}

		private function updateIcon() : void
		{
			_itemIcon.source = _source;
		}

		override protected function getToolTipText() : String
		{
			var text : String = "";

			text += getDescriptionText() + "\r\r";
			text += getSellPriceText() + "\r";
			text += getSendChatText() + "\r";

			return text;
		}

		protected function getItemNameText() : String
		{
			var item : Item = _source as Item;
			var text : String = '<font size="14"><b>' + item.htmlName + "</b></font>";
			return text;
		}

		protected function getBindingText() : String
		{
			return "";
			// return (_source as Item).binding ? "不可交易" : "可交易";
		}

		// protected function getLevelText() : String
		// {
		// return "使用等级：" + Item(_source).useLevel + "级";
		// }
		protected function getLevelText() : String
		{
			var item : Item = _source;
			var hero : VoHero = UserData.instance.myHero;

			var text : String = "使用等级：";
			if (hero.level >= item.useLevel)
				text += String(item.useLevel);
			else
				text += StringUtils.addColor(String(item.useLevel), ColorUtils.WARN);
			text += "级";
			return text;
		}

		protected function getDescriptionText() : String
		{
			return "效果：" + Item(_source).description;
		}

		protected function getSellPriceText() : String
		{
			return StringUtils.addColor("可出售：" + Item(_source).price + "银币", ColorUtils.GRAY);
		}

		protected function getSendChatText() : String
		{
			return StringUtils.addColor("CTRL+左键发送到聊天频道", ColorUtils.GRAY);
		}

		override protected function layout() : void
		{
			if (_itemIcon)
			{
				_itemIcon.x = _data.padding;
				_itemIcon.y = _data.padding;

				_label.y = _itemIcon.y + _itemIcon.height + _data.padding;

				_nameLabel.x = _itemIcon.x + _itemIcon.width + _data.padding;
				_nameLabel.y = _data.padding;
				
				_tradeLabel.x = _nameLabel.x;
				_tradeLabel.y = _nameLabel.y + _nameLabel.textField.getLineMetrics(0).height;
			}

			_height = _label.y + _label.height + _data.padding;
			_width = Math.max(_label.x + _label.width, _nameLabel.x + _nameLabel.width) + _data.padding;
			_backgroundSkin.width = _width;
			_backgroundSkin.height = _height;
		}
	}
}
