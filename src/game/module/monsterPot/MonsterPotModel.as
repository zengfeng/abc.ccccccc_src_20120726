package game.module.monsterPot
{
	/**
	 * @author jian
	 */
	public class MonsterPotModel
	{
		// ===============================================================
		// 属性
		// ===============================================================
		// 已开启的国度
		public var openedCountryId : int;
		public var openedMonsterId : int;
		public var maxFreeResetCount : int;
		public var maxGoldResetCount : int = 0;
		public var currentCountryId : int = 0;
		public var countries : Array /* of MonsterCountryVO */;
		public var resetPrice : int = 20;

		// ===============================================================
		// 方法
		// ===============================================================
		public function get currentCountryVO() : MonsterCountryVO
		{
			return getCountryVoById(currentCountryId);
		}

		public function getCountryVoById(countryId : uint) : MonsterCountryVO
		{
			for each (var countryVO:MonsterCountryVO in countries)
			{
				if (countryVO.countryId == countryId)
					return countryVO;
			}

			return null;
		}

		public function parseXmlData(xmlData : XML) : void
		{
			countries = [];
			var dataList : XMLList = xmlData.children();
			for (var i : uint = 0; i < dataList.length(); i++)
			{
				var countryVO : MonsterCountryVO = new MonsterCountryVO();
				countryVO.countryId = dataList[i].@id;
				countryVO.countryName = dataList[i].@name;
				countryVO.openLevel = dataList[i].@openLevel;
				countryVO.dropGoods = dataList[i].@goodsExplain;
				countryVO.description = "<font color='#ffffff'>进入等级 : " + countryVO.openLevel + "</font>\r<font color='#ffffff'>掉落物品 : </font><font color='#ffff00'>" + dataList[i].@goodsExplain + "</font>";
				for (var j : uint = 0; j < dataList[i].children().length(); j++)
				{
					countryVO.monsterAvatarIds.push(dataList[i].monsterItem[j].@id);
				}
				countries.push(countryVO);
			}
		}
	}
}
