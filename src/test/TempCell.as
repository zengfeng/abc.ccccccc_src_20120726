package test
{
	import gameui.cell.GTreeCellData;
	import gameui.cell.TreeCell;
	import gameui.controls.GLabel;
	import gameui.data.GLabelData;
	import model.TreeNode;

	/**
	 * @author yangyiqiang
	 */
	public class TempCell extends TreeCell
	{
		public function TempCell()
		{
			_data = new GTreeCellData();
			initData();
			super(_data);
			initView();
			initEvent();
		}

		private function initData() : void
		{
			_data.width = 100;
			_data.height = 20;
		}

		private function initView() : void
		{
			initLable();
		}

		private function initEvent() : void
		{
		}

		private var lable : GLabel;

		private function initLable() : void
		{
			var data : GLabelData = new GLabelData();
			lable = new GLabel(data);
			addChild(lable);
		}

		override public function set source(value : *) : void
		{
			_source = value;
			var node : TreeNode = TreeNode(value);
			lable.htmlText = node.getLable();
		}

		override public function get source() : *
		{
			return _source;
		}
	}
}
