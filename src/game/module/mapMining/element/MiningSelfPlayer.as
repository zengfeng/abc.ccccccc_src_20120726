package game.module.mapMining.element {
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarThumb;
	import game.core.avatar.AvatarType;
	import game.module.mapMining.event.MiningEvent;

	import worlds.apis.MFactory;
	import worlds.roles.animations.SimpleAnimation;
	import worlds.roles.cores.Role;

	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	/**
	 * @author jian
	 */
	public class MiningSelfPlayer extends MiningPlayer
	{
		// 驴子NpcId
		public static var DONKEY_ID : int = 3008;//5019;
		// 驴子
		private var _donkey : Role;
		// 驴子动作
		private var _donkeyHelper : DonkeyHelper;
		// Event
		public var eventDispatcher : EventDispatcher = new EventDispatcher();

		public function get donkey() : Role
		{
			return _donkey;
		}
		
		private function followerAvatar_clickHandler(event : MouseEvent) : void
		{
			event.stopPropagation();
			var e : MiningEvent = new MiningEvent(MiningEvent.OPEN_BASKET);
			eventDispatcher.dispatchEvent(e);
		}

		override public function enter() : void
		{
			super.enter();

			_donkey = createDonkey();
			_donkey.follow(player, 65);
			_donkey.avatar.player.addEventListener(MouseEvent.CLICK, followerAvatar_clickHandler, false, 999);

			_donkeyHelper = new DonkeyHelper();
			_donkeyHelper.attach(_donkey.avatar);
		}

		override public function exit() : void
		{
			_donkey.avatar.player.removeEventListener(MouseEvent.CLICK, followerAvatar_clickHandler);
			_donkey.cancelFollow();
			_donkey.destory();
			_donkey = null;
			super.exit();

			_donkeyHelper.detach();
		}

		override public function takePlace() : void
		{
			avatarMiner.setAction(avatarMiner.direction + 10);
			setTimeout(moveDonkey, 200);
		}

		private function createDonkey() : Role
		{
			var role : Role = MFactory.makeRole();
//			var avatar : AvatarThumb = MAvatarFactory.makeMonster(DONKEY_ID);
			var avatar:AvatarThumb = AvatarManager.instance.getAvatar(DONKEY_ID, AvatarType.FLLOW_TYPE) as AvatarThumb;
			// avatar.setName(name, colorStr);
			var animation : SimpleAnimation = MFactory.makeSimpleAnimation();
			animation.resetSimple(avatar);
			role.resetRole(0);
			role.setAnimation(animation);
			// if (MapUtil.hasMask) role.setNeedMask(MapUtil.hasMask);
			role.initPosition(player.x+10, player.y+10, 4);
			role.clickToType = -1;
			role.addToLayer();

			return role;
		}

		private function moveDonkey() : void
		{
			var to : Point = new Point();
			if (avatarMiner.player.scaleX > 0)
			{
				to.x = player.x - 40;
				to.y = player.y + 20;
			}
			else
			{
				to.x = player.x + 40;
				to.y = player.y + 20;
			}

			donkey.walkLineTo(to.x, to.y);
		}
	}
}
