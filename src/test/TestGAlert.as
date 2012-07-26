package test
{
	import flash.events.Event;
	import game.config.StaticConfig;
	import gameui.controls.GAlert;
	import gameui.controls.GLabel;
	import gameui.data.GAlertData;
	import gameui.data.GLabelData;
	import gameui.manager.UIManager;
	import net.AssetData;
	import net.LibData;
	import net.SWFLoader;
	import project.Game;
	import utils.BDUtil;





	[SWF(width=1000,height=570,backgroundColor=0x003399,frameRate=30)]

	public class TestGAlert extends Game {

		override protected function initGame() : void {
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/ui.swf","ui")));
			_res.addEventListener(Event.COMPLETE, completeHandler);
			_res.startLoad();
		}

		private function completeHandler(event : Event) : void {
			addLabel();
			addAlert();
		}

		private function addLabel() : void {
			var data : GLabelData = new GLabelData();
//			data.iconData.bitmapData = BDUtil.getBD(new AssetData("light_22"));
			data.text = "你真的要删除[单管炮]1个?";
			var label : GLabel = new GLabel(data);
			addChild(label);
		}

		private function addAlert() : void {
			var data : GAlertData = new GAlertData();
			data.parent = UIManager.root;
//			data.labelData.iconData.bitmapData = BDUtil.getBD(new AssetData("light_22"));
			//data.textInputData = new GTextInputData();
			//data.textInputData.width = 70;
			data.flag = GAlert.YES | GAlert.NO;
			var alert : GAlert = new GAlert(data);
			alert.label = "你真的要删除[单管炮]1个?";
			alert.addEventListener(Event.CLOSE, listener);
			addChild(alert);
			//alert.hide();
		}

		private function listener(event:Event) : void
		{
			var detail:uint=GAlert(event.currentTarget).detail;
			//trace("detail===>"+detail);
			if(detail==GAlert.YES){
				//trace("GAlert.OK===>"+event.type);
			}else if(detail==GAlert.NO){
				//trace(event.type);
			}
		}


		public function TestGAlert() {
		}
	}
}
