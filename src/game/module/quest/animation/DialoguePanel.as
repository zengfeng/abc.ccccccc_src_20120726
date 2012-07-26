package game.module.quest.animation
{
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import game.module.quest.QuestUtil;
	import gameui.controls.GImage;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import net.AssetData;
	import net.RESManager;





	/**
	 * @author yangyiqiang
	 */
	public class DialoguePanel extends GComponent
	{
		public function DialoguePanel()
		{
			_base = new GComponentData();
			_base.width = 900;
			_base.height = 300;
			_base.parent = UIManager.root;
			_base.align = new GAlign(-1, -1, -1, 0, 0);
			super(base);
			initView();
		}

		private var _back : Sprite;

		private var _nameLable : TextField;

		private var _dialog : TextField;

		private var _head : GImage;

		private var _head2 : GImage;

		private var _trigon : MovieClip;

		private function initView() : void
		{
			_back = new Sprite();
			_back.y = 163;
			addChild(_back);
			drawBack();
			var gimgData : GImageData = new GImageData();
			gimgData.align = new GAlign(0, -1, -1, 0);
			gimgData.autoLayout=true;
			_head = new GImage(gimgData);
			addChild(_head);
			gimgData = new GImageData();
			gimgData.align = new GAlign(-1 ,0, -1, 0);
			gimgData.autoLayout=true;
			_head2 = new GImage(gimgData);
			addChild(_head2);

			_nameLable = new TextField();
			_nameLable.x = 300;
			_nameLable.y = 170;
			_nameLable.width = 300;
			_nameLable.wordWrap = true;
			_nameLable.selectable = false;
			_nameLable.defaultTextFormat = UIManager.getTextFormat(14, 0xfff000);
			addChild(_nameLable);

			_dialog = UIManager.getTextField();
			_dialog.wordWrap = true;
			_dialog.selectable = false;
			_dialog.defaultTextFormat = UIManager.getTextFormat(14);
			_dialog.textColor = 0xFFFFFF;
			addChild(_dialog);
			_dialog.width = 447;
			_dialog.height = 100;
			_dialog.x = 220;
			_dialog.y = 200;

			_trigon = RESManager.getMC(new AssetData("quest_trigon", "quest"));
			_trigon.x = _dialog.x + 447;
			_trigon.y = 300;
			addChild(_trigon);
		}

		private function drawBack() : void
		{
		}

		private var strArray : Array = [];

		private var num : int = 0;

		private var _timer : Timer;

		private function addWords(str : String) : void
		{
			str = QuestUtil.parseRegExpStr(str);
			strArray = [];
			num = 0;
			for (var i : int = 0;i < str.length;i++)
			{
				strArray.push(str.charAt(i));
			}
			if (strArray.length < 1) return;
			_dialog.text = "";
			if (!_timer) _timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, enterFrame);
			_timer.start();
		}

		private function enterFrame(event : TimerEvent) : void
		{
			if (num < strArray.length)
				_dialog.appendText(strArray[num]);
			else
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, enterFrame);
			}
			num++;
		}

		/** 
		 * return true   已经显示完成了，可以进入下一步
		 *        false  还在运行文字中，点击显示完成
		 */
		public function showAll() : Boolean
		{
			if (!_vo) return true;
			if (!_timer.running) return true;
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, enterFrame);
			_dialog.htmlText = QuestUtil.parseRegExpStr(_vo.describe);
			return false;
		}

		private var _vo : Action;

		public function set data(value : Action) : void
		{
			if (!value)
			{
				this.hide();
				return;
			}
			_vo = value;
			_head.alpha = 0;
			_head2.alpha = 0;
			if (value.direction == 1)
			{
				_head.url = value.helfUrl;
				_nameLable.text = value.targetName;
				_nameLable.x = 220;
				TweenLite.to(_head, 0.5, {alpha:1});
				TweenLite.to(_head2, 0.5, {alpha:0});
				addWords(value.describe);
			}
			else
			{
				_head2.url = value.helfUrl;
				_nameLable.text = value.targetName;
				_nameLable.x = 600;
				TweenLite.to(_head, 0.5, {alpha:0});
				TweenLite.to(_head2, 0.5, {alpha:1});
				addWords(value.describe);
			}
			this.show();
			layout();
		}

		override protected function layout() : void
		{
			GLayout.layout(this);
			if (_back)
				_back.x = (this.width - UIManager.stage.stageWidth) / 2;
		}

		override public function hide() : void
		{
			super.hide();
			if (_trigon)
				_trigon.stop();
		}

		override public function show() : void
		{
			super.show();
			layout();
			if (_trigon)
				_trigon.gotoAndPlay(0);
		}
	}
}
