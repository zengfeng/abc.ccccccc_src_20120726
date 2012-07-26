package com.commUI.tooltip
{
	import game.core.item.Item;
	import game.module.trade.exchange.ExchangeVO;
	import gameui.data.GToolTipData;


	/**
	 * @author jian
	 */
	public class ExchangeTip extends ToolTip
	{
		private var _myToolTip:ToolTip;
		private var _parterToolTip:ToolTip;
		
		public function ExchangeTip(data:ToolTipData)
		{
			super(data);

		}
		
		override protected function create():void
		{
			super.create();
			_backgroundSkin.visible = false;
			_myToolTip = new ToolTip(new ToolTipData());
			_parterToolTip = new ToolTip(new ToolTipData());
			_myToolTip.visible = false;
			_parterToolTip.visible = false;
			addChild(_myToolTip);
			addChild(_parterToolTip);			
		}
		
		override public function set source (value:*):void
		{
			if (!(value is ExchangeVO))
				return;
			
			_source = value;
			
			if (_source)
			{
				sourceMyToolTip();
				sourcePartnerToolTip();
				layout();
			}
		}
		
		private function sourceMyToolTip():void
		{
			var vo : ExchangeVO = _source as ExchangeVO;
			var string : String = "";
			string += '<font size="14"><b>我的交易物品</b></font>' + "\r";
			string += "元宝：" + vo.myPrice + "\r";
			for each (var item:Item in vo.myItems)
			{
				string += item.htmlName + "×" + item.nums + "\r";
			}
			_myToolTip.source =string;
			
		}
		
		private function sourcePartnerToolTip() : void
		{
			var vo : ExchangeVO = _source as ExchangeVO;
			var string : String = "";
			string += '<font size="14"><b>对方的交易物品</b></font>' + "\r";
			string += "元宝：" + vo.partnerPrice + "\r";
			for each (var item:Item in vo.partnerItems)
			{
				string += item.htmlName + "×" + item.nums + "\r";
			}
			_parterToolTip.source = string;
		}		
		
		override protected function layout():void
		{
			if (!_source) return;
			
			switch ((_source as ExchangeVO).status)
			{
				case ExchangeVO.I_START:
					_myToolTip.x = 0;
					_width = _myToolTip.width;
					_height = _myToolTip.height;
					_myToolTip.visible = true;
					_parterToolTip.visible = false;
					break;
				case ExchangeVO.HE_START:
					_parterToolTip.x = 0;
					_width = _parterToolTip.width;
					_height = _parterToolTip.height;
					_myToolTip.visible = false;
					_parterToolTip.visible = true;
					break;
				default:
					_myToolTip.x = 0;
					_parterToolTip.x = _myToolTip.width + 4;
					_width = _myToolTip.width + _parterToolTip.width + 4;
					_height = Math.max(_myToolTip.height, _parterToolTip.height);
					_myToolTip.visible = true;
					_parterToolTip.visible = true;
			}
		}
	}
}
