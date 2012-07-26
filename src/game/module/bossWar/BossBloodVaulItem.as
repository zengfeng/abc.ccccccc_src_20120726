package game.module.bossWar {
	import gameui.manager.UIManager;
	import com.utils.StringUtils;
	import gameui.data.GLabelData;
	import gameui.controls.GLabel;
	import gameui.skin.SkinStyle;
	import net.AssetData;
	import gameui.containers.GPanel;
	import gameui.data.GPanelData;

	/**
	 * @author Lv
	 */
	public class BossBloodVaulItem extends GPanel {
		private var playerName:GLabel;
		private var bloodPercentage:GLabel;
		
		private var bossBloodTotal:Number = 999999999;
		private var nameStr:String ="123";
		private var row:GLabel;
		
		/**
		 * name:玩家名字
		 * harm:玩家对boss造成的伤害
		 * num:排序
		 */
		public function BossBloodVaulItem() {
			_data = new GPanelData();
			initData();
			super(_data);
			initView();
			initEvent();
		}

		private function initData() : void {
			_data.width = 200;
			_data.height = 20;
			_data.bgAsset=new AssetData(SkinStyle.emptySkin);   //取消背景
		}

		private function initEvent() : void {
		}

		private function initView() : void {
			addPanel();
		}

		private function addPanel() : void {
			bossBloodTotal = ProxyBossWar.bossBloodTotal;
			var data:GLabelData = new GLabelData();
			data.textColor = 0xFFFFFF;
			data.textFieldFilters = UIManager.getEdgeFilters(0x000000, 1,17);
			data.textFormat.size = 12;
			data.text = "10.";
			row = new GLabel(data);
			_content.addChild(row);
			data.clone();
			data.x = row.x + row.width;
			data.text = "["+nameStr+"]";
			playerName = new GLabel(data);
			_content.addChild(playerName);
//			data.clone();
//			data.x = 100;
//			data.text = "造成伤害";
//			var text:GLabel = new GLabel(data);
//			_content.addChild(text);
			data.clone();
			data.x = 160;
			//data.text = num() + "%";
			bloodPercentage = new GLabel(data);
			_content.addChild(bloodPercentage);
		}
		
		private function num1(harm:Number,total:int):Number{
			var numBlood:Number;
            bossBloodTotal = total;
			numBlood = (Math.round((harm/bossBloodTotal)*10000))/100;
			return numBlood;
		}
		
		public function setPlayerName(num:int,name:String,harm:int,total:int):void{
			row.text = num +".";
			playerName.text = "["+name+"]";
            if(harm == 0)
            	bloodPercentage.text = StringUtils.addColor("0%","#FFFF80");
            else
				bloodPercentage.text = StringUtils.addColor(num1(harm,total) + "%","#FFFF80");
		}
		
		public function setCleartext(): void{
			bloodPercentage.text = "";
			playerName.text = "";
			row.text = "";
		}
		
		public function setTextColor(color:uint):void{
           playerName.text = StringUtils.addColorById(String(playerName.text),  color );
		}
	}
}
