package game.module.riding
{
	import game.definition.UI;

	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import utils.DictionaryUtil;

	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * @author zhengyuhang
	 */
	public class RidingSelectPanel extends GComponent
	{
		// =====================
		// 定义
		// =====================
		public static const LIST_LFFTPADDING : uint = 80;
		public static const ICON_PADDING : uint = 10;
		
		public static const LIST_BOTTOMGAP : uint = 30;
		public static const LIST_GAP : uint = 20;
		
		public static const ICON_WIDTH : uint = 50;
		public static const ICON_HEIGHT : uint = 50;
		
		public static const ROW_NUMS : uint = 7;
		
		// =====================
		// 属性
		// =====================
		private var _itemNum:int=0;
		private var _ridingItems:Array;
		private var _currentSelItem:RidingItemCell;
		
	    private var _leftButton : GButton;
		private var _rightButton : GButton;
		
		private var _model:MoveBarModel;
		// =====================
		// Getter/Setter
		// =====================
		override public function set source(value:*):void
		{
			if(value is Array)
			{
					
			}
		}
		
		// =====================
		// 方法
		// =====================		
		private function layoutItems():void
		{
			var itemCount:int=0; 
			var i:int=0;
//		    while(itemCount<_itemNum) 
//			{	
//		  	for(var i:int=0;i<ROW_NUMS;i++)
//			{
//				if(itemCount>=_itemNum)
//				return;
//				
//				(_ridingItems[itemCount] as RidingItemCell).x=LIST_LFFTPADDING+(ICON_WIDTH+ICON_PADDING)*i;
//				(_ridingItems[itemCount] as RidingItemCell).y=LIST_BOTTOMGAP+(ICON_PADDING+ICON_WIDTH)*j;
//				itemCount++;
//			}
//			 j++;
//			}
            while(itemCount<_itemNum) 
			 {
				(_ridingItems[itemCount] as RidingItemCell).x=LIST_LFFTPADDING+(ICON_WIDTH+ICON_PADDING)*i;
				(_ridingItems[itemCount] as RidingItemCell).y=5;
				itemCount++;
				i++;
			 }		
		}
		
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------		
		public function RidingSelectPanel()
		{
			var data : GComponentData = new GComponentData();
			data.width = 590;
			data.height = 60;
			super(data);
			
			
			
		}
		
		override protected function create():void
		{
			super.create();
			addBg();
			addMountHeadList();
			addButtons();
		}
		
		private function addBg():void
		{
			var componentBg:Sprite=UIManager.getUI(new AssetData(UI.COMMON_BACKGROUND03));
			componentBg.x=0;
			componentBg.y=0;
			componentBg.width=590;
			componentBg.height=60;
			addChild(componentBg);
		}
		
		private function addMountHeadList():void
		{
			
			_ridingItems=new Array();
			var arr:Array=DictionaryUtil.getValues(RidingUtils._mountDic);
		    _model=new MoveBarModel();
			
			
			//获取icon数量
			_itemNum=arr.length;
			
			for(var i:int=0;i<arr.length;i++)
			{
				var ridingItem:RidingItemCell=new RidingItemCell();
				ridingItem.source = arr[i];
				_ridingItems.push(ridingItem);
				addChild(ridingItem);
			}
			
               selectOne(_ridingItems[0] as RidingItemCell);
			   
			   _model.source = _ridingItems;
		}
		
		private function addButtons():void
		{
			_leftButton = new GButton(UICreateUtils.buttonDataShiftLeft);
			_leftButton.x = 30;
			_leftButton.y = 20;
		    addChild(_leftButton);
			

			_rightButton = new GButton(UICreateUtils.buttonDataShiftRight);
			_rightButton.x = 560-_rightButton.width;
			_rightButton.y = 20;
			addChild(_rightButton);
		}
		
		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		override protected function layout():void
		{
			layoutItems();
		}
		
		override protected function onShow():void
		{			
			super.onShow();
			for(var i:int=0;i<_ridingItems.length;i++)
			{		
			(_ridingItems[i] as RidingItemCell).addEventListener(MouseEvent.CLICK, onRidingCellClick);
			}
			
			_leftButton.addEventListener(MouseEvent.CLICK, onLeftButtonDown);
			_rightButton.addEventListener(MouseEvent.CLICK, onRightButtonDown);
		}

		
		override protected function onHide():void
		{			
			super.onHide();
			for(var i:int=0;i<_ridingItems.length;i++)
			{		
			(_ridingItems[i] as RidingItemCell).removeEventListener(MouseEvent.CLICK, onRidingCellClick);
			}
			
			_leftButton.removeEventListener(MouseEvent.CLICK, onLeftButtonDown);
			_rightButton.removeEventListener(MouseEvent.CLICK, onRightButtonDown);	
		}
		
		
		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		private function onRidingCellClick(event:Event) : void
		{
			var selCell:RidingItemCell=event.target as RidingItemCell;
			selectOne(selCell);
						
			var ridingUpdateEvent:RidingUpdateEvent=new RidingUpdateEvent(RidingUpdateEvent.RIDINGUPDATE,true);
			ridingUpdateEvent.ridingVO=selCell.getRidingItemVO();
			dispatchEvent(ridingUpdateEvent);
		}		
		
		
		private function onLeftButtonDown(event:MouseEvent):void
		{
			_model.moveLeft();
		}
		
		private function onRightButtonDown(event:MouseEvent):void
		{
						_model.moveLeft();
		}
		
		// -------------------------------------------------
		// 其他
		// -------------------------------------------------				
		private function selectOne(newSelCell:RidingItemCell):void
		{
			if(_currentSelItem)
			{
			   _currentSelItem.setMouseOut();			   
			}
			_currentSelItem=newSelCell;
			_currentSelItem.setMouseDown();			
		}
		
	}
}
