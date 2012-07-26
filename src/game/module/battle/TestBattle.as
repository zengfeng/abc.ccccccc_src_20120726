package game.module.battle
{
	import flash.display.Sprite;
	import game.core.hero.HeroManager;
	import game.manager.RSSManager;
	import game.net.core.Common;
	import game.net.core.RequestData;
	import game.net.data.StoC.PropertyB;
	import game.net.data.StoC.SCBattleInfo;


	/**
	 * @author yangyiqiang
	 */
	public class TestBattle extends Sprite
	{
		public function TestBattle() : void
		{
		}
		/**
		 * 发送开始战斗
		 */
		public static function startB():void
		{
			var cmd:SCBattleInfo=new SCBattleInfo();
			cmd.randomseed=int(Math.random()*1000000);
			var i:int;
			for(i=1;i<5;i++){
				var porp:PropertyB = new PropertyB();
				porp.fname=HeroManager.instance.getTeamHeroById(i)._name;
				porp.skillid=3;
				porp.weaponid=1;
				porp.id = i;
				porp.side=0;
				porp.ftype=1;
				
				if(i == 1){
					porp.pos = 10;
				}
				if(i == 2){
					porp.pos = 8;
				}
				if(i == 3){
					porp.pos = 17;
				}
				if(i == 4){
					porp.pos = 14;
				}
				if(i == 5){
					porp.pos = 6;
				}
				
				porp.hp = 6000;     //hp
				porp.attack = int(Math.random()*800+500);    //攻击力
				porp.defend = 230;      //防御
				porp.speed = 50*i+160;  //速度
				porp.hitrate = 0.8;     //命中率
				porp.dodge = 0.6;//0.07;//躲闪率
				porp.crit = 0.4;    //暴击率
				porp.pierce = 0.4;      //破击率
				porp.counter = 0.0;     //反击率
				porp.critmul = 0.05;    //高爆率
				porp.piercedef = 0.05;  //防破率
				porp.countermul = 0.05; //高反
				porp.spelldmg= 600;    //附加法术伤害
				porp.spellmul = 0.5;    //法术伤害倍数
				porp.gaugemax = 100;    //最大聚气值
				porp.gaugeinit = 180;   //初始聚气值
				porp.gaugeuse = 180;    //聚气触发技能值
				cmd.vecpropertyb.push(porp);
			}
			
			for(i=1;i<6;i++){
				var porp1:PropertyB = new PropertyB();
				porp.fname=RSSManager.getInstance().getMosterById(porp.id).name;
				porp1.skillid=1;
				porp1.weaponid=2;
				porp1.side = 1;
				porp1.id = 4103+i;
				porp1.ftype=0;
				if(i == 1){
					porp1.pos = 1;
				}
				if(i == 2){
					porp1.pos = 14;
				}
				if(i == 3){
					porp1.pos = 10;
				}
				if(i == 4){
					porp1.pos =  8;
				}
				if(i == 5){
					porp1.pos = 6;
				}
				porp1.hp = 6000;       //hp
				porp1.attack = int(Math.random()*500+1000);    //攻击力
				porp1.defend = 230;      //防御
				porp1.speed = 20*i+200;  //速度
				porp1.hitrate = 0.8;     //命中率
				porp1.dodge = 0.03;      //躲闪率
				porp1.crit = 0.4;    //暴击率
				porp1.pierce = 0.4;      //破击率
				porp1.counter = 0.8;     //反击率
				porp1.critmul = 0.05;    //高爆率
				porp1.piercedef = 0.05;  //防破率
				porp1.countermul = 0.05; //高反
				porp1.spelldmg = 600;    //附加法术伤害
				porp1.spellmul = 0.5;    //法术伤害倍数
				porp1.gaugemax = 100;    //最大聚气值
				porp1.gaugeinit = 180;   //初始聚气值
				porp1.gaugeuse = 180;    //聚气触发技能值
				cmd.vecpropertyb.push(porp1);
			}
			Common.game_server.executeCallback(new RequestData(0x66, cmd));
		}
	}
}
