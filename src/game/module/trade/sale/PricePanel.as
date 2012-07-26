package game.module.trade.sale
{
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	import game.definition.UI;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GToolTipData;
	import gameui.manager.UIManager;
	import net.AssetData;




	/**
	 * @author zhenyuhang
	 */
	public class PricePanel extends GComponent
	{
		// 重构笔记
		// 1. GPanel - GComponent
		// 2. _priceText
		// 3. 为什么要用ToolTip？
		// 4. setPrice
		
		// =====================
		// @属性
		// =====================
		private var _priceText:TextField;

		// =====================
		// @创建
		// =====================		
		public function PricePanel()
		{
			var data:GComponentData = new GComponentData();
			data.width=13;
			data.height=20;
			data.toolTipData = new GToolTipData();
		    super(data);
		}
		
		override protected function create():void
		{
			addbg();
			addPriceText();
		}	
		
		private function addbg():void
		{
			var goldbg:Sprite=UIManager.getUI(new AssetData(UI.MONEY_ICON_GOLD));
		   	goldbg.width=13;
		   	goldbg.height=11;
		   	goldbg.x=0;
		   	goldbg.y=3;
	       	addChild(goldbg);
		}
		
		private function addPriceText():void
		{
			_priceText = UICreateUtils.createTextField(null,null, 40,20,15,0,TextFormatUtils.panelContent);
			addChild(_priceText);
		}
		
		// =====================
		// @更新
		// =====================
		public function setPrice(count:String):void
		{
		    _priceText.text = count;
		}
	}
}
