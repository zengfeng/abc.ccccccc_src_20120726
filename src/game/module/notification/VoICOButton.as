package game.module.notification
{
	import com.utils.RegExpUtils;
	/**
	 * @author yangyiqiang
	 */
	public class VoICOButton
	{
		public var id : int;

		public var name : String;

		public var type : int;

		public var openType : int;

		private var _tips : String;
		
		public var ioc : String;

		public var classString : String;

		public var  description : String;
		
		public var dailyId:int;

		public function getTips(paramStr : Vector.<String>,paramNum : Vector.<uint>) : String
		{
			return RegExpUtils.getRegExpContent(_tips,paramStr,paramNum);
		}
		
		public function getOldTips():String
		{
			return _tips;
		}

		public function prase(xml : XML) : void
		{
			if (xml.@id == undefined) return;
			id = xml.@id;
			name = xml.@name;
			type = xml.@type;
			openType = xml.@openType;
			_tips = xml.children();
			ioc = xml.@ioc;
			classString = xml.@classString;
			description = xml.@description;
			dailyId=xml.@dailyId;
		}
	}
}
