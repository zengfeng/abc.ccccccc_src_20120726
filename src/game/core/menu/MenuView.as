package game.core.menu
{
	import game.core.hero.VoHero;
	import game.core.user.UserData;
	import game.manager.ViewManager;
	import game.module.quest.guide.GuideMange;
	import game.net.core.Common;
	import game.net.data.StoC.SCPlayerInfoChange2;

	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.RESManager;

	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;

	import flash.display.MovieClip;

	/**
	 * @author yangyiqiang
	 */
	public final class MenuView extends GComponent
	{
		public static const MAX : int = 13;

		private var _bg : MovieClip;

		private var _progess : ExpProgressBar;

		private var _content : GComponent;

		private var _list : Vector.<MenuButton>;

		private var _showList : Vector.<MenuButton>;

		private var _actionList : Vector.<MenuButton>=new Vector.<MenuButton>();

		public function MenuView()
		{
			_base = new GComponentData();
			_base.width = 645;
			_base.height = 70;
			_base.parent = ViewManager.instance.uiContainer;
			super(_base);
			_list = new Vector.<MenuButton>();
			_showList = new Vector.<MenuButton>();
			initView();
			initEvent();
		}

		public function add(value : GComponent) : void
		{
			_list.push(value);
		}

		private var  _startX : int;

		public function refresh() : void
		{
			clear();
			for each (var button:MenuButton in _list)
			{
				if (!MenuManager.getInstance().checkButton(button)) continue;
				button.isShowIng=true;
				_showList.push(button);
			}
			_showList.sort(MenuManager.getInstance().sortFun);
			_startX = (MAX - _showList.length) * 50;
			for (var i : int = 0;i < _showList.length;i++)
			{
				_showList[i].x = 50 * i + _startX;
				_content.addChild(_showList[i]);
			}
		}

		private function clear() : void
		{
			for (var i : int = 0;i < _showList.length;i++)
			{
				if(_showList[i]&&_showList[i].parent)_showList[i].parent.removeChild(_showList[i]);
			}
			_showList = new Vector.<MenuButton>();
		}

		public function refreshList(list : Array) : void
		{
			if (!list)
			{
				refresh();
				return;
			}
			clear();
			for each (var button:MenuButton in _list)
			{
				if (list.indexOf(button.vo.id) < 0 || !MenuManager.getInstance().checkButton(button)) continue;
				button.isShowIng=true;
				_showList.push(button);
			}
			_showList.sort(MenuManager.getInstance().sortFun);
			_startX = (MAX - _showList.length) * 50;
			for (var i : int = 0;i < _showList.length;i++)
			{
				_showList[i].x = 50 * i + _startX;
				_content.addChild(_showList[i]);
			}
		}

		public function refreshToAction() : Boolean
		{
			for each (var button:MenuButton in _list)
			{
				if (!MenuManager.getInstance().checkButton(button)) continue;
				if (_showList.indexOf(button) >= 0 || _actionList.indexOf(button) >= 0) continue;
				if(button.isShowIng)continue;
				_actionList.push(button);
			}
			if (_actionList.length == 0) return false;
			execute(_actionList.pop());
			return true;
		}

		private var _index : int;

		private function execute(button : MenuButton) : void
		{
			if (!button)
			{
				// QuestDisplayManager.getInstance().showWait();
				return;
			}
			_showList.push(button);
			_showList.sort(MenuManager.getInstance().sortFun);
			_index = _showList.indexOf(button);
			_startX = (MAX - _showList.length) * 50;
			button.x = 50 * _index + _startX;
			MenuOpenAction.instance.showFlash(button.vo, this.x + button.x, this.y + button.y, playNextStep, onEnd, this);
		}

		private function playNextStep() : void
		{
			for (var i : int = 0;i < _showList.length;i++)
			{
				if (i == _index) continue;
				if (i < _index)
				{
					TweenLite.to(_showList[i], 0.8, {x:50 * i + _startX - 50, ease:Quint.easeOut, overwrite:0});
				}
				else
				{
					TweenLite.to(_showList[i], 0.8, {x:50 * i + _startX + 50, ease:Quint.easeOut, overwrite:0});
				}
			}
		}

		private function onEnd() : void
		{
			_showList.sort(MenuManager.getInstance().sortFun);
			for (var i : int = 0;i < _showList.length;i++)
			{
				if (i == _index) continue;
				TweenLite.to(_showList[i], 0.8, {x:50 * i + _startX, ease:Quint.easeOut, overwrite:0});
				_content.addChild(_showList[i]);
			}
			playComplete();
		}

		private function playComplete() : void
		{
			_showList[_index].alpha = 0.3;
			_content.addChild(_showList[_index]);
			TweenLite.to(_showList[_index], 0.5, {alpha:1, overwrite:0, onComplete:execute, onCompleteParams:[_actionList.pop()]});
			GuideMange.getInstance().resetAndCheckGuide(_showList[_index].vo.id);
		}

		// private var _action : MenuOpenAction=MenuOpenAction.instance;
		private function initView() : void
		{
			this.name = "MenuView";
			x = UIManager.stage.stageWidth - _base.width;
			y = UIManager.stage.stageHeight - _base.height;
			var base : GComponentData = new GComponentData();
			base.align = new GAlign(-1, 0);
			_content = new GComponent(base);
			addChild(_content);
			_bg = RESManager.getMC(new AssetData("menuBackground"));
			_bg.y = 33;
			_content.addChild(_bg);
			_progess = new ExpProgressBar();
			_progess.x = 5;
			_progess.y = 63;
			addChild(_progess);

			var myHero : VoHero = UserData.instance.myHero;

			if (myHero)
			{
				_progess.value = myHero.exp / myHero.upgradeExp * 100;
				_progess.toolTip.source = "经验：" + myHero.exp + "/" + myHero.upgradeExp;
			}
		}

		private function heroInfoChange(msg : SCPlayerInfoChange2) : void
		{
			if (!msg.hasLevel && !msg.hasExp) return;
			var myHero : VoHero = UserData.instance.myHero;
			var exp : int = myHero.exp / myHero.upgradeExp * 100;
			if (msg.hasLevel) _progess.value = 0;
			TweenLite.to(_progess, 1, {value:exp, ease:Sine.easeInOut, overwrite:0});
			_progess.toolTip.source = "经验：" + myHero.exp + "/" + myHero.upgradeExp;
		}

		private function initEvent() : void
		{
			Common.game_server.addCallback(0x1f, heroInfoChange);
		}
	}
}
