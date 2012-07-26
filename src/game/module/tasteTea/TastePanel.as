package game.module.tasteTea {
	import com.utils.FilterUtils;
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.definition.UI;
	import game.manager.VersionManager;
	import game.manager.ViewManager;

	import gameui.controls.BDPlayer;
	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.BDSWFLoader;
	import net.LibData;
	import net.RESManager;

	import com.commUI.GCommonWindow;
	import com.greensock.TweenLite;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;


	/**
	 * @author Lv
	 */
	public class TastePanel extends GCommonWindow implements IAssets {
		
		private var item:TeaItem;
		private var teaArr:Array = ["普通清茶","天山清茶","蓬莱仙茶"];
		private var moneyRollArr:Array = [2,1,1];
		private var moneyArr:Array = [5000,25,50];
		private var honourArr:Array = [200,500,1000];
		private var itemVec : Vector.<TeaItem> = new Vector.<TeaItem>();
		private var _effect:BDPlayer ;
		private var _rewardtxt:TextField ;

		public function set bonous(value:int) : void{
			for each( var item:TeaItem in itemVec ){
				item.bonous = value;
			}
		}
		
		public function TastePanel() {
			_data = new GTitleWindowData();
			super(_data);
			initEvents();
		}
		
		public function getResList():Array{
			 return [ new BDSWFLoader(new LibData(VersionManager.instance.getUrl("assets/avatar/184549377.swf"), "enhanceLight")) ];
		}
		
		override protected function initData() : void {
			_data.width = 474;
			_data.height = 267;
			_data.parent = ViewManager.instance.uiContainer;
			_data.allowDrag = true;	
			super.initData();	
		}
		
		 override protected function onClickClose(event : MouseEvent) : void{
			MenuManager.getInstance().closeMenuView(MenuType.TASTTEA);
		 }

		private function initEvents() : void {
			
		}
		
		override protected function initViews() : void
		{
			title = "品茶";	
			super.initViews();
			addBG();
			addPanel();
		}

		private function addBG() : void {
			var bg:Sprite = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
			bg.width = 461;
			bg.height = 261;
			bg.x = 4;
			bg.y = 2;
			_contentPanel.addChild(bg);
		}

		private function addPanel() : void {
			
			var tbg:Sprite = UICreateUtils.createSprite("taste_tea_background",443,208,13,-53);
			addChild(tbg);
			
			if(itemVec != null)cearnItem();
			for(var i:int = 0 ; i < 3; i++){
				item = new TeaItem(i, moneyRollArr[i],teaArr[i]);
				item.x = 13 + 149 * i;
				item.y = 158;
				item.setContent(honourArr[i], moneyArr[i]);
				itemVec.push(item);
				_contentPanel.addChild(item);
			}
			
		}
		
		/**
		 * 今日不能品茶
		 */
		public function EnableTastTea(b:Boolean):void{
			for each(var item:TeaItem in itemVec){
				item.visibelBtn(b);
			}
		}

		private function cearnItem() : void {
			while(itemVec.length>0){
				itemVec.splice(0, 1);
			}
		}
		
		override public function hide():void{
			this.align = new GAlign((UIManager.stage.stageWidth - this.width) / 2,-1,(UIManager.stage.stageHeight - this.height) / 2,-1);
			super.hide();
		}
		override public function show():void{
			this.align = new GAlign((UIManager.stage.stageWidth - this.width) / 2,-1,(UIManager.stage.stageHeight - this.height) / 2,-1);
			super.show();
		}
		
		public function reward(sel:uint , hon:uint ):void{
			
			//effect
			if(_effect == null){
				_effect = new BDPlayer(new GComponentData());
				_effect.setBDData(RESManager.getBDData(new AssetData("1","enhanceLight")));
				_effect.addEventListener(Event.COMPLETE, onEffectComplete);
			}
			addChild( _effect );
			_effect.x = 149*sel + 44 ;
			_effect.y = 193 ;
			_effect.show();
			_effect.play(33, null, 1, 0);
			
			if( _rewardtxt == null ){
				_rewardtxt = UICreateUtils.createTextField(null,null,146,26, 0 ,0,UIManager.getTextFormat(16,0xFFFF00,"center") );
				_rewardtxt.filters = [FilterUtils.iconTextEdgeFilter];
			}
			_rewardtxt.text = "获得" + hon.toString() + "修为";
			_rewardtxt.x = 13 + 149 * sel ;
			_rewardtxt.y = 146 ;
			addChild(_rewardtxt) ;
			TweenLite.to(_rewardtxt, 2, {y:70,onComplete:function():void{removeChild(_rewardtxt);}});
		}

		private function onEffectComplete(event : Event) : void {
			_effect.removeEventListener(Event.COMPLETE, onEffectComplete);
			removeChild(_effect);
		}

	}
}
