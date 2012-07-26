package worlds.roles.cores
{
	import worlds.apis.MWorld;
	import worlds.auxiliarys.MapPoint;
	import worlds.mediators.SelfMediator;

	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-14
	*/
	public class SelfPlayer extends Player
	{
		/** 单例对像 */
		private static var _instance : SelfPlayer;

		/** 获取单例对像 */
		static public function get instance() : SelfPlayer
		{
			if (_instance == null)
			{
				_instance = new SelfPlayer(new Singleton());
			}
			return _instance;
		}

		public function SelfPlayer(singleton : Singleton)
		{
		}

		public function cacheIn() : void
		{
			setNeedMask(false);
			setGhost(false);
			setGlow(false);
			walkStop();
			removeFromLayer();
			uiRemoveAll();
		}

		public function cacheOut() : void
		{
			addToLayer();
			sPosition.add(SelfMediator.sPosition.dispatch);
			SelfMediator.cbPosition.register(getPosition);
			sWalkTurn.add(walkTurn);
			sWalkStart.add(walkTurnIndexRest);
			sWalkStart.add(SelfMediator.sWalkStart.dispatch);
			sWalkEnd.add(SelfMediator.sWalkEnd.dispatch);
			sTransportTo.add(dispatchTransport);
			sDestory.add(SelfMediator.sDestory.dispatch);
		}

		private function dispatchTransport(toX : int, toY : int) : void
		{
			toX;
			toY;
			preToX = 0;
			preToY = 0;
			SelfMediator.sTransport.dispatch();
		}

		private var walkTurnIndex : int = 0;

		private function walkTurnIndexRest() : void
		{
			walkTurnIndex = 0;
		}
		
		private var preToX:int = 0;
		private var preToY:int = 0;
		private function walkTurn(fromX : int, fromY : int, toX : int, toY : int) : void
		{
			if(!MWorld.needSendWalk) return;
			if(preToX == toX && preToY == toY) return;
			preToX = toX;
			preToY = toY;
			SelfMediator.sWalkTurn.dispatch(fromX, fromY, toX, toY);
			if (walkTurnIndex > 0)
			{
				fromX = 0;
				fromY = 0;
			}
			SelfMediator.csWalkTurn.dispatch(toX, toY, fromX, fromY);
			walkTurnIndex++;
		}

		private function getPosition() : MapPoint
		{
			return position;
		}
	}
}
class Singleton
{
}