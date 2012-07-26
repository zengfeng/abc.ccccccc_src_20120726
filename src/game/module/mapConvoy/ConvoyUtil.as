package game.module.mapConvoy
{
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-15 ����4:14:29
     */
    public class ConvoyUtil
    {
        /** 模式是否加速 */
        public static function modelIsSpeedUp(model:int):Boolean
        {
            return model > 4;
        }
        
        /** 获取龟仙Avatar的ID */
        public static function getFollowerAvatarIdByModel(model:int):int
        {
            return ConvoyConfig.getAvatar(getQuality(model));
        }
        
        /** 获取龟仙Avatar的ID */
        public static function getFollowerAvatarId(quality:int):int
        {
            return ConvoyConfig.getAvatar(quality);
        }
        
        /** 获取香炉品质 */
        public static function getQuality(model:int):int
        {
            if(model > 4)
            {
                return model - 4;
            }
            return model;
        }
        
        public static function getSpeed(model:int):Number
        {
           return modelIsSpeedUp(model) == false ? ConvoyConfig.NORMAL_SPEED : ConvoyConfig.FAST_SPEED;
        }
    }
}
