package game.core.menu
{
	import flash.display.DisplayObject;
	import game.manager.VersionManager;
	import gameui.core.GAlign;
	import gameui.manager.UIManager;
	import net.AssetData;
	import net.RESManager;




	/**
	 * @author yangyiqiang
	 */
	public class VoMenuButton
	{
		/**	  
		 *	id  		面板编号
		 *	type 		类型   1  主面板按钮    2  右侧按钮   3  上面按钮  
		 *	tips        
		 *	level       出现等级  
		 *	coexist     可以并存的面板
		 *	sortId      从左到右的平铺顺序
		 *	openId       打开当前面板时，必须一起打开的面板
		 *	classString 对应的面板类的位置
		 */
		public var id : int;

		public var name : String;

		public var type : int;

		public var level : int;

		public var tips : String;

		public var ioc : String;

		public var classString : String;

		private var _url : String;

		public var description : String;

		public var coexist : Array;

		public var sortId : int;

		public var sortIndex : int;

		public var stack : int;

		public var align : GAlign = new GAlign(-1, 0);

		public var offX : int = 0;

		public var offY : int = 0;

		public var w : int = 0;

		public var h : int = 0;

		public function get url() : String
		{
			return VersionManager.instance.getUrl(_url);
		}
		
		public function get disObj():DisplayObject
		{
			switch(type){
				case 1:
					return UIManager.getUI(new AssetData(ioc, "lang_menu"));
				break;
				case 3:
					var cls:Class=RESManager.getClass(new AssetData(ioc, "lang_menu"));
					if(!cls)return null;
					return new cls();
				break;
			}
			return null;
		}

		public function prase(xml : XML) : void
		{
			if (xml.@id == undefined) return;
			id = xml.@id;
			name = xml.@name;
			type = xml.@type;
			level = xml.@level;
			tips = xml.@tips;
			ioc = xml.@ioc;
			classString = xml.@classString;
			_url = xml.@url;
			coexist = xml.@coexist != "" ? String(xml.@coexist).split(",") : [];
			sortId = xml.@sortId != "" ? int(xml.@sortId) : 10;
			offX = xml.@x == undefined ? 0 : xml.@x;
			offY = xml.@x == undefined ? 0 : xml.@y;
			w = xml.@w == undefined ? 0 : xml.@w;
			h = xml.@h == undefined ? 0 : xml.@h;
			stack = xml.@stack;
			sortIndex = xml.@sortIndex;
			description = xml.@description;
		}
	}
}
