package game.module.mapFishing
{
	import flash.utils.Dictionary;
	import game.module.mapFishing.element.FishingPlayer;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-15 ����11:33:08
     * 运镖玩家管理器
     */
    public class FishingPlayerManager
    {
        public function FishingPlayerManager(singleton : Singleton)
        {
            singleton;
        }

        /** 单例对像 */
        private static var _instance : FishingPlayerManager;

        /** 获取单例对像 */
        static public function get instance() : FishingPlayerManager
        {
            if (_instance == null)
            {
                _instance = new FishingPlayerManager(new Singleton());
            }
            return _instance;
        }
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        private var playerDic:Dictionary = new Dictionary();
        
        public function addPlayer(fishingPlayer:FishingPlayer):void
        {
            playerDic[fishingPlayer.playerId] = fishingPlayer;
        }
        
        public function removePlayer(playerId:int):void
        {
            delete playerDic[playerId];
        }
        
        public function getPlayer(playerId:int):FishingPlayer
        {
            return playerDic[playerId];
        }
        
        public function havePlayer(playerId:int):Boolean
        {
            return playerDic[playerId] ? true : false;
        }
        
        public function clear():void
        {
            for(var key:String in playerDic)
            {
                delete playerDic[key];
            }
        }
    }
}
class Singleton
{
    
}