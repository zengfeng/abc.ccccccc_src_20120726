package game.module.friend
{
	import com.commUI.PhotoItem;
	import com.utils.PotentialColorUtils;
	import com.utils.UrlUtils;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.core.user.UserData;
	import game.manager.ViewManager;
	import game.module.friend.view.FriendItem;
	import game.module.friend.view.FriendSearchView;
	import game.module.friend.view.FriendView;
	import game.net.core.Common;
	import game.net.data.CtoC.CCVIPLevelChange;
	import gameui.controls.GButton;




	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-10  ����11:04:15 
	 */
	public class ControllerFriendView extends EventDispatcher
	{
		private var CtoS : ProtoCtoSFriend = ProtoCtoSFriend.instance;

		/** 用户数据信息 */
		private function get userData() : UserData
		{
			return UserData.instance;
		}

		public var view : FriendView;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 添加知已按钮 */
		public var searchFriendButton : GButton;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 自己信息区块 -- 头像 */
		private var selfHeadPhoto : PhotoItem;
		/** 自己信息区块 -- 名称 */
		private var selfPlayerNameLabel : TextField;
		/** 自己信息区块 -- 知己数量 */
		private var selfFriendNumLabel : TextField;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public var modelFriend : ModelFriend = ModelFriend.instance;

		public function ControllerFriendView(view : FriendView)
		{
			// 第一次请求好友列表
			CtoS.cs_ShowContext();
			this.view = view;
			super(view);
			initView();
			initEvents();
		}

		/** 初始化视图 */
		private function initView() : void
		{
			searchFriendButton = view.searchFriendButton;
			selfHeadPhoto = view.selfHeadPhoto;
			selfPlayerNameLabel = view.selfPlayerNameLabel;
			selfFriendNumLabel = view.selfFriendNumLabel;

			// 设置值,自己信息区块 -- 名称
			selfPlayerNameLabel_setValue();
			// 设置值,自己信息区块 -- 知己数量
			selfFriendNumLabel_setValue();

			lastlinkPanel_update();
			blacklistPanel_update();
		}

		/** 设置值,自己信息区块 -- 名称 */
		private function selfPlayerNameLabel_setValue() : void
		{
			selfPlayerNameLabel.text = userData.playerName;
			if (userData.myHero)
			{
				selfPlayerNameLabel.textColor = PotentialColorUtils.getColor(userData.myHero.potential);
				selfHeadPhoto.url = UrlUtils.getHeroHeadPhoto(userData.myHero.id);
			}
		}

		/** 设置值,自己信息区块 -- 知己数量 */
		private function selfFriendNumLabel_setValue(event : EventFriend = null) : void
		{
			var str : String = "好友 `Count`/`Max`";
			str = str.replace(/`Count`/, modelFriend.friendCount);
			str = str.replace(/`Max`/, modelFriend.friendMax);
			selfFriendNumLabel.text = str;
		}

		/** 最近联系人更新 */
		public function lastlinkPanel_update(event : EventFriend = null) : void
		{
			view.lastlinkPanel_update();
		}

		/** 黑名单更新 */
		public function blacklistPanel_update(event : EventFriend = null) : void
		{
			view.blacklistPanel_update();
		}

		/** 初始化事件 */
		private function initEvents() : void
		{
			// 添加知已按钮点击事件
			searchFriendButton.addEventListener(MouseEvent.CLICK, searchFriendButton_clickHandler);
			// 添加选中好友事件
			view.addEventListener(EventFriend.SELECTED_FRIEND, onSelectedFriend);

			// 数据模型 -- 好友数量发生改变
			modelFriend.addEventListener(EventFriend.FRIEND_COUNT_CHANGE, selfFriendNumLabel_setValue);
			// 数据模型 -- 在线好友数量发生改变
			modelFriend.addEventListener(EventFriend.ONLINE_FRIEND_COUNT_CHANGE, onlineFriendCount_changeHandler);
			// 数据模型 -- 更新最近联系人列表
			modelFriend.addEventListener(EventFriend.UPDATE_LAST_LINK, lastlinkPanel_update);
			// 数据模型 -- 移出黑名单事件
			modelFriend.addEventListener(EventFriend.MOUVE_OUT_BACKLIST, blacklistPanel_update);
			// 数据模型 -- 移入黑名单事件
			modelFriend.addEventListener(EventFriend.MOUVE_IN_BACKLIST, blacklistPanel_update);
			// 数据模型 -- 好友数据更新事件
			modelFriend.addEventListener(EventFriend.UPDATE_FRIEND, lastlinkPanel_update);
			// 数据模型 -- 加为好友事件
			modelFriend.addEventListener(EventFriend.ADD_FRIEND, lastlinkPanel_update);
			// 数据模型 -- 删除好友事件
			modelFriend.addEventListener(EventFriend.Remove_FRIEND, lastlinkPanel_update);
			
			
			// CC协议监听[0xFFF7] VIP等级改变
			Common.game_server.addCallback(0xFFF7, cc_VIPLevelChange);
		}
		
		private var selectedFirendItem:FriendItem;
		private function onSelectedFriend(event : EventFriend) : void
		{
			var firendItem:FriendItem = event.target as FriendItem;
			if(selectedFirendItem == firendItem) return;
			if(selectedFirendItem) selectedFirendItem.isSelected = false;
			firendItem.isSelected = true;
			selectedFirendItem = firendItem;
		}

		/** CC协议监听[0xFFF7] VIP等级改变 */
		private function cc_VIPLevelChange(msg : CCVIPLevelChange) : void
		{
			selfFriendNumLabel_setValue();
		}

		/** 数据模型 -- 在线好友数量发生改变 */
		private function onlineFriendCount_changeHandler(event : EventFriend) : void
		{
			// view.firendTabButton.htmlText = modelFriend.onlineFriendCount.toString();
		}

		/** 添加知已按钮点击事件 */
		private function searchFriendButton_clickHandler(event : MouseEvent) : void
		{
			var friendSearchView : FriendSearchView = ViewManager.instance.uiContainer.getChildByName(FriendSearchView.NAME) as FriendSearchView;
			if (friendSearchView == null)
			{
				friendSearchView = new FriendSearchView();
			}

			if (friendSearchView.parent)
			{
				friendSearchView.hide();
			}
			else
			{
				friendSearchView.show();
			}
		}
	}
}
