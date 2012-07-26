package game.module.friend
{
	import game.net.core.Common;
	import game.net.data.StoC.ContactPlayer;
	import game.net.data.StoC.SCContactInfoChange;
	import game.net.data.StoC.SCContactList;
	import game.net.data.StoC.SCListRecent;
	import game.net.data.StoC.SCRecentContact;
	import game.net.data.StoC.SCRecentOnline;
	import game.net.data.StoC.SCRemoveContact;
	import game.net.data.StoC.SCShowContact;
	import game.net.data.StoC.SCShowContactMore;

	import com.utils.PotentialColorUtils;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;



	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-9  ����3:49:12 
	 * 协议(服务器至客户端) -- 好友
	 */
	public class ProtoStoCFriend extends EventDispatcher
	{
		/** 单例对像 */
		private static var _instance : ProtoStoCFriend;
		private static var modelFriend : ModelFriend = ModelFriend.instance;
		private static var protoCtoSFriend : ProtoCtoSFriend = ProtoCtoSFriend.instance;

		public function ProtoStoCFriend(target : IEventDispatcher = null)
		{
			super(target);
			// 协议监听
			sToC();
		}

		/** 获取单例对像 */
		static public function get instance() : ProtoStoCFriend
		{
			if (_instance == null)
			{
				_instance = new ProtoStoCFriend();
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 协议监听 */
		private function sToC() : void
		{
			// 协议监听 -- 黑名单列表
			//Common.game_server.addCallback(0x54, sc_ListBlock);
			// 协议监听 -- 最近联系人列表
			Common.game_server.addCallback(0x55, sc_ListRecent);
			// 协议监听 -- 好友列表
			Common.game_server.addCallback(0x40, sc_ShowContact);
			// 协议监听 -- 添加联系人
			Common.game_server.addCallback(0x41, sc_listContact);
			// 协议监听 -- 联系人信息改变
			Common.game_server.addCallback(0x42, sc_contactInfoChange);
			// 协议监听 -- 删除联系人
			Common.game_server.addCallback(0x43, sc_removeContace);
			// 协议监听 -- 新增好友组
			//Common.game_server.addCallback(0x41, sc_AddFriendGrp);
			// 协议监听 -- 删除好友组
			//Common.game_server.addCallback(0x42, sc_DelFriendGrp);
			// 协议监听 -- 修改好友组名
			//Common.game_server.addCallback(0x43, sc_ChgGroupName);
			// 协议监听 -- 通过名字添加好友
			//Common.game_server.addCallback(0x44, sc_FollowName);
			// 协议监听 -- 通过id批量添加好友
			//Common.game_server.addCallback(0x45, sc_FollowId);
			// 协议监听 -- 通过id删除知己
			//Common.game_server.addCallback(0x46, sc_Unfollow);
			// 协议监听 -- 修改好友的组别
			//Common.game_server.addCallback(0x47, sc_ChgFollowGrp);
			// 协议监听 -- 通过名字添加 黑名单
			//Common.game_server.addCallback(0x48, sc_Block);
			// 协议监听 -- 通过id移出 黑名单
			//Common.game_server.addCallback(0x4A, sc_Unblock);
			//			//  协议监听 -- 新加粉丝列表
			// Common.game_server.addCallback(0x4B, sc_FansIncome);
			// 协议监听 -- 除了第一次打开社交面板，传递在线的block和最近联系人
			Common.game_server.addCallback(0x4C, sc_ShowContactMore);
			// 协议监听 -- 客户端请求某其他玩家信息
			Common.game_server.addCallback(0x4D, sc_RecentContact);
			// 协议监听 -- 请求最近联系人在线状况
			Common.game_server.addCallback(0x4F, sc_RecentOnline);

			//			//  协议监听 -- 被添加好友
			// Common.game_server.addCallback(0x50, sc_Followed);
			// 协议监听 -- 被删除好友
			//Common.game_server.addCallback(0x51, sc_UnFollowed);
			// 协议监听 -- 被添加 黑名单
			//Common.game_server.addCallback(0x52, sc_Blocked);
			// 协议监听 -- 好友上线/下线
//			Common.game_server.addCallback(0x53, sc_FollowOnline);

			//			//  协议监听 -- 好友申请列表数据  look  game.module.notification.NotificationProxy.as
			// Common.game_server.addCallback(0x5D, sc_FriendApllyList);
		}
		private function sc_removeContace( msg:SCRemoveContact ) : void {
			var voFriendItem:VoFriendItem = modelFriend.friendDic[msg.player] as VoFriendItem;
			if( voFriendItem != null )
			{
				if( voFriendItem.type == VoFriendItem.TYPE_BACKLIST )
					modelFriend.moveOutBacklist(voFriendItem);
				else if( voFriendItem.type == VoFriendItem.TYPE_BOTH )
				{
					voFriendItem.type = VoFriendItem.TYPE_SHE_ADD_ME ;
					modelFriend.updateFriend(voFriendItem);
					modelFriend.groupRemoveFriend(voFriendItem);
				}
				else if( voFriendItem.type == VoFriendItem.TYPE_I_ADD_SHE )
				{
					modelFriend.removeFriend(voFriendItem);
				}
				else {
					voFriendItem.type = VoFriendItem.TYPE_STRANGER ;
					modelFriend.updateFriend(voFriendItem);
				}
				
				return ;
			}
			
			modelFriend.moveOutBacklistById(msg.player);
			
		}
		private function sc_contactInfoChange(msg:SCContactInfoChange) : void {
			
			var vo:VoFriendItem ;

			if( msg.hasRelation )
			{
				if( msg.relation == 3 )
				{
					vo = modelFriend.friendDic[msg.id] as VoFriendItem;
					if( vo != null )
					{
						vo.type = VoFriendItem.TYPE_BACKLIST ;
						modelFriend.moveInBacklist(vo);
					}
					return ;
				}
				else if( msg.relation == 0 )
				{
					modelFriend.moveOutBacklist(vo);
					return ;
				}
				else{
					vo = modelFriend.moveOutBacklist(vo);
					if( vo != null )
					{
						if( msg.relation == 1 )
						{
							vo.type = VoFriendItem.TYPE_BOTH;
						}
						else
						{
							vo.type = VoFriendItem.TYPE_I_ADD_SHE ;
						}
						modelFriend.addFriend(vo);
					}
				}
			}
			vo = modelFriend.friendDic[msg.id] as VoFriendItem ;
			if( vo != null )
			{
				if( msg.hasIsOnline )
				{
					var vogrp:VoFriendGroup = vo.group ;
					if( vogrp != null ){
						if( msg.isOnline == false && vo.isOnline == true )
						{
							vogrp.childOnline(false);
						}
						else if( msg.isOnline == true && vo.isOnline == false )
						{
							vogrp.childOnline(true);
						}
					}
					vo.isOnline = msg.isOnline ;
				}
				if( msg.hasLevel )
					vo.level = msg.level ;
				if( msg.hasPotential )
					vo.colorPropertyValue = PotentialColorUtils.getColorLevel(msg.potential) ;
				if( msg.hasGroup )
				{
					var grp:VoFriendGroup = modelFriend.friendGroupDic[vo.groupId];
					if( grp != null ){
						modelFriend.groupRemoveFriend2(grp, vo);
						grp = modelFriend.friendGroupDic[msg.group];
						modelFriend.groupAddFriend2(grp, vo);
						vo.groupId = msg.group ;
						vo.group = grp ;
					}
				}
				if( msg.hasServerId )
				{
					vo.serverId = msg.serverId ;
				}
				modelFriend.updateFriend(vo);
			}
		}
		private function sc_listContact(msg:SCContactList) : void {
			for each( var item:ContactPlayer in msg.playerList )
			{
				var vo:VoFriendItem = modelFriend.friendDicByName[item.id] as VoFriendItem;
				if( vo == null )
				{
					vo = new VoFriendItem() ;
					vo.id = item.id ;
					vo.name = item.name ;
					vo.isMale = item.isMale;
					vo.job = item.job * 2 - ( item.isMale ? 1 : 0 ) ;
					vo.isOnline = item.isOnline;
					vo.level = item.level;
					vo.colorPropertyValue = PotentialColorUtils.getColorLevel(item.potential);
					vo.serverId = item.serverId;
					vo.groupId = item.group ;
					vo.group = modelFriend.friendGroupDic[vo.groupId];
					if( item.relation == 1 )
					{
						vo.type = VoFriendItem.TYPE_BOTH ;
						modelFriend.addFriend(vo);
					}
					else if( item.relation == 2 )
					{
						vo.type = VoFriendItem.TYPE_I_ADD_SHE ;
						modelFriend.addFriend(vo);
						
					}
					else if( item.relation == 3 )
					{
						vo.type = VoFriendItem.TYPE_BACKLIST ;
						modelFriend.moveInBacklist(vo);
					}

				}
			}
		}
		

//		/** 协议监听 -- 好友上线/下线 */
//		private function sc_FollowOnline(message : SCFollowOnline) : void
//		{
//			var voFriendItem : VoFriendItem;
//			voFriendItem = modelFriend.friendDicByName[message.playerName] as VoFriendItem;
//			if (voFriendItem)
//			{
//				voFriendItem.isOnline = message.isOnline;
//				voFriendItem.id = message.playerId;
//				modelFriend.updateFriend(voFriendItem);
//
//				// 不显示好友上下线了 -_-  (ControllerChat)
//				// SignalBusManager.sendToChatFriendIsOnline.dispatch(voFriendItem.name, voFriendItem.id, voFriendItem.colorPropertyValue, voFriendItem.isOnline);
//			}
//		}

//		/** 协议监听 -- 被添加黑名单 */
//		private function sc_Blocked(message : SCBlocked) : void
//		{
//			var voFriendItem : VoFriendItem;
//			voFriendItem = modelFriend.friendDic[message.player] as VoFriendItem;
//			if (voFriendItem)
//			{
//				if (ModelFriend.instance.isInFriendListByPlayerId(message.player))
//				{
//					voFriendItem.type = VoFriendItem.TYPE_I_ADD_SHE;
//					modelFriend.updateFriend(voFriendItem);
//				}
//				else
//				{
//					voFriendItem.type = VoFriendItem.TYPE_STRANGER;
//					modelFriend.updateFriend(voFriendItem);
//				}
//			}
//		}
//
//		/** 协议监听 -- 被删除好友 */
//		private function sc_UnFollowed(message : SCUnFollowed) : void
//		{
//			var voFriendItem : VoFriendItem;
//			voFriendItem = modelFriend.friendDic[message.player] as VoFriendItem;
//			if (voFriendItem)
//			{
//				if (ModelFriend.instance.isInFriendListByPlayerId(message.player))
//				{
//					voFriendItem.type = VoFriendItem.TYPE_I_ADD_SHE;
//					modelFriend.updateFriend(voFriendItem);
//				}
//				else
//				{
//					voFriendItem.type = VoFriendItem.TYPE_STRANGER;
//					modelFriend.updateFriend(voFriendItem);
//				}
//			}
//		}
//
//		/** 协议监听 -- 被添加好友 */
//		private function sc_Followed(message : SCFollowed) : void
//		{
//			var voFriendItem : VoFriendItem = new VoFriendItem();
//			voFriendItem.id = message.id;
//			voFriendItem.name = message.name;
//			voFriendItem.isMale = message.isMale;
//			voFriendItem.isOnline = message.isOnline;
//			voFriendItem.level = message.level;
//			voFriendItem.colorPropertyValue = message.potential;
//			voFriendItem.serverId = message.serverId;
//			voFriendItem.type = message.isFollow ? VoFriendItem.TYPE_I_ADD_SHE : VoFriendItem.TYPE_BOTH;
//			modelFriend.addFriendApply(voFriendItem);
//		}
//
//		/** 协议监听 -- 好友申请列表数据 **/
//		private function sc_FriendApllyList(message : SCListContactNotification) : void
//		{
//			for (var i : int = 0; i < message.items.length; i++)
//			{
//				var voFriendItem : VoFriendItem = new VoFriendItem();
//				voFriendItem.id = message.items[i].id;
//				voFriendItem.name = message.items[i].name;
//				voFriendItem.job = message.items[i].job & 0xf;
//				voFriendItem.isMale = (message.items[i].job & 0xf) % 2 ? true : false;
//				voFriendItem.level = message.items[i].level;
//				voFriendItem.colorPropertyValue = message.items[i].job >> 4;
//				modelFriend.addFriendApply(voFriendItem);
//			}
//		}

		/** 协议监听 -- 客户端请求某其他玩家信息 */
		private function sc_RecentContact(message : SCRecentContact) : void
		{
			var voFriendItem : VoFriendItem;
			voFriendItem = modelFriend.friendDicByName[message.name] as VoFriendItem;
			if (voFriendItem)
			{
				voFriendItem.id = message.id;
				voFriendItem.name = message.name;
				voFriendItem.isMale = message.isMale;
				voFriendItem.isOnline = message.isOnline;
				voFriendItem.level = message.level;
				voFriendItem.colorPropertyValue = message.potential;
				voFriendItem.job = message.job;
				voFriendItem.serverId = message.serverId;
				modelFriend.updateFriend(voFriendItem);
			}
		}

		/** 协议监听 -- 客户端请求某其他玩家信息 */
		private function sc_RecentOnline(message : SCRecentOnline) : void
		{
			var ids : Vector.<uint> = message.players;

			var voFriendItem : VoFriendItem;
			var lastLinkData : Vector.<VoFriendItem> = modelFriend.lastLinkData;
			// 最近联系人列表
			for (var i : int = 0; i < lastLinkData.length; i++)
			{
				voFriendItem = lastLinkData[i];
				if (ids.indexOf(voFriendItem.id) != -1)
				{
					voFriendItem.isOnline = true;
				}
				else
				{
					voFriendItem.isOnline = false;
				}

				modelFriend.updateFriend(voFriendItem);
			}
		}

//		/** 协议监听 -- 新加粉丝列表 */
//		private function sc_FansIncome(message : SCFansIncome) : void
//		{
//			var voFriendItem : VoFriendItem;
//			for (var i : int = 0; i < message.playerList.length; i++)
//			{
//				var contactPlayer : ContactPlayer = message.playerList[i];
//				voFriendItem = new VoFriendItem();
//				voFriendItem.mirrorValueByContactPlayer(contactPlayer);
//				modelFriend.addFriendApply(voFriendItem);
//			}
//		}

		/** 协议监听 -- 除了第一次打开社交面板，传递在线的block和最近联系人 */
		private function sc_ShowContactMore(message : SCShowContactMore) : void
		{
			var i : int;
			var playerId : int;
			var voFriendItem : VoFriendItem;
			// 在线黑名单玩家ID列表
			for (i = 0; i < message.blockOnline.length; i++)
			{
				playerId = message.blockOnline[i];
				voFriendItem = modelFriend.friendDic[playerId] as VoFriendItem;
				if (voFriendItem)
				{
					voFriendItem.isOnline = true;
					modelFriend.updateFriend(voFriendItem);
				}
			}

			// 在线的最近联系人ID列表
			for (i = 0; i < message.recentOnline.length; i++)
			{
				playerId = message.recentOnline[i];
				voFriendItem = modelFriend.friendDic[playerId] as VoFriendItem;
				if (voFriendItem)
				{
					voFriendItem.isOnline = true;
					modelFriend.updateFriend(voFriendItem);
				}
			}
		}

//		/** 协议监听 -- 通过id移出黑名单 */
//		private function sc_Unblock(message : SCUnblock) : void
//		{
//			modelFriend.moveOutBacklistById(message.blockId);
//		}
//
//		/** 协议监听 -- 通过名字添加黑名单 */
//		private function sc_Block(message : SCBlock) : void
//		{
//			var voFriendItem : VoFriendItem;
//			voFriendItem = modelFriend.friendDicByName[message.name] as VoFriendItem;
//			if (voFriendItem)
//			{
//				modelFriend.moveInBacklist(voFriendItem);
//			}
//			else
//			{
//				voFriendItem = new VoFriendItem();
//				voFriendItem.id = message.id;
//				voFriendItem.name = message.name;
//				voFriendItem.isMale = message.isMale;
//				voFriendItem.isOnline = message.isOnline;
//				voFriendItem.level = message.level;
//				voFriendItem.colorPropertyValue = message.potential;
//				voFriendItem.job = message.job;
//				voFriendItem.serverId = message.serverId;
//				voFriendItem.groupId = -1;
//				voFriendItem.group = null;
//				modelFriend.moveInBacklist(voFriendItem);
//			}
//		}

		/** 协议监听 --  好友列表 */
		private function sc_ShowContact(message : SCShowContact) : void
		{
			var i : int = 0;
			var voFriendGroup : VoFriendGroup;
			var voFriendItem : VoFriendItem;
			var playerId : uint;
			// 组列表
			// modelFriend.friendGroupDic = new Dictionary();
			// modelFriend.friendListData = new Vector.<VoFriendGroup>();

			// 创建默认好友组(我的好友)
			voFriendGroup = modelFriend.friendGroupDic[modelFriend.DEFAULT_GROUP_ID_1];
			if (voFriendGroup == null)
			{
				modelFriend.createDefaultGroup();
			}

			// for (i = 0; i < message.groupList.length; i++)
			// {
			// var friendGrpInfo : FriendGrpInfo = message.groupList[i];
			// voFriendGroup = new VoFriendGroup();
			// voFriendGroup.id = friendGrpInfo.id;
			// voFriendGroup.name = friendGrpInfo.name;
			// voFriendGroup.childen = [];
			// modelFriend.addGroup(voFriendGroup);
			// }

			// 好友列表
			for (i = 0; i < message.followList.length; i++)
			{
				var contactPlayer : ContactPlayer = message.followList[i];
				voFriendItem = new VoFriendItem();
				voFriendItem.mirrorValueByContactPlayer(contactPlayer);
				modelFriend.addFriend(voFriendItem);
			}

			// 在线黑名单玩家ID列表
			for (i = 0; i < message.blockOnline.length; i++)
			{
				playerId = message.blockOnline[i];
				voFriendItem = modelFriend.friendDic[playerId] as VoFriendItem;
				if (voFriendItem)
				{
					voFriendItem.isOnline = true;
					modelFriend.updateFriend(voFriendItem);
				}
			}

			// 在线的最近联系人ID列表
			for (i = 0; i < message.recentOnline.length; i++)
			{
				playerId = message.recentOnline[i];
				voFriendItem = modelFriend.friendDic[playerId] as VoFriendItem;
				if (voFriendItem)
				{
					voFriendItem.isOnline = true;
					modelFriend.updateFriend(voFriendItem);
				}
			}

			// 友列表 -- 加载完成
			modelFriend.friendListData_loadCompleted();
		}

		/** 协议监听 -- 最近联系人列表 */
		private function sc_ListRecent(message : SCListRecent) : void
		{
			var i : int = 0;
			for (i = 0; i < message.playerList.length; i++)
			{
				var contactPlayer : ContactPlayer = message.playerList[i];
				var voFriendItem : VoFriendItem = new VoFriendItem();
				voFriendItem.mirrorValueByContactPlayer(contactPlayer);
				voFriendItem.type = contactPlayer.isFriend ? VoFriendItem.TYPE_I_ADD_SHE : VoFriendItem.TYPE_STRANGER;
				modelFriend.addLastLink(voFriendItem);
			}

			// 发送协议[0x4C] -- 除了第一次打开社交面板，传递在线的block和最近联系人
			protoCtoSFriend.cs_ShowContactMore();
		}

	}
}
