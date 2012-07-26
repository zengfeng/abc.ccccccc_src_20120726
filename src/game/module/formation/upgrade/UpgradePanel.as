package game.module.formation.upgrade {
	import com.commUI.button.KTButtonData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.module.formation.FMControlPoxy;
	import game.module.formation.FMControler;
	import game.module.formation.formationManage.FMManager;
	import game.module.formation.formationManage.VoFM;
	import game.net.core.Common;
	import game.net.data.CtoS.CSSwitchSquad;
	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.data.GButtonData;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;

	/**
	 * @author Lv
	 */
	public class UpgradePanel extends GPanel {
		private var itemDic:Dictionary = new Dictionary();
		private var upgradeFormationNameArr:Array = ["oneFormation","twoFormation","threeFormation","fourFormation"];
		private var usingButton:GButton;
		private var voVec:Vector.<VoFM>;
		private var itemVec:Vector.<UpgradItem>;
		public function UpgradePanel() {
			_data = new GPanelData();
            initData();
            super(_data);
            initView();
            initEvent();
		}

		private function initData() : void {
			_data.width = 180;
            _data.height = 322;
            _data.bgAsset = new AssetData(SkinStyle.emptySkin);
		}

		private function initEvent() : void {
		}

		private function initView() : void {
			addBG();
			addPanel();
		}
		
		public function setItemList() : void {
			var max:int = itemVec.length;
			var heroLevel:int = UserData.instance.myHero.level;
			var needFmLevelArr:Array= FMManager.formationLeveLimitVec;
			for(var i:int =0;i<max;i++){
				var showLevel:int = voVec[i].fm_shwoLevel;
				var fmLevel:int = voVec[i].fm_level;
				var needLevel:int = needFmLevelArr[fmLevel];
				if(heroLevel>(showLevel-1)){
					itemVec[i].visible = true;
					if(heroLevel<(showLevel +2)){
						itemVec[i].fmStart(showLevel+2);
					}else if(heroLevel>(showLevel-1)){
						if(fmLevel == 0){
							itemVec[i].fmLeanr();
						}else{
//							if(heroLevel>(needLevel-3)){
							if(heroLevel>(needLevel-1)){
								itemVec[i].fmUpgrader();
							}else{
								itemVec[i].fmUpgraderEnable();
							}
						}
					}
				}
			}
			var  dicFM:Dictionary = FMControlPoxy.saveAllFMDic;
			for(var K:String in dicFM){
				if(int(K) == FMControlPoxy.startFmK){
					(itemDic[K] as UpgradItem).isClick = true;
					(itemDic[K] as UpgradItem).usingFormation();
				}else{
					(itemDic[K] as UpgradItem).closingFormation();
				}
				
			}
			isSelectFm();
		}
		//设置阵形可选
		private function isSelectFm():void{
			var max:int = itemVec.length;
			var heroLevel:int = UserData.instance.myHero.level;
			for(var i:int =0;i<max;i++){
				var shwoLevel:int = voVec[i].fm_shwoLevel;
				if(heroLevel>(shwoLevel+1)){
					itemVec[i].enabled = true;
					if(voVec[i].fm_level>0)
						itemVec[i].openClick = true;
					else
						itemVec[i].openClick = false;
				}
				else
					itemVec[i].enabled = false;
			}
		}
		
		private function addPanel() : void {
			var item:UpgradItem;
			voVec = FMManager.formationVec;
			itemVec = new Vector.<UpgradItem>();
			for(var i:int = 0; i<4;i++){
				var nameStr:String = voVec[i].fm_name;
				var id:int = voVec[i].fm_id;
				var level:int = voVec[i].fm_level;
				item = new UpgradItem(nameStr,id,level);
				item.y =  5+ 69* i;
				item.x = 5;
				_content.addChild(item);
				item.changeMC(upgradeFormationNameArr[i]);
				itemDic[id] = item;
				itemVec.push(item);
				item.closingFormation();
				item.name  = "name_" + i;
				item.addEventListener(MouseEvent.CLICK, onDown);
				item.visible = false;
			}
			indexNUM = FMControlPoxy.startFmK;
			if(itemDic[FMControlPoxy.startFmK] ==null)return;
			(itemDic[FMControlPoxy.startFmK] as UpgradItem).usingFormation();
			FMControler.instance.changeFmToCenMC(FMControlPoxy.startFmK);
			
			var data:GButtonData = new KTButtonData();
			data.labelData.text = "启用阵形";
			
			data.x = 50;
			data.y = 293;
			data.width = 80;
			data.height = 30;
			usingButton = new GButton(data);
			usingButton.addEventListener(MouseEvent.CLICK, onClickSelect);
			_content.addChild(usingButton);
			usingButton.visible = false;
			setItemList();
		}

		private function onClickSelect(event : MouseEvent) : void {
			var cmd:CSSwitchSquad = new CSSwitchSquad();
			cmd.id = indexNUM;
			Common.game_server.sendMessage(0x1E,cmd);
		}
		//成功启用阵型
		public function usingFM():void{
			closeItem();
			if(itemDic[indexNUM] == null)return;
			usingButton.visible = false;
			(itemDic[indexNUM] as UpgradItem).usingFormation();
		}
		//阵形升级
		public function fmUpGraderItem(fmID:int,Fmlevel:int):void{
			(itemDic[fmID] as UpgradItem).upgradeFm(Fmlevel);
			isSelectFm();
		}
		private var indexNUM:Number = -1;
		
		private function onDown(event : MouseEvent) : void {
			var item:UpgradItem = event.currentTarget as UpgradItem;
			if(!item.openClick)return;
			for each(var item1:UpgradItem in itemDic){
				item1.mouseOut();
			}
			item.mouseClick();
			if(item.usingTxt.visible == false){
				usingButton.visible = true;
			}else{
				usingButton.visible = false;
			}
			FMControlPoxy.startFmK = item.FmID;
			indexNUM = item.FmID;
			FMControler.instance.changeFmToCenMC(item.FmID);
			setClickItem(item.FmID);
			
		}

		private function setClickItem(fmID : int) : void {
			var max:int = itemVec.length;
			for(var i:int =0; i< max;i++){
				if(itemVec[i].FmID == fmID)
					itemVec[i].isClick = true;
				else
					itemVec[i].isClick = false;
			}
		}

//		}
		private function closeItem():void{
			for each(var item:UpgradItem in itemDic){
				item.closingFormation();
			}
		}

		private function addBG() : void {
			var bg : Sprite = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND2));
			bg.width = 180;
			bg.height = 282;
			_content.addChild(bg);
		}
	}
}
