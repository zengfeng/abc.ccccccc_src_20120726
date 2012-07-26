package game.module.settings {
	import flash.utils.Dictionary;
	import game.net.core.Common;

	/**
	 * @author yangyiqiang
	 */
	public class SettingData {
		
		private static var _data:Dictionary=new Dictionary(true);
		
		public static function getDataById(id:int):Boolean
		{
			if(!_data[id])return false;
			return _data[id]["value"] as Boolean; 
		}
		
		public static function setDataById(id:int,value:Boolean):void
		{
			if(!_data[id])return;
			_data[id]["value"]=value;
			Common.los.setAt("setting", toObject());
			Common.los.flush();
		}
		
		public static function initVo(vo:SettingVo):void
		{
			_data[vo.id]=vo;
		}
				
		public static function toObject() : Object {
			var result : Object = new Object();
			for each(var vo:SettingVo in _data){
				result[vo.id.toString()]=vo.value;
			}
			return result;
		}

		public  static function parseObj(value : Object) : void {
			if (value == null) return;
			for each(var vo:SettingVo in _data){
				if(!value.hasOwnProperty(vo.id.toString()))continue;
				vo.value=value[vo.id.toString()];					
			}
		}
	}
}
