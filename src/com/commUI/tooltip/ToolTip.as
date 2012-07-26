package com.commUI.tooltip
{
	import gameui.controls.GToolTip;

	public class ToolTip extends GToolTip
	{
		
		public function ToolTip(data : ToolTipData)
		{
			super(data);
		}

		override public function set source(value : *) : void
		{
			_source = value;

			if (_source)
			{
				_label.htmlText = getToolTipText();
			}
			else
			{
				_label.htmlText = "";
			}

			layout();
		}

		protected function getToolTipText() : String
		{
            if (_source is String)
            {
                return _source;
            }
            else
            {
				return "";
            }
		}

		override protected function layout() : void
		{		
			_width = _data.padding * 2 + _label.width;
			_height = _data.padding * 2 + _label.height;

			_backgroundSkin.width = _width;
			_backgroundSkin.height = _height;
		}
	}
}
