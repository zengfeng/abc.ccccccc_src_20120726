package test
{
	import project.Game;

	import com.commUI.pager.Pager;

	/**
	 * @author jian
	 */
	public class TestPager extends Game
	{
		override protected function initGame() : void
		{
			for (var i : uint = 0; i < 10; i++)
			{
				for (var j : uint = 0; j <= i + 5; j++)
				{
					var pager : Pager = new Pager(i + 1);
					pager.x = 15 * i * (10 + i);
					pager.y = 20 * j;
					pager.setPage(1, j + 1);
					addChild(pager);
				}
			}
		}
	}
}
