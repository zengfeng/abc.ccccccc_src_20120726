package game.module.bossWar
{
	import game.manager.ViewManager;
	/**
	 * @author Lv
	 */
	public class BossWarSystem
	{
		private static var _isJoin : Boolean = false;

		public static function get isJoin() : Boolean
		{
			return _isJoin;
		}

		public static function set isJoin(value : Boolean) : void
		{
			_isJoin = value;
			if (_isJoin)
				ViewManager.otherPlayerPanel.hide();
		}
	}
}
