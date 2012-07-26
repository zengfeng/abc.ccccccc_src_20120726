package game.module.friend
{
	import game.module.vip.config.VIPConfigManager;
	import com.utils.StringUtils;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import game.core.user.UserData;
	import game.module.friend.config.FriendMaxConfig;
	import game.net.data.StoC.SCDelSpecialNotification;
	import game.net.data.StoC.SCListContactNotification;

	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-9  ����10:32:39 
	 * 模型 -- 好友
	 */
	public class ModelFriend extends EventDispatcher
	{
		/** 单例对像 */
		private static var _instance : ModelFriend;

		public function ModelFriend(target : IEventDispatcher = null)
		{
			super(target);
			// setTimeout(testData2, 2000);
		}

		/** 获取单例对像 */
		static public function get instance() : ModelFriend
		{
			if (_instance == null)
			{
				_instance = new ModelFriend();
			}
			return _instance;
		}

		public function testData2() : void
		{
			var voFriendGroup : VoFriendGroup = new VoFriendGroup();
			voFriendGroup.id = 1;
			voFriendGroup.name = "组1";
			if (friendListData && friendListData.length > 0) voFriendGroup = friendListData[0];
			addGroup(voFriendGroup);
			var i : int;
			for (i = 0; i < 20; i++)
			{
				var voFriendItem : VoFriendItem = new VoFriendItem();
				voFriendItem.id = i;
				voFriendItem.name = "玩家_" + i;
				voFriendItem.level = Math.floor(Math.random() * 200);
				voFriendItem.colorPropertyValue = Math.random() * 200;
				voFriendItem.isOnline = Math.random() > 0.5 ? true : false;
				voFriendItem.isMale = Math.random() > 0.5 ? true : false;
				voFriendItem.job = Math.floor(Math.random() * 6);
				voFriendItem.type = Math.floor(Math.random() * 3);
				voFriendGroup.addChild(voFriendItem);
			}

			for (i = 30; i < 40; i++)
			{
				voFriendItem = new VoFriendItem();
				voFriendItem.id = i;
				voFriendItem.name = "玩家_" + i;
				voFriendItem.level = Math.floor(Math.random() * 200);
				voFriendItem.colorPropertyValue = Math.random() * 200;
				voFriendItem.isOnline = Math.random() > 0.5 ? true : false;
				voFriendItem.isMale = Math.random() > 0.5 ? true : false;
				voFriendItem.job = Math.floor(Math.random() * 6);
				voFriendItem.type = Math.floor(Math.random() * 3);
				addLastLink(voFriendItem);
			}

			for (i = 100; i < 110; i++)
			{
				voFriendItem = new VoFriendItem();
				voFriendItem.id = i;
				voFriendItem.name = "玩家_" + i;
				voFriendItem.level = Math.floor(Math.random() * 200);
				voFriendItem.colorPropertyValue = Math.random() * 200;
				voFriendItem.isOnline = Math.random() > 0.5 ? true : false;
				voFriendItem.isMale = Math.random() > 0.5 ? true : false;
				voFriendItem.job = Math.floor(Math.random() * 6);
				voFriendItem.type = Math.floor(Math.random() * 3);
				moveInBacklist(voFriendItem);
			}

			for (i = 200; i < 210; i++)
			{
				voFriendItem = new VoFriendItem();
				voFriendItem.id = i;
				voFriendItem.name = "玩家_" + i;
				voFriendItem.level = Math.floor(Math.random() * 200);
				voFriendItem.colorPropertyValue = Math.random() * 200;
				voFriendItem.isOnline = Math.random() > 0.5 ? true : false;
				voFriendItem.isMale = Math.random() > 0.5 ? true : false;
				voFriendItem.job = Math.floor(Math.random() * 6);
				voFriendItem.type = Math.floor(Math.random() * 3);
				addFriendApply(voFriendItem);
			}
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 在线好友数量 */
		private var _onlineFriendCount : uint = 0;

		/** 在线好友数量 */
		public function get onlineFriendCount() : uint
		{
			return _onlineFriendCount;
		}

		public function set onlineFriendCount(value : uint) : void
		{
			if (value < 0) value = 0;
			_onlineFriendCount = value;

			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.ONLINE_FRIEND_COUNT_CHANGE, true);
			dispatchEvent(event);
		}

		/** 好友数量 */
		private var _friendCount : uint = 0;

		/** 好友数量 */
		public function get friendCount() : uint
		{
			return _friendCount;
		}

		public function set friendCount(value : uint) : void
		{
			if (value < 0) value = 0;
			_friendCount = value;

			//			//  TODO
			//			//  抛出事件
			// var event : EventFriend = new EventFriend(EventFriend.FRIEND_COUNT_CHANGE, true);
			// dispatchEvent(event);
		}

		/** 好友最好限制 */
		public function get friendMax() : int
		{
			// return FriendMaxConfig.getValue(UserData.instance.vipLevel);
			return VIPConfigManager.instance.getConfigItems(UserData.instance.vipLevel).friend;
		}

		/** 最多创建多少个组 */
		public var groupMax : uint = 8;
		// ---- 我是小巧段落分隔线 ---- //
		/** 好友字典 */
		public var friendDic : Dictionary = new Dictionary();
		/** 好友字典以名字做为Key */
		private var _friendDicByName : Dictionary = new Dictionary();
		/** 好友组字典 */
		public var friendGroupDic : Dictionary = new Dictionary();
		//
		// ---- 我是小巧段落分隔线 ---- //
		//
		/** 好友列表 */
		public var friendListData : Vector.<VoFriendGroup> = new Vector.<VoFriendGroup>();
		// public var friendListData : Vector.<VoFriendGroup> = TestData.friendListData2();
		/** 最近联系人列表列表 */
		public var lastLinkData : Vector.<VoFriendItem> = new Vector.<VoFriendItem>();
		/** 黑名单列表 */
		public var backlistData : Vector.<VoFriendItem> = new Vector.<VoFriendItem>();
		/** 好友申请列表 */
		public var friendApplyListData : Vector.<VoFriendItem> = new Vector.<VoFriendItem>();
		//
		// ---- 我是小巧段落分隔线 ---- //
		//
		// 默认分组改为：知己和好友两组
		/** 默认好友组Id */
		// 知己组
		public const DEFAULT_GROUP_ID_1 : uint = 1;
		// 好友组
		public const DEFAULT_GROUP_ID_2 : uint = 2;
		/** 默认好友组名称 */
		public const DEFAULT_GROUP_NAME : String = "我的好友";

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 好友列表 -- 加载完成 */
		public function friendListData_loadCompleted() : void
		{
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.FRIEND_LIST_DATA_LOAD_COMPLETED, true);
			dispatchEvent(event);
		}

		/** 好友数量更改 */
		public function friendCountChange() : void
		{
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.FRIEND_COUNT_CHANGE, true);
			dispatchEvent(event);
		}

		public function get friendDicByName() : Dictionary
		{
			return _friendDicByName;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		// ----- 好友组 ----- //
		/** 添加组 */
		public function addGroup(vo : VoFriendGroup) : void
		{
			// 判断参数合法
			if (vo == null) return;
			var index : int = friendListData.indexOf(vo);
			if (index != -1) return;
			// 执行
			friendGroupDic[vo.id] = vo;
			friendListData.push(vo);
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.ADD_GROUP, true);
			event.voFriendGroup = vo;
			dispatchEvent(event);
		}

		/** 删除组 */
		public function removeGroup(vo : VoFriendGroup) : void
		{
			// 判断参数合法
			if (vo == null) return;
			var index : int = friendListData.indexOf(vo);
			if (index == -1) return;
			// 执行
			var defaultVoFriendGroup : VoFriendGroup = friendGroupDic[DEFAULT_GROUP_ID_1];
			while (vo.childen.length > 0)
			{
				var voFriendItem : VoFriendItem = vo.childen[0];
				vo.removeChild(voFriendItem);
				defaultVoFriendGroup.addChild(voFriendItem);
			}
			delete friendGroupDic[vo.id];
			friendListData.splice(index, 1);
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.REMOVE_GROUP, true);
			event.voFriendGroup = vo;
			dispatchEvent(event);

			// 发送好友数据改变事件
			friendCountChange();
		}

		// 好友申请面板打开时需要获知当前好友数量
		public var friendsNums : uint;
		
		public function sc_FriendApllyList(message : SCListContactNotification) : void
		{
			for (var i : int = 0; i < message.items.length; i++)
			{
				var voFriendItem : VoFriendItem = new VoFriendItem();
				voFriendItem.id = message.items[i].id;
				voFriendItem.name = message.items[i].name;
				voFriendItem.job = message.items[i].job & 0xf;
				voFriendItem.isMale = (message.items[i].job & 0xf) % 2 ? true : false;
				voFriendItem.level = message.items[i].level;
				voFriendItem.colorPropertyValue = (message.items[i].job >> 4);
				addFriendApply(voFriendItem);
			}
			
			friendsNums = message.followcnt;

			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.ADD_FRIEND_APPLY, true);
			dispatchEvent(event);
		}

		public function sc_removeFriendList(message : SCDelSpecialNotification) : void
		{
			for each (var item:uint in message.idList)
			{
				for each (var vo:VoFriendItem in friendApplyListData)
				{
					if (vo.id == item)
						friendApplyListData.splice(friendApplyListData.indexOf(vo), 1);
				}
			}

			// 抛出事件
			// var event : EventFriend = new EventFriend(EventFriend.ADD_FRIEND_APPLY, true);
			// dispatchEvent(event);
		}

		/** 删除组，根据组Id */
		public function removeGroupById(id : uint) : void
		{
			// 判断参数合法
			var vo : VoFriendGroup = friendGroupDic[id];
			if (vo == null) return;
			// 执行
			// removeGroup(vo);
		}

		/** 组重命名 */
		public function groupRename(id : uint, name : String) : void
		{
			// 判断参数合法
			var vo : VoFriendGroup = friendGroupDic[id];
			if (vo == null) return;
			// 执行
			vo.name = name;
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.GROUP_RENAME, true);
			event.voFriendGroup = vo;
			dispatchEvent(event);
		}

		/** 组加入好友 */
		public function groupAddFriend(voFriendItem : VoFriendItem) : void
		{
			// 判断参数合法
			if (voFriendItem == null) return;
			var vo : VoFriendGroup = friendGroupDic[voFriendItem.id];
			if (vo == null) return;
			// 执行
			vo.addChild(voFriendItem);
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.GROUP_ADD_FRIEND, true);
			event.voFriendGroup = vo;
			event.voFriendItem = voFriendItem;
			dispatchEvent(event);

			// 发送好友数据改变事件
			friendCountChange();
		}

		/** 组加入好友2 */
		public function groupAddFriend2(vo : VoFriendGroup, voFriendItem : VoFriendItem) : void
		{
			// 判断参数合法
			if (vo == null || voFriendItem == null) return;
			// 执行
			vo.addChild(voFriendItem);
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.GROUP_ADD_FRIEND, true);
			event.voFriendGroup = vo;
			event.voFriendItem = voFriendItem;
			dispatchEvent(event);

			// 发送好友数据改变事件
			friendCountChange();
		}

		/** 组移出好友 */
		public function groupRemoveFriend(voFriendItem : VoFriendItem) : void
		{
			// 判断参数合法
			var vo : VoFriendGroup = friendGroupDic[voFriendItem.groupId];
			if (vo == null) return;
			// 执行
			vo.removeChild(voFriendItem);
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.GROUP_REMOVE_FRIEND, true);
			event.voFriendGroup = vo;
			event.voFriendItem = voFriendItem;
			dispatchEvent(event);

			// 发送好友数据改变事件
			friendCountChange();
		}

		/** 组移出好友2 */
		public function groupRemoveFriend2(vo : VoFriendGroup, voFriendItem : VoFriendItem) : void
		{
			// 判断参数合法
			if (vo == null || voFriendItem == null) return;
			// 执行
			vo.removeChild(voFriendItem);
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.GROUP_REMOVE_FRIEND, true);
			event.voFriendGroup = vo;
			event.voFriendItem = voFriendItem;
			dispatchEvent(event);

			// 发送好友数据改变事件
			friendCountChange();
		}

		/** 创建默认组 */
		public function createDefaultGroup() : void
		{
			// 知己组
			var voFriendGroup_1 : VoFriendGroup = new VoFriendGroup();
			voFriendGroup_1.id = DEFAULT_GROUP_ID_1;
			voFriendGroup_1.name = "知己";
			voFriendGroup_1.childen = [];
			addGroup(voFriendGroup_1);

			// 好友组
			var voFriendGroup_2 : VoFriendGroup = new VoFriendGroup();
			voFriendGroup_2.id = DEFAULT_GROUP_ID_2;
			voFriendGroup_2.name = "好友";
			voFriendGroup_2.childen = [];
			addGroup(voFriendGroup_2);
		}

		// ----- 好友 ----- //
		/** 添加好友 */
		public function addFriend(vo : VoFriendItem) : void
		{
			// 判断参数合法
			if (vo == null) return;
			// 执行
			var oldVo : VoFriendItem = _friendDicByName[vo.name];
			if (oldVo != null)	// 如果好友字典中存在以前的
			{
				if (oldVo.type == VoFriendItem.TYPE_BACKLIST)	// 如果是在黑名单列表中
				{
					moveOutBacklist(oldVo);
					// 移出黑名单
				}

				if (oldVo.groupId != -1)		// 如果以前在好友组中
				{
					updateFriend(vo);
					return;
				}
				oldVo.mirrorValueByVoFriendItem(vo);
				vo = oldVo;
			}
			friendDic[vo.id] = vo;
			_friendDicByName[vo.name] = vo;
			// 创建默认好友组(我的好友)
			if (friendGroupDic[DEFAULT_GROUP_ID_1] == null)
			{
				createDefaultGroup();
			}
			var voFriendGroup : VoFriendGroup = friendGroupDic[vo.groupId];
			voFriendGroup.addChild(vo);

			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.ADD_FRIEND, true);
			event.voFriendGroup = voFriendGroup;
			event.voFriendItem = vo;
			dispatchEvent(event);

			// 发送好友数据改变事件
			friendCountChange();
		}

		/** 移除好友 */
		public function removeFriend(vo : VoFriendItem) : void
		{
			// 判断参数合法
			if (vo == null) return;
			// 执行
			var voFriendGroup : VoFriendGroup = friendGroupDic[vo.groupId];
			voFriendGroup.removeChild(vo);
			if (backlistData.indexOf(vo) == -1 && lastLinkData.indexOf(vo) == -1)
			{
				delete friendDic[vo.id];
				delete _friendDicByName[vo.name];
			}
			vo.type = VoFriendItem.TYPE_STRANGER;
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.Remove_FRIEND, true);
			event.voFriendGroup = voFriendGroup;
			event.voFriendItem = vo;
			dispatchEvent(event);

			// 发送好友数据改变事件
			friendCountChange();
		}

		/** 移除好友,根据id */
		public function removeFriendById(id : uint) : void
		{
			// 判断参数合法
			var vo : VoFriendItem = friendDic[id];
			if (vo == null) return;
			// 执行
			removeFriend(vo);
		}

		/** 移除好友,根据name */
		public function removeFriendByName(name : String) : void
		{
			// 判断参数合法
			var vo : VoFriendItem = friendDicByName[name];
			if (vo == null) return;
			// 执行
			removeFriend(vo);
		}

		/** 好友数据更新 */
		public function updateFriend(vo : VoFriendItem) : void
		{
			// 判断参数合法
			if (vo == null) return;
			// 执行
			var oldVo : VoFriendItem = friendDicByName[vo.name];
			if (oldVo != vo)
			{
				oldVo.mirrorValueByVoFriendItem(vo);
				vo = oldVo;
			}
			if (vo.group) vo.group.addChild(vo);
			_friendDicByName[vo.name] = vo;
			if (vo.id) friendDic[vo.id] = vo;
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.UPDATE_FRIEND, true);
			event.voFriendItem = vo;
			dispatchEvent(event);
		}

		// ----- 黑名单 ----- //
		/** 移出黑名单 */
		public function moveOutBacklist(vo : VoFriendItem) : VoFriendItem
		{
			// 判断参数合法
			if (vo == null) return null;
			if (vo.type == VoFriendItem.TYPE_BACKLIST)
			{
				vo.type = VoFriendItem.TYPE_STRANGER;
			}
			var index : int = backlistData.indexOf(vo);
			if (index == -1) return null;
			// 执行
			backlistData.splice(index, 1);
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.MOUVE_OUT_BACKLIST, true);
			event.voFriendItem = vo;
			dispatchEvent(event);
			return vo ;
		}

		/** 移出黑名单,根据Id */
		public function moveOutBacklistById(id : uint) : VoFriendItem
		{
			// 判断参数合法
			var vo : VoFriendItem = friendDic[id];
			if (vo == null) return null;
			// 执行
			return moveOutBacklist(vo);
		}

		/** 移出黑名单,根据名称 */
		public function moveOutBacklistByName(name : String) : VoFriendItem
		{
			// 判断参数合法
			var vo : VoFriendItem = friendDicByName[name];
			if (vo == null) return null;
			// 执行
			return moveOutBacklist(vo);
		}

		/** 移入黑名单 */
		public function moveInBacklist(vo : VoFriendItem) : void
		{
			// 判断参数合法
			if (vo == null) return;
			vo.type = VoFriendItem.TYPE_BACKLIST;
			var index : int = backlistData.indexOf(vo);
			if (index != -1) return;
			// 执行
			removeLastLinkByName(vo.name);
			groupRemoveFriend(vo);
			backlistData.push(vo);
			friendDic[vo.id] = vo;
			_friendDicByName[vo.name] = vo;
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.MOUVE_IN_BACKLIST, true);
			event.voFriendItem = vo;
			dispatchEvent(event);
		}

		/** 移入黑名单,根据Id */
		public function moveInBacklistById(id : uint) : void
		{
			// 判断参数合法
			var vo : VoFriendItem = friendDic[id];
			if (vo == null) return;
			// 执行
			moveInBacklist(vo);
		}

		/** 移入黑名单,根据名称 */
		public function moveInBacklistByName(name : String) : void
		{
			// 判断参数合法
			var vo : VoFriendItem = friendDicByName[name];
			if (vo == null) return;
			// 执行
			moveInBacklist(vo);
		}

		// ----- 最近联系人 ----- //
		/** 添加最近联系人 */
		public function addLastLink(vo : VoFriendItem) : void
		{
			// 判断参数合法
			if (vo == null) return;
			if (isInBackListByPlayerName(vo.name)) return;
			var index : int = lastLinkData.indexOf(vo);
			// 判断之前是否有
			if (index != -1)
			{
				lastLinkData.splice(index, 1);
				lastLinkData.unshift(vo);
			}
			else
			{
				var vo2 : VoFriendItem = findLastLinkByName(vo.name);
				if (vo2)
				{
					updateFriend(vo);
				}
				else
				{
					var vo3 : VoFriendItem = friendDicByName[vo.name];
					if (vo3)
					{
						lastLinkData.unshift(vo3);
					}
					else
					{
						_friendDicByName[vo.name] = vo;
						if (vo.id) friendDic[vo.id] = vo;
						lastLinkData.unshift(vo);
					}
				}
			}

			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.UPDATE_LAST_LINK, true);
			dispatchEvent(event);
		}

		/** 添加最近联系人,根据名称 */
		public function addLastLinkByName(name : String) : VoFriendItem
		{
			// 判断参数合法
			name = StringUtils.trim(name);
			if (!name) return null;
			if (isInBackListByPlayerName(name)) return null;
			// 执行
			var vo : VoFriendItem = findLastLinkByName(name);
			if (vo != null)	// 如果以前存在就移到最前
			{
				var index : int = lastLinkData.indexOf(vo);
				lastLinkData.splice(index, 1);
				lastLinkData.unshift(vo);
			}
			else
			{
				vo = friendDicByName[name];
				if (vo)
				{
					lastLinkData.unshift(vo);
				}
				else
				{
					vo = new VoFriendItem();
					vo.name = name;
					_friendDicByName[vo.name] = vo;
					lastLinkData.unshift(vo);
					ProtoCtoSFriend.instance.cs_RecentContact(vo.name);
				}
			}

			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.UPDATE_LAST_LINK, true);
			dispatchEvent(event);
			return vo;
		}

		/** 移除最近联系人 */
		public function removeLastLinkByName(name : String) : void
		{
			// 判断参数合法
			name = StringUtils.trim(name);
			if (!name) return;
			// 执行
			var vo : VoFriendItem;
			for (var i : int = 0; i < lastLinkData.length; i++)
			{
				vo = lastLinkData[i];
				if (vo.name == name)
				{
					lastLinkData.splice(i, 1);
					break;
				}
			}
			// 抛出事件
			var event : EventFriend = new EventFriend(EventFriend.UPDATE_LAST_LINK, true);
			dispatchEvent(event);
		}

		/** 查找最近联系人,根据名称 */
		public function findLastLinkByName(name : String) : VoFriendItem
		{
			// 判断参数合法
			name = StringUtils.trim(name);
			if (!name) return null;
			var vo : VoFriendItem;
			for (var i : int = 0; i < lastLinkData.length; i++)
			{
				vo = lastLinkData[i];
				if (vo.name == name)
				{
					return vo;
				}
				else
				{
					vo = null;
				}
			}
			return  vo;
		}

		// ----- 好友申请 ----- //
		/** 新增好友申请 */
		public function addFriendApply(vo : VoFriendItem) : void
		{
			// 判断参数合法
			if (vo == null) return;
			// 执行
			friendApplyListData.push(vo);
			//			//  抛出事件
			// var event : EventFriend = new EventFriend(EventFriend.ADD_FRIEND_APPLY, true);
			// event.voFriendItem = vo;
			// dispatchEvent(event);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 检查是否在好友列表中,根据玩家ID */
		public function isInFriendListByPlayerId(playerId : uint) : Boolean
		{
			var voFriendItem : VoFriendItem = friendDic[playerId] as VoFriendItem;
			if (voFriendItem == null) return false;
			if (voFriendItem.type == VoFriendItem.TYPE_BOTH || voFriendItem.type == VoFriendItem.TYPE_I_ADD_SHE)
			{
				return true;
			}
			return false;
		}

		/** 检查是否在好友列表中,根据玩家名称 */
		public function isInFriendListByPlayerName(playerName : String) : Boolean
		{
			var voFriendItem : VoFriendItem = friendDicByName[playerName] as VoFriendItem;
			if (voFriendItem == null) return false;
			if (voFriendItem.type == VoFriendItem.TYPE_BOTH || voFriendItem.type == VoFriendItem.TYPE_I_ADD_SHE)
			{
				return true;
			}
			return false;
		}

		/** 检查是否在黑名单中,根据玩家ID */
		public function isInBackListByPlayerId(playerId : uint) : Boolean
		{
			var voFriendItem : VoFriendItem = friendDic[playerId] as VoFriendItem;
			if (voFriendItem && voFriendItem.type == VoFriendItem.TYPE_BACKLIST)
			{
				return true;
			}
			return false;
		}

		/** 检查是否在黑名单中,根据玩家名称 */
		public function isInBackListByPlayerName(playerName : String) : Boolean
		{
			var voFriendItem : VoFriendItem = friendDicByName[playerName] as VoFriendItem;
			if (voFriendItem && voFriendItem.type == VoFriendItem.TYPE_BACKLIST)
			{
				return true;
			}
			return false;
		}

		public function friendOnline() : void
		{
			var evt : EventFriend = new EventFriend(EventFriend.ONLINE_FRIEND_COUNT_CHANGE, true);
			dispatchEvent(evt);
		}
	}
}
