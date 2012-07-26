package game.module.heroPanel {
	import game.core.hero.VoHero;
	import game.manager.RSSManager;
	import game.manager.SignalBusManager;

	import gameui.containers.GTreePanel;
	import gameui.controls.GLabel;
	import gameui.data.GLabelData;
	import gameui.data.GTitleWindowData;
	import gameui.data.GToolTipData;
	import gameui.data.GTreePanelData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import model.TreeNode;

	import net.AssetData;

	import com.commUI.GCommonSmallWindow;
	import com.utils.StringUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;






	/**
	 * @author yangyiqiang
	 */
	public class HeroPropPanel extends GCommonSmallWindow
	{
		// =====================
		// 属性
		// =====================
		private var _hero : VoHero;
		private var _prop : Dictionary = new Dictionary(true);
		private var _tree : GTreePanel;
		private var _specialLabel : Dictionary = new Dictionary(true);
		private var _root : TreeNode;
		private var _specialVar : Vector.<TreeNode> = new Vector.<TreeNode>();

		// =====================
		// Setter/Getter
		// =====================
		override public function set source(value : *) : void
		{
			_hero = value;
			refreshProp();
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function HeroPropPanel(data:GTitleWindowData)
		{
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			
			this.title = "属性";

			addBackground();
			addGeneralProps();
			addSpecialProps();
		}

		private function addBackground() : void
		{
			var propBg : Sprite = UIManager.getUI(new AssetData("common_background_02"));
			if (!propBg) return;
			propBg.width = this.width - 10;
			propBg.height = this.height - 5;
			propBg.x = 5;
			propBg.y = 0;
			this.contentPanel.add(propBg);
		}

		private function addGeneralProps() : void
		{
			var xml : XML = RSSManager.getInstance().getData("heroPanel");
			if (!xml) return;
			var label : GLabel;
			var data : GLabelData = new GLabelData();
			data.textFieldFilters = [];
			data.x = 14;
			for each (var item:XML in xml["HeroPropPanel"]["item"])
			{
				data = data.clone();
				data.y = item.@y;
				if (item.@tips == undefined || item.@tips == "")
				{
					data.toolTipData = null;
				}
				else
				{
					data.toolTipData = new GToolTipData();
				}
				label = new GLabel(data);
				if (data.toolTipData)
					label.toolTip.source = item.@tips;
				if (Number(item.@id) < 30)
				{
					this.contentPanel.add(label);
					_prop[Number(item.@id)] = label;
				}
				else
				{
					_specialLabel[Number(item.@id)] = label;
				}
			}
		}

		private function addSpecialProps() : void
		{
			var treeData : GTreePanelData = new GTreePanelData();
			treeData.bgAsset = new AssetData(SkinStyle.emptySkin, AssetData.AS_LIB);
			treeData.vGap = 0;
			treeData.height = 75;
			treeData.variableH = true;
			_tree = new GTreePanel(treeData);

			addChild(_tree);
			// this.contentPanel.add(_tree);
			_tree.width = 100;
			_tree.height = 75;
			_tree.x = 14;
			_tree.y = 325;
			_tree.cell = HeroPropCell;
			_tree.source = initTreeData();
			_root = _tree.model.getRoot().getChildren()[0];
			this.layout();
		}

		private function initTreeData() : Object
		{
			var _data : Object = new Object();
			_data["lable"] = "";
			var obj : Object = new Object();
			obj["lable"] = StringUtils.addColor("特殊属性", "#000000");
			obj["data"] = new Object();
			_data["childrens"] = [obj];
			return _data;
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function refreshTree() : void
		{
			if (_root)
			{
				_tree.removeNode(_root);
				_root.setChildren(_specialVar);
				_tree.addNode(_root);
				this.layout();
			}
		}

		public function refreshProp() : void
		{
			if (!_hero) return;
			var xml : XML = RSSManager.getInstance().getData("heroPanel");
			if (!xml) return;
			var lable : GLabel;
			var str : String = "";
			_specialVar = new Vector.<TreeNode>();
			for each (var item:XML in xml["HeroPropPanel"]["item"])
			{
				lable = Number(item.@id) > 29 ? _specialLabel[Number(item.@id)] : _prop[Number(item.@id)];
				str = item.children();
				if (20 < Number(item.@id) && Number(item.@id) < 30)
				{
					str = str.replace("*****", Math.round(_hero.prop[item.@name] * 10) / 10);
				}
				else
				{
					str = str.replace("*****", Math.round(_hero.prop[item.@name]));
				}
				str = str.replace("+#####", "");
				if (!lable) continue;
				lable.htmlText = str;
				if (Number(item.@id) > 30 && _hero.prop[item.@name] > 0)
				{
					var _obj : Object = new Object();
					_obj["lable"] = str;
					_obj["data"] = lable;
					_obj["childrens"] = [];
					_specialVar.push(new TreeNode(_root, _obj));
				}
			}
			refreshTree();
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			_tree.addEventListener(Event.CHANGE, tree_ChangeHandler);
			SignalBusManager.heroPropChange.add(onHeroPropChange);
		}

		override protected function onHide() : void
		{
			_tree.removeEventListener(Event.CHANGE, tree_ChangeHandler);
			SignalBusManager.heroPropChange.remove(onHeroPropChange);
			super.onHide();
		}
		
		private function onHeroPropChange(hero:VoHero):void
		{
			if (_source && hero.id == _source.id)
			{
				refreshProp();
			}
		}

		private function tree_ChangeHandler(event : Event) : void
		{
			this.layout();
		}
	}
}
