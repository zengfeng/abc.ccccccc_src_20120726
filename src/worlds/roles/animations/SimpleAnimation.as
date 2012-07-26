package worlds.roles.animations {
	import game.core.avatar.AvatarThumb;

	import gameui.controls.BDPlayer;

	import worlds.apis.MMouse;
	import worlds.roles.animations.depths.RoleNode;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-1
	*/
	public class SimpleAnimation extends RoleNode
	{
		public function resetSimple(avatar : AvatarThumb) : void
		{
			setAvatar(avatar);
			avatar.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		override public function destory() : void
		{
			avatar.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeFromLayer();
			AvatarFactory.destoryAvatar(avatar);
			super.destory();
			destoryToPool();
			avatar = null;
		}

		protected function destoryToPool() : void
		{
			SimpleAnimationPool.instance.destoryObject(this, true);
		}
		
		public var callClick:Function;
		
		public var _effPlayer:BDPlayer ;
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(MMouse.enableWalk == false) return;
			if(callClick != null) callClick();
			event.stopPropagation();
		}

		/** 设置位置 */
		public function setPosition(x : int, y : int) : void
		{
			this.x = x;
			this.y = y;
			avatar.x = x;
			avatar.y = y;
			updateDepth();
			updateMask();
		}

		/** 站立 */
		public function stand() : void
		{
			avatar.stand();
		}

		/** 站立方向 */
		public function standDirection(targetX : int, targetY : int, x : int = 0, y : int = 0) : void
		{
			avatar.standDirection(targetX, targetY, x, y);
		}

		/** 跑 */
		public function run(fromX : int, fromY : int, toX : int, toY : int) : void
		{
			avatar.run(toX, toY, fromX, fromY);
		}

		/** 攻击 */
		public function attack(targetX : int) : void
		{
			if (targetX > x)
			{
				avatar.fontAttack();
			}
			else
			{
				avatar.backAttack();
			}
		}

		// ===================
		// 设置Avatar头丁元件
		// ===================
		public function setName(name : String, colorStr : String) : void
		{
			avatar.setName(name, colorStr);
		}

		public function setProgressBarVisible(value : Boolean) : void
		{
			if (value)
			{
				avatar.addProgressBar();
			}
		}

		public function setProgressBarValue(value : Number) : void
		{
			avatar.showHPBar(value);
		}

		public function setShodowVisible(value : Boolean) : void
		{
			if (value)
			{
				avatar.showShodow();
			}
			else
			{
				avatar.hideShodow();
			}
		}
		
		public function setAction(value : int, loop : int = 0, index : int = -1, arr : Array = null):void
		{
			avatar.setAction(value, loop, index,arr);
		}

		public function fadeQuit() : void {
			avatar.fadeQuit(removeFromLayer) ;
			
//			avatar.quit();
//            _effPlayer = new BDPlayer(new GComponentData());
//            _effPlayer.setBDData(AvatarManager.instance.getDie());
//            addChild(_effPlayer);
//            _effPlayer.play(40);
//            _effPlayer.addEventListener(Event.COMPLETE, dieComplete);

		}
	}
}
