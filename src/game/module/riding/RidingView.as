package game.module.riding
{
	import game.manager.ViewManager;

	import gameui.data.GTitleWindowData;

	import com.commUI.GCommonWindow;
	/**
	 * @author 1
	 */
	public class RidingView extends GCommonWindow
	{
		
        // =====================
		// 定义
		// =====================
				
		// =====================
		// 属性
		// =====================
		private var _descriptionPanel:RidingDescriptionPanel;
		private var _ridingSelectPanel:RidingSelectPanel;
		// =====================
		// Getter/Setter
		// =====================
			
		
		// =====================
		// 方法
		// =====================
		
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function RidingView():void
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 600;
			data.height = 410;
			data.allowDrag = false;
			data.parent = ViewManager.instance.uiContainer;
			super(data);
		}
		
		protected override function create():void
		{
			super.create();
			addDescriptionPanel();
			addMountSelectPanel();			
		}


		private function addDescriptionPanel() : void
		{
			_descriptionPanel=new RidingDescriptionPanel();
			_descriptionPanel.x=50;
			_descriptionPanel.y=20;
			addChild(_descriptionPanel);
			
			_descriptionPanel.updateDescription(RidingUtils._mountDic[1]);
		}
		
	    private function addMountSelectPanel() : void
		{
			_ridingSelectPanel=new RidingSelectPanel();
			_ridingSelectPanel.x=5;
			_ridingSelectPanel.y=330;
			addChild(_ridingSelectPanel);
		}		
		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		override protected function onShow():void
		{
			super.onShow();
			addEventListener(RidingUpdateEvent.RIDINGUPDATE, onRidingDesUpdate);
		}
		
		override protected function onHide():void
		{
			super.onHide();
			removeEventListener(RidingUpdateEvent.RIDINGUPDATE, onRidingDesUpdate);
		}
		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		private function onRidingDesUpdate(event:RidingUpdateEvent):void
		{
			var vo:RidingVO=event.ridingVO;
			_descriptionPanel.updateDescription(vo);
		}
		
		// -------------------------------------------------
		// 其他
		// -------------------------------------------------
													
		
	}
}
