package game.module.gem.merge
{
	import com.commUI.icon.ItemIcon;
	import com.commUI.itemgrid.ItemGrid;
	import com.commUI.itemgrid.ItemGridCell;
	import com.commUI.itemgrid.ItemGridCellData;
	import com.commUI.itemgrid.ItemGridData;
	import com.utils.HeroUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import game.core.hero.VoHero;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.ItemService;
	import game.core.item.gem.Gem;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.module.gem.GemChildPanel;
	import gameui.cell.GCell;
	import gameui.controls.GButton;
	import gameui.controls.GRadioButton;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;









	/**
	 * @author jian
	 */
	public class GemMergePanel extends GemChildPanel
	{
		// =====================
		// @属性
		// =====================
		private static const BATCH_MERGE_VIP_LEVEL:uint = 0;
		private var _fragmentGrid : ItemGrid;
		private var _productIcon : ItemIcon;
		private var _mergeButton : GButton;
		private var _batchMergeButton : GButton;
		private var _hideBindRButton : GRadioButton;
		private var _showMatchRButton : GRadioButton;
		private var _control : GemMergeControl;

		// =====================
		// @创建
		// =====================
		override protected function create() : void
		{
			super.create();
			addControl();
			addHint();
			addFragments();
			addArrow();
			addProduct();
			addButtons();
			addRadioButtons();
			addPackTitle();
		}

		/*
		 * 添加合成控制器
		 */
		private function addControl() : void
		{
			_control = new GemMergeControl();
		}

		/*
		 * 添加提示
		 */
		private function addHint() : void
		{
			var icon : Sprite = UIManager.getUI(new AssetData(UI.ICON_HINT));
			icon.x = 14;
			icon.y = 15;
			addChild(icon);

			var hintText : TextField = UICreateUtils.createTextField("三个同等级同类灵珠能合成至下一级", null, 200, 20, 38, 13, TextFormatUtils.panelContent);
			addChild(hintText);
		}

		/*
		 * 添加材料
		 */
		private function addFragments() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.AREA_BACKGROUND));
			bg.width = 300;
			bg.height = 100;
			bg.x = 20;
			bg.y = 34;
			_content.addChild(bg);

			var title : TextField = UICreateUtils.createTextField("合成材料", null, 300, 20, 20, 40, TextFormatUtils.panelSubTitleCenter);
			_content.addChild(title);

			var data : ItemGridData = new ItemGridData();
			data.rows = 1;
			data.columns = 3;
			data.hgap = 30;
			data.vgap = 0;
			data.padding = 4;
			data.x = 60;
			data.y = 60;
			data.bgAsset = new AssetData(SkinStyle.emptySkin, AssetData.AS_LIB);
			data.cell = ItemGridCell;

			var cellData : ItemGridCellData = new ItemGridCellData();
			cellData.width = 54;
			cellData.height = 70;
			cellData.showName = true;
			cellData.iconData.showBg = true;
			cellData.iconData.showBorder = true;
			cellData.iconData.showToolTip = true;
			cellData.iconData.showBinding = true;
			cellData.iconData.showOwner = true;

			data.cellData = cellData;

			_fragmentGrid = new ItemGrid(data);
			_content.addChild(_fragmentGrid);
		}

		/*
		 * 添加结果
		 */
		private function addProduct() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.AREA_BACKGROUND));
			bg.width = 300;
			bg.height = 100;
			bg.x = 20;
			bg.y = 200;
			_content.addChild(bg);

			var title : TextField = UICreateUtils.createTextField("合成结果", null, 300, 20, 20, 206, TextFormatUtils.panelSubTitleCenter);
			_content.addChild(title);

			_productIcon = UICreateUtils.createItemIcon({x:145, y:228, showBorder:true, showBg:true, showToolTip:true, showBinding:true});
			_content.addChild(_productIcon);
		}

		/*
		 * 箭头
		 */
		private function addArrow() : void
		{
		}

		/*
		 * 按钮
		 */
		private function addButtons() : void
		{
			_mergeButton = UICreateUtils.createGButton("合成", 0, 0, 133, 346);
			_content.addChild(_mergeButton);

			_batchMergeButton = UICreateUtils.createGButton("一键合成至下级", 96, 0, 440, 346);
			if (UserData.instance.vipLevel < BATCH_MERGE_VIP_LEVEL)
				_batchMergeButton.visible = false;
			_content.addChild(_batchMergeButton);
		}

		/*
		 * 单选框
		 */
		private function addRadioButtons() : void
		{
			_hideBindRButton = UICreateUtils.createGRadioButton("只显示可交易", 0, 0, 345, 30);
			addChild(_hideBindRButton);

			_showMatchRButton = UICreateUtils.createGRadioButton("满足合成条件的灵珠", 120, 0, 420, 30);
			addChild(_showMatchRButton);
		}

		/*
		 * 包裹标题
		 */
		private function addPackTitle() : void
		{
			var title : TextField = UICreateUtils.createTextField("灵珠列表", null, 100, 20, 343, 9, TextFormatUtils.panelSubTitle);
			_content.addChild(title);
		}
		
		/*
		 * 添加物品格
		 */
		override protected function addItemGrid() : void
		{
			var gridData : ItemGridData = new ItemGridData();
			gridData.x = 345;
			gridData.y = 53;
			gridData.allowDrag = false;
			gridData.bgAsset = new AssetData(UI.PACK_BACKGROUND);
			gridData.rows = 4;
			gridData.columns = 5;
			gridData.hgap = 2;
			gridData.vgap = 1;
			gridData.padding = 4;
			gridData.cell = _itemGridCellClass;
			gridData.filterFuncs = [];
			gridData.sortFuncs = [itemSortFunc];
			gridData.enabled = true;

			var cellData : ItemGridCellData = new ItemGridCellData();
			cellData.width = 54;
			cellData.height = 70;
			cellData.enabled = true;
			cellData.selected_upAsset = null;
			cellData.showName = true;
			cellData.iconData.showToolTip = true;
			cellData.iconData.showNums = true;
			cellData.iconData.showBinding = true;
			cellData.iconData.showOwner = true;
			cellData.iconData.showBorder = true;
			cellData.iconData.showLevel = true;

			gridData.cellData = cellData;

			_itemGrid = new _itemGridClass(gridData);
			_content.addChild(_itemGrid);
		}

		// =====================
		// @更新
		// =====================
		/*
		 * 更新视图
		 */
		private function updateView() : void
		{
			updateFragments();
			updatePack();
		}

		/*
		 * 更新合成材料
		 */
		private function updateFragments() : void
		{
			_fragmentGrid.source = _control.fragments;
		}

		/*
		 * 更新包裹
		 */
		override protected function updateItemGrid() : void
		{
			var arr:Array = [];
			for each (var hero:VoHero in UserData.instance.heroes.sort(HeroUtils.sortFun))
			{
				arr = arr.concat(hero.gems);
			}
			
			arr = arr.concat(ItemManager.instance.packModel.getPageItems(Item.GEM).filter(itemFilterFunc));
			
			_itemGrid.source = filterFragments(filterMatch(filterBinding(arr)));
		}

		private function clearProduct() : void
		{
			if (_productIcon.source)
			{
				_productIcon.source = null;
			}
		}

		// =====================
		// @交互
		// =====================
		/*
		 * 进入面板
		 */
		override protected function onShow() : void
		{
			super.onShow();
			_itemGrid.addEventListener(GCell.SELECT, sourceGemSelectHandler, true);
			_fragmentGrid.addEventListener(GCell.SELECT, clickFragmentHandler, true);
			_productIcon.addEventListener(MouseEvent.CLICK, clickProductHandler);
			_mergeButton.addEventListener(MouseEvent.CLICK, mergeButtonHandler);
			_batchMergeButton.addEventListener(MouseEvent.CLICK, batchMergeButtonHandler);
			_control.addEventListener(Event.COMPLETE, mergeCompleteHandler);
			_hideBindRButton.addEventListener(MouseEvent.CLICK, changeRButtonHandler);
			_showMatchRButton.addEventListener(MouseEvent.CLICK, changeRButtonHandler);
			updateView();
		}

		/*
		 * 退出面板
		 */
		override protected function onHide() : void
		{
			_itemGrid.removeEventListener(GCell.SELECT, sourceGemSelectHandler, true);
			_fragmentGrid.removeEventListener(GCell.SELECT, clickFragmentHandler, true);
			_productIcon.removeEventListener(MouseEvent.CLICK, clickProductHandler);
			_mergeButton.removeEventListener(MouseEvent.CLICK, mergeButtonHandler);
			_batchMergeButton.removeEventListener(MouseEvent.CLICK, batchMergeButtonHandler);
			_control.removeEventListener(Event.COMPLETE, mergeCompleteHandler);
			_hideBindRButton.removeEventListener(MouseEvent.CLICK, changeRButtonHandler);
			_showMatchRButton.removeEventListener(MouseEvent.CLICK, changeRButtonHandler);
			super.onHide();
		}

		/*
		 * 点击包裹内合成材料
		 */
		private function sourceGemSelectHandler(event : Event) : void
		{		
			var item : Gem = (event.target as ItemGridCell).source as Gem;
			var n:uint =Math.min(3, item.nums);
			for (var i:uint = 0; i<n; i++)
			{
				_control.addFragment(item);
			}
			updateFragments();
			updatePack();
			clearProduct();
		}

		/*
		 * 点击合成材料
		 */
		private function clickFragmentHandler(event : Event) : void
		{
			_control.clear();
			var item : Item = (event.target as ItemGridCell).source;
			_control.removeFragment(item);
			_fragmentGrid.removeItem(item);
			updateFragments();
			updatePack();
		}

		/*
		 * 点击合成产物
		 */
		private function clickProductHandler(event : MouseEvent) : void
		{
			clearProduct();
		}

		/*
		 * 单个合成
		 */
		private function mergeButtonHandler(event : MouseEvent) : void
		{
			_control.merge();
		}

		/*
		 * 一键合成
		 */
		private function batchMergeButtonHandler(event : MouseEvent) : void
		{
			ItemService.instance.sendMergeAllGemMessage();
		}

		/*
		 * 响应单选框
		 */
		private function changeRButtonHandler(event : Event) : void
		{
			updatePack();
		}

		/*
		 * 响应合成完成
		 */
		private function mergeCompleteHandler(event : Event) : void
		{
			_productIcon.source = _control.product;
			_control.clear();
			updateView();
		}
		
		/*
		 * VIP 等级改变
		 */
		private function vipLevelChangeHandler(event:Event):void
		{
			_batchMergeButton.visible = UserData.instance.vipLevel >= BATCH_MERGE_VIP_LEVEL;
		}

		// =====================
		// @其他
		// =====================
		private function filterBinding(arr : Array) : Array
		{
			if (!_hideBindRButton.selected) return arr;
			var arrOut : Array = [];
			for each (var item:Item in arr)
			{
				if (item.binding == false)
					arrOut.push(item);
			}

			return arrOut;
		}

		/*
		 * 过滤总数小于三的灵珠
		 */ 
		private function filterMatch(arr : Array) : Array
		{
			if (!_showMatchRButton.selected) return arr;

			var arrOut : Array = [];

			var numByGemId : Dictionary = new Dictionary();
			for each (var item:Item in arr)
			{
				if (numByGemId[item.id])
				{
					numByGemId[item.id] += item.nums;
				}
				else
				{
					numByGemId[item.id] = item.nums;
				}
			}

			for each (item in arr)
			{
				if (numByGemId[item.id] >= 3)
				{
					arrOut.push(item);
				}
			}
			return arrOut;
		}
		
		/*
		 * 扣除合成材料
		 */
		private function filterFragments(arr:Array):Array
		{
			var fragments : Array = _control.fragments;
			if (fragments.length == 0) return arr;
			
			var key : String;
			var numByFragIdBinding : Dictionary = new Dictionary();
			for each (var frag:Gem in fragments)
			{
				key = frag.heroId+"_"+frag.id+"_"+frag.binding;
				if (numByFragIdBinding[key])
					numByFragIdBinding[key] += 1;
				else
					numByFragIdBinding[key] = 1;
			}

			var arrOut:Array = [];
			for each (var item:Gem in arr)
			{
				// 需要扣除材料
				key = item.heroId+"_"+item.id+"_"+item.binding;
				if (numByFragIdBinding[key])
				{
					var num : int = item.nums - numByFragIdBinding[key];
					// 扣除后有剩余
					if (num > 0)
					{
						var newItem : Item = ItemManager.instance.newItem(item.id, item.binding);
						newItem.nums = num;
						arrOut.push(newItem);
					}
				}
				else
				{
					arrOut.push(item);
				}
			}
			return arrOut;
		}
		
		 		/*
		 * 灵珠排序函数
		 */
		override protected function itemSortFunc(a : Item, b : Item) : int
		{
			var aHeroId:uint = Gem(a).heroId;
			var bHeroId:uint = Gem(b).heroId;
			
			if (aHeroId != bHeroId)
			{
				if (aHeroId == 0) return 1;
				if (bHeroId == 0) return -1;
				return aHeroId - bHeroId;	
			}
			
			if (a.id != b.id) return b.id - a.id;
			return (b.binding?1:0) - (a.binding?1:0);
		}

	}
}
