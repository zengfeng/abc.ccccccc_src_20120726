package com.utils
{
    import flash.display.DisplayObject;
    import gameui.manager.UIManager;
    import flash.display.Stage;
    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-3-1   ����3:18:58 
     */
    public class UIUtil
    {
        /** 场景舞台 */
        public static function get stage():Stage
        {
            return UIManager.stage;
        }
        
        /** 对齐屏幕中间 */
        public static function alignStageCenter(displayObject:DisplayObject):void
        {
            displayObject.x = (stage.stageWidth - displayObject.width) / 2;
            displayObject.y = (stage.stageHeight - displayObject.height) / 2;
        }
        
        /** 水平对齐屏幕中间 */
        public static function alignStageHCenter(displayObject:DisplayObject):void
        {
            displayObject.x = (stage.stageWidth - displayObject.width) / 2;
        }
        
        /** 垂直对齐屏幕中间 */
        public static function alignStageVCenter(displayObject:DisplayObject):void
        {
            displayObject.y = (stage.stageHeight - displayObject.height) / 2;
        }
    }
}
