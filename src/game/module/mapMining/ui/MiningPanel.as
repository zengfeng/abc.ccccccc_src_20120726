package game.module.mapMining.ui
{
	import com.commUI.tooltip.WordWrapToolTip;

	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import gameui.manager.UIManager;
	import gameui.layout.GLayout;

	import com.utils.StringUtils;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;

	import flash.display.BlendMode;

	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.mapMining.MiningUtils;
	import game.module.mapMining.event.MiningEvent;
	import game.net.core.Common;
	import game.net.data.CtoC.CCVIPLevelChange;

	import gameui.controls.GButton;
	import gameui.controls.GCheckBox;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;
	import gameui.data.GButtonData;
	import gameui.data.GCheckBoxData;

	import net.AssetData;
	import net.RESManager;

	import com.commUI.RemindBubble;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jian
	 */
	public class MiningPanel extends GComponent
	{
		// =====================
		// 属性
		// =====================
		private var _currentButton : GButton;
		private var _silverButton : GButton;
		private var _goldButton : GButton;
		private var _silverDuringButton : GButton;
		private var _goldDuringButton : GButton;
		private var _timesLeft : int = 0;
		private var _batchCheck : GCheckBox;
		private var _bubble : RemindBubble;
		private var _digging : Boolean;
		private var _lightCircle : MovieClip;

		// =====================
		// getter/setter
		// =====================
		public function get useGold() : Boolean
		{
			return _timesLeft == 0 && UserData.instance.vipLevel >= MiningUtils.VIP_LEVEL;
		}

		public function set digging(value : Boolean) : void
		{
			_digging = value;
			updateButton();
		}

		public function get digging() : Boolean
		{
			return _digging;
		}

		public function set timesLeft(value : int) : void
		{
			_timesLeft = value;
			updateButton();
			updateBubble();
			updateBatchCheck();
		}

		public function get timesLeft() : int
		{
			return _timesLeft;
		}

		public function set batchMode(value : Boolean) : void
		{
			_batchCheck.selected = value;
		}

		public function get batchMode() : Boolean
		{
			return _batchCheck.selected;
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function MiningPanel()
		{
			var data : GComponentData = new GComponentData();
			data.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
			data.width = 80;
			data.align = new GAlign(-1, -1, 70, -1, 0);
			super(data);
		}

		override protected function create() : void
		{
			addButtons();
			addBubble();
			addBatchCheck();
			addCircle();
			updateButton();
			setHitArea();
		}

		private function setHitArea() : void
		{
			var mask : Sprite = new Sprite();
			mask.graphics.beginFill(0x000000);
			mask.graphics.drawCircle(43, 41, 37);
			mask.alpha = 0;
			_goldButton.hitArea = mask;
			_goldButton.addChild(mask);

			mask = new Sprite();
			mask.alpha = 0;
			mask.graphics.beginFill(0x000000);
			mask.graphics.drawCircle(43, 41, 37);
			_silverButton.hitArea = mask;
			_silverButton.addChild(mask);
		}

		private function addCircle() : void
		{
			_lightCircle = RESManager.getMC(new AssetData(UI.MINING_LIGHT_CIRCLE, "mining"));
			_lightCircle.blendMode = BlendMode.LIGHTEN;
			_lightCircle.scaleX = 0.4;
			_lightCircle.scaleY = 0.4;
			_lightCircle.x = 22;
			_lightCircle.y = 22;
		}

		private function addButtons() : void
		{
			var silverData : GButtonData = new GButtonData();
			silverData.overAsset = new AssetData(UI.MINING_SILVER_BUTTON_OVER, "mining");
			silverData.upAsset = new AssetData(UI.MINING_SILVER_BUTTON_UP, "mining");
			silverData.downAsset = new AssetData(UI.MINING_SILVER_BUTTON_DOWN, "mining");
			silverData.scaleMode = ScaleMode.SCALE_NONE;

			_silverButton = new GButton(silverData);

			var goldData : GButtonData = new GButtonData();
			goldData.overAsset = new AssetData(UI.MINING_GOLD_BUTTON_OVER, "mining");
			goldData.upAsset = new AssetData(UI.MINING_GOLD_BUTTON_UP, "mining");
			goldData.downAsset = new AssetData(UI.MINING_GOLD_BUTTON_DOWN, "mining");
			goldData.scaleMode = ScaleMode.SCALE_NONE;
			_goldButton = new GButton(goldData);

			var silverDuringData : GButtonData = new GButtonData();
			silverDuringData.overAsset = new AssetData(UI.DURING_SILVER_BUTTON_OVER, "mining");
			silverDuringData.upAsset = new AssetData(UI.DURING_SILVER_BUTTON_OVER, "mining");
			silverDuringData.downAsset = new AssetData(UI.DURING_SILVER_BUTTON_OVER, "mining");
			silverDuringData.scaleMode = ScaleMode.SCALE_NONE;
			_silverDuringButton = new GButton(silverDuringData);

			var goldDuringData : GButtonData = new GButtonData();
			goldDuringData.overAsset = new AssetData(UI.DURING_GOLD_BUTTON_OVER, "mining");
			goldDuringData.upAsset = new AssetData(UI.DURING_GOLD_BUTTON_OVER, "mining");
			goldDuringData.downAsset = new AssetData(UI.DURING_GOLD_BUTTON_OVER, "mining");
			goldDuringData.scaleMode = ScaleMode.SCALE_NONE;
			_goldDuringButton = new GButton(goldDuringData);
		}

		private function addBubble() : void
		{
			_bubble = new RemindBubble();
			_bubble.x = 65;
			_bubble.y = 15;
			addChild(_bubble);
		}

		private function addBatchCheck() : void
		{
			var data : GCheckBoxData = new GCheckBoxData();
			data.labelData.textColor = 0xFFFFFF;
			data.labelData.text = "采集" + MiningUtils.BATCH_TIMES + "次";
			data.x = 8;
			data.y = _goldButton.height + 5;
			_batchCheck = new GCheckBox(data);
			addChild(_batchCheck);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateButton() : void
		{
			var swapButton : GButton;

			if (_digging)
			{
				if (useGold)
					swapButton = _goldDuringButton;
				else
					swapButton = _silverDuringButton;

				_batchCheck.visible = false;
				playCircle();
			}
			else
			{
				if (useGold)
				{
					swapButton = _goldButton;
					_bubble.visible = false;
				}
				else
				{
					swapButton = _silverButton;
					_bubble.visible = true;
				}

				if (UserData.instance.vipLevel >= MiningUtils.BATCH_LEVEL)
				{
					_batchCheck.visible = true;
				}
				else
				{
					_batchCheck.visible = false;
					_batchCheck.selected = false;
				}
				stopCircle();
			}

			if (swapButton == _currentButton)
				return;

			if (!_currentButton)
			{
				_currentButton = swapButton;
				addChildAt(swapButton, 0);
			}
			else
			{
				// addChildAt(swapButton, getChildIndex(_currentButton));

				addChildAt(swapButton, 0);
				removeChild(_currentButton);
				_currentButton = swapButton;
			}
		}

		private function playCircle() : void
		{
			addChild(_lightCircle);
			_lightCircle.gotoAndPlay(1);
		}

		private function stopCircle() : void
		{
			if (_lightCircle.parent)
			{
				_lightCircle.stop();
				_lightCircle.parent.removeChild(_lightCircle);
			}
		}

		private function updateBubble() : void
		{
			_bubble.text = _timesLeft.toString();
		}

		private function updateBatchCheck() : void
		{
			if (useGold)
			{
				_batchCheck.text = "批量" + MiningUtils.BATCH_TIMES + "次";
			}
			else
			{
				_batchCheck.text = "批量" + _timesLeft + "次";
			}
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			_silverButton.addEventListener(MouseEvent.CLICK, miningButton_clickHandler);
			_goldButton.addEventListener(MouseEvent.CLICK, miningButton_clickHandler);
			Common.game_server.addCallback(0xFFF7, onVipLevelChange);
			ToolTipManager.instance.registerToolTip(_silverButton, WordWrapToolTip, provideSilverButtonToolTip);
			ToolTipManager.instance.registerToolTip(_goldButton, WordWrapToolTip, provideGoldButtonToolTip);
		}

		override protected function onHide() : void
		{
			_silverButton.removeEventListener(MouseEvent.CLICK, miningButton_clickHandler);
			_goldButton.removeEventListener(MouseEvent.CLICK, miningButton_clickHandler);
			Common.game_server.removeCallback(0xFFF7, onVipLevelChange);
			ToolTipManager.instance.destroyToolTip(_silverButton);
			ToolTipManager.instance.destroyToolTip(_goldButton);
		}

		private function miningButton_clickHandler(event : MouseEvent) : void
		{
			var e : Event = new MiningEvent(MiningEvent.GO);
			dispatchEvent(e);
		}

		private function onVipLevelChange(msg : CCVIPLevelChange) : void
		{
			updateButton();
			updateBatchCheck();
		}

		private function provideSilverButtonToolTip() : String
		{
			return "免费采集次数：" + StringUtils.addGoldColor(_timesLeft.toString());
		}

		private function provideGoldButtonToolTip() : String
		{
			return "花费" + StringUtils.addGoldColor((_batchCheck.selected ? MiningUtils.GOLD_COST * MiningUtils.BATCH_TIMES : MiningUtils.GOLD_COST).toString()) + "元宝采集，获得高级仙石的概率提高了";
		}
	}
}
