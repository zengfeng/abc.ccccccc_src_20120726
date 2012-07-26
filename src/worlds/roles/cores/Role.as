package worlds.roles.cores
{
	import worlds.apis.MTo;
	import worlds.maps.UIMediator;

	import flash.display.DisplayObject;

	import game.core.avatar.AvatarThumb;

	import worlds.auxiliarys.MapMath;
	import worlds.auxiliarys.MapPoint;
	import worlds.auxiliarys.mediators.Call;
	import worlds.auxiliarys.mediators.DelayCall;
	import worlds.auxiliarys.mediators.MSignal;
	import worlds.roles.RolePool;
	import worlds.roles.animations.SimpleAnimation;
	import worlds.roles.proessors.attacks.AttackerProcessor;
	import worlds.roles.proessors.attacks.DefenderProcessor;
	import worlds.roles.proessors.follows.FollowerProcessor;
	import worlds.roles.proessors.follows.LeaderProcessor;
	import worlds.roles.proessors.walks.WalkProcessor;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-14
	 */
	public class Role
	{
		// ==============
		// 稳定信息
		// ==============
		public var id : int;
		public var name : String;
		protected var colorStr : String;
		private var nameVisible : Boolean = true;
		private var progressBarVisible : Boolean = false;
		private var progressBarValue : Number = 0;
		private var shodowVisible : Boolean = true;
		// ==============
		// 基本
		// ==============
		protected var speed : Number;
		protected var position : MapPoint = new MapPoint();
		protected var walking : Boolean;
		protected var toX : int = 0;
		protected var toY : int = 0;
		// ==============
		// 处理器
		// ==============
		public var animation : SimpleAnimation;
		protected var walkProcessor : WalkProcessor;
		protected var attackerProcessor : AttackerProcessor;
		protected var defenderProcessor : DefenderProcessor;
		protected var followerProcessor : FollowerProcessor;
		protected var leaderProcessor : LeaderProcessor;
		// ==============
		// 消息
		// ==============
		public var sUninstall : MSignal = new MSignal();
		protected var sDestory : MSignal = new MSignal();
		/* 消息--走路 */
		protected var sWalkLinkTo : MSignal = new MSignal(int, int);
		protected var sWalkPathTo : MSignal = new MSignal(int, int);
		protected var sWalkAddPathPoint : MSignal = new MSignal(int, int);
		protected var sWalkSetPath : MSignal = new MSignal(Vector.<MapPoint>);
		protected var sWalkRemoveLastPathPoint : MSignal = new MSignal();
		protected var sWalkFromTo : MSignal = new MSignal(int, int, Boolean, int, int);
		protected var sWalkStop : MSignal = new MSignal();
		public var sWalkStart : MSignal = new MSignal();
		public var sWalkEnd : MSignal = new MSignal();
		public var sWalkTurn : MSignal = new MSignal(int, int, int, int);
		protected var sChangeSpeed : MSignal = new MSignal(Number);
		/* 消息--位置&传送 */
		public var sPosition : MSignal = new MSignal(int, int);
		public var sTransportTo : MSignal = new MSignal(int, int);
		/* 消息--站立朝向 */
		protected var sStandDirection : MSignal = new MSignal(int, int);
		private var delayCallStandDirection : DelayCall = new DelayCall();
		protected var callActionAttack : Call = new Call();
		protected var callActionStand : Call = new Call();
		protected var callAddToLayer : Call = new Call();
		protected var callRemoveFromLayer : Call = new Call();
		protected var callNeedMask : Call = new Call();
		protected var sNameChange : MSignal = new MSignal(String, String);
		protected var callProgressBarVisible : Call = new Call();
		protected var callProgressBarValue : Call = new Call();
		protected var callShodowVisible : Call = new Call();
		protected var callAction : Call = new Call();
		protected var callFadeQuit : Call = new Call();

		public function resetRole(id : int) : void
		{
			this.id = id;
			initialize();
		}

		private function initialize() : void
		{
			sTransportTo.add(setPosition);
			sWalkStart.add(walkStart);
			sWalkEnd.add(walkEnd);
			sWalkTurn.add(walkTurn);
		}

		public function destory() : void
		{
			if (walking) sWalkStop.dispatch();
			walking = false;
			sUninstall.dispatch();
			sUninstall.clear();
			sDestory.dispatch();
			sDestory.clear();
			sWalkLinkTo.clear();
			sWalkPathTo.clear();
			sWalkAddPathPoint.clear();
			sWalkSetPath.clear();
			sWalkRemoveLastPathPoint.clear();
			sWalkStop.clear();
			sWalkStart.clear();
			sWalkEnd.clear();
			sWalkTurn.clear();
			sChangeSpeed.clear();
			sPosition.clear();
			sTransportTo.clear();
			sStandDirection.clear();
			delayCallStandDirection.clear();
			callActionAttack.clear();
			callActionStand.clear();
			callAddToLayer.clear();
			callRemoveFromLayer.clear();
			callNeedMask.clear();
			callAction.clear();
			destoryToPool();
		}

		protected function destoryToPool() : void
		{
			RolePool.instance.destoryObject(this, true);
		}

		/** 初始化位置 */
		public function initPosition(x : int, y : int, speed : Number = 4, walking : Boolean = false, walkTime : Number = 0, fromX : int = 0, fromY : int = 0, toX : int = 0, toY : int = 0, moveProessorType : int = 0) : void
		{
			this.speed = speed;
			this.walking = walking;
			position.x = x;
			position.y = y;
			generateWalkProcessor(moveProessorType);
			if (walking == false)
			{
				this.toX = x;
				this.toY = y;
				setPosition(x, y);
				return;
			}

			this.toX = toX;
			this.toY = toY;
			var distance : Number = MapMath.distance(fromX, fromY, toX, toY);
			var length : Number = speed * (walkTime / 1000 * 60);
			if (length >= distance)
			{
				setPosition(toX, toY);
				return;
			}

			var radian : Number = MapMath.radian(fromX, fromY, toX, toY);
			x = MapMath.radianPointX(radian, length, fromX);
			y = MapMath.radianPointY(radian, length, fromY);
			setPosition(x, y);
			walkLineTo(toX, toY);
		}

		// ==============
		// 动画
		// ==============
		public function setAnimation(animation : SimpleAnimation) : void
		{
			this.animation = animation;
			animation.callClick = onClick;
			animation.setPosition(x, y);
			sDestory.add(destoryAnimation);
			sWalkTurn.add(animation.run);
			sWalkEnd.add(callActionStand.call);
			sPosition.add(animation.setPosition);
			sStandDirection.add(animation.standDirection);
			callActionStand.register(animation.stand);
			callActionAttack.register(animation.attack);
			callAddToLayer.register(animation.addToLayer);
			callNeedMask.register(animation.setNeedMask);
			callRemoveFromLayer.register(animation.removeFromLayer);
			sNameChange.add(animation.setName);
			callProgressBarVisible.register(animation.setProgressBarVisible);
			callProgressBarValue.register(animation.setProgressBarValue);
			callShodowVisible.register(animation.setShodowVisible);
			callAction.register(animation.setAction);
			callFadeQuit.register(animation.fadeQuit);
		}

		protected function destoryAnimation() : void
		{
			if (animation == null) return;
			animation.callClick = null;
			clickToType = 0;
			clearClickCall();
			sDestory.remove(destoryAnimation);
			sWalkTurn.remove(animation.run);
			sWalkEnd.remove(animation.stand);
			sPosition.remove(animation.setPosition);
			sStandDirection.remove(animation.standDirection);
			callActionAttack.clear();
			callActionStand.clear();
			callAddToLayer.clear();
			callRemoveFromLayer.clear();
			callNeedMask.clear();
			sNameChange.remove(animation.setName);
			callProgressBarVisible.clear();
			callProgressBarValue.clear();
			callShodowVisible.clear();
			callAction.clear();
			callFadeQuit.clear() ;
			animation.destory();
			animation = null;
		}

		public function addToLayer() : void
		{
			callAddToLayer.call();
		}

		public function removeFromLayer() : void
		{
			callRemoveFromLayer.call();
		}

		public function setNeedMask(value : Boolean) : void
		{
			callNeedMask.call(value);
		}

		// =======================
		// 点击回调
		// =======================
		protected var clickList : Vector.<Function> = new Vector.<Function>();

		public function addClickCall(fun : Function) : void
		{
			var index : int = clickList.indexOf(fun);
			if (index == -1)
			{
				clickList.push(fun);
			}
		}

		public function removeClickCall(fun : Function) : void
		{
			var index : int = clickList.indexOf(fun);
			if (index != -1)
			{
				clickList.splice(index, 1);
			}
		}

		public var clickToType : int = 0;

		protected function onClick() : void
		{
			switch(clickToType)
			{
				case -1:
					runClickList();
					break;
				case 1:
					MTo.toNpc(1, id, 0, runClickList);
					break;
				case 2:
					MTo.toPoint(1, x + MapMath.randomPlusMinus(100), y + MapMath.randomPlusMinus(100), x, y, runClickList);
					break;
				case 0:
				default:
					MTo.toPoint(1, x, y, 0, 0, runClickList);
					break;
			}
		}

		private function runClickList() : void
		{
			for each (var fun:Function in  clickList)
			{
				fun(this);
			}
		}

		public function clearClickCall() : void
		{
			while (clickList.length)
			{
				clickList.shift();
			}
		}

		// ===================
		// 设置Avatar头丁元件
		// ===================
		public function setNameVisible(value : Boolean) : void
		{
			nameVisible = value;
			if (value)
			{
				sNameChange.dispatch(name, colorStr);
			}
			else
			{
				sNameChange.dispatch("", "");
			}
		}

		public function setProgressBarVisible(value : Boolean) : void
		{
			progressBarVisible = value;
			callProgressBarVisible.call(value);
		}

		public function setProgressBarValue(value : Number) : void
		{
			progressBarValue = value;
			callProgressBarValue.call(value);
		}

		public function setShodowVisible(value : Boolean) : void
		{
			shodowVisible = value;
			callShodowVisible.call(value);
		}

		public function setColorStr(colorStr : String) : void
		{
			this.colorStr = colorStr;
			sNameChange.dispatch(name, colorStr);
		}

		// ==============
		// 设置动作
		// ==============
		public function setAction(value : int, loop : int = 0, index : int = -1, arr : Array = null) : void
		{
			callAction.call(value, loop, index, arr);
		}

		public function actionAttack(targetX : int) : void
		{
			callActionAttack.call(targetX);
		}

		public function actionStand() : void
		{
			callActionStand.call();
		}

		// ==============
		// 渐渐消失，水花效果
		// ==============
		public function fadeQuit() : void
		{
			callFadeQuit.call();
		}

		// ==============
		// 走路处理器
		// ==============
		protected function generateWalkProcessor(moveProessType : int = 0) : void
		{
			if (walkProcessor == null) walkProcessor = new WalkProcessor();
			walkProcessor.reset(position, speed, sPosition.dispatch, sWalkStart.dispatch, sWalkTurn.dispatch, sWalkEnd.dispatch, moveProessType);
			sDestory.add(destoryWalkProcessor);
			sChangeSpeed.add(walkProcessor.changeSpeed);
			sWalkLinkTo.add(walkProcessor.lineTo);
			sWalkPathTo.add(walkProcessor.pathTo);
			sWalkAddPathPoint.add(walkProcessor.addPathPoint);
			sWalkSetPath.add(walkProcessor.setPath);
			sWalkRemoveLastPathPoint.add(walkProcessor.removePathLastPoint);
			sWalkFromTo.add(walkProcessor.fromTo);
			sWalkStop.add(walkProcessor.stop);
		}

		protected function destoryWalkProcessor() : void
		{
			if (walkProcessor == null) return;
			sDestory.remove(destoryWalkProcessor);
			sChangeSpeed.remove(walkProcessor.changeSpeed);
			sWalkLinkTo.remove(walkProcessor.lineTo);
			sWalkPathTo.remove(walkProcessor.pathTo);
			sWalkAddPathPoint.remove(walkProcessor.addPathPoint);
			sWalkSetPath.remove(walkProcessor.setPath);
			sWalkRemoveLastPathPoint.remove(walkProcessor.removePathLastPoint);
			sWalkFromTo.remove(walkProcessor.fromTo);
			sWalkStop.remove(walkProcessor.stop);
			walkProcessor.destory();
			walkProcessor = null;
		}

		// =======================
		// 走路操作
		// =======================
		public function walkLineTo(toX : int, toY : int) : void
		{
			sWalkLinkTo.dispatch(toX, toY);
		}

		public function walkPathTo(toX : int, toY : int) : void
		{
			sWalkPathTo.dispatch(toX, toY);
		}

		public function walkAddPathPoint(x : int, y : int) : void
		{
			sWalkAddPathPoint.dispatch(x, y);
		}

		public function walkSetPath(path : Vector.<MapPoint>) : void
		{
			sWalkSetPath.dispatch(path);
		}

		public function walkRemovePathLastPoint() : void
		{
			sWalkRemoveLastPathPoint.dispatch();
		}

		public function walkFromTo(toX : int, toY : int, hasFrom : Boolean, fromX : int, fromY : int) : void
		{
			sWalkFromTo.dispatch(toX, toY, hasFrom, fromX, fromY);
		}

		public function walkStop() : void
		{
			sWalkStop.dispatch();
		}

		// =======================
		// 走路状态
		// =======================
		private function walkStart() : void
		{
			walking = true;
		}

		private function walkEnd() : void
		{
			walking = false;
		}

		private function walkTurn(fromX : int, fromY : int, toX : int, toY : int) : void
		{
			fromX;
			fromY;
			this.toX = toX;
			this.toY = toY;
		}

		// =======================
		// 传送&位置
		// =======================
		public function transportTo(toX : int, toY : int) : void
		{
			if (walking) walkStop();
			sTransportTo.dispatch(toX, toY);
		}

		public function setPosition(x : int, y : int) : void
		{
			sPosition.dispatch(x, y);
			position.x = x;
			position.y = y;
		}

		// =======================
		// 站立朝向
		// =======================
		public function setStandDirection(targetX : int, targetY : int) : void
		{
			if (walking)
			{
				delayCallStandDirection.register(standDirection, [targetX, targetY]);
				sWalkEnd.add(delayCallStandDirection.call);
			}
			else
			{
				standDirection(targetX, targetY);
			}
		}

		protected function cancelStandDirection() : void
		{
			delayCallStandDirection.clear();
			sWalkEnd.remove(delayCallStandDirection.call);
		}

		protected function standDirection(targetX : int, targetY : int) : void
		{
			cancelStandDirection();
			sStandDirection.dispatch(targetX, targetY);
		}

		// =======================
		// 速度
		// =======================
		public function changeSpeed(speed : Number) : void
		{
			this.speed = speed;
			dispatchSpeed(this.speed);
		}

		protected function recoverSpeed() : void
		{
			dispatchSpeed(this.speed);
		}

		protected function dispatchSpeed(speed : Number) : void
		{
			sChangeSpeed.dispatch(speed);
		}

		// =======================
		// 战斗
		// =======================
		public function attack(defender : Role) : void
		{
			if (attackerProcessor)
			{
				attackerProcessor.destory();
			}
			attackerProcessor = new AttackerProcessor();
			defender.addAttaker(this);
			var defenderProcessor : DefenderProcessor = defender.defenderProcessor;
			sDestory.add(attackerProcessor.destory);
			sWalkEnd.remove(callActionStand.call);
			sWalkEnd.add(attackerProcessor.walkEnd);
			attackerProcessor.reset(defenderProcessor, position, defender.x, defender.y, cancelAttack, walkLineTo, callActionAttack.call);
		}

		public function cancelAttack(destoryed : Boolean = false) : void
		{
			if (attackerProcessor == null) return;
			sDestory.remove(attackerProcessor.destory);
			sWalkEnd.remove(attackerProcessor.walkEnd);
			sWalkEnd.add(callActionStand.call);
			if (!destoryed) attackerProcessor.destory();
			attackerProcessor = null;
			walkStop();
		}

		protected function generateDefenderProcessor() : void
		{
			defenderProcessor = new DefenderProcessor();
			defenderProcessor.reset(destoryDefenderProcessor);
			sPosition.add(defenderProcessor.move);
			sDestory.add(defenderProcessor.destory);
		}

		protected function destoryDefenderProcessor(destoryed : Boolean = false) : void
		{
			if (defenderProcessor == null) return;
			sPosition.remove(defenderProcessor.move);
			sDestory.remove(defenderProcessor.destory);
			if (!destoryed) defenderProcessor.destory();
			defenderProcessor = null;
		}

		protected function addAttaker(role : Role) : void
		{
			if (defenderProcessor == null)
			{
				generateDefenderProcessor();
			}
			defenderProcessor.addAttacker(role.attackerProcessor);
		}

		// =======================
		// 跟随
		// =======================
		public function follow(leader : Role, distance:Number = 130) : void
		{
			if (followerProcessor)
			{
				followerProcessor.destory();
			}
			followerProcessor = new FollowerProcessor();
			leader.addFollower(this);
			var leaderProcessor : LeaderProcessor = leader.leaderProcessor;
			sDestory.add(followerProcessor.destory);
			followerProcessor.distance = distance;
			followerProcessor.reset(leaderProcessor, position, cancelFollow, dispatchSpeed, transportTo, walkAddPathPoint, walkRemovePathLastPoint, setStandDirection);
		}

		public function cancelFollow(destoryed : Boolean = false) : void
		{
			if (followerProcessor == null) return;
			recoverSpeed();
			cancelStandDirection();
			sDestory.remove(followerProcessor.destory);
			if (!destoryed) followerProcessor.destory();
			walkStop();
			followerProcessor = null;
		}

		protected function generateLeaderProcessor() : void
		{
			leaderProcessor = new LeaderProcessor();
			leaderProcessor.reset(destoryLeaderProcessor, position, speed, walking, toX, toY);
			sDestory.add(leaderProcessor.destory);
			sWalkStart.add(leaderProcessor.walkStart);
			sWalkTurn.add(leaderProcessor.walkTurn);
			sWalkEnd.add(leaderProcessor.walkEnd);
			sChangeSpeed.add(leaderProcessor.changeSpeed);
			sTransportTo.add(leaderProcessor.transport);
		}

		protected function destoryLeaderProcessor(destoryed : Boolean = false) : void
		{
			if (leaderProcessor == null) return;
			sDestory.remove(leaderProcessor.destory);
			sWalkStart.remove(leaderProcessor.walkStart);
			sWalkTurn.remove(leaderProcessor.walkTurn);
			sWalkEnd.remove(leaderProcessor.walkEnd);
			sChangeSpeed.remove(leaderProcessor.changeSpeed);
			sTransportTo.remove(leaderProcessor.transport);
			if (!destoryed) leaderProcessor.destory();
			leaderProcessor = null;
		}

		protected function addFollower(role : Role) : void
		{
			if (leaderProcessor == null)
			{
				generateLeaderProcessor();
			}
			leaderProcessor.addFollower(role.followerProcessor);
		}

		// =======================
		// UI
		// =======================
		private var uiList : Vector.<DisplayObject> = new Vector.<DisplayObject>();

		public function uiAdd(displayObject : DisplayObject) : void
		{
			if (displayObject == null) return;
			if (uiList.indexOf(displayObject) != -1) return;
			displayObject.x = x;
			displayObject.y = y;
			UIMediator.cAdd.call(displayObject);
			uiList.push(displayObject);
			if (uiList.length == 1)
			{
				sDestory.add(uiRemoveAll);
				sPosition.add(uiPositionUpdate);
			}
		}

		public function uiRemove(displayObject : DisplayObject) : void
		{
			if (displayObject == null) return;
			var index : int = uiList.indexOf(displayObject) ;
			if (index == -1) return;
			UIMediator.cRemove.call(displayObject);
			uiList.splice(index, 1);
			if (uiList.length == 0)
			{
				sDestory.remove(uiRemoveAll);
				sPosition.remove(uiPositionUpdate);
			}
		}

		public function uiRemoveAll() : void
		{
			while (uiList.length > 0)
			{
				uiRemove(uiList.shift());
			}
		}

		private function uiPositionUpdate(x : int, y : int) : void
		{
			var displayObject : DisplayObject;
			var length : int = uiList.length;
			for (var i : int = 0; i < length; i++)
			{
				displayObject = uiList[i];
				displayObject.x = x;
				displayObject.y = y;
			}
		}

		// =======================
		// GETER&SETER
		// =======================
		public function get x() : int
		{
			return position.x;
		}

		public function get y() : int
		{
			return position.y;
		}

		public function get avatar() : AvatarThumb
		{
			if (animation)
			{
				return animation.avatar;
			}
			return null;
		}
	}
}
