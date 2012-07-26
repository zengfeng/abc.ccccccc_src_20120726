package test
{
	import flash.events.Event;
	import flash.events.TextEvent;
	import game.config.StaticConfig;
	import gameui.cell.LabelSource;
	import gameui.controls.GComboBox;
	import gameui.data.GComboBoxData;
	import gameui.data.GListData;
	import gameui.data.GTextInputData;
	import net.LibData;
	import net.SWFLoader;
	import project.Game;





	/**
	 * @author Administrator
	 */
	public class TestComboBox extends Game
	{
		private var _comBoBox : GComboBox;

		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/ui.swf","ui")));
			_res.addEventListener(Event.COMPLETE,completeHandler);
			_res.startLoad();
		}

		public function TestComboBox()
		{
			super();
		}

		private function completeHandler(event : Event) : void
		{
			addComboBox();
		}

		private function addComboBox() : void
		{
			var data : GComboBoxData = new GComboBoxData();
			data.parent = this;
			data.x = 150;
			data.y = 8;
			// data.width=60;
			var listData : GListData = new GListData();
			// listData.width=60;
			data.listData = listData;
			data.editable=true;
			data.textInputData=new GTextInputData();
			_comBoBox = new GComboBox(data);
			_comBoBox.model.source = [new LabelSource("<font color='" + "#ffee00" + "'>" + "1级仙石" + "</font>",1), new LabelSource("2级仙石",2), new LabelSource("3级仙石",3), new LabelSource("4级仙石",4), new LabelSource("5级仙石",5), new LabelSource("6级仙石",6), new LabelSource("7级仙石",7)];
			_comBoBox.selectionModel.index = 0;
			_comBoBox.list.model.max=0;
			_comBoBox.selectionModel.addEventListener(Event.CHANGE,selection_changeHandler);
			_comBoBox.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			_comBoBox.addEventListener(Event.CHANGE,textInputHandler2);
			addChild(_comBoBox);
		}

		private function textInputHandler(event:TextEvent) : void
		{
//			//trace(event.text);
			_comBoBox.model.source = [new LabelSource("2级仙石",2), new LabelSource("3级仙石",3), new LabelSource("4级仙石",4), new LabelSource("5级仙石",5), new LabelSource("6级仙石",6), new LabelSource("7级仙石",7)];

//			_comBoBox.showList();
//			_comBoBox.list.setSelected(true, 1);
		}

		private function textInputHandler2(event:Event) : void
		{
//			//trace(_comBoBox.textInputText);
			_comBoBox.model.source = [new LabelSource("2级仙石",2), new LabelSource("3级仙石",3), new LabelSource("4级仙石",4), new LabelSource("5级仙石",5), new LabelSource("6级仙石",6), new LabelSource("7级仙石",7)];
//			_comBoBox.showList();
		}


		private function selection_changeHandler(event : Event) : void
		{
			//trace("_comBoBox.list.selection.value" + _comBoBox.list.selection);
			_comBoBox.model.source = [new LabelSource("2级仙石",2), new LabelSource("3级仙石",3), new LabelSource("4级仙石",4), new LabelSource("5级仙石",5), new LabelSource("6级仙石",6), new LabelSource("7级仙石",7)];
		}
	}
}
