package game.module.trade
{
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import game.definition.UI;
	import game.net.core.Common;
	import game.net.data.CtoS.CSBuyout;
	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import net.AssetData;




	/**
	 * @author zhenyuhang
	 */
	public class TradeMySaleItem3 extends GComponent
	{
		// 重构笔记
		// 1. 重排代码顺序，属性-创建-更新-交互-其它
		// 2. 用GComponent替换GPanel，减少资源消耗
		// 3. 把事件的绑定和注销放在onShow和onHide中，show(),hide()中的内容可以合并到onShow, onHide中
		// 4. 把initView()函数中的内容移到 override  create()中，如果父类不为GComponent，记住要先 super.create()
		// 5. 变量名重命名：GoodsID-_goodsId TradeID-_tradeId _buy-_buyButton, 函数重命名 initall - clear, refreshLabel - setLabel
		//    避免出现cmd1, cmd2这种命名方式
		// 6. 重写耦合性极强的addItemText()函数，使用CreateUtils.createTextField()函数
		// 7. 显式创建 _goodsNameText, _goodsCountText, _goodsOwnerText, _goodsPriceText等TextField，调试，扩展都方便
		// 8. _goodsName, _goodsCount等空字符串的定义是冗余的
		// 9. 拼写错误
		// 10. 把@author zhenyuhang标上
		// 11. 不提倡refreshLabel (setLabel) 函数的通过参数将所有数据一次性传入的方法，如果需求发生改变，那么接口要跟着变，推荐两种解决方法
		//     a. 将setLabel拆成 setName, setID, set ...等一系列函数，每个接口互相独立
		//     b. 将name, count, ...等数据打包成一个VO，函数的参数永远是一个VO，不会变，而VO本身打包的数据可以跟着需求变化
		
		// =====================
		// @属性
		// =====================
		private var _goodsId : int;
		private var _tradeId : int;
		private var _buyButton : GButton;
		private var _nameText:TextField;
		private var _countText:TextField;
		private var _ownerText:TextField;
		private var _priceText:TextField;

		// =====================
		// @创建
		// =====================
		public function TradeMySaleItem3()
		{
			var data : GComponentData = new GComponentData();
			data.width = 410;
			data.height = 38.2;
			super(data);
		}

		override protected function create() : void
		{
			addBg();
			addButton();
			_buyButton.hide();
			addLabel();
		}

		private function addBg() : void
		{
			var panelBg : Sprite = UIManager.getUI(new AssetData(UI.TRADE_ITEM_EXAMPLE));
			panelBg.width = 35;
			panelBg.height = 35;
			panelBg.x = 2;
			panelBg.y = 0.7;
			addChild(panelBg);
		}

		private function addLabel() : void
		{
			_nameText = UICreateUtils.createTextField(null, null, 98.8, 19, 38, 8.2, TextFormatUtils.panelContent);
			_countText = UICreateUtils.createTextField(null, null, 35, 19, 168, 8.2, TextFormatUtils.panelContent);
			_ownerText = UICreateUtils.createTextField(null, null, 95.8, 19, 237, 8.2, TextFormatUtils.panelContent);
			_priceText = UICreateUtils.createTextField(null, null, 55.3, 19, 375, 8.2, TextFormatUtils.panelContent);
			
			addChild(_nameText);
			addChild(_countText);
			addChild(_ownerText);
			addChild(_priceText);
		}

		private function addButton() : void
		{
			var data : GButtonData = new GButtonData();
			data.width = 51;
			data.height = 24;
			data.x = 480;
			data.y = 5;
			_buyButton = new GButton(data);
			_buyButton.text = "购买";
			addChild(_buyButton);
		}
		
		// =====================
		// @更新
		// =====================	
		public function setLabel(goodsName : String, goodsCount : String, goodsOwner : String, goodsPrice : String, itemId : int, orderId : int, tradeId : int) : void
		{
			_goodsId = itemId;
			_tradeId = tradeId;
			_nameText.text = goodsName;
			_countText.text = goodsCount;

			_ownerText.text = goodsOwner;
			_priceText.text = goodsPrice;
			_buyButton.show();
		}
		
		public function clear() : void
		{
			_nameText.text = "";
			_countText.text = "";
			_ownerText.text = "";
			_priceText.text = "";
			_buyButton.hide();
		}
				
		public function getGoodsId() : int
		{
			return _goodsId;
		}

		public function getTradeId() : int
		{
			return _tradeId;
		}

		// =====================
		// @交互
		// =====================
		override protected function onShow():void
		{
			super.onShow();
			_buyButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			GLayout.layout(this);
		}
		
		override protected function onHide():void
		{
			_buyButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
			super.onHide();
		}
		
		private function onButtonClick(event : MouseEvent) : void
		{
			var cmd : CSBuyout = new CSBuyout();
			cmd.tradeid = _tradeId;
			Common.game_server.sendMessage(0xB9, cmd);
		}
	}
}

