package worlds.maps.layers
{
	import worlds.auxiliarys.PointShape;
	import worlds.maps.UIMediator;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
	 */
	public class UILayer extends Sprite
	{
		// ===========
		// 绘制地图高宽的两个点
		// ===========
		private var leftTopPointShape : PointShape;
		private var rightBottomPointShape : PointShape;
		private var list : Vector.<DisplayObject>;
		private var container : Sprite;

		function UILayer(container : Sprite) : void
		{
			leftTopPointShape = new PointShape();
			rightBottomPointShape = new PointShape();
			addChild(leftTopPointShape);
			addChild(rightBottomPointShape);
//			this.mouseChildren = false;
//			this.mouseEnabled = false;

			this.container = container;
			list = new Vector.<DisplayObject>();
			UIMediator.cAdd.register(add);
			UIMediator.cRemove.register(remove);
			UIMediator.cClearup.register(clearup);
		}

		public function resetMapSize(mapWidth : int, mapHeight : int) : void
		{
			rightBottomPointShape.x = mapWidth - rightBottomPointShape.width;
			rightBottomPointShape.y = mapHeight - rightBottomPointShape.height;
		}

		public function add(child : DisplayObject) : void
		{
			if (list.indexOf(child) != -1) return;
			addChild(child);
			list.push(child);
			if (list.length == 1)
			{
				show();
			}
		}

		public function remove(child : DisplayObject) : void
		{
			var index : int = list.indexOf(child) ;
			if (index == -1) return;
			removeChild(child);
			list.splice(index, 1);
			if (list.length == 0)
			{
				hide();
			}
		}

		public function clearup() : void
		{
			var child : DisplayObject;
			while (list.length > 0)
			{
				child = list.pop();
				removeChild(child);
			}
			hide();
		}

		private function show() : void
		{
			container.addChild(this);
		}

		private function hide() : void
		{
			if (parent) parent.removeChild(this);
		}
	}
}
