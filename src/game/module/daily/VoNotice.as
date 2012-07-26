package game.module.daily
{
	import com.utils.ColorUtils;
	import com.utils.StringUtils;
	import game.manager.VersionManager;

	/**
	 * @author zhangzheng
	 */
	public class VoNotice {
		
		public static var DEFAULT_DESC:Array ;
		
		public static var DEFAULT_JOIN:String ;
		
		private var _id:int ;
		private var _name:String ;
		private var _desc:Array ;
		private var _join:String ;
		private var _icon:String ;
		
//		public function set id(value:int):void
//		{
//			_id = value ;
//		}
		public function get id():int
		{
			return _id ;
		}
//		public function set name(value:String):void
//		{
//			_name = value ;
//		}
		public function get name():String
		{
			return _name ;
		}
//		public function set desc( value:Vector.<String> ):void
//		{
//			_desc = value ;
//		}
		public function description(state:int):String
		{
			if( _desc != null && _desc.length > state )
			{
				return (_desc[state] as String).replace(/_NAME_/g, StringUtils.addColor(_name,ColorUtils.HIGHLIGHT_DARK) );
			}
			return (DEFAULT_DESC[state] as String).replace(/_NAME_/g,StringUtils.addColor(_name,ColorUtils.HIGHLIGHT_DARK) );
		}
		
//		public function set joinString( str:String ):void
//		{
//			_join = str ;
//		}
		
		public function get joinString():String{
			return _join == null ? DEFAULT_JOIN : _join ;
		}
		
//		public function set iconUrl( url:String ):void{
//			_icon = url ;
//		}
		
		public function get iconUrl():String
		{
			return VersionManager.instance.getUrl( _icon == null ?  "assets/ico/daily/daily" + _id + ".png": _icon ) ;
		}
		
		public function parse(xml:XML):void
		{
			_id = xml.@id ;
			_name = xml.@name ;
			if( xml.@desc != undefined )
				_desc = xml.@desc.split("|");
			_join = xml.@join == undefined ? null : xml.@join ;
			_icon = xml.@icon == undefined ? null : xml.@icon ;
		}
	}
}
