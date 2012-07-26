package game.module.formation.headPanel {
	import flash.text.TextFormat;
	import game.core.avatar.AvatarType;
	import game.core.hero.VoHero;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.module.formation.FMControlPoxy;
	import game.module.formation.FMControler;
	import game.module.formation.drageAvatear.FMDrageAvatar;
	import gameui.containers.GPanel;
	import gameui.data.GPanelData;
	import gameui.drag.DragData;
	import gameui.drag.IDragItem;
	import gameui.drag.IDragTarget;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;

	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;




	/**
	 * @author Lv
	 */
	public class HeadPanel extends GPanel implements IDragTarget {
		private var headMCVec:Vector.<HeadItem> = new Vector.<HeadItem>();
		private var headMCDic:Dictionary = new Dictionary();
		public function HeadPanel() {
			 _data = new GPanelData();
            initData();
            super(_data);
            initView();
            initEvent();
		}

		private function initData() : void {
			_data.width = 150;
            _data.height = 282;
            _data.bgAsset = new AssetData(SkinStyle.emptySkin);
		}

		private function initEvent() : void {
		}
//
		public function changeHeroLevel() : void {
			addPushHeadIMG();
			NowIsWaring(FMControlPoxy.startFmK);
		}

		private function initView() : void {
			addBG();
			addPushHeadIMG();
		}
		//招募将领  添加到列表
		public function RecruitHero(hero:VoHero):void{
			var num:int = showHeroItmeVec.length;
			var id:int = hero.id;
			headMCVec[num].addIMG(hero);
			headMCVec[num].UnWaring();
			headMCVec[num].visible = true;
			headMCDic[id] = headMCVec[num];
			showHeroItmeVec.push(headMCVec[num]);
		}
		private var showHeroItmeVec:Vector.<HeadItem> = new Vector.<HeadItem>();
		public function addPushHeadIMG():void{
			clearnMC();
			var heroListVo:Vector.<VoHero> = UserData.instance.heroes;
			if(!heroListVo)return;
			var max:int=heroListVo.length;
			for(var i:int = 0; i< max;i++){
				var id:int = heroListVo[i].id;
				headMCVec[i].addIMG(heroListVo[i]);
				if(heroListVo[i].state == 3)
					headMCVec[i].waring();
				else
					headMCVec[i].UnWaring();
				headMCDic[id] = headMCVec[i];
				headMCVec[i].visible = true;
				showHeroItmeVec.push(headMCVec[i]);
			}
		}

		private function clearnMC() : void {
			for each(var item:HeadItem in headMCVec){
				item.visible = false;
			}
			for each(var k:String in headMCDic){
				delete headMCDic[k];
			}
			while(showHeroItmeVec.length>0){
				showHeroItmeVec.splice(0, 1);
			}
		}
		//id:英雄id
		public function UnWaring(id:int):void{
			(headMCDic[id] as HeadItem).UnWaring();
		}
		//id：英雄id
		public function Waring(id:int):void{
			(headMCDic[id] as HeadItem).waring();
		}
		//当前阵形的将领出战情况
		public function NowIsWaring(fmID:int):void{
			for each(var item:HeadItem in headMCVec){
				item.UnWaring();
			}
			var objVec:Vector.<Object> = FMControlPoxy.saveAllFMDic[fmID];
			for each(var obj:Object in objVec){
				var heroID:int = obj["id"];
				if(headMCDic[heroID] == null)return;
				(headMCDic[heroID] as HeadItem).waring();
			}
		}

		private function addBG() : void {
			var bg : Sprite = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND2));
			bg.width = 150;
			bg.height = 282;
			_content.addChild(bg);
			var sp:Sprite = UIManager.getUI(new AssetData(UI.ICON_HINT));
			sp.x = 10;
			sp.y = 8;
			_content.addChild(sp);
			var txt:TextField = UICreateUtils.createTextField(null, "拖动名仙至右侧阵\n型面板进行布阵→", 101, 34,34,5, new TextFormat(null,null,"0x2F1F00",null,null,null,null,null,TextFormatAlign.LEFT));
			_content.addChild(txt);
			addHeroLowPanel();
		}

		private function addHeroLowPanel() : void {
			var dx:int = 0;
			var dy:int = 0;
			for(var i:int = 0; i < 8;i++){
				if(dx > 1){
					dx = 0;
					dy++;
				}
				var mc:HeadItem = new HeadItem();
				mc.x = 6 + 70 * dx;
				mc.y = 43 + 55 * dy;
				mc.name = "name_"+i;
				dx++;
				_content.addChild(mc);
				mc.visible = false;
				headMCVec.push(mc);
				mc.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
				mc.addEventListener(MouseEvent.MOUSE_UP, onUp);
			}
		}

		private function onUp(event : MouseEvent) : void {
			this.enabled = false;
			setTimeout(openitem, 1000);
		}
		//有将领解雇
		public function dismissHero():void{
			//清空列表
			clearnHeroPanel();
			//添加空列表
			addHeroLowPanel();
			//添加将领信息
			addPushHeadIMG();
		}
		//删除将领
		private function clearnHeroPanel():void{
			while(headMCVec.length){
				var mc:HeadItem = headMCVec[0];
				mc.removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
				mc.removeEventListener(MouseEvent.MOUSE_UP, onUp);
				_content.removeChild(headMCVec[0]);
				headMCVec.splice(0, 1);
			}
			for(var k:String in headMCDic){
				delete headMCDic[k];
			}
			while(showHeroItmeVec.length>0){
				showHeroItmeVec.splice(0, 1);
			}
		}
		//排序 出战英雄排在前面
		private function rollHero():void{
			
		}
		private var index:int;
		private function onClick(event : MouseEvent) : void {
			var item:HeadItem= event.currentTarget as HeadItem;
			index = event.currentTarget.name.split("_")[1];
			this.enabled = false;
			setTimeout(openitem, 1000);
			var hero:FMDrageAvatar =item.dragImage as FMDrageAvatar;
			hero.identifyPath = 1;
			hero.isWaring = item.isWaring;
			hero.initAvatar(item.heroID, AvatarType.PLAYER_BATT_BACK,0);
			hero.stateDrag();
			if(item.isWaring ==1)
				FMControler.instance.changeFmPos(item.heroID);
			if(hero.isWaring == 1)return;
			rollHero();
			
		}
		private function openitem():void{
			this.enabled = true;
		}
		public function dragEnter(dragData : DragData) : Boolean {
			var Dis:Boolean;
			if(!dragData||!(dragData.dragSource is FMDrageAvatar)||(dragData.s_place == 1))
				Dis= false;
			else 
				Dis = true;
			
			if((Dis == true)&&(dragData.s_gird != UserData.instance.myHero.id)){
				FMControler.instance.deleteInFmHero(dragData.s_gird);
				dragData.s_place = 1;
				dragData.t_place = 2;
			}
			if((Dis == false)&&(dragData.s_gird == UserData.instance.myHero.id)){
				FMControler.instance.clearnStartStep();
				StateManager.instance.checkMsg(279);
			}
			return Dis;
		}

		public function canSwap(source : IDragItem, target : IDragItem) : Boolean {
			return false;
		}
	}
}
