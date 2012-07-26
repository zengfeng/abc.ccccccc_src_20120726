package game.module.battle.battleData
{
	public class tipData
	{
		public var playerName:String;
		public var playerLevel:uint;
		public var playerHp:uint;
		public var playerHPInit:uint;
		public var playerGauge:uint;
		public var playerGaugeInit:uint;
		public var playerSkillName:String;
		public var playerColor:uint
		public var playerSkillId:uint;
		
		public function tipData()
		{
		}
		public function clone():tipData
		{
			var t:tipData = new tipData();
			t.playerName = this.playerName;
			t.playerLevel = this.playerLevel;
			t.playerHp = this.playerHp;
			t.playerHPInit = this.playerHPInit
			t.playerGauge = this.playerGauge;
			t.playerGaugeInit = this.playerGaugeInit;
			t.playerSkillName = this.playerSkillName;
			t.playerColor = this.playerColor;
			return t;
		}
	}
}