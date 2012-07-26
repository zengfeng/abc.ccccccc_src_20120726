package game.module.mapFishing.view
{
	import game.core.item.Item;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.icon.ItemIcon;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.text.TextField;








	/**
	 * @author jian
	 */
	public class AwardPanel extends GComponent
	{
		// =====================
		// 属性
		// =====================
		private var _awardIcon : ItemIcon;
		private var _awardItem : Item;
		private var _awardText : TextField;

		// =====================
		// Getter/Setter
		// =====================
		public function set award(value:Item):void
		{
			_awardItem = value;
			
			updateAward();
		}
		
		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function AwardPanel()
		{
			var data:GComponentData = new GComponentData();
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			addBackground();
			addAwardIcon();
			addAwardText();
		}

		private function addBackground() : void
		{
			addChild(UIManager.getUI(new AssetData("fishing_award_panel", "fishing")));
		}

		private function addAwardIcon() : void
		{
			_awardIcon = UICreateUtils.createItemIcon({x:111, y:15, showBorder:true, showBg:true, showToolTip:true});
			addChild(_awardIcon);
		}

		private function addAwardText() : void
		{			
			_awardText = UICreateUtils.createTextField(null, null, 200, 20, 30, 69, TextFormatUtils.panelContent);
			addChild(_awardText);
		}

		
		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateAward() : void
		{
			_awardIcon.source = _awardItem;
			_awardText.htmlText = "恭喜！你从鱼塘里钓到了" + _awardItem.htmlName;
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
//		override protected function onShow() : void
//		{
//			super.onShow();
//			stage.addEventListener(MouseEvent.CLICK, stage_clickHandler);
//		}
//
//		override protected function onHide() : void
//		{
//			stage.removeEventListener(MouseEvent.CLICK, stage_clickHandler);
//			super.onHide();
//		}
//
//		private function stage_clickHandler(event : Event) : void
//		{
//			event.stopPropagation();
//			
//			FishingManager.instance.finishFishing();
//			hide();
//		}
	}
}
