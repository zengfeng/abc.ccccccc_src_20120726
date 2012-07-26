package game.core.user
{
	/**
	 * @author jian
	 */
	public class OtherPlayerVO
	{
		// 玩家姓名
		private var _name : String;
		// 等级
		private var _level : int;
		// 修为等级
		private var _profLevel : int;
		// 阵型ID
		private var _formationID : int;
		// 阵型等级
		private var _formationLevel : int;
		// 将领列表
		public var heroes : Array /* of VoHero */;

		public function get name() : String
		{
			return _name;
		}

		public function get level() : int
		{
			return _level;
		}

		public function get profLevel() : int
		{
			return _profLevel;
		}

		public function get formationID() : int
		{
			return _formationID;
		}

		public function get formationLevel() : int
		{
			return _formationLevel;
		}

		public function OtherPlayerVO(name : String, level : int, profLevel : int, formationID : int, formationLevel : int)
		{
			_name = name;
			_level = level;
			_profLevel = profLevel;
			_formationID = formationID;
			_formationLevel = formationLevel;
		}
	}
}
