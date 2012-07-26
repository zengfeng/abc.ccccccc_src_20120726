package game.module.userBuffStatus
{
    import com.utils.TimeUtil;
    import com.utils.UrlUtils;
    import framerate.SecondsTimer;
    import game.module.userBuffStatus.ui.BuffIcon;



    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-1 ����2:59:17
     */
    public class Buff
    {
        public var id : int = 0;
        public var iconFile:String = "buff_1.jpg";
        /** 时间 */
        protected var _time : int = 0;
        /** 时间控制器是否在运行 */
        protected var cdRuning : Boolean = false;
        /** 当前TIP内容 */
        protected var _tip : String;
        /** TIP配置 */
        public var tipConfig : String = "BUFF的TIP配置";
        /** 视图 */
        protected var _icon : BuffIcon;

        function Buff() : void
        {
        }

        /** 获取当前TIP */
        public function get tip() : String
        {
            if (!_tip)
            {
                _tip = tipConfig;
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

        /** 时间 */
        public function get time() : int
        {
            return _time;
        }

        public function set time(value : int) : void
        {
            _time = value;
            if (_time <= 0)
            {
                cdRuning = false;
                visible = false;
                SecondsTimer.removeFunction(secondsTimer);
                _time = 0;
                return;
            }

            if (icon == null)
            {
                icon = new BuffIcon(this);
            }

            var tipStr:String = tipConfig.replace(/__TIME__/gi, TimeUtil.toMMSS(_time));
			if(extendReplaceConfig)
			{
				for each(var arr:Array in extendReplaceConfig)
				{
					var fun:Function = arr[1];
					if(fun != null)
					{
						tipStr = tipStr.replace(arr[0], fun.apply());
					}
					else
					{
						tipStr = tipStr.replace(arr[0], arr[1]);
					}
				}
			}
			tip = tipStr;
            icon.time = _time;

            if (cdRuning == false)
            {
                cdRuning = true;
                SecondsTimer.addFunction(secondsTimer);
            }
            visible = true;
        }
		
		private var extendReplaceConfig:Array;
		public function extendReplace(array:Array):void
		{
			extendReplaceConfig = array;
            var tipStr:String = tipConfig.replace(/__TIME__/gi, TimeUtil.toMMSS(_time));
			if(extendReplaceConfig)
			{
				for each(var arr:Array in extendReplaceConfig)
				{
					var fun:Function = arr[1];
					if(fun != null)
					{
						tipStr = tipStr.replace(arr[0], fun.apply());
					}
					else
					{
						tipStr = tipStr.replace(arr[0], arr[1]);
					}
				}
			}
			tip = tipStr;
		}

        /** 秒运行 */
        private function secondsTimer() : void
        {
            time -= 1;
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
            runVisibleChangeCall();
        }

        /** 视图 */
        public function get icon() : BuffIcon
        {
            return _icon;
        }

        public function set icon(value : BuffIcon) : void
        {
            _icon = value;
        }

        /** icon图片路径 */
        public function get url() : String
        {
            return UrlUtils.getBuffIcon(iconFile);
        }

        /** 显示改变回调函数列表 */
        protected var visibleChangeCallList : Vector.<Function> = new Vector.<Function>();

        /** 添加显示改变回调函数 */
        public function addVisibleChangeCall(fun : Function) : void
        {
            if (fun == null) return;
            var index : int = visibleChangeCallList.indexOf(fun);
            if (index == -1)
            {
                visibleChangeCallList.push(fun);
            }
        }

        /** 移除显示改变回调函数 */
        public function removeVisibleChangeCall(fun : Function) : void
        {
            if (fun == null) return;
            var index : int = visibleChangeCallList.indexOf(fun);
            if (index != -1)
            {
                visibleChangeCallList.splice(index, 1);
            }
        }

        /** 运行显示改变回调函数 */
        protected function runVisibleChangeCall() : void
        {
            var fun : Function;
            for (var i : int = 0; i < visibleChangeCallList.length; i++)
            {
                fun = visibleChangeCallList[i];
                fun.apply(null, [visible]);
            }
        }
    }
}
