package game.module.settings {
	/**
	 * @author yangyiqiang
	 */
	public class SettingVo {
		
		public var id:int;
		
		public var name:String;
		
		public var value:*;
		
		public function parse(xml:XML):void
		{
			id=xml.@id;
			name=xml.@name;
			value=xml.@defaultValue;
		}
	}
}
