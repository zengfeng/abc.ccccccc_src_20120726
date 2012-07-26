package worlds.roles.cores
{
	import worlds.mediators.NpcMediator;
	import worlds.mediators.SelfMediator;
	import worlds.mediators.ToMediator;
	import worlds.roles.NpcPool;
	import worlds.roles.proessors.ais.NpcAIProcessor;

	import flash.geom.Point;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-14
	 */
	public class Npc extends Role
	{
		protected var aiProcessor : NpcAIProcessor;

		public function Npc()
		{
		}

		public function resetNpc(npcId : int) : void
		{
			resetRole(npcId);
		}

		override protected function destoryToPool() : void
		{
			NpcPool.instance.destoryObject(this, true);
		}

		public function startupAI(originX : int, originY : int, standPointList : Vector.<Point>, moveRadius : int, attackRadius : int) : void
		{
			if (aiProcessor == null)
			{
				aiProcessor = new NpcAIProcessor();
			}
			sDestory.add(destoryAI);
			SelfMediator.sDestory.add(destoryAI);
			if (moveRadius > 0)
			{
				aiProcessor.sWalkTo.add(aiWalkTo);
			}
			aiProcessor.sHitEnemy.add(aiHit);
			aiProcessor.reset(originX, originY, standPointList, moveRadius, attackRadius, x, y, SelfMediator.cbPosition.call());
			sPosition.add(aiProcessor.updatePosition);
			SelfMediator.sPosition.add(aiProcessor.enemyUpdatePosition);
		}

		private function aiWalkTo(toX : int, toY : int) : void
		{
			walkLineTo(toX, toY);
		}

		private function destoryAI() : void
		{
			sDestory.remove(destoryAI);
			SelfMediator.sTransport.remove(aiStart);
			sDestory.remove(destoryAI);
			sPosition.remove(aiProcessor.updatePosition);
			aiProcessor.destory();
			aiProcessor = null;
		}

		public function aiStart() : void
		{
			SelfMediator.sTransport.remove(aiStart);
			aiProcessor.start();
		}

		public function aiPause() : void
		{
			aiProcessor.stop();
		}

		private function aiHit() : void
		{
			trace("hitEnemy");
			walkStop();
			ToMediator.clear.call();
			SelfMediator.cWalkStop.call();
			SelfMediator.sTransport.add(aiStart);
			NpcMediator.aiHit.dispatch(id);
		}
	}
}
