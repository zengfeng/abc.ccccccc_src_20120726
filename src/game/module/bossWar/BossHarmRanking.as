package game.module.bossWar {
	import game.definition.UI;

	import gameui.controls.GLabel;
	import gameui.core.GComponent;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author Lv
	 */
	public class BossHarmRanking extends GComponent {
		
		private var myPlayerToBossHarm:TextField;
		private var rankingVaulItemList:Vector.<BossBloodVaulItem> = new Vector.<BossBloodVaulItem>();
		private var listSp:Sprite;
		private var bossBloodTotal:Number;
		
		public function BossHarmRanking() {
			_base = new GPanelData();
			initData();
			super(_base);
			initView();
			initEvent();
		}

		private function initData() : void {
			_base.width = 220;
			_base.height = 180;
//			_base.bgAsset=new AssetData(SkinStyle.emptySkin);   //取消背景
		}

		private function initEvent() : void {
		}

		private function initView() : void {
//			bossBloodTotal = ProxyBossWar.bossBloodTotal;
			addBg();
			addPanel();
			//addRankPanel();
		}

		private function addBg() : void {
			var bg:Sprite = UIManager.getUI(new AssetData("RecruitPullItemPanel"));
			bg.width = 220;
			bg.height = 180 -25;
			addChild(bg);
			
			var line1:Sprite = UIManager.getUI(new AssetData(UI.LINEMC));
			var line2:Sprite = UIManager.getUI(new AssetData(UI.LINEMC));
			line1.y = 26;
			line2.y = 158-25;
			addChild(line2);
			addChild(line1);
		}
		/**
		 * 《玩家对boss的伤害排行榜   前10名》
		 * NameVec:玩家名字
		 * ColorVec:玩家颜色
		 * BloodVec:玩家对boss的伤害总值
		 * totalBlood:boss的总血量
		 */
		public function addRankPanel(rankObj:Vector.<Object>,totalBlood:uint) : void {
			removeList();
			var max:int = rankObj.length;
			if(max == 0)return;
			if(max>5)max = 5;
			for(var i:int = 0; i < max ; i++){
				var obj:Object = rankObj[i];
				var color:uint = obj["color"];
				var name:String = obj["name"];
				var harm:int = obj["harm"];
				rankingVaulItemList[i].alpha = 1;
				rankingVaulItemList[i].visible = true;
				rankingVaulItemList[i].setPlayerName(i+1, name, harm,totalBlood);
				rankingVaulItemList[i].setTextColor(color);
			}
			
		}

		public function removeList() : void {
			for(var i:int = 0; i< 5; i++){
				rankingVaulItemList[i].alpha = 0;
				rankingVaulItemList[i].visible = false;
				rankingVaulItemList[i].setCleartext();
			}
		}

		private function addPanel() : void {
			
			var text:TextField = UICreateUtils.createTextField(null, "伤害列表", 220, 25,0,3, new TextFormat(null,null,"0xFFFF00",null,null,null,null,null,TextFormatAlign.CENTER));
			
			text.filters = UIManager.getEdgeFilters(0x000000, 1,17);
			
			myPlayerToBossHarm = UICreateUtils.createTextField(null, "我的伤害: 0 (0%)", 220, 25,0,158-25, new TextFormat(null,null,"0xFFFF00",null,null,null,null,null,TextFormatAlign.CENTER));
			myPlayerToBossHarm.filters = UIManager.getEdgeFilters(0x000000, 1,17);
			addChild(myPlayerToBossHarm);
			addChild(text);
			
			listSp = new Sprite();
			listSp.y = myPlayerToBossHarm.height + 2;
			addChild(listSp);
			
			for(var i:int = 0; i < 10 ; i++){
				var item:BossBloodVaulItem = new BossBloodVaulItem();
				item.y = 3 + i * item.height;
				item.x = 10;
				rankingVaulItemList.push(item);
				
				item.alpha = 0;
				listSp.addChild(item);
			}
		}
		/**
		 * 《我的boss造成的伤害》
		 * harm:伤害值
		 * total:boss总血量
		 */
		public function myHeroBloodToBoss(harm:uint,total:uint):void{
            bossBloodTotal = total;
            if(harm ==0)
            	myPlayerToBossHarm.text = "我的伤害: 0 (0%)";
           else
				myPlayerToBossHarm.text = "我的伤害: "+harm+" ("+(Math.round((harm/bossBloodTotal)*10000))/100+"%"+")";
			
			
		}
        //清空
        public function clearnMyHeroBlood():void{
            myPlayerToBossHarm.text = "我的伤害: 0 (0%)";
        }
		
		override public function hide():void{
			super.hide();
		}
	}
}
