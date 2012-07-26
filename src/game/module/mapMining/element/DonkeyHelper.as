package game.module.mapMining.element {
	import game.core.avatar.AvatarThumb;

	import com.utils.FilterUtils;

	import flash.events.MouseEvent;

	/**
	 * @author jian
	 */
	public class DonkeyHelper
	{
		private var _avatar : AvatarThumb;

		public function attach(avatar : AvatarThumb) : void
		{
			_avatar = avatar;
			_avatar.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			_avatar.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}

		public function detach() : void
		{
			_avatar.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			_avatar.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}

		private function rollOverHandler(event : MouseEvent) : void
		{
			_avatar.run(0, 0, 0, 0);
			_avatar.player.filters = [FilterUtils.defaultGlowFilter];
		}

		private function rollOutHandler(event : MouseEvent) : void
		{
			_avatar.stand();
			_avatar.player.filters = [];
		}
	}
}
