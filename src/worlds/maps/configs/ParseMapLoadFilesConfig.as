package worlds.maps.configs {
	import game.config.StaticConfig;
	import game.manager.VersionManager;

	import net.ALoader;
	import net.BDSWFLoader;
	import net.LibData;
	import net.RESLoader;
	import net.SWFLoader;

	import flash.utils.Dictionary;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-13
	 */
	public class ParseMapLoadFilesConfig
	{
		public static function parse(xml : XML) : void
		{
			var dataDic : Dictionary = MapLoadFilesConfigData.instance.dic;
			var xmlList : XMLList = xml["file"];
			var file : XML;
			var mapId : int;
			var src : String;
			var key : String;
			var loadClass : String;
			var isRepeat : Boolean;
			var files : Array;
			var libData : LibData;
			var loader : ALoader;
			for each (file in xmlList)
			{
				mapId = file.@mapId;
				src = file.@src;
				src = src.replace("zh_CN", StaticConfig.langString);
				loadClass = file.@loadClass;
				isRepeat = file.@isRepeat == "true";

				key = file.@key;
				if (!key) key = null;
				files = dataDic[mapId];
				if (files == null)
				{
					dataDic[mapId] = files = [];
				}

				src = VersionManager.instance.getUrl(src);
				libData = new LibData(src, key, key ? true : false, isRepeat);
				switch(loadClass)
				{
					case  "SWFLoader":
						loader = new SWFLoader(libData);
						break;
					case  "RESLoader":
						loader = new RESLoader(libData);
						break;
					case "BDSWFLoader":
						loader = new BDSWFLoader(libData);
					default:
						loader = new RESLoader(libData);
						break;
				}
				files.push(loader);
			}
		}
	}
}
