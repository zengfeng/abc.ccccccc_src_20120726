package worlds.roles.animations
{
	import game.core.avatar.AvatarFisher;
	import game.core.avatar.AvatarPlayer;
	import game.core.avatar.AvatarType;

	import worlds.auxiliarys.mediators.MSignal;

	import com.utils.FilterUtils;

	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-1
	 */
	public class PlayerAnimation extends SimpleAnimation
	{
		private static const FISHER_AVATAR_ID : uint = 167772187;
		protected var colorStr : String;
		protected var isGhost : Boolean;
		protected var isGlow : Boolean;
		protected var playerAvatar : AvatarPlayer;
		protected var fisherAvatar : AvatarFisher;
		protected var sDestory : MSignal = new MSignal();

		public function reset(avatar : AvatarPlayer, name : String, colorStr : String) : void
		{
			resetSimple(avatar);
			playerAvatar = avatar;
			this.name = name;
			this.colorStr = colorStr;
		}

		override public function destory() : void
		{
			sDestory.dispatch();
			sDestory.clear();
			super.destory();
			playerAvatar = null;
		}

		override protected function destoryToPool() : void
		{
			PlayerAnimationPool.instance.destoryObject(this, true);
		}

		public var mouseDownUseBody : Boolean = true;

		override protected function onMouseDown(event : MouseEvent) : void
		{
			if (mouseDownUseBody)
			{
				if (playerAvatar.isBody(event.localX, event.localY))
				{
					super.onMouseDown(event);
				}
			}
			else
			{
				super.onMouseDown(event);
			}
		}

		// ==================
		// 灵魂
		// ==================
		public function setGhost(value : Boolean) : void
		{
			if (isGhost == value) return;
			isGhost = value;
			if (value)
			{
				ghostIn();
			}
			else
			{
				ghostOut();
			}
		}

		protected function ghostIn() : void
		{
			isGhost = true;
			FilterUtils.addFilter(avatar.player, FilterUtils.dieFilter, ColorMatrixFilter);
			sDestory.add(ghostOut);
		}

		protected function ghostOut() : void
		{
			isGhost = false;
			sDestory.remove(ghostOut);
			FilterUtils.removeFilter(avatar.player, ColorMatrixFilter);
		}

		// ==================
		// 佛光
		// ==================
		public function setGlow(value : Boolean) : void
		{
			if (isGlow == value) return;
			isGlow = value;
			if (value)
			{
				glowIn();
			}
			else
			{
				glowOut();
			}
		}

		protected function glowIn() : void
		{
			isGlow = true;
			FilterUtils.addGlow(avatar);
			sDestory.add(ghostOut);
		}

		protected function glowOut() : void
		{
			isGlow = false;
			sDestory.remove(ghostOut);
			FilterUtils.removeGlow(avatar);
		}

		// ==================
		// 玩家普通功能
		// ==================
		/** 打坐 */
		public function sitDown() : void
		{
			avatar.sitdown();
		}

		public function sitUp() : void
		{
			stand();
		}

		/** 坐骑 */
		public function rideDown() : void
		{
			avatar.removeSeat();
		}

		public function rideUp(rideId : int) : void
		{
			stand();
			avatar.addSeat(rideId);
		}

		/** 换装 */
		public function changeCloth(clothId : int, heroId : int) : void
		{
			playerAvatar.changeCloth(clothId, heroId, AvatarType.PLAYER_RUN);
		}

		public function changeModel(modelId : int) : void
		{
			playerAvatar.changeModel(modelId);
		}

		/** 换名字颜色 */
		public function changeNameColor(colorStr : String) : void
		{
			avatar.setName(name, colorStr);
		}
		/*
		// ====================
		// 钓鱼
		// ====================
		public function fishModelIn(fishDirection : int) : void
		{
		if (fisherAvatar == null)
		{
		fisherAvatar = new AvatarFisher(fishDirection);
		}
		else
		{
		fisherAvatar.resetPosition(fishDirection);
		}
		fisherAvatar.setName(name, colorStr);
		fisherAvatar.initUUID(FISHER_AVATAR_ID);
		fisherAvatar.sit();
		avatar.player.visible = false;
		avatar.hideName();
		avatar.addChild(fisherAvatar);
		sDestory.add(fishModelOut);
		}

		public function fishModelOut() : void
		{
		if (fisherAvatar == null) return;
		fisherAvatar.hide();
		fisherAvatar.dispose();
		fisherAvatar = null;
		avatar.player.visible = true;
		avatar.showName();
		}

		public function fishSit() : void
		{
		fisherAvatar.sit();
		}

		public function fishHold() : void
		{
		fisherAvatar.hold();
		}

		public function fishPull(awardUrl : String, onPullComplete : Function) : void
		{
		fisherAvatar.pull(awardUrl, onPullComplete);
		}*/
	}
}
