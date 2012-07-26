package test
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.config.StaticConfig;
	import gameui.containers.GPanel;
	import gameui.containers.GTabbedPanel;
	import gameui.containers.GTitleWindow;
	import gameui.controls.GButton;
	import gameui.data.GButtonData;
	import gameui.data.GPanelData;
	import gameui.data.GTabData;
	import gameui.data.GTabbedPanelData;
	import gameui.data.GTitleWindowData;
	import net.AssetData;
	import net.LibData;
	import net.SWFLoader;
	import project.Game;




	[SWF(width=1000,height=570,backgroundColor=0x003399,frameRate=30)]

	public class TestGPanel extends Game {

		private var _panel : GPanel;

		private var _panel2 : GPanel;
		
		private var _panel3 : GPanel;
		
		private var _panel4 : GPanel;
		
		private var titleWindow:GTitleWindow;

		private var _tabbedPanel : GTabbedPanel;

		override protected function initGame() : void {
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/ui.swf","ui")));
			_res.addEventListener(Event.COMPLETE, completeHandler);
			_res.startLoad();
		}

		private function completeHandler(event : Event) : void {
			addPanel();
			addTabbedPanel();
		}

		private function addPanel() : void {
			var data : GPanelData = new GPanelData();
			data.bgAsset = new AssetData("GTabbedPanel_backgroundSkin");
			data.width = 149;
			data.height = 150 + 13;
			data.padding = 0;
			_panel = new GPanel(data);
			_panel3 = new GPanel(data);
			_panel4 = new GPanel(data);
			data = data.clone();
			_panel2 = new GPanel(data);
			var buttonData : GButtonData = new GButtonData();
			buttonData.x = 10;
			buttonData.y = 10;
			buttonData.labelData.text = "测试1";
			_panel.add(new GButton(buttonData));
			buttonData = buttonData.clone();
			buttonData.y = 50;
			buttonData.labelData.text = "测试2";
			_panel2.add(new GButton(buttonData));
			_panel2.addEventListener(MouseEvent.CLICK, onClick2);
			var titleData:GTitleWindowData=new GTitleWindowData();
			titleData.width=400;
			titleData.height=200;
			titleData.x=100;
			titleData.y=100;
			titleWindow=new GTitleWindow(titleData);
			addChild(titleWindow);
			
			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function addTabbedPanel() : void {
			var tabData:GTabData=new GTabData();
			tabData.gap=2;
			var data : GTabbedPanelData = new GTabbedPanelData();
			data.x = 10;
			data.y = 10;
			data.tabData=tabData;
			_tabbedPanel = new GTabbedPanel(data);
			_tabbedPanel.addTab("转移", _panel);
			_tabbedPanel.addTab("天材地宝", _panel2);
			_tabbedPanel.addTab("转移", _panel3);
			_tabbedPanel.addTab("帽子", _panel4);
			addChild(_tabbedPanel);
		}

		private function onClick(event:MouseEvent) : void
		{
//			_tabbedPanel.removeTab(_panel3);
		}

		private function onClick2(event:MouseEvent) : void
		{
//			_tabbedPanel.addTab("test2",_panel2,1);
		}

		public function TestGPanel() {
			super();
		}
	}
}
