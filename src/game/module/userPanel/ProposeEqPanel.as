package game.module.userPanel
{
	import com.commUI.GInfoWindow;
	import com.commUI.icon.ItemIcon;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.core.hero.HeroManager;
	import game.core.item.Item;
	import game.core.item.equipment.Equipment;
	import game.definition.UI;
	import game.manager.ViewManager;
	import gameui.controls.GButton;
	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import net.AssetData;




	/**
	 * @author jian
	 */
	public class ProposeEqPanel extends GInfoWindow
	{
		private var _nameText:TextField;
		private var _itemIcon:ItemIcon;
		private var _okButton:GButton;
		
		override public function set source(value:*):void
		{
			_source = value;
			updateItemIcon();
			updateNameText();
		}
		
		public function ProposeEqPanel()
		{
			var data:GComponentData = new GComponentData();
			data.parent = ViewManager.instance.uiContainer;
			data.align = new GAlign(-1, 25, -1, 140);
			data.width = 285;
			data.height = 155;
			
			super(data);
		}
		
		override protected function create():void
		{
			super.create();
			
			addHintText();
			addFrameSkin();
			addItemIcon();
			addNameText();
			addOkButton();
		}
		
		private function addHintText():void
		{
			addChild(UICreateUtils.createTextField("你获得了新装备，是否立即装备？", null, 190, 20, 10, 8, TextFormatUtils.panelContent));
		}
		
		private function addFrameSkin():void
		{
			var frame:Sprite = UIManager.getUI(new AssetData(UI.AREA_BACKGROUND));
			frame.x = 8;
			frame.y = 28;
			frame.width = 271;
			frame.height = 75;
			addChild(frame);
		}
		
		private function addItemIcon():void
		{
			_itemIcon = UICreateUtils.createItemIcon({x:65, y:38, showBorder:true, showBg:true, showToolTip:true, showBinding:true, sendChat:true});
			addChild(_itemIcon);
		}

		private function addNameText():void
		{
			_nameText = UICreateUtils.createTextField(null, null, 140, 30, 120, 56, TextFormatUtils.panelSubTitle);
			addChild(_nameText);
		}
		
		private function addOkButton():void
		{
			_okButton = new GButton(UICreateUtils.buttonDataNormal);
			_okButton.text = "确定";
			_okButton.x = 103;
			_okButton.y = 119;
			addChild(_okButton);
		}
		
		private function updateItemIcon():void
		{
			_itemIcon.source = _source;
		}
		
		private function updateNameText():void
		{
			_nameText.htmlText = (_source as Item).htmlName;
		}
		
		override protected function onShow():void
		{
			super.onShow();
			GLayout.update(UIManager.root, this);
			_okButton.addEventListener(MouseEvent.CLICK, okButton_clickHandler);
		}
		
		override protected function onHide():void
		{
			_okButton.removeEventListener(MouseEvent.CLICK, okButton_clickHandler);
			super.onHide();
		}
		
		private function okButton_clickHandler(event:MouseEvent):void
		{
			var eq:Equipment = _source as Equipment;
			HeroManager.instance.myHero.getEqSlot(eq.type).equip(eq);
			this.hide();
		}
	}
}
