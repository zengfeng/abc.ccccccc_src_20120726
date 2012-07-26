package game.module.chat
{
    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-2-27   ����2:59:45 
     */
    public class ChatTag
    {
        /** 玩家 */
        public static function player(id : int, name : String, color : Number) : String
        {
            // [p:color:name] 玩家
            return "[p:" + color + ":" + name + "]";
        }

        /** 物品 */
        public static function goods(id : int, name : String, color : Number) : String
        {
            // [g:id:color:name] 物品
            
            return "[g:" + id + ":" + color + ":" + name + "]";
        }

        /** NPC */
        public static function npc(id : int, name : String, color : Number) : String
        {
            // [n:id:color:name] NPC
            return "[n:" + id + ":" + name + ":" + color + "]";
        }
        
        /** 地图 */
        public static function map(id:int, x:int = 0, y:int = 0):String
        {
            // [m:id:x:y] 地图
            return "[m:" + id + ":" + x + ":" + y + "]";
        }
        
        /** Item */
        public static function item(info:String, name:String, color:Number):String
        {
            // [i:info_:color:name]
            return "[i:" + info + ":" + color + ":" + name + "]";
        }
        
        /** Hero */
        public static function hero(info:String, name:String, color:Number):String
        {
            // [h:info:color:name]
            return "[h:" + info + ":" + color + ":" + name + "]";
        }
        
        
    }
}
