package game.core.menu {
	import game.manager.DailyInfoManager;
	import game.manager.ViewManager;
	import game.module.rewardPackage.GiftPackageManage;

	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.layout.GLayout;

	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;



	/**
	 * @author yangyiqiang
	 *  显示在TOP的活动菜单
	 */
	public class TopMenu extends GComponent
	{
		public function TopMenu()
		{
			_base = new GComponentData();
			_base.width = 490;
			_base.height = 200;
			_base.align = new GAlign(-1, 190, 5);
			_base.parent = ViewManager.instance.uiContainer;
			super(_base);
			this.mouseEnabled = false;
			_list = new Vector.<MenuButton>();
			_showList = new Vector.<MenuButton>();
		}

		private var _list : Vector.<MenuButton>;

		private var _showList : Vector.<MenuButton>;

		private var  _startX : int;

		private const MAX : int = 7;

		public function refresh() : void
		{
			removeAll();
			for each (var button:MenuButton in _list)
			{
				if (!MenuManager.getInstance().checkButton(button)) continue;
				if (_showList.indexOf(button) >= 0) continue;
				if(button.vo.id==MenuType.GIFTALL&&GiftPackageManage.instance.getGifNum()<=0)continue;
				if(button.vo.id==MenuType.ONLINE_GIFT&&!GiftPackageManage.instance.showOnlineGift)continue;
				_showList.push(button);
			}
			_showList.sort(MenuManager.getInstance().sortFun);
			for (var i : int = 0;i < _showList.length;i++)
			{
				if (i % MAX == 0) _startX = this.width - 60;
				_showList[i].x = -60 * (i % MAX) + _startX;
				_showList[i].y = int(i / MAX) * 60;
				addChild(_showList[i]);
			}
		}
		
		private function removeAll():void
		{
			for each (var button:MenuButton in _showList)
			{
				if(button.parent)button.parent.removeChild(button);
			}
			_showList=new Vector.<MenuButton>;
		}

		private var _actionList : Vector.<MenuButton>=new Vector.<MenuButton>();

		public function refreshToAction() : Boolean
		{
			_actionList =new Vector.<MenuButton>();
			for each (var button:MenuButton in _list)
			{
				if (!MenuManager.getInstance().checkButton(button)) continue;
				if (_showList.indexOf(button) >= 0 || _actionList.indexOf(button) >= 0) continue;
				if(button.vo.id==MenuType.GIFTALL)continue;
				if(button.vo.id==MenuType.ONLINE_GIFT)continue;
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
				return;
			}
			_showList.push(button);
			_showList.sort(MenuManager.getInstance().sortFun);
			_index = _showList.indexOf(button);
			_startX = this.width - 60;
			button.x = -60 * (_index % MAX) + _startX;
			button.y = int(_index / MAX) * 60;
			if(button.vo.id==MenuType.DAILY){
				DailyInfoManager.instance.requestDaily();
			}
			
			MenuOpenAction.instance.showFlash(button.vo, this.x + button.x, this.y + button.y, playNextStep, onEnd, this);
		}

		private function playNextStep() : void
		{
			for (var i : int = 0;i < _showList.length;i++)
			{
				if (i == _index) continue;
				if(_showList[_index].y!=_showList[i].y)continue;
				if (i < _index)
				{
					if (i % MAX == 0) _startX = this.width - 60;
					TweenLite.to(_showList[i], 0.8, {x:_startX - 60 * (i % MAX) + 60, ease:Quint.easeOut, overwrite:0});
				}
				else
				{
					TweenLite.to(_showList[i], 0.8, {x:_startX - 60 * (i % MAX)-60, ease:Quint.easeOut, overwrite:0});
				}
			}
		}

		private function onEnd() : void
		{
			_showList.sort(MenuManager.getInstance().sortFun);
			for (var i : int = 0;i < _showList.length;i++)
			{
				if (i == _index) continue;
				if (i % MAX == 0) _startX = this.width - 60;
				TweenLite.to(_showList[i], 0.8, {x:_startX - 60 * (i % MAX), y:int(i / MAX) * 60, ease:Quint.easeOut, overwrite:0});
				addChild(_showList[i]);
			}
			playComplete();
		}

		private function playComplete() : void
		{
			_showList[_index].alpha = 0.3;
			addChild(_showList[_index]);
			TweenLite.to(_showList[_index], 0.5, {alpha:1, overwrite:0, onComplete:execute, onCompleteParams:[_actionList.pop()]});
		}

		public function add(value : GComponent) : void
		{
			_list.push(value);
		}

		override protected function onShow() : void
		{
			super.onShow();
			GLayout.layout(this);
		}
		
		override protected function onHide():void
		{
			super.onHide();
		}
	}
}
