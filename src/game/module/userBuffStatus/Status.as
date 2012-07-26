package game.module.userBuffStatus
{
    import com.utils.UrlUtils;
    import flash.utils.Dictionary;
    import game.module.userBuffStatus.ui.StatusIcon;







    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-1 ����2:59:17
     */
    public class Status
    {
        public var id : int = 0;
		public var mask:int;
		public var bits:int;
        public var iconFile:String = "buff_1.jpg";
        /** 等级 */
        protected var _level : int = 0;
        /** 当前TIP内容 */
        protected var _tip : String;
        /** TIP配置字典,以level为键值 */
        protected var _tipLevelDic : Dictionary;
        /** 视图 */
        protected var _icon : StatusIcon;

        function Status() : void
        {
        }

        /** TIP配置字典,以level为键值 */
        public function get tipLevelDic() : Dictionary
        {
            if (_tipLevelDic == null)
            {
                _tipLevelDic = new Dictionary();
            }
            return _tipLevelDic;
        }

        public function set tipLevelDic(value : Dictionary) : void
        {
            _tipLevelDic = value;
        }

        protected function getTip(level : int = 0) : String
        {
            var str : String = tipLevelDic[level];
            if (!str) str = tipLevelDic[0];
            return str;
        }

        /** 获取当前TIP */
        public function get tip() : String
        {
            if (!_tip)
            {
                _tip = getTip(level);
            }
            return _tip;
        }

        public function set tip(value : String) : void
        {
            _tip = value;

            if (icon)
            {
                icon.tip = _tip;
            }
        }

        /** 等级 */
        public function get level() : int
        {
            return _level;
        }

        public function set level(value : int) : void
        {
            _level = value;
            runLevelChangeCall();
            if (_level <= 0)
            {
                visible = false;
                return;
            }
            
            if (icon == null)
            {
                icon = new StatusIcon(this);
            }
            tip = getTip(level);
            icon.level = _level;
            runLevelChangeCall();
            
            visible = true;
        }
        
        private var _visible : Boolean = false;

        public function get visible() : Boolean
        {
            return _visible;
        }

        public function set visible(value : Boolean) : void
        {
            if (_visible == value)
            {
                return;
            }

			_visible = value;
            if (_visible == true)
            {
                if (icon) icon.show();
            }
            else
            {
                if (icon) icon.hide();
            }
        }

        /** 视图 */
        public function get icon() : StatusIcon
        {
            return _icon;
        }

        public function set icon(value : StatusIcon) : void
        {
            _icon = value;
        }

        /** icon图片路径 */
        public function get url() : String
        {
            return UrlUtils.getStatusIcon(iconFile);
        }

        /** 等级改变回调函数列表 */
        protected var levelChangeCallList : Vector.<Function> = new Vector.<Function>();

        /** 添加等级改变回调函数 */
        public function addLevelChangeCall(fun : Function) : void
        {
            if (fun == null) return;
            var index : int = levelChangeCallList.indexOf(fun);
            if (index == -1)
            {
                levelChangeCallList.push(fun);
            }
        }

        /** 移除等级改变回调函数 */
        public function removeLevelChangeCall(fun : Function) : void
        {
            if (fun == null) return;
            var index : int = levelChangeCallList.indexOf(fun);
            if (index != -1)
            {
                levelChangeCallList.splice(index, 1);
            }
        }

        /** 运行等级改变回调函数 */
        protected function runLevelChangeCall() : void
        {
            var fun : Function;
            for (var i : int = 0; i < levelChangeCallList.length; i++)
            {
                fun = levelChangeCallList[i];
                fun.apply(null, [level]);
            }
        }
    }
}
