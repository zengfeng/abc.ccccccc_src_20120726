package game.core.avatar {
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class AvatarSkill extends AbstractAvatar {
		public function AvatarSkill() {
			super();
		}

		override protected function initComplete(event : Event) : void {
		}

		private var _mc : MovieClip;
		private var _isMc : Boolean = false;

		override public function setAction(value : int, loop : int = 0, index : int = 0, arr : Array = null, onComplete : Function = null, onCompleteParams : Array = null) : void {
			if (_isMc) {
				if (_mc)
					_mc.gotoAndPlay(1);
				return;
			}
			super.setAction(value, loop, index, arr, onComplete, onCompleteParams);
		}
		
		/** 回收 */
		override internal function callback() : void {
			reset();
			dispose();
		}
		
		override protected function addShodow() : void {
		}
		
		override protected function change(type : int = 1) : void {
		}
		
		protected function skillComplete(event : Event) : void {
			hide();
		}

		override public function dispose() : void {
			player.dispose();
		}

		override protected function onHide() : void {
		}
	}
}
