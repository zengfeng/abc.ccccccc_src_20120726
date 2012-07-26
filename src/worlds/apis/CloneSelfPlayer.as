package worlds.apis
{
	import game.core.avatar.AvatarType;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import game.core.avatar.AvatarPlayer;
	
	import worlds.auxiliarys.MapPoint;
	import worlds.auxiliarys.Path;
	import worlds.auxiliarys.mediators.MSignal;
	import worlds.roles.PlayerPool;
	import worlds.roles.animations.AvatarFactory;
	import worlds.roles.animations.PlayerAnimation;
	import worlds.roles.animations.PlayerAnimationPool;
	import worlds.roles.cores.Player;
	import worlds.roles.structs.PlayerStruct;







	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-26
	*/
	public class CloneSelfPlayer
	{
		private var struct : PlayerStruct;
		private var player : Player;
		public var avatar : AvatarPlayer;
		private var path : Path;
		private var pathPointList : Vector.<MapPoint>;
		private var avatarParent : Sprite;
		public var sPosition : MSignal;
		public var sWalkEnd:MSignal;

		function CloneSelfPlayer() : void
		{
			struct = MSelfPlayer.struct;
			player = PlayerPool.instance.getObject();
			player.resetPlayer(struct.id, struct.name,  struct.colorStr,  struct.heroId,  struct.clothId,  struct.rideId);
			var playerAnimation : PlayerAnimation = PlayerAnimationPool.instance.getObject();
			avatar = AvatarFactory.instance.makePlayer(struct.heroId, struct.clothId, struct.rideId, struct.name, struct.colorStr);
			playerAnimation.reset(avatar, struct.name, struct.colorStr);
			player.setAnimation(playerAnimation);
			sPosition = player.sPosition;
			sWalkEnd = player.sWalkEnd;
			MSelfPlayer.sChangeCloth.add(player.changeCloth);
			MSelfPlayer.sChangeRide.add(player.rideUp);
			
		}

		/** 析构 */
		public function destory() : void
		{
			MSelfPlayer.sChangeCloth.remove(player.changeCloth);
			MSelfPlayer.sChangeRide.remove(player.rideUp);
			player.destory();
			path.clearup();
			sPosition = null;
			struct = null;
			player = null;
			avatar = null;
			path = null;
			pathPointList = null;
			avatarParent = null;
		}
		
		/** 更新AVATAR */
		public function updateAvatar():void
		{
			avatar.initAvatar(struct.heroId, AvatarType.PLAYER_RUN, struct.clothId);
		}

		/** 缓存 */
		public function cache() : void
		{
			MSelfPlayer.sChangeCloth.remove(player.changeCloth);
			MSelfPlayer.sChangeRide.remove(player.rideUp);
		}

		/** 启动 */
		public function startup() : void
		{
			MSelfPlayer.sChangeCloth.add(player.changeCloth);
			MSelfPlayer.sChangeRide.add(player.rideUp);
			if (avatarParent) avatarParent.addChild(avatar);
			player.changeCloth(struct.clothId);
			player.rideUp(struct.rideId);
		}

		/** 设置父容器 */
		public function addTo(parent : Sprite,idx:uint) : void
		{
			avatarParent = parent;
//			parent.addChild(avatar);
			parent.addChildAt(avatar,idx);
		}

		/** 将显示对像从父容器移除 */
		public function removeFromParent() : void
		{
			if ( avatar.parent) avatar.parent.removeChild(avatar);
		}

		/** 设置寻路数据 */
		public function setPathData(byteArray : ByteArray) : void
		{
			if(byteArray == null) return;
			if (path == null)
			{
				path = new Path();
			}
			path.reset(byteArray);
			setPath(path);
		}

		/** 设置寻路 */
		public function setPath(path : Path) : void
		{
			this.path = path;
			if (pathPointList == null) pathPointList = new Vector.<MapPoint>();
		}

		/** 初始化位置 */
		public function initPosition(x : int, y : int) : void
		{
			player.initPosition(x, y, struct.speed);
		}
		
		/** 设置位置 */
		public function setPosition(x:int, y:int):void
		{
			player.setPosition(x, y);
		}
		
		/** 走路 */
		public function walkTo(toX : int, toY : int) : void
		{
			if (path)
			{
				path.find(player.x, player.y, toX, toY, pathPointList);
				player.walkSetPath(pathPointList);
			}
			else
			{
				player.walkLineTo(toX, toY);
			}
		}
		
		public function get x():int
		{
			return player.x;
		}
		
		
		public function get y():int
		{
			return player.y;
		}
		
		public function setStandDirection(targetX:int, targetY:int):void
		{
			player.setStandDirection(targetX, targetY);
		}
		
		public function set mouseEnabled(value:Boolean):void
		{
			avatar.mouseEnabled = value;
			avatar.mouseChildren = value;
		}
	}
}
