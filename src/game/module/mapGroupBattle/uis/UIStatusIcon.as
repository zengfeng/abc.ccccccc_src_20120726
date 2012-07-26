package game.module.mapGroupBattle.uis
{
	import net.AssetData;
	import net.RESManager;

	import flash.display.BitmapData;
	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-3
	 */
	public class UIStatusIcon
	{
		 /** 在交战区处于休息状态ICON */
        private static var _restIcon : BitmapData;
        /** 在交战区处于休息状态ICON */
        public static function get restIcon() : BitmapData
        {
            if (_restIcon == null)
            {
                _restIcon = RESManager.getBitmapData(new AssetData("GroupBattle_StatusRestIcon"));
            }
            return _restIcon;
        }
        
        
        /** 战斗状态ICON */
        private static var _vsIcon : BitmapData;
        /** 战斗状态ICON */
        public static function get vsIcon() : BitmapData
        {
            if (_vsIcon == null)
            {
                _vsIcon = RESManager.getBitmapData(new AssetData("GroupBattle_StatusVsIcon"));
            }
            return _vsIcon;
        }
        
        
        /** 等待状态ICON */
        private static var _waitIcon : BitmapData;
        /** 等待状态ICON */
        public static function get waitIcon() : BitmapData
        {
            if (_waitIcon == null)
            {
                _waitIcon = RESManager.getBitmapData(new AssetData("GroupBattle_StatusWaitIcon"));
            }
            return _waitIcon;
        }
        
        
        /** 死亡状态ICON */
        private static var _dieIcon : BitmapData;
        /** 死亡状态ICON */
        public static function get dieIcon() : BitmapData
        {
            if (_dieIcon == null)
            {
                _dieIcon = null;
            }
            return _dieIcon;
        }
        
        public static function clear():void
        {
            if(_restIcon) _restIcon.dispose();
            _restIcon = null;
            
            if(_vsIcon) _vsIcon.dispose();
            _vsIcon = null;
            
            if(_waitIcon) _waitIcon.dispose();
            _waitIcon = null;
            
            if(_waitIcon) _waitIcon.dispose();
            _waitIcon = null;
            
            if(_dieIcon) _dieIcon.dispose();
            _dieIcon = null;
        }
	}
}
