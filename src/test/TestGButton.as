package test
{
	import com.commUI.tooltip.ToolTipData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.config.StaticConfig;
	import gameui.controls.GButton;
	import gameui.controls.GCheckBox;
	import gameui.controls.GRadioButton;
	import gameui.controls.GToggleButton;
	import gameui.data.GButtonData;
	import gameui.data.GCheckBoxData;
	import gameui.data.GRadioButtonData;
	import gameui.data.GToggleButtonData;
	import gameui.group.GToggleGroup;
	import net.LibData;
	import net.SWFLoader;
	import project.Game;






	[SWF(width=1000,height=570,backgroundColor=0x000000,frameRate=30)]
	public class TestGButton extends Game
	{
		private var _btn1 : GButton;
		private var _btn2 : GButton;
		private var _tb1 : GToggleButton;
		private var _tb2 : GToggleButton;
		private var _cb : GCheckBox;
		private var _rb1 : GRadioButton;
		private var _rb2 : GRadioButton;
		private var _rb3 : GRadioButton;

		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/ui.swf", "ui")));
			_res.addEventListener(Event.COMPLETE, completeHandler);
			_res.startLoad();
		}

		private function completeHandler(event : Event) : void
		{
			testButtons();
			testToggleButtons();
			testCheckBoxs();
			testRadioButtons();
		}

		private function testButtons() : void
		{
			var data : GButtonData = new GButtonData();
			data.x = 10;
			data.y = 10;
//			data.width = 100;
//			data.height = 24;
			data.labelData.text = "背";
			_btn1 = new GButton(data);
//			addChild(_btn1);
			_btn1.addEventListener(MouseEvent.CLICK, onClick);
			data.x = 100;
			data = data.clone();
			data.toolTipData=new ToolTipData();
			_btn2 = new GButton(data);
			_btn2.addEventListener(MouseEvent.CLICK, onClick2);
			addChild(_btn2);
		}

		private function onClick(event : MouseEvent) : void
		{
			//trace("onClick");
		}
		private var _text:String="";
		private function onClick2(event : MouseEvent) : void
		{
			//trace(group.selectionModel.index);
			_text+="afdasf";
			_btn2.toolTip.source=_text;
		}

		private function testToggleButtons() : void
		{
			var data : GToggleButtonData = new GToggleButtonData();
			data.x = 200;
			data.y = 10;
			data.labelData.text = "q";
			_tb1 = new GToggleButton(data);
			data = data.clone();
			data.x = 300;
			data.labelData.text = "3";
			_tb2 = new GToggleButton(data);
			_tb1.group = _tb2.group = new GToggleGroup();
			addChild(_tb1);
			addChild(_tb2);
		}

		private function testCheckBoxs() : void
		{
			var data : GCheckBoxData = new GCheckBoxData();
			data.x = 10;
			data.y = 50;
			// data.enabled = false;
			data.selected = true;
			data.labelData.text = "检查按钮";
			_cb = new GCheckBox(data);
			addChild(_cb);
		}

		private var group : GToggleGroup = new GToggleGroup();

		private function testRadioButtons() : void
		{
			var data : GRadioButtonData = new GRadioButtonData();
			data.x = 100;
			data.y = 50;
			data.labelData.text = "选择1";
			_rb1 = new GRadioButton(data);
			// data = data.clone();
			data.x = 160;
			// data.labelData.text = "选择2";
			_rb2 = new GRadioButton(data);
			data = data.clone();
			data.x = 220;
			// data.labelData.text = "选择3";
			_rb3 = new GRadioButton(data);
			_rb3.selected = true;
			
			_rb1.group = group;
			_rb2.group = group;
			_rb1.selected = true;
			addChild(_rb1);
			addChild(_rb2);
			addChild(_rb3);
		}

		private var arr : Array = [16777320, 16777238, 16777319, 16777316, 16777323, 16777324];

		// 50331752 50331670 50331751 50331748 50331755 50331756
		public function TestGButton()
		{
			super();
			for each (var num:int in arr)
			{
				//trace(num | 0x2000000);
			}
		}
	}
}
