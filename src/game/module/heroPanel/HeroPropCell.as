package game.module.heroPanel
{
	import gameui.cell.GTreeCellData;
	import gameui.cell.TreeCell;
	import gameui.controls.GLabel;
	import gameui.data.GLabelData;

	import model.TreeNode;

	import net.AssetData;

	/**
	 * @author yangyiqiang
	 */
	public class HeroPropCell extends TreeCell
	{
		// =====================
		// 属性
		// =====================
		private var _label : GLabel;

		// =====================
		// Setter/Getter
		// =====================
		override public function set source(value : *) : void
		{
			_source = value;
			updateNode();
		}

		override public function get source() : *
		{
			return _source;
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function HeroPropCell()
		{
			var data : GTreeCellData = new GTreeCellData();
			data.width = 100;
			data.height = 16;
			data.upAsset = new AssetData("tree_node_up");
			data.overAsset = new AssetData("tree_node_over");
			data.selected_upAsset = new AssetData("tree_node_seldown");
			data.selected_overAsset = new AssetData("tree_node_selover");
			data.disabledAsset = new AssetData("tree_node_seldown");
			
			_data = data;
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			addLabel();
		}

		private function addLabel() : void
		{
			var data : GLabelData = new GLabelData();
			data.textFieldFilters = [];
			_label = new GLabel(data);
			addChild(_label);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateNode() : void
		{
			var node : TreeNode = TreeNode(_source);
			_label.htmlText = node.getLable();
			if (node.getData()["data"] is GLabel)
			{
				_label.hide();
				_label = node.getData()["data"] as GLabel;
				addChild(_label);
			}
			
			this.visible = node.hasChildren();
//			if (!node.hasChildren())
//			{
//				if (this.contains(_current))
//					removeChild(_current);
//			}
		}
	}
}
