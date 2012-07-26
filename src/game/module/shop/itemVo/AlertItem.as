package game.module.shop.itemVo
{
	import gameui.containers.GPanel;
	import gameui.controls.GLabel;
	import gameui.controls.GRadioButton;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.data.GRadioButtonData;
	import gameui.skin.SkinStyle;
	import net.AssetData;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	/**
	 * @author 1
	 */
	public class AlertItem extends GPanel {
		private var alertText:GLabel;
		private var complexBox:GRadioButton;
		private var GoldreadMB:String = "0";
		private var Honourread:String = "0";
		private var Identify:int = 0;    // 1:为元宝   2：为声望
		public function AlertItem() {
			_data = new GPanelData();
			initData();
			super(_data);
			initView();
			initEvent();
		}

		private function initData() : void {
			_data.width = 218;
			_data.height = 90;
			_data.bgAsset=new AssetData(SkinStyle.emptySkin);   //取消背景
		}

		private function initEvent() : void {
			complexBox.addEventListener(MouseEvent.MOUSE_DOWN,ondown);
		}

		private function ondown(e:MouseEvent) : void {
			if(Identify == 1)
			{
				setRead();
			}
			else if(Identify == 2){
				setHonourItem();
			}
			
		}
		private var sharGold:SharedObject = SharedObject.getLocal("元宝——内存我来了");
		private var sharHonour:SharedObject = SharedObject.getLocal("声望——内存我来了");
		private function initView() : void {
			addPanel();
			GoldreadMB = sharGold.data["goldmsg"];
			Honourread = sharHonour.data["honourmsg"];
		}

		private function addPanel() : void {
			var data:GLabelData = new GLabelData();
			data.x = 5;
			data.y = 2;
			data.width = 197;
			data.height = 60;
			alertText = new GLabel(data);
			_content.addChild(alertText);
			var dataR:GRadioButtonData = new GRadioButtonData();
			dataR.x = 2;
			dataR.labelData.text = "下次不再提醒";
			dataR.y = 60;
			complexBox = new GRadioButton(dataR);
			complexBox.selected = false;
			_content.addChild(complexBox);
			
		}
		public function setText(Str:String,index:int):void
		{
			Identify = index;
			alertText.text = Str;
		}
		//元宝判断
		public function get GetreadMB() : String {
			GoldreadMB = sharGold.data["goldmsg"];
			return GoldreadMB;
		}
		private function setRead():void{
			sharGold.data["goldmsg"] = "1";
			GoldreadMB = sharGold.data["goldmsg"];
		}
		public function deleteSaveShar():void
		{
			delete sharGold.data["goldmsg"];
			GoldreadMB = sharGold.data["goldmsg"];
			complexBox.selected = false;
		}
		
		public function setHonourItem():void
		{
			sharHonour.data["honourmsg"] = "1";
			Honourread = sharHonour.data["honourmsg"];
		}
		//声望判断
		public function get GetHonourread() : String {
			Honourread = sharHonour.data["honourmsg"];
			return Honourread;
		}
		public function deleHonourShare():void
		{
			delete sharHonour.data["honourmsg"];
			Honourread = sharGold.data["honourmsg"];
			complexBox.selected = false;
		}
		
	}
}
