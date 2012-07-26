package com.commUI.icon
{
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.text.TextField;
	import game.core.item.Item;
	import game.definition.ID;
	import gameui.controls.GCheckBox;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GCheckBoxData;





	/**
	 * @author jian
	 */
	public class ExpenseIcon extends GComponent
	{
		// =====================
		// 属性
		// =====================
		private var _icon : ItemIcon;
		private var _text : TextField;
		private var _item : Item;
		private var _nums : uint;
		private var _ckBox : GCheckBox;
		private var _checkText:String;

		// =====================
		// Setter/Getter
		// =====================
		public function setExpense(item : Item, nums : uint, checkText : String = null) : void
		{
			_item = item;
			_nums = nums;
			_checkText = checkText;
			
			if (checkText && !_ckBox)
			{
				addCheckBox();
			}

			if (_item)
			{
				updateIcon();
				updateText();
				updateCheckBox();
			}
			else
			{
				clear();
			}
		}

		override public function get source() : *
		{
			return _icon.source;
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function ExpenseIcon(base : GComponentData)
		{
			super(base);
		}

		override protected function create() : void
		{
			addItemIcon();
			addText();
		}

		private function addItemIcon() : void
		{
			_icon = UICreateUtils.createItemIcon({x:10, y:0, showBorder:true, showBg:true, showToolTip:true, showShopping:true, showNums:true, showRollOver:true});
			addChild(_icon);
		}

		private function addText() : void
		{
			_text = UICreateUtils.createTextField(null, null, 68, 20, 0, 50, TextFormatUtils.panelContentCenter);
			addChild(_text);
		}
		
		private function addCheckBox():void
		{
			var data:GCheckBoxData=new GCheckBoxData();
			data.x=0;
			data.y=50;
			data.height=20;
			data.width=68;
			_ckBox = new GCheckBox(data);
			addChild(_ckBox);		
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateIcon() : void
		{
			_icon.source = _item;

			if (_item.id == ID.SILVER)
				_icon.showNums = false;
			else
				_icon.showNums = true;
		}

		private function updateText() : void
		{
			if (_checkText)
			{
				_text.visible = false;
			}
			else
			{
				_text.visible = true;
				if (_item.id == ID.SILVER)
					_text.text = _nums.toString();
				else
					_text.text = "消耗×" + _nums;
			}
		}
		
		private function updateCheckBox():void
		{
			if (_checkText)
			{
				_ckBox.visible = true;
				if (_ckBox.selected)
					_ckBox.text = "消耗×" + _nums;
				else
					_ckBox.text = _checkText;
			}
			else
			{
				if (_ckBox)
					_ckBox.visible = false;
			}
		}

		private function clear() : void
		{
			_icon.source = null;
			_text.text = "";
		}
	}
}
