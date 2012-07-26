package test
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.config.StaticConfig;
	import gameui.containers.GTreePanel;
	import gameui.controls.GButton;
	import gameui.data.GButtonData;
	import gameui.data.GTreePanelData;
	import model.TreeNode;
	import net.LibData;
	import net.SWFLoader;
	import project.Game;

	/**
	 * @author yangyiqiang
	 */
	public class TestTreePanel extends Game
	{
		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/ui.swf","ui")));
			_res.addEventListener(Event.COMPLETE, completeHandler);
			_res.startLoad();
		}

		private function completeHandler(event : Event) : void
		{
			initData();
			addTreePanel();
			initButton();
			initEvent();
		}

		private var addButton:GButton;
		private var removeButton:GButton;
		private function initButton() : void
		{
			var butData:GButtonData=new GButtonData();
			addButton=new GButton(butData);
			addButton.text ="增加节点";
			addChild(addButton);
			butData=butData.clone();
			butData.y=30;
			removeButton=new GButton(butData);
			removeButton.text = "删除节点";
			addChild(removeButton);
		}

		private function initEvent() : void
		{
			addButton.addEventListener(MouseEvent.CLICK, onAddItem);
			removeButton.addEventListener(MouseEvent.CLICK, onRemoveButton);
		}

		private function onAddItem(event:MouseEvent) : void
		{
			var obj:Object=new Object();
			obj["lable"]="新增加的";
			var arr:Array=[];
			for(var i:int=0;i<10;i++){
				var iobj:Object=new Object();
				iobj["lable"]=i+"子节点";
				arr.push(iobj);
			}
			obj["childrens"]=arr;
			_tree.addNode(new TreeNode(_tree.model.getRoot(),initData()));
		}
		
		private function onRemoveButton(event:MouseEvent):void
		{
			_tree.removeNode(_tree.model.getRoot().getChildrenAt(_tree.model.getRoot().getChildren().length-1));
		}

		private var _tree : GTreePanel;

		private function addTreePanel() : void
		{
			var data:GTreePanelData = new GTreePanelData();
			data.x = 300;
			data.width = 200;
			data.height = 500;
			_tree = new GTreePanel(data);
			addChild(_tree);
			_tree.source = initData();
		}

		private function initData() :Object
		{
			var _data:Object = new Object();
			_data["childrens"] = [];
			_data["lable"] = "root";
			_data["data"] = new Object();
			var tempArray : Array;
			var tempObj : Object = new Object();
			for (var i : int = 0;i < 10;i++)
			{
				tempObj = new Object();
				tempObj["lable"] = "		i====>" + i;
				tempObj["data"] = new Object();
				tempArray = [];
				for (var j : int = 0;j < 10;j++)
				{
					var obj : Object = new Object();
					obj["lable"] = "	j===>" + j;
					tempArray.push(obj);
					var arr : Array = [];
					for (var k : int = 0;k < 10;k++)
					{
						var _obj : Object = new Object();
						_obj["lable"] = "k===>" + k;
						_obj["data"] = new Object();
						var arr2:Array=[];
						for (var x : int = 0;x < 10;x++)
						{
							var _objx : Object = new Object();
							_objx["lable"] = "x===>" + x;
							_objx["data"] = new Object();
							arr2.push(_objx);
						}
						_obj["childrens"] = arr2;
						arr.push(_obj);
					}
					obj["childrens"] = arr;
				}
				tempObj["childrens"] = tempArray;
				(_data["childrens"] as Array).push(tempObj);
			}
			return _data;
		}

		public function TestTreePanel()
		{
			super();
		}
	}
}
