package game.module.userBuffStatus.ui
{
    import flash.display.DisplayObject;
    import gameui.core.GComponent;
    import gameui.core.GComponentData;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-1 ����2:33:32
     */
    public class BuffStatusContainer extends GComponent
    {
            
        function BuffStatusContainer(singleton : Singleton) : void
        {
            singleton;
            _base = new GComponentData();
            _base.width = 140;
            _base.height = 25;
            super(_base);
        }

        /** 单例对像 */
        private static var _instance : BuffStatusContainer;

        /** 获取单例对像 */
        public static function get instance() : BuffStatusContainer
        {
            if (_instance == null)
            {
                _instance = new BuffStatusContainer(new Singleton());
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        
        public function addIcon(icon:DisplayObject):void
        {
            if(icon == null || contains(icon) == true) return;
            addChild(icon);
            sortIcon();
        }
        
        public function removeIcon(icon:DisplayObject):void
        {
            if(icon == null || contains(icon) == false) return;
            removeChild(icon);
            sortIcon();
        }
        
        private var gapH:int = 5;
        private var gapV:int = 5;
        private var iconWidth:int = 25;
		private var maxRandCount:int = 4;
        public function sortIcon():void
        {
            var icon:DisplayObject;
			var row:int = 0;
			var rand:int = 0;
            for(var i:int = 0; i < numChildren; i++)
            {
                icon = getChildAt(i);
				row = Math.floor(i / maxRandCount);
				rand = i - row * maxRandCount;
                icon.x = (iconWidth + gapH) * rand;
                icon.y = (iconWidth + gapV) * row;
            }
        }
        
    }
}

class Singleton
{
    
}
