package com.utils
{
	import game.core.hero.VoHero;
	import game.core.user.UserData;

	/**
	 * @author yangyiqiang
	 */
	public class HeroUtils
	{
		// =====================
		// 定义
		// =====================
		public static const ONTEAM_HERO:uint = 0;
		public static const OFFTEAM_HERO:uint = 1;
		public static const ALL_HERO:uint = 2;
		
		// =====================
		// 方法
		// =====================
		public static function getIdByMale(job : uint, isMale : Boolean) : int
		{
			var id : int;
			switch(job)
			{
				case 1:
					id = isMale == true ? 1 : 2;
					break;
				case 2:
					id = isMale == true ? 3 : 4;
					break;
				case 3:
					id = isMale == true ? 5 : 6;
					break;
				default:
					id = 1;
			}
			return id;
		}

		/*
		 * 获取性别 0 男   1 女
		 */
		public static function getMySex() : uint
		{
			return UserData.instance.myHero.id % 2 == 0 ? 1 : 0;
		}

		private static  var JOB_NAME : Array = ["主将","金刚", "修罗", "天师"];

		public static function getJobName(job : uint) : String
		{
			if (job >= 0 && job < 4) return JOB_NAME[job];
			return "";
		}

		public static function sortFun(a : VoHero, b : VoHero) : int
		{
			if (a.id == UserData.instance.myHero.id) 
				return -1;
			if (b.id == UserData.instance.myHero.id) 
				return 1;
			if (a.state != b.state) return b.state - a.state;
			if (a.color != b.color) return b.color - a.color;
			return a.id - b.id;
//			if (a.level != b.level) return b.level - a.level;
//			if (a.potential != b.potential) return b.potential - a.potential;
//			return 0;
		}
		
		
		public static function sortOtherHeroColor(a : VoHero, b : VoHero) : int
		{
			if (a.color != b.color) return b.color - a.color;
//			if (a.id != b.id) 
			return b.id - a.id;
//			if (a.level != b.level) return b.level - a.level;
//			if (a.potential != b.potential) return b.potential - a.potential;
//			return 0;
		}
		
		public static function filterOtherHeroColor(hero :VoHero, index:int, arr:Array):Boolean
		{
			return isHighFindHero(hero.id);
//			if(hero.color==ColorUtils.GREEN||hero.color==ColorUtils.BLUE)
//			{
//			return true;
//			}
//			else
//			{
//				return false;
//			}
		}
		
		public static function isHighFindHero(heroId:int):Boolean
		{
			return heroId>=21 && heroId<=29;
		}
	}
}
