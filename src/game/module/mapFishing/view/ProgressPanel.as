package game.module.mapFishing.view {
	import game.core.avatar.AvatarManager;
	import game.core.user.StateManager;
	import game.definition.UI;
	import game.module.mapFishing.FishingManager;
	import game.module.mapFishing.FishingModel;
	import game.module.mapFishing.FishingPosition;
	import game.module.mapFishing.FishingState;

	import gameui.controls.BDPlayer;
	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.RESManager;

	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.FilterUtils;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.TimeUtil;
	import com.utils.UICreateUtils;

	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;

	// import org.osmf.utils.TimeUtil;
	/**
	 * @author jian
	 */
	public class ProgressPanel extends GComponent
	{
		// =====================
		// 属性
		// =====================
		private var _model : FishingModel;
		private var _startButton : SimpleButton;
		private var _pullButton : SimpleButton;
		// private var _pullEffect : MovieClip;
		private var _circlePlayer : BDPlayer;
		private var _basketButton : SimpleButton;
		private var _speedUpButton : GButton;
		private var _exitButton : GButton;
		private var _timeText : TextField;
		private var _actionText : TextField;

		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function ProgressPanel(model : FishingModel) : void
		{
			_model = model;

			var data : GComponentData = new GComponentData();
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			addTexts();
			addButtons();
		}

		private function addTexts() : void
		{
			_actionText = UICreateUtils.createTextField(null, null, 144, 20, -70, -82, TextFormatUtils.contentCenter);
			_actionText.filters = [FilterUtils.defaultTextEdgeFilter];
			addChild(_actionText);

			_timeText = UICreateUtils.createTextField(null, null, 180, 20, -70, -82, TextFormatUtils.content);
			_timeText.filters = [FilterUtils.defaultTextEdgeFilter];
			addChild(_timeText);
		}

		private function addButtons() : void
		{
			var basketButtonClass : Class = RESManager.getClass(new AssetData("fishing_basket_button", "fishing"));
			_basketButton = new basketButtonClass() as SimpleButton;
			_basketButton.x = -90;
			_basketButton.y = -60;
			addChild(_basketButton);

			var startButtonClass : Class = RESManager.getClass(new AssetData("fishing_rod_button", "fishing"));
			_startButton = new startButtonClass() as SimpleButton;
			_startButton.x = -23;
			_startButton.y = -60;
			addChild(_startButton);

			var dragButtonClass : Class = RESManager.getClass(new AssetData("fishing_bait_button", "fishing"));
			_pullButton = new dragButtonClass() as SimpleButton;
			_pullButton.x = -23;
			_pullButton.y = -60;
			_pullButton.visible = false;
			addChild(_pullButton);

			_circlePlayer = AvatarManager.instance.getCommBDPlayer(AvatarManager.COMM_CIRCLEEFFECT, new GComponentData());
			_circlePlayer.mouseEnabled = false;
			_circlePlayer.x = 2.5;
			_circlePlayer.y = -36.5;
			_circlePlayer.scaleX = 0.65;
			_circlePlayer.scaleY = 0.65;
			addChild(_circlePlayer);

			_exitButton = UICreateUtils.createGButton(null, 0, 0, -23, -60, KTButtonData.EXIT_ROUND_BUTTON);
			addChild(_exitButton);

			// offButton = FishManager.makeButton(275, 10, 72, 24, '离开鱼池', this);
			_speedUpButton = UICreateUtils.createGButton(null, 28, 22, 45, -85, KTButtonData.SMALL_BUTTON);
			var arrow : Sprite = UIManager.getUI(new AssetData(UI.ICON_FAST_FORWARD));
			arrow.x = 10;
			arrow.y = 5;
			_speedUpButton.addChild(arrow);
			addChild(_speedUpButton);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		public function setPosition(position : uint) : void
		{
			if (position == FishingPosition.TOP_LEFT || position == FishingPosition.BOTTOM_LEFT)
				_basketButton.x = -90;
			else
				_basketButton.x = 43;
		}

		public function updateState() : void
		{
			if (_model.state == FishingState.INIT)
			{
				// trace("钓鱼面板 INIT");
				_startButton.visible = true;
				_startButton.enabled = true;
				_pullButton.visible = false;
				// _pullEffect.visible = true;
				// _pullEffect.gotoAndPlay(1);
				_circlePlayer.visible = true;
				_circlePlayer.play(80, null, 0);
				_actionText.text = "点击开始";
				_speedUpButton.visible = false;
				_exitButton.visible = false;
				_timeText.visible = false;
			}
			else if (_model.state == FishingState.WAIT)
			{
				// trace("钓鱼面板 WAIT");
				_model.timer.addEventListener(TimerEvent.TIMER, timerHandler);
				// _pullEffect.visible = false;
				// _pullEffect.stop();
				_circlePlayer.visible = false;
				_circlePlayer.stop();
				_actionText.text = "";
				_startButton.enabled = false;
				_speedUpButton.visible = true;
				
				_timeText.visible = true;
				_timeText.text = "钓鱼剩余时间 00:00";
			}
			else if (_model.state == FishingState.HOLD)
			{
				// trace("钓鱼面板 HOLD");
				_model.timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				_speedUpButton.visible = false;
				_timeText.visible = false;
				_startButton.visible = false;
				_exitButton.visible = false;
				_pullButton.visible = true;
				_actionText.text = "点击拉杆";
				// _pullEffect.visible = true;
				// _pullEffect.gotoAndPlay(1);
				_circlePlayer.visible = true;
				_circlePlayer.play(80, null, 0);
			}
			else if (_model.state == FishingState.FINISH || _model.state == FishingState.PULL)
			{
				// trace("钓鱼面板 FINISH or PULL");
				_pullButton.visible = false;
				_actionText.text = "";
				// _pullEffect.visible = false;
				// _pullEffect.stop();
				_circlePlayer.visible = false;
				_circlePlayer.stop();
				_exitButton.visible = false;
				_startButton.visible = true;
				_startButton.enabled = true;
			}
			else if (_model.state == FishingState.ZERO)
			{
				// trace("钓鱼面板 ZERO");
				_pullButton.visible = false;
				_actionText.text = "";
				// _pullEffect.visible = false;
				// _pullEffect.stop();
				_circlePlayer.visible = false;
				_circlePlayer.stop();
				_startButton.visible = false;
				_startButton.enabled = false;
				_exitButton.visible = true;
			}
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			// _timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_startButton.addEventListener(MouseEvent.CLICK, startButton_clickHandler);
			_pullButton.addEventListener(MouseEvent.CLICK, pullButton_clickHandler);
			_exitButton.addEventListener(MouseEvent.CLICK, exitButton_clickHandler);
			_basketButton.addEventListener(MouseEvent.CLICK, basketButton_clickHandler);
			_speedUpButton.addEventListener(MouseEvent.CLICK, speedUpButton_clickHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
			ToolTipManager.instance.registerToolTip(_speedUpButton, ToolTip, "花费" + StringUtils.addGoldColor("10元宝") + "立即拉杆");
		}

		override protected function onHide() : void
		{
			// _timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			_startButton.removeEventListener(MouseEvent.CLICK, startButton_clickHandler);
			_pullButton.removeEventListener(MouseEvent.CLICK, pullButton_clickHandler);
			_exitButton.removeEventListener(MouseEvent.CLICK, exitButton_clickHandler);
			_basketButton.removeEventListener(MouseEvent.CLICK, basketButton_clickHandler);
			_speedUpButton.removeEventListener(MouseEvent.CLICK, speedUpButton_clickHandler);
			removeEventListener(MouseEvent.CLICK, clickHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
			ToolTipManager.instance.destroyToolTip(_speedUpButton);
		}

		private function clickHandler(event : MouseEvent) : void
		{
			event.stopPropagation();
		}

		private function timerHandler(event : TimerEvent) : void
		{
			_timeText.text = "钓鱼剩余时间 " + TimeUtil.secondsToMinuteSeconds(_model.totalSeconds - _model.timer.currentCount);//TimeUtil.secondsToTimeSimple(_model.totalSeconds - _model.timer.currentCount);
		}

		private function startButton_clickHandler(event : Event) : void
		{
			event.stopPropagation();

			if (_model.state != FishingState.WAIT)
			{
				FishingManager.instance.startFishing();
			}
		}

		private function pullButton_clickHandler(event : Event) : void
		{
			event.stopPropagation();

			if (_model.state != FishingState.PULL)
			{
				FishingManager.instance.sendFishDrawMessage();
			}
		}

		private function basketButton_clickHandler(event : Event) : void
		{
			event.stopPropagation();
			FishingManager.instance.basketPanel.show();
		}

		private function speedUpButton_clickHandler(event : Event) : void
		{
			event.stopPropagation();
			FishingManager.instance.speedUpFishing();
		}

		private function exitButton_clickHandler(event : Event) : void
		{
			event.stopPropagation();
			if (_model.leftTimes == 0)
				FishingManager.instance.canelFishing();
			else
				StateManager.instance.checkMsg(21, null, confirmCancelFishing);
		}

		private function confirmCancelFishing(type : String) : Boolean
		{
			switch(type)
			{
				case Alert.OK_EVENT :
				case Alert.YES_EVENT :
					FishingManager.instance.canelFishing();
					break;
			}
			return true;
		}
	}
}
