package worlds.apis
{
	import worlds.roles.cores.Player;
	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-27
	*/
	public class Fishing
	{
		function Fishing():void
		{
			MPlayer.MODEL_FISHING_IN.add(playerIn);
			MPlayer.MODEL_FISHING_OUT.add(playerOut);
		}
		
		public function playerIn(playerId:int, modelId:int):void
		{
			var player:Player = MPlayer.getPlayer(playerId);
			player.changeModel(modelId);
		}
		
		public function playerOut(playerId:int):void
		{
			var player:Player = MPlayer.getPlayer(playerId);
			player.changeModel(0);
		}
		
	}
}
