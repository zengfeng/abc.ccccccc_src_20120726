package test
{
	import model.TreeNode;
	import model.TreeBuilder;
	import flash.display.Sprite;

	/**
	 * @author yangyiqiang
	 */
	public class TestTree extends Sprite
	{
		private var _data : Object;

		public function TestTree()
		{
			initData();
			initTree();
		}

		private function initData() : void
		{
			_data = new Object();
			_data["childrens"] = [];
			_data["lable"] = "root";
			var tempArray : Array;
			var tempObj : Object = new Object();
			for (var i : int = 0;i < 10;i++)
			{
				tempObj = new Object();
				tempObj["lable"] = "		i====>" + i;
				tempArray = [];
				for (var j : int = 0;j < 10;j++)
				{
					var obj : Object = new Object();
					obj["lable"] = "	j===>" + j;
					tempArray.push(obj);
					var arr : Array = [];
					for (var k : int = 0;k < 2;k++)
					{
						var _obj : Object = new Object();
						_obj["lable"] = "k===>" + k;
						arr.push(_obj);
					}
					obj["childrens"] = arr;
				}
				tempObj["childrens"] = tempArray;
				(_data["childrens"] as Array).push(tempObj);
			}
		}

		private var _root : TreeNode;
		

		private function initTree() : void
		{
			var builder : TreeBuilder = new TreeBuilder();
			_root = builder.generateTree(_data);
			//showNode(_root);
			_root.removeChildAt(0);
			showNode(_root);
		}
		

		private function showNode(root : TreeNode) : void
		{
			if (!root) return;
			var arr : Vector.<TreeNode> =root.getChildren();
			for each (var node:TreeNode in arr)
			{
				//trace(node.toString());
				showNode(node);
			}
		}
	}
}
