package test.toolbox
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author jian
	 */
	public class Toolbox
	{
		// 用于遍历所有显示对象
		public static function forEachChildIn(root : DisplayObjectContainer, func : Function, depth : int = 0, currentDepth : int = 0) : void
		{
			if (depth >= 0 && currentDepth > depth)
				return;

			var num : int = root.numChildren;

			for (var i : int = 0; i < num; i++)
			{
				var child : DisplayObject = root.getChildAt(i);
				if (func is Function)
				{
					if (!func(child, currentDepth))
						return;
				}

				if (child is DisplayObjectContainer)
				{
					forEachChildIn(child as DisplayObjectContainer, func, depth, currentDepth + 1);
				}
			}
		}
		

	}
}
