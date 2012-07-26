package game.module.mapWorld
{
    import flash.utils.Dictionary;
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-26 ����12:28:17
     */
    public class WorldMapConfig
    {
        /** 世界地图配置 */
        public static var worldMap:Dictionary = new Dictionary();
        /** 副本地图配置 */
        public static var copyMap:Dictionary = new Dictionary();
        
        
        /** 解析配置 */
        public static function parseConfig(xml:XML):void
        {
            for each(var item:XML in xml.worldMapList[0].map)
            {
                parseWorldMapConfig(item);
            }
            
            for each(item in xml.copyMapList[0].map)
            {
                parseCopyMapConfig(item);
            }
        }
        
        /** 解析世界地图配置 */
        public static function parseWorldMapConfig(xml:XML):void
        {
            var worldMapStruct:WorldMapStruct = new WorldMapStruct();
            worldMapStruct.id = xml.@id;
            worldMapStruct.name = xml.@name;
            worldMapStruct.openLevel = xml.@openLevel;
            worldMapStruct.parentMap = 0;
            worldMap[worldMapStruct.id] = worldMapStruct;
        }
        
        /** 解析副本地图配置 */
        public static function parseCopyMapConfig(xml:XML):void
        {
            var worldMapStruct:WorldMapStruct = new WorldMapStruct();
            worldMapStruct.id = xml.@id;
            worldMapStruct.name = xml.@name;
            worldMapStruct.openLevel = xml.@openLevel;
            worldMapStruct.parentMap = xml.@parentMap;
            copyMap[worldMapStruct.id] = worldMapStruct;
        }
        
    }
}
