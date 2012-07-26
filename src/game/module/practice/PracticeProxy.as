package game.module.practice {
	import worlds.apis.MSelfPlayer;
	import worlds.apis.MTo;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.net.core.Common;
	import game.net.data.CtoS.CSTrainStart;
	import game.net.data.StoC.SCItemTrain;
	import game.net.data.StoC.SCTrainInfo;

	import worlds.apis.MValidator;

	/**
	 * @author yangyiqiang
	 */
	public class PracticeProxy
	{
		private var _view : PracticeView;
		private static var _instance : PracticeProxy;

		public function PracticeProxy()
		{
			if (_instance)
			{
				throw Error("PracticeProxy 是单类，不能多次初始化!");
			}
			Common.game_server.addCallback(0x2C, heroPractice);
			Common.game_server.addCallback(0x2D, practiceInfo);
		}

		public static function getInstance() : PracticeProxy
		{
			if (_instance == null)
			{
				_instance = new PracticeProxy();
			}
			return _instance;
		}

		public function getView() : PracticeView
		{
			if (!_view)
			{
				if (MenuManager.getInstance().getMenuButton(MenuType.PRACTICE) && MenuManager.getInstance().getMenuButton(MenuType.PRACTICE).target)
				{
					_view = MenuManager.getInstance().getMenuButton(MenuType.PRACTICE).target as PracticeView;
				}
				else
				{
					_view = new PracticeView();
					MenuManager.getInstance().getMenuButton(MenuType.PRACTICE).target = _view;
				}
			}
			return _view;
		}

		public function sendCmd(type : int = 2) : void
		{
			if (type != 0)
			{
				var result : Boolean = MValidator.joinOtherActivity.doValidation(sendCmd, [type]);
				if (result == false) return;
			}
			MTo.clear();
			MSelfPlayer.setClanName("");
			var cmd : CSTrainStart = new CSTrainStart();
			cmd.action = type;
			Common.game_server.sendMessage(0x2D, cmd);
		}

		private function heroPractice(msg : SCItemTrain) : void
		{
		}

		private function practiceInfo(msg : SCTrainInfo) : void
		{
			if (msg.type == 0)
			{
				getView().hideOnly();
			}
			else
			{
				if (!getView().parent)
					getView().showOnly();
			}
		}

//		private var validator : Validator;
//
//		private function doValidator(v : Validator) : Boolean
//		{
//			validator = v;
//			sendCmd(0);
//			return true;
//		}
//
//		/** 请求英雄闭关 */
//		public function sendPractice(type : int = 0, heroID : int = -1, num : int = 1) : void
//		{
//			var cmd : CSItemTrain = new CSItemTrain();
//			cmd.type = type;
//			cmd.hero = heroID;
//			cmd.count = num;
//			Common.game_server.sendMessage(0x2C, cmd);
//		}
	}
}
