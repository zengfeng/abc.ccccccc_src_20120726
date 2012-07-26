package test
{
	import net.AssetData;
	import gameui.manager.UIManager;
	import flash.utils.getTimer;
	import flash.display.Sprite;

	/**
	 * @author jian
	 */
	public class TestPerformances extends Sprite
	{
		public function TestPerformances()
		{
			testNewAssetData();
		}
		
		private function testGetEdgeFilters():void
		{
			var times:int = 10000;
			//trace("=======================================");
			//trace("  测试UIManager.getEdgeFilters()的效率：");
			//trace("  调用" + times + "次函数，计算需要时间");
			//trace("\r\r");
			var startTime:int = getTimer();
			//trace("  测试开始 >" + startTime);
			
			for (var i:int = 0; i<times; i++)
			{
				UIManager.getEdgeFilters();
			}
			var endTime:int = getTimer();
			//trace("  测试结束 >" + endTime);
			//trace("  测试用时 >" + (endTime - startTime));
		}
		
		private function testNewAssetData():void
		{
			var times:int = 10000;
			//trace("=======================================");
			//trace("  测试new AssetData()的效率：");
			//trace("  调用" + times + "次函数，计算需要时间");
			//trace("\r\r");
			var startTime:int = getTimer();
			//trace("  测试开始 >" + startTime);
			
			for (var i:int = 0; i<times; i++)
			{
				new AssetData("classname", "uilib");
			}
			var endTime:int = getTimer();
			//trace("  测试结束 >" + endTime);
			//trace("  测试用时 >" + (endTime - startTime));
		}
	}
}
