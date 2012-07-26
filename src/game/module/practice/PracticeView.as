package game.module.practice
{
	import game.core.avatar.AvatarMySelf;
	import flash.utils.getTimer;
	import framerate.SecondsTimer;

	import game.core.user.StateManager;
	import game.core.user.StateType;
	import game.manager.ViewManager;
	import game.net.core.Common;
	import game.net.data.StoC.SCTrainInfo;

	import gameui.containers.GPanel;
	import gameui.controls.GLabel;
	import gameui.core.GAlign;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.RESManager;

	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.TimeUtil;

	import flash.display.Bitmap;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;

	/**
	 * @author yangyiqiang
	 */
	public final class PracticeView extends GPanel
	{
		public function PracticeView()
		{
			_data = new GPanelData();
			_data.width = 268;
			_data.height = 130;
			_data.bgAsset = new AssetData("AlertBg");
			_data.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
			_data.align = new GAlign(-1, -1, -1, -1, 0, 100);
			super(_data);
			initEvent();
		}

		private var _titleLabel : TextField = new TextField();

		private var _back : Bitmap;

		private var _lable : GLabel;

		private var _time : GLabel;

		override protected function create() : void
		{
			super.create();
			_titleLabel.embedFonts = true;
			_titleLabel.selectable = false;
			_titleLabel.mouseEnabled = false;
			_titleLabel.defaultTextFormat = TextFormatUtils.windowTitle;
			_titleLabel.filters = [new DropShadowFilter(0, 45, 0x000000, 1, 5, 5, 2)];
			_titleLabel.width = 268;
			_titleLabel.height = 28;
			_titleLabel.x = 0;
			_titleLabel.y = 5;
			_titleLabel.text = "挂机修炼中...";
			addChild(_titleLabel);
			_back = new Bitmap();
			_back.x = 10;
			_back.y = 40;
			_back.bitmapData = RESManager.getBitmapData(new AssetData("praticeIoc"));
			addChild(_back);
			var lableData : GLabelData = new GLabelData();
			lableData.textColor = 0xffffff;
			lableData.text = "累积经验：";
			lableData.width = 230;
			_lable = new GLabel(lableData);
			_lable.x = 86;
			_lable.y = 45;
			lableData = lableData.clone();
			lableData.text = "修炼时间：";
			_time = new GLabel(lableData);
			_time.x = 86;
			_time.y = 70;
			addChild(_lable);
			addChild(_time);
			GLayout.layout(_titleLabel);
		}

		public function showOnly() : void
		{
			_data.parent.addChildAt(this, 0);
			AvatarMySelf.instance.sitdown();
			timeFun();
			SecondsTimer.addFunction(timeFun);
			initEvent();
			StateManager.instance.changeState(StateType.PRACTICE_STATE);
			GLayout.update(UIManager.root, this);
		}

		public function hideOnly() : void
		{
//			AvatarMySelf.instance.stand();
			super.hide();
			SecondsTimer.removeFunction(timeFun);
			StateManager.instance.changeState(StateType.PRACTICE_STATE, false);
		}

		private var showTime:Number = 0;
		override public function show() : void
		{
			if(getTimer() - showTime < 200)
			{
				return;
			}
			showTime = getTimer();
			PracticeProxy.getInstance().sendCmd();
		}

		override public function hide() : void
		{
			PracticeProxy.getInstance().sendCmd(0);
		}

		private function initEvent() : void
		{
			Common.game_server.addCallback(0x2D, practiceInfo);
		}

		private var _timer : uint;

		/**  0表示结束，2表示打坐  */
		private var _type : int;

		private function timeFun() : void
		{
			_time.text = "修炼时间：" + TimeUtil.secondsToTime(_timer);
			_timer--;
		}

		private var _completeCount : int = 0;

		private function practiceInfo(msg : SCTrainInfo) : void
		{
			_type = msg.type;
			_timer = msg.timeLeft;
			_lable.htmlText = "累积经验：" + StringUtils.addColorById(String(msg.expGot), 2);
			_completeCount = msg.completeCount;
		}
	}
}
