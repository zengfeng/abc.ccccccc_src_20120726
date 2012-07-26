package com.commUI.labelButton
{
	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;

	/**
	 * @author jian
	 */
	public class LabelButtonData extends GComponentData
	{
		public var upLabelData : GLabelData;
		public var overLabelData : GLabelData;

		override protected function parse(source : *) : void
		{
			super.parse(source);
			var data : LabelButtonData = source as LabelButtonData;
			if (data == null) return;
			data.upLabelData = upLabelData;
			data.overLabelData = overLabelData;
		}

		public function LabelButtonData()
		{
			width = 70;
			height = 24;
			upLabelData = new GLabelData();
			upLabelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			overLabelData = new GLabelData();
			overLabelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
		}

		override public function clone() : *
		{
			var data : LabelButtonData = new LabelButtonData();
			parse(data);
			return data;
		}
	}
}
