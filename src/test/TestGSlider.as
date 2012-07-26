package  test
{
	import flash.events.Event;
	import game.config.StaticConfig;
	import gameui.controls.GLabel;
	import gameui.controls.GSlider;
	import gameui.data.GLabelData;
	import gameui.data.GSliderData;
	import gameui.data.GToolTipData;
	import net.LibData;
	import net.SWFLoader;
	import project.Game;




	/**
	 * @author Administrator
	 */
	public class TestGSlider extends Game
	{
		private var slider1 : GSlider;

		private var slider2 : GSlider;

		private var lable1 : GLabel;

		private var lable2 : GLabel;

		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/ui.swf","ui")));
			_res.addEventListener(Event.COMPLETE, completeHandler);
			_res.startLoad();
		}

		private function completeHandler(event : Event) : void
		{
			addSlider();
		}

		private function addSlider() : void
		{
			var data : GSliderData = new GSliderData();
			data.x = 100;
			data.y = 50;
			slider1 = new GSlider(data);
			slider1.model.addEventListener(Event.CHANGE, onChange1);
			data = data.clone();
			data.y = 100;
			slider2 = new GSlider(data.clone());
			slider2.direction = GSlider.VERTICAL;
			slider2.model.addEventListener(Event.CHANGE, onChange2);
			addChild(slider1);
			addChild(slider2);
			var lableData : GLabelData = new GLabelData();
			lableData.x = 50;
			lableData.y = 50;
			var tipData:GToolTipData=new GToolTipData();
			tipData.width=100;
			lableData.toolTipData=tipData;
			lable1 = new GLabel(lableData);
			lable1.text = slider1.model.value.toString();
			lableData = lableData.clone();
			lableData.y = 100;
			lable2 = new GLabel(lableData);
			lable2.text = slider2.model.value.toString();
			slider2.model.value = 10;
			lable1.toolTip.source = "工作进度:"+lable1.text;
			lable2.toolTip.source = "工作进度:"+lable2.text;
			addChild(lable1);
			addChild(lable2);
		}

		private function onChange1(event : Event) : void
		{
			lable1.text = slider1.model.value.toString() + "%";
			lable1.toolTip.source = "工作进度:"+lable1.text;
		}

		private function onChange2(event : Event) : void
		{
			lable2.text = slider2.model.value.toString() + "%";
			lable2.toolTip.source = "工作进度:"+lable2.text;
		}

		public function TestGSlider()
		{
			super();
		}
	}
}
