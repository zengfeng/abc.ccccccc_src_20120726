package game.module.trade.market
{
	import com.utils.TextFormatUtils;
	import game.definition.UI;
	import gameui.cell.GTreeCellData;
	import gameui.cell.TreeCell;
	import gameui.controls.GLabel;
	import gameui.core.ScaleMode;
	import gameui.data.GLabelData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import model.TreeNode;
	import net.AssetData;




	/**
	 * @author yangyiqiang
	 */
	public class MarketPropCell extends TreeCell
	{
		public function MarketPropCell()
		{
			_data = new GTreeCellData();
			initData();
			super(_data);
			initView();
			initEvent();
		}


        //创建分类树节点
		override protected function create() : void
		{
			_upSkin = UIManager.getUI(new AssetData(UI.TRADE_TREEUP));
			_overSkin = UIManager.getUI(new AssetData(UI.TRADE_TREEOVER));
		//	_selected_upSkin = UIManager.getUI(new AssetData(UI.TRADE_SIGNUP));
		//	_selected_upSkin = UIManager.getUI(new AssetData(UI.TRADE_TREESEUP));
		    _selected_upSkin = UIManager.getUI(new AssetData(UI.TRADE_TREESEOVER));
			_selected_overSkin = UIManager.getUI(new AssetData(UI.TRADE_TREESEOVER));
		//	_disabledSkin = UIManager.getUI(new AssetData(UI.TRADE_SIGNDOWN));
			_current = _upSkin;
			addChild(_current);
			switch(_data.scaleMode)
			{
				case ScaleMode.SCALE_WIDTH:
					_height = _upSkin.height;
					break;
				case ScaleMode.SCALE_NONE:
					_width = _upSkin.width;
					_height = _upSkin.height;
					break;
			}			
			
		}
		
		//初始化节点的宽和高
		private function initData() : void
		{
			_data.width = 120;
			_data.height = 18;
			_data.x=10;
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
			data.textFieldFilters = [];
			data.textFormat = TextFormatUtils.panelContentNoLeading;
			data.y = -1;
			lable = new GLabel(data);
			addChild(lable);
		}
		
		public function getData1():int
		{
			return _node.getData()["data"];
		}
		
		private var _node:TreeNode;
		
		//节点id为十的倍数的节点作为根节点
		override public function set source(value : *) : void
		{
			 _source = value;
			 _node = TreeNode(value);
			 var _id:uint=_node.getData()["data"];
			 
			lable.htmlText = _node.getLable();
			if(_id%10!=0)
			{		
				 _upSkin=UIManager.getUI(new AssetData(SkinStyle.emptySkin));
				 _overSkin = UIManager.getUI(new AssetData(UI.TRADE_TREE_SUBNODE_SELECTBG));
				 _selected_upSkin = UIManager.getUI(new AssetData(UI.TRADE_TREE_SUBNODE_SELECTBG));
				 _selected_overSkin= UIManager.getUI(new AssetData(UI.TRADE_TREE_SUBNODE_SELECTBG));
				 viewSkin();
			}

		}

		override public function get source() : *
		{
			return _source;
		}
	}
}
