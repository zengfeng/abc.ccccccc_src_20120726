package game.module.friend
{
    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-4  ����12:10:18 
     */
    public class VoFriendGroup
    {
        public var childen:Array = [];
        
        /** id */
        public var id:uint;
        /** 名称 */
        public var name:String;
        /** 总数 */
        public var count:uint;
        /** 在线数 */
        public var onLineNum:uint;
        
        public function addChild(vo:VoFriendItem):VoFriendItem
        {
            if(childen == null || childen.length <= 0)
            {
                childen = [];
                childen.push(vo);
                vo.group = this;
                vo.groupId = id;
                count += 1;
                ModelFriend.instance.friendCount += 1;
                if(vo.isOnline)
                {
                	onLineNum += 1;
                    ModelFriend.instance.onlineFriendCount += 1;
                }
				
				//发送好友数据改变事件
				ModelFriend.instance.friendCountChange();
            	return vo;
            }
            else if(childen.indexOf(vo) == -1)
            {
                childen.push(vo);
                vo.group = this;
                vo.groupId = id;
                count += 1;
                ModelFriend.instance.friendCount += 1;
                if(vo.isOnline)
                {
                	onLineNum += 1;
                    ModelFriend.instance.onlineFriendCount += 1;
                }
            }
			
			//发送好友数据改变事件
			ModelFriend.instance.friendCountChange();
            return vo;
        }
        
        public function removeChild(vo:VoFriendItem):VoFriendItem
        {
            var index:int = childen.indexOf(vo);
            if(index != -1)
            {
                childen.splice(index, 1);
                vo.group = null;
                vo.groupId = -1;
                count -= 1;
                if(ModelFriend.instance.friendCount > 0) ModelFriend.instance.friendCount -= 1;
                if(vo.isOnline)
                {
                    if(onLineNum > 0) onLineNum -= 1;
                    if(ModelFriend.instance.onlineFriendCount > 0) ModelFriend.instance.onlineFriendCount -= 1;
                }
            }
			//发送好友数据改变事件
			ModelFriend.instance.friendCountChange();
            return vo;
        }
		
		public function childOnline(onl:Boolean):void
		{
			onLineNum = onl?onLineNum + 1 : ( onLineNum > 0 ? onLineNum - 1 : 0 );
			ModelFriend.instance.friendOnline();
		}
    }
}
