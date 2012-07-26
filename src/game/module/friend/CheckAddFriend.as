package game.module.friend
{
	import com.utils.RegExpUtils;

	import game.core.user.StateManager;
	import game.core.user.UserData;

	/**
	 * @author ME
	 */
	public class CheckAddFriend
	{
		// 搜索添加好友 检查
		public static function check(playerName : String) : Boolean
		{
			var result : Boolean = true;
			if (ModelFriend.instance.friendCount == ModelFriend.instance.friendMax)
			{
				StateManager.instance.checkMsg(66);
				result = false;
			}
			else if (playerName == "")
			{
				StateManager.instance.checkMsg(67);
				result = false;
			}
			else if (RegExpUtils.checkStr(playerName) == true)
			{
				StateManager.instance.checkMsg(147);
				result = false;
			}
			else if (playerName == UserData.instance.myHero.name)
			{
				StateManager.instance.checkMsg(305);
				result = false;
			}
			else if (ManagerFriend.getInstance().isInFriendListByPlayerName(playerName))
			{
				StateManager.instance.checkMsg(307);
				result = false;
			}
			else if (ManagerFriend.getInstance().isInBackListByPlayerName(playerName))
			{
				StateManager.instance.checkMsg(309);
				result = false;
			}
			return result;
		}

		// Tips或者私聊面板添加好友 检查
		public static function addFriendCheck(playerName : String) : Boolean
		{
			var result : Boolean = true;
			if (ModelFriend.instance.friendCount == ModelFriend.instance.friendMax)
			{
				StateManager.instance.checkMsg(66);
				result = false;
			}
			else if (ManagerFriend.getInstance().isInFriendListByPlayerName(playerName))
			{
				StateManager.instance.checkMsg(307);
				result = false;
			}
			else if (ManagerFriend.getInstance().isInBackListByPlayerName(playerName))
			{
				StateManager.instance.checkMsg(309);
				result = false;
			}
			return result;
		}
	}
}
