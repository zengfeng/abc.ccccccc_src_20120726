package worlds.maps.configs
{
	import flash.utils.Dictionary;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-11
	 */
	public class ParseBattleMonstersConfig
	{
		public static function parse(data : Array) : void
		{
			var dataDic : Dictionary = BattleMonstersConfigData.instance.dic;

			var npcId : int;
			var monsters : Array;
			var tempStr : String;
			var tempArr : Array;
			var tempId : int;
			var line : Array;
			for each (line in data)
			{
				npcId = line[0];
				monsters = new Array();
				tempStr = line[1];
				tempArr = tempStr.split(",");
				while (tempArr.length > 0)
				{
					tempId = parseInt(tempArr.shift());
					if (tempId > 0)
					{
						monsters.push(tempId);
					}
				}
				monsters.sort(Array.NUMERIC);
				dataDic[npcId] = monsters;
			}
		}
	}
}
