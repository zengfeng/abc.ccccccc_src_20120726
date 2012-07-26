package worlds.roles.cores {
	import flash.utils.getTimer;
	import worlds.players.PlayerWaitShow;
	import worlds.roles.proessors.ais.WanderProcessor;
	import worlds.players.PlayerFactory;
	import worlds.auxiliarys.mediators.Call;
	import worlds.auxiliarys.mediators.MSignal;
	import worlds.roles.PlayerPool;
	import worlds.roles.animations.PlayerAnimation;
	import worlds.roles.animations.SimpleAnimation;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-14
	 */
	public class Player extends Role {
		public var isShow : Boolean;
		public var gridX : int = -1;
		public var gridY : int = -1;
		public var preGridX : int = -1;
		public var preGridY : int = -1;
		// ==============
		// 稳定信息
		// ==============
		protected var heroId : int;
		protected var clothId : int;
		protected var rideId : int;
		protected var isGhost : Boolean;
		protected var isGlow : Boolean;
		// ==============
		// 处理器及动画
		// ==============
		protected var playerAnimation : PlayerAnimation;
		protected var turtle : Role;
		/* 消息 */
		protected var callActionSitdown : Call = new Call();
		protected var callActionSitdup : Call = new Call();
		protected var callActionRideUp : Call = new Call();
		protected var callActionRideDown : Call = new Call();
		protected var callGhost : Call = new Call();
		protected var callGlow : Call = new Call();
		protected var sChangeCloth : MSignal = new MSignal(int, int);
		protected var sChangeModel : MSignal = new MSignal(int);
		public var sMove : MSignal = new MSignal(Player);

		override public function destory() : void {
			sMove.clear();
			super.destory();
			isShow = false;
			gridX = -1;
			gridY = -1;
			preGridX = -1;
			preGridY = -1;
		}

		override protected function destoryToPool() : void {
			isGhost = false;
			isGlow = false;
			PlayerPool.instance.destoryObject(this, true);
		}

		public function resetPlayer(playerId : int, name : String, colorStr : String, heroId : int, clothId : int, rideId : int) : void {
			resetRole(playerId);
			this.name = name;
			this.colorStr = colorStr;
			this.heroId = heroId;
			this.clothId = clothId;
			this.rideId = rideId;
			sPosition.add(onMove);
			if(!playerWaitShow) playerWaitShow = PlayerWaitShow.instance;
		}

		protected function onMove(x : int, y : int) : void {
			sMove.dispatch(this);
		}

		// ==============
		// 动画
		// ==============
		override public function setAnimation(animation : SimpleAnimation) : void {
			isShow = true;
			playerAnimation = animation as PlayerAnimation;
			super.setAnimation(animation);
			playerAnimation.setGhost(isGhost);
			callActionSitdown.register(playerAnimation.sitDown);
			callActionSitdup.register(playerAnimation.sitUp);
			callActionRideUp.register(playerAnimation.rideUp);
			callActionRideDown.register(playerAnimation.rideDown);
			callGhost.register(playerAnimation.setGhost);
			callGlow.register(playerAnimation.setGlow);
			sChangeCloth.add(playerAnimation.changeCloth);
			sChangeModel.add(playerAnimation.changeModel);
		}

		override protected function destoryAnimation() : void {
			isShow = false;
			super.destoryAnimation();
			if (playerAnimation == null) return;
			callActionSitdown.clear();
			callActionSitdup.clear();
			callActionRideUp.clear();
			callActionRideDown.clear();
			callGhost.clear();
			callGlow.clear();
			sChangeCloth.remove(playerAnimation.changeCloth);
			sChangeModel.remove(playerAnimation.changeModel);
			playerAnimation = null;
		}

		public static var playerWaitShow:PlayerWaitShow;
		public function limitShow() : void {
			playerWaitShow.add(this);
			sDestory.add(onDestoryLimitShowRemove);
		}
		
		private function onDestoryLimitShowRemove():void
		{
			playerWaitShow.remove(this);
		}
		
		public function limitShowExe() : void {
			// if (isShow == true) return;
			// if (playerAnimation == null)
			// {
			// var animation : PlayerAnimation = PlayerFactory.instance.makePlayerAnimation(id, name, colorStr, heroId, clothId, rideId);
			// setAnimation(animation);
			// if (walking) animation.run(x, y, toX, toY);
			// }
			addToLayer();
		}

		public function limitHide() : void {
			sDestory.remove(onDestoryLimitShowRemove);
			playerWaitShow.remove(this);
			// if (isShow == false) return;
			removeFromLayer();
			// destoryAnimation();
		}

		// =======================
		// 打座
		// =======================
		public function sitDown() : void {
			walkStop();
			rideDown();
			callActionSitdown.call();
			sWalkStart.add(rideUp);
		}

		public function sitUp() : void {
			if (walking == false) callActionStand.call();
			rideUp();
		}

		// =======================
		// 坐骑
		// =======================
		public function rideUp(rideId : int = -1) : void {
			sWalkStart.remove(rideUp);
			if (rideId != -1) this.rideId = rideId;
			if (this.rideId == 0) {
				rideDown();
			} else {
				callActionRideUp.call(this.rideId);
			}
		}

		protected function rideDown() : void {
			callActionRideDown.call();
		}

		// =======================
		// 换装
		// =======================
		public function changeCloth(clothId : int) : void {
			this.clothId = clothId;
			sChangeCloth.dispatch(clothId, heroId);
		}

		public function changeModel(modelId : int) : void {
			sChangeModel.dispatch(modelId);
		}

		// =======================
		// 设置是否是灵魂
		// =======================
		public function setGhost(value : Boolean) : void {
			isGhost = value;
			callGhost.call(value);
		}

		public function setGlow(value : Boolean) : void {
			isGlow = value;
			callGlow.call(value);
		}

		// =======================
		// 点击回调
		// =======================
		public var callShowInfo : Function;

		override public function addClickCall(fun : Function) : void {
			super.addClickCall(fun);
			if (playerAnimation) playerAnimation.mouseDownUseBody = clickList.length == 0;
		}

		override public function removeClickCall(fun : Function) : void {
			super.removeClickCall(fun);
			if (playerAnimation) playerAnimation.mouseDownUseBody = clickList.length == 0;
		}

		override public function clearClickCall() : void {
			super.clearClickCall();
			if (playerAnimation) playerAnimation.mouseDownUseBody = true;
		}

		override protected function onClick() : void {
			if (callShowInfo != null) callShowInfo(this);
			if (clickList.length > 0) {
				super.onClick();
			}
		}

		private var wanderProcessor : WanderProcessor;
		public function wander() : void {
			wanderProcessor = new WanderProcessor();
			wanderProcessor.reset(walkProcessor.lineTo, null, x, y);
			sDestory.add(wanderCancel);
		}
		public function wanderCancel():void
		{
			if(wanderProcessor)wanderProcessor.stop();
			wanderProcessor = null;
		}
	}
}
