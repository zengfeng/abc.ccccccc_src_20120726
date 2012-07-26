package test
{
	import flash.display.Sprite;
	import flash.events.Event;
	import game.config.StaticConfig;
	import gameui.cell.GCellData;
	import gameui.containers.GPanel;
	import gameui.data.GPanelData;
	import net.LibData;
	import net.SWFLoader;
	import project.Game;





	/**
	 * @author yangyiqiang
	 */
	public class TestGGird extends Game
	{
		private var gird : GPanel;

		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/ui.swf", "ui")));
			_res.addEventListener(Event.COMPLETE, completeHandler);
			_res.startLoad();
		}

		private function completeHandler(event : Event) : void
		{
			var cellData : GCellData = new GCellData();
			cellData.width = 80;
			cellData.height = 80;
			var panelData : GPanelData = new GPanelData();
			panelData.width = 450;
			panelData.height = 243;
			gird = new GPanel(panelData);

			for (var i : int = 0;i < 50;i++)
			{
				var data : Sprite = new Sprite();
				if (i % 2)
					data.graphics.beginFill(0xffff00);
				else
					data.graphics.beginFill(0xff0000);
				data.graphics.drawRect(0, 0, 50, 50);
				data.graphics.endFill();
				data.x = i % 5 * 50;
				data.y = int(i / 5) * 50;
				gird.add(data);
//				var data : GCellData = cellData.clone();
//				data.x = i % 5 * 82;
//				data.y = int(i / 5) * 80;
//				gird.add(new GCell(data));
			}
						
			addChild(gird);
		}

		public function TestGGird()
		{
			super();
		}
	}
}
