package game.module.battle.battleData
{
	import game.module.battle.BattleField;
	import game.module.battle.BattleFighter;
	import game.module.battle.ForRand;
	import game.module.battle.Formation;
	import game.module.battle.Player;
	import game.module.battle.view.BTSystem;
	import log4a.Logger;
	
	
	
	public class BattleSimulator extends BattleField
	{
		static public  function  CompLess(lhs:BattleFighter , rhs:BattleFighter):int           //耗血由大到小排
		{
			if( lhs.getHpConsume() > rhs.getHpConsume())
				return -1;
			else if(lhs.getHpConsume() == rhs.getHpConsume())
				return 0;
			else 
				return 1;
		}
		
		public function BattleSimulator( player1:Player, player2:Player, location:uint, maxTurns:uint = 4294967295 )
		{
			super();
			_player[0] = player1;
			_player[1] = player2;
			_portrait[0] = 0;
			_portrait[1] = 0;
			//将将领加入阵中
			player1.put(this as BattleSimulator, 0);
			player2.put(this as BattleSimulator, 1);
		}
		
		private function getId():int
		{
			return _id;
		}
		
		private function getTurns():int
		{
			return _turns;
		}
		
		private function getMilliSecs():int
		{
			return _millisecs;
		}
		
		private function getWinner():int
		{
			return _winner;
		}
		
		private function setPortrait(side:uint, por:uint):void
		{
			_portrait[side] = por;
		}
		
		private function getMaxAction():int
		{
			return _maxAction;
		}
		
		private function setMaxAction(mxA:int):void
		{
			_maxAction = mxA;
		}
		
		public function newFighter(prop:PropInfo2Base, weaponType:uint, skillId:uint, side:uint, pos:uint, nstr:String, fID:uint, jobID:uint):BattleFighter
		{
			var pEf:PointEffect = Formation.Formationlist[fID];
			var bft:BattleFighter = new BattleFighter(prop, weaponType, skillId, side, pos, nstr, pEf, jobID);
			setObject(side, pos, bft);
			return bft;
		}
		
		private function getRandomFighter(side:uint, excepts:Array):BattleFighter
		{
			var posList:Array = [];
			var posSize:uint = 0;
			for(var i:int = 0; i < 25; ++i)
			{
				var bft:BattleFighter = _objs[side][i];
				if(bft == null || bft.getHP() == 0)
					continue;
				var except:Boolean = false;
				for(var j:int = 0; j < excepts.length; ++j)
				{
					if(excepts[j] == i)
					{
						except = true;
						break;
					}
				}
				if(except)
				{
					continue;
				}
				posList[posSize++] = i;
			}
			if(posSize == 0)
			{
				return null;
			}
			return _objs[side][posList[int(ForRand.getRand(posSize))]];
		}
	
		private function onDead(bo:BattleFighter):void
		{
			if(bo != null)
			{

				var toremove:FighterStatus = new FighterStatus();
				toremove.bfgt = bo;
				removeFighterStatus(toremove);
				
				_winner = testWinner();
			}
		}
		
        private function testWinner():uint
		{
		   var c:uint = _fgtlist.length;
		   var alive:Array = [0,0];
		   for(var i:int = 0; i < c; ++i)
		   {
			   if((_fgtlist[i].bfgt as BattleFighter).getHP() > 0)
				   alive[_fgtlist[i].bfgt.getSide()]++;
		   }
		   
		   if(alive[0] == 0)
		   {
			   return 2;
		   }
		   else if(alive[1] == 0)
		   {
			   return 1;
		   }
		   return 0; 
	   }
	   
		
	   public function start():int                //战斗开始
	   {	
		   ///Logger.debug("**********Begin to Fight*********");
		   		   
		   //设置阵型buffer
		   addBufferByFormation();
		   
		   //设置选择规则
		   setAntiAction();
		   
		   //为战斗表现，判断战斗前阵上所有人的buff状态（目前仅有聚气这一种）
		   getNowBuffEfft();
		   
		   //初始tip
		   getInitGaugeAndHP();
		   
		   var act_count:uint = 0;
		   _winner = testWinner();
		   while(_winner == 0)
		   {
			   var pos:int = findFirstAttacker();
			   act_count += doAttack(pos);
		   }
		   
		   if(act_count == 0)
		   {
			   _winner = 1;
		   }
		   return _winner;
	   }
	   
	   private function getNowBuffEfft():void
	   {
		   var i:int;
		   var j:int;
		   for(i = 0; i < 2; ++i)
		   {
			   for(j = 0; j < 25; ++j)
			   {
				   var bf:BattleFighter = _objs[i][j];
				   if(bf != null)
				   {
					   //判断聚气
					   if(bf.getGauge() >= bf.getTrigger())
					   {
						   bf.setbHasGaugebuff(true);
							   
						   var btPro:BtBuffProcess = new BtBuffProcess();
						   var bs:BtStatus = new BtStatus();
						   bs.atkorBackatk = 2;
						   bs.sideFrom = bf.getSide();
						   bs.toside = bf.getSide();
						   bs.fpos = bf.getPos();
						   bs.tpos = bf.getPos();
						   bs.skillid = skillType.GAUGEFULL;
						   bs.type = 1;   //聚气满
						   btPro.StatusList.push(bs);
						   BtBuffProcess.data.push(btPro);
					   }
				   }
			   }
		   }
	   }
	   
	   private function getInitGaugeAndHP():void
	   {
		   var i:uint;
		   var j:uint;
		   for(i = 0; i < 2; ++i)
		   {
			   for(j = 0; j < 25; ++j)
			   {
				   var bf:BattleFighter = _objs[i][j];
				   if(bf)
				   {
					   var bin:BtInit = new BtInit();
					   bin.pside = bf.getSide();
					   bin.ppos = bf.getPos();
					   bin.pHp = bf.getHP();
					   bin.pGauge = bf.getGauge();
					   BtInitProcess.data.push(bin);
				   }
			   }
		   }
	   }
	   
	   private function setAntiAction():void
	   {
		   var maxa:int = 0;
		   var i:int;
		   var j:int;
		   for(i = 0; i < 2; ++i)
		   {
			   for(j = 0; j < 25; ++j)
			   {
				   var pf1:BattleFighter = _objs[i][j];
				   if(pf1 != null)
				   {
					   if(maxa < pf1.getSpeed())
					   {
						   maxa = pf1.getSpeed();
					   }
				   }
			   }
		   }
		   setMaxAction(maxa);               //设置最大的action
		   
		   for(i = 0; i < 2; ++i)
		   {
			   for(j = 0; j < 25; ++j )
			   {
				   var pf2:BattleFighter = _objs[i][j];
				   if(pf2 != null)
				   {
					   pf2.setCoolDown(uint((maxa * maxa)/pf2.getSpeed()));
					   var fs:FighterStatus = new FighterStatus(pf2, maxa, pf2.getCoolDown());
					   insertFighterStatus(fs);
				   }
			   }
		   }
	   }
	   
	   private function insertFighterStatus(fs:FighterStatus):void
	   {
		   var cnt:int = _fgtlist.length;
		   var tempA:Array = [];
		   for(var i:int = cnt-1; i >= 0; --i)
		   {
			   if(_fgtlist[i].antiAction < fs.antiAction)
			   {
				//   _fgtlist.splice(i+1,1,fs);
				   tempA = _fgtlist.splice(i+1);
				   _fgtlist.push(fs);
				   _fgtlist = _fgtlist.concat(tempA);
				   return;
			   }
		   }
		   _fgtlist.unshift(fs);
	   }
	   
	   private function removeFighterStatus(fs:FighterStatus):void
	   {
		   var c:uint = _fgtlist.length;
		   var i:uint = 0;
		   while(i < c)
		   {
			   if(_fgtlist[i].bfgt == fs.bfgt)
			   {
				   _fgtlist.splice(i, 1);
				   --c;
			   }
			   else
			   {
				   ++i
			   }
		   }
	   }
	   
	   private function removeFSByMark(pf:BattleFighter, mark:uint):void       //删除动作队列中已经存在的来自同一个人的动作
	   {
		   var c:uint = _fgtlist.length;
		   var i:uint = 0;
		   while(i < c)
		   {
			   if( _fgtlist[i].atkMark != 0 && _fgtlist[i].atkMark == mark && _fgtlist[i].bfgt == pf )
			   {
				   _fgtlist.splice(i, 1);
				   --c;
			   }
			   else
			   {
				   ++i;
			   }
		   }
	   }
	   
	   private function doAttack(pos:int):uint
	   {
		   var fs:FighterStatus = _fgtlist[pos];
		   var bf:BattleFighter = fs.bfgt;
		   if(bf == null)
		   {
			   return 0;
		   }
		   
		   //给客户端数据
		   var pPro:BtProcess = new BtProcess();
		   
		   _fgtlist.splice(pos, 1);
		   
		   //update all action points
		   var minact:uint = fs.antiAction;
		   for(var i:int = 0; i < _fgtlist.length; ++i)
		   {
			   if(_fgtlist[i].bfgt.getHP() == 0)
				   continue;
			   _fgtlist[i].MinusAction(minact);
		   }
		   
		   //此处判断中毒效果
		   if(fs.poisonAction)
		   {
			   var hpnowA:int = bf.getHP();
			   if(bf.getHP() > 0)
			   {
				   var fdmg:int = fs.poisonDamage;
				   bf.makeDamage(fdmg);
				   var rd:uint = bf.getPRound();
				   bf.setPRound(--rd);
				   var bdie:int = 0;
				   var hpnowB:uint = bf.getHP();
				   if(bf.getHP() == 0)
				   {
					   onDead(bf);
					   bdie = 1;
				   }
				   
				   // Logger.debug("Posion------------------------------------");
				   // Logger.debug("Posion:" +  "side:" + bf.getSide() + "  Pos:" + bf.getPos() +"  HPDamage" + fdmg);
				   
				   var pBuf:BtStatus = new BtStatus();
				   pBuf.atkorBackatk = 0;
				   pBuf.data = -fdmg;
				   pBuf.letDie = bdie;
				   pBuf.skillab = 0;
				   bf.MinusBuffRound(skillType.POISONTYPE, pPro, 0, pBuf);
			   }
			   return 1;
		   }
		   else
		   {
			   //有加速buff，减少一轮
			   bf.MinusBuffRound(skillType.SPEEDTYPE, pPro, 0);
			   
			   //有加速速buff,减少一轮
			   bf.MinusBuffRound(skillType.SLOWTYPE, pPro, 0);
			   			     			   			   
			   fs.resetAntiAction();
			   insertFighterStatus(fs);
		   }
		   
		   //判断是否是眩晕
		   var stun:uint = bf.getStunRound();
		   if(stun > 0)
		   {
			   --stun;
			   bf.setStunRound(stun);
			   if(stun >= 0)
			   {
				   
				   ///Logger.debug("stun------------------------------------");
				   ///Logger.debug("OnStun:" + bf.getSide() + "/" + bf.getPos());
				   bf.MinusBuffRound(skillType.STUNTYPE, pPro, 0);
				   return 0; 
			   }
		   }
		   
		   setAllPlayerDodge(false);
		   
		   if(bf.getGauge() >= bf.getTrigger())
		   {
			   //技能攻击
			   doSkillAttack(bf, pPro);
		   }
		   else
		   {
			   //物理攻击
			   doPhyAttack(bf, pPro);
		   }
		   
		   
		   //有暴击buff的,减少一轮
		   bf.MinusBuffRound(skillType.ADDCRIT, pPro, 0);
		   
		   //有破击buff，减少一轮
		   bf.MinusBuffRound(skillType.ADDPIERCE, pPro, 0);
		   
		   //有降低命中率的buff,去掉一轮
		   bf.MinusBuffRound(skillType.REDUCEHITRATE, pPro, 0);
	
		   //有加攻击的，减少一轮buff
		   bf.MinusBuffRound(skillType.ADDATTACK, pPro, 0);
		   
		   //有给自己加攻击的，减少一轮
		   bf.MinusBuffRound(skillType.ADDMYSELFATTACK, pPro, 0);
		   
		   //有减攻击的buff,减少一轮
		   bf.MinusBuffRound(skillType.REDUCEATTACK, pPro, 0);
		   
		   return 1;
	   }
	   
	   
	   private function attackOncePhy(bf:BattleFighter, targetbf:BattleFighter, factor:Number, counter_deny:int, isCrit:Boolean, ispierce:Boolean, bGather:Boolean, pPro:BtProcess):uint
	   {
		   if(targetbf == null || targetbf.getHP() == 0)
			   return 0; 
		   var fdmg:int;
		   var defender:BtDefend = new BtDefend();
		   defender.pos = targetbf.getPos();
	
		   if(bf.isCalcHit(targetbf))     //命中
		   {
			   var dmg:Number;
			   if(isCrit && ispierce)     //暴破
			   {
				   dmg = bf.calcCritpiercePhyAtk(targetbf);
			   }
			   else if(isCrit)
			   {
				   dmg = bf.calcCritPhyAtk(targetbf);
			   }
			   else if (ispierce)
			   {
				   dmg = bf.calcpiercePhyAtk(targetbf);
			   }
			   else
			   {
				   dmg = bf.calcNormalPhyAtk(targetbf);
			   }
			   
			   //如果触发聚气
			   if(bGather)
			   {
				   if (isCrit && ispierce)  //触发暴破
				   {
					   bf.addQiGather(50, true, pPro, 0);
					   targetbf.addQiGather(30, true, pPro, 0);
				   }
				   else if (isCrit)
				   {
					   bf.addQiGather(40, true, pPro, 0);
					   targetbf.addQiGather(30, true, pPro, 0);
				   }
				   else if (ispierce)
				   {
					   bf.addQiGather(40, true, pPro, 0);
					   targetbf.addQiGather(30, true, pPro, 0);
				   }
				   else
				   {
					   bf.addQiGather(30, true, pPro, 0);
					   targetbf.addQiGather(30, true, pPro, 0);
				   }
			   }
			   dmg = int(dmg * factor);
			   
			   //判断格挡
			   var resisFac1:Number = targetbf.getResistanceFac();
			   fdmg = int(dmg*(1.0-resisFac1));
			   targetbf.MinusBuffRound(skillType.RESISTANCE, pPro, 0);   //来自其它人的格挡作用轮数减去一轮
			  
			   //判断伤害加深
			   var hurtFac1:Number = targetbf.getDeepHurtFac();
			   fdmg += int(dmg*hurtFac1);
			   targetbf.MinusBuffRound(skillType.DEEPHURT, pPro, 0);
			   
			   //基础伤害减免
			   fdmg -= int(dmg*targetbf.getDamageDef());
			   
			   if(fdmg < 0)
				   fdmg = 0;
			   
			   targetbf.makeDamage(uint(fdmg));
			   		   
			   //判断是否dead
			   if(targetbf.getHP() == 0)
			   {
				   onDead(targetbf);
			   }
			   		   
			   defender.damage = fdmg;   //显示伤害
			   defender.leftHp = targetbf.getHP();
			   trace(defender.leftHp);
			   
			  ///Logger.debug("PHYSIC:-"+bf.getSide()+"-"+bf.getPos()+"-"+targetbf.getPos()+"--HPDmg"+fdmg);
		   }
		   else
		   {
			   //首要目标躲闪,聚气
			   if(bGather)
			   {
				   //攻击方
				   bf.addQiGather(30, true, pPro, 0);
	
				   //被攻击方
				   targetbf.addQiGather(30, true, pPro, 0);
			   }	
			   ///Logger.debug("PHYSIC:-"+bf.getSide()+"-"+bf.getPos()+"-"+targetbf.getPos()+"--Miss");
			   defender.damage = -1;   //显示伤害
			   defender.leftHp = targetbf.getHP();
		   }
		   
		   
		   //判断反击
		   if(_winner == 0 && counter_deny > 0 && bf.getHP() > 0 && targetbf.getHP() > 0 && targetbf.isCounter() && bGather) //首要目标才能触发反击
		   {
			   //如果命中
			   if(targetbf.isCalcHit(bf))
			   {
				   var backdmg:Number;    //反击伤害
				   var isbCrit:Boolean = false;
				   isbCrit = targetbf.isCritAttack(bf);
				   var isbpierce:Boolean = false;
				   isbpierce = targetbf.ispierceAttack(bf);
				   if(isbCrit && isbpierce)   //触发暴破
				   {
					   backdmg = targetbf.calcCritpiercePhyAtk(bf);
				   }
				   else if(isbCrit)
				   {
					   backdmg = targetbf.calcCritPhyAtk(bf);
				   }
				   else if(isbpierce)
				   {
					   backdmg = targetbf.calcpiercePhyAtk(bf);
				   }
				   else
				   {
					   backdmg = targetbf.calcNormalPhyAtk(bf);
				   }
				   
				   //加上反击伤害系数
				   var fbackdmg:int;
				   backdmg = int(backdmg * targetbf.calcBackAtkMultiple());
				   
				   //判断格挡
				   var resisFac2:Number = bf.getResistanceFac();
				   fbackdmg = int(backdmg*(1-resisFac2));
				   targetbf.MinusBuffRound(skillType.RESISTANCE, pPro, 1);   //来自其它人的格挡作用轮数减去一轮
				   
				   //判断伤害加深
				   var hurtFac2:Number = bf.getDeepHurtFac();
				   fbackdmg += int(backdmg*hurtFac2);
				   bf.MinusBuffRound(skillType.DEEPHURT, pPro, 1);
				   
				   //基础伤害减免
				   fbackdmg -= int(backdmg*bf.getDamageDef());
				   
				   bf.makeDamage(uint(fbackdmg));
				   
				   defender.counterDmg = fbackdmg;
				   defender.counterLeft = bf.getHP();
				   
				   if(bf.getHP() == 0)
				   {
					   onDead(bf);
				   }
				   
				   //反击命中，首要被攻击者和攻击者聚气
				   if(bGather)
				   {
					   targetbf.addQiGather(0, true, pPro, 1);
					   bf.addQiGather(0, true, pPro, 1);
				   }
				   
				   ///Logger.debug("BackAttack BackDmg: "+fbackdmg);
			   }
			   else
			   {
				   //反击被闪避
				   defender.counterDmg = -1;
				   defender.counterLeft = bf.getHP();
				   ///Logger.debug("BackAttack Miss:");
			   }
		   }
		   
		   //有闪避的，减少一轮
		   targetbf.MinusBuffRound(skillType.ADDDODGE, pPro, 0);
		   //有添加防御的buff
		   targetbf.MinusBuffRound(skillType.ADDDEFEND, pPro, 0);
		   //有降低受到的法术伤害的buff
		//   targetbf.MinusBuffRound(skillType.REDUCESPELLDMG, pPro, 0);
		   
		   //有降低受到的暴击概率的buff，减少一轮
		   targetbf.MinusBuffRound(skillType.REBECRITPROB, pPro, 0);
		   
		   //有降低受到的破击概率的buff，减少一轮
		   targetbf.MinusBuffRound(skillType.REBEPIERCEPROB, pPro, 0);
		   
		   //有反击buff的，减少一轮
		   targetbf.MinusBuffRound(skillType.ADDCOUNTER, pPro, 0);
		   
		   
		   //被攻击者攻击完剩余hp，gauge
		   defender.leftHp = targetbf.getHP();
		   defender.leftGauge = targetbf.getGauge();
		  
		   //攻击者攻击完剩余hp，gauge
		   defender.aterleftHp = bf.getHP();
		   defender.aterleftGauge = bf.getGauge();
		   
		   pPro.defendList.push(defender);
		   
		   return uint(fdmg);
	   }
	   
	   private function attackOnceSpell(bf:BattleFighter, targetbf:BattleFighter, ap:Array, i:int, factor1:Number, factor2:Number, skilltype:int, isCrit:Boolean, ispierce:Boolean, bGather:Boolean, pPro:BtProcess = null):uint
	   {
		   if(bf == null || targetbf == null || targetbf.getHP() == 0 )
		   {
			   return 0; 
		   }
		   var fdmg:int;   //伤害
		   var side:uint = targetbf.getSide();
		   var pos:uint = targetbf.getPos();
		   var letDie:int = 0;
		   
		   var defender:BtDefend = new BtDefend();
		   defender.pos = targetbf.getPos();
		   
		   if(bf.isCalcHit(targetbf))    //命中
		   {
			   var dmg:Number;
			   if (isCrit && ispierce)  //触发暴破
			   {
				   dmg = bf.calcCritpierceSpellDamage(targetbf);
			   }
			   else if (isCrit)
			   {
				   dmg = bf.calcCritSpellDamage(targetbf);
			   }
			   else if (ispierce)
			   {
				   dmg = bf.calcPierceSpellDamage(targetbf);
			   }
			   else
			   {
				   dmg = bf.calcNormalSpellDamage(targetbf);
			   }
			   
			   //如果触发聚气
			   if(bGather)
			   {
				   if(isCrit && ispierce)   //触发暴破
				   {
					   bf.addQiGather(0, true, pPro, 0);
					   targetbf.addQiGather(0, true, pPro, 0);
				   }
				   else if(isCrit)
				   {
					   bf.addQiGather(0, true, pPro, 0);
					   targetbf.addQiGather(0, true, pPro, 0);
				   }
				   else if(ispierce)
				   {
					   bf.addQiGather(0, true, pPro, 0);
					   targetbf.addQiGather(0, true, pPro, 0);
				   }
				   else
				   {
					   bf.addQiGather(0, true, pPro, 0);
					   targetbf.addQiGather(0, true, pPro, 0);
				   }
			   }
			   
			 //  dmg = uint(factor1 * dmg);
			   
			   //判断格挡
			   var resisFac:Number = targetbf.getResistanceFac();
			   fdmg = int(dmg*factor1*(1-resisFac));
			   targetbf.MinusBuffRound(skillType.RESISTANCE, pPro, 0);   //来自其它人的格挡作用轮数减去一轮
			   
			   //判断伤害加深
			   var hurtFac:Number = targetbf.getDeepHurtFac();
			   fdmg += int(dmg*factor1*hurtFac);
			   targetbf.MinusBuffRound(skillType.DEEPHURT, pPro, 0);
			   
			   //基础伤害减免
			   fdmg -= int(dmg*targetbf.getDamageDef());
			   
			   //判断降低法术伤害
			   var reSpellFac:Number = targetbf.getReSpelldmgFac();
			   fdmg -= int(dmg*factor1*reSpellFac);
			   
			   if(fdmg < 0)
				   fdmg = 0;
			   
			   if(targetbf.getHP() == 0 )
				   letDie = 2;
			   if(skilltype == skillType.POISONTYPE)
				   targetbf.makeDamage(uint(fdmg) + uint(factor2 * dmg));
			   else
				   targetbf.makeDamage(uint(fdmg));
			   if(targetbf.getHP() == 0)
				   letDie = 1;
			   			   
			   if(skilltype == skillType.POISONTYPE && factor2 != 0)  //客户端表现中毒buffer
			   {
				   bf.setPRound(bf.getPRound()-1);                    //回合数减少
				   var pBuf:BtStatus = new BtStatus();
				   pBuf.atkorBackatk = 0;
				   pBuf.sideFrom = bf.getSide();
				   pBuf.toside = targetbf.getSide();
				   pBuf.fpos = bf.getPos();
				   pBuf.tpos = targetbf.getPos();
				   pBuf.skillid = bf.getSkillID();
				   pBuf.type = (targetbf.getPRound() == 0) ? 2 : 1;   //为2，加上后立马让其消失，为1则持久加上中毒buffer
				   pBuf.data = 0-uint(factor2 * dmg);
				   pBuf.letDie = letDie;
				   pBuf.skillab = 0;
				   pPro.SChangeList.push(pBuf);
			   }
			   		   

			   //判断是否dead
			   if(targetbf.getHP() == 0)
			   {
				   onDead(targetbf);
			   }
			   
			   ///if(skilltype == skillType.POISONTYPE)
				   ///Logger.debug("SKILL:"+"-"+bf.getSide()+"-"+bf.getPos()+ "-" + targetbf.getPos() + "--HPDmg:" + fdmg + "--PosionDmg:" + uint(factor2 * dmg));
			   ///else
				   ///Logger.debug("SKILL:"+"-"+bf.getSide()+"-"+bf.getPos()+ "-" + targetbf.getPos() + "--HPDmg:" + fdmg );
			
			   defender.damage = fdmg;
			   defender.leftHp = targetbf.getHP();
			   trace(defender.leftHp);
		   }
		   else
		   {
			   fdmg = 0;
			   //如果miss取消中毒，眩晕等效果
			   ap[i].type = 0;
			   
			   //首要目标躲闪，聚气
			   if(bGather)
			   {
				   targetbf.addQiGather(0, true, pPro, 0);
			   }
//			   Logger.debug("SKILLID:-"+skilltype+"-"+bf.getSide()+"-"+bf.getPos()+ "-" + targetbf.getPos() + "--Miss" );
			   
			   if(skilltype == skillType.POISONTYPE)
			   {
				   //trace("posion dodge");
			   }
			   defender.damage = -1;
			   defender.leftHp = targetbf.getHP();
			   
			   targetbf.setbDodge(true);
		   }
		   
		   
		   //有闪避的，减少一轮
		   targetbf.MinusBuffRound(skillType.ADDDODGE, pPro, 0);
		   //有添加防御的buff
		   targetbf.MinusBuffRound(skillType.ADDDEFEND, pPro, 0);
		   //有降低受到的法术伤害的buff
		   targetbf.MinusBuffRound(skillType.REDUCESPELLDMG, pPro, 0);
		   
		   //有降低受到的暴击概率的buff，减少一轮
		   targetbf.MinusBuffRound(skillType.REBECRITPROB, pPro, 0);
		   //有降低受到的破击概率的buff，减少一轮
		   targetbf.MinusBuffRound(skillType.REBEPIERCEPROB, pPro, 0);
		   
		   //有反击buff的，减少一轮
		   //targetbf.MinusBuffRound(skillType.ADDCOUNTER, pPro, 0);
		
		   
		   //被攻击者攻击完剩余hp，gauge
		   defender.leftHp = targetbf.getHP();
		   defender.leftGauge = targetbf.getGauge();
		   
		   //攻击者攻击完剩余hp，gauge
		   defender.aterleftHp = bf.getHP();
		   defender.aterleftGauge = bf.getGauge();
		   
		   pPro.defendList.push(defender);
		   
		   return uint(fdmg);
	   }
	   
	    private function attackOnceSpecial(bf:BattleFighter, targetbf:BattleFighter, ap:Array, i:int, factor1:Number, factor2:Number, skilltype:int, isCrit:Boolean, ispierce:Boolean, bGather:Boolean, additionVec:Array, pPro:BtProcess = null):uint
		{
			if(bf == null || targetbf == null || targetbf.getHP() == 0 )
			{
				return 0; 
			}
			var fdmg:uint;   //伤害
			var side:uint = targetbf.getSide();
			var pos:uint = targetbf.getPos();
			var letDie:int = 0;
			
			var defender:BtDefend = new BtDefend();
			defender.pos = targetbf.getPos();
			
			if(bf.isCalcHit(targetbf))    //命中
			{
				var dmg:Number;
				if (isCrit && ispierce)  //触发暴破
				{
					dmg = bf.calcCritpierceSpellDamage(targetbf);
				}
				else if (isCrit)
				{
					dmg = bf.calcCritSpellDamage(targetbf);
				}
				else if (ispierce)
				{
					dmg = bf.calcPierceSpellDamage(targetbf);
				}
				else
				{
					dmg = bf.calcNormalSpellDamage(targetbf);
				}
				
				//如果触发聚气
				if(bGather)
				{
					if(isCrit && ispierce)   //触发暴破
					{
						bf.addQiGather(0, true, pPro, 0);
						targetbf.addQiGather(0, true, pPro, 0);
					}
					else if(isCrit)
					{
						bf.addQiGather(0, true, pPro, 0);
						targetbf.addQiGather(0, true, pPro, 0);
					}
					else if(ispierce)
					{
						bf.addQiGather(0, true, pPro, 0);
						targetbf.addQiGather(0, true, pPro, 0);
					}
					else
					{
						bf.addQiGather(0, true, pPro, 0);
						targetbf.addQiGather(0, true, pPro, 0);
					}
				}
				
				dmg = uint(factor1 * dmg);
				
				//判断格挡
				var resisFac:Number = targetbf.getResistanceFac();
				fdmg = uint(dmg*(1-resisFac));
				targetbf.MinusBuffRound(skillType.RESISTANCE, pPro, 0);   //来自其它人的格挡作用轮数减去一轮
				
				//判断伤害加深
				var hurtFac:Number = targetbf.getDeepHurtFac();
				fdmg += uint(dmg*hurtFac);
				targetbf.MinusBuffRound(skillType.DEEPHURT, pPro, 0);
				
				//判断降低法术伤害
				var reSpellFac:Number = targetbf.getReSpelldmgFac();
				fdmg -= uint(dmg*factor1*reSpellFac);
				
				//获得攻击次数
				var atkNum:int = 0;
				var adtionFac:Number = 0;
				if (additionVec.size() >= 3)
				{
					atkNum = int(additionVec[0]);
					for (var i:int = 0; i < atkNum; i++)
					{
						if (additionVec[1] > additionVec[2])
						{
							adtionFac = additionVec[1]-additionVec[2];
							adtionFac = additionVec[2] + adtionFac*(ForRand.getRand(100)/Number(100.0));
						}
						else
						{
							adtionFac = additionVec[2]-additionVec[1];
							adtionFac = additionVec[1] + adtionFac*(ForRand.getRand(100)/Number(100.0));
						}
						
						targetbf.makeDamage(uint((fdmg + uint(factor2 * dmg))*adtionFac));
						//判断是否dead
						if (targetbf.getHP() == 0)
						{
							onDead(targetbf);
							break;
						}
					}
				}

				
				defender.damage = fdmg;
				defender.leftHp = targetbf.getHP();
//				targetbf.makeDamage(fdmg);
//				if(targetbf.getHP() == 0 )
//					letDie = 2;
//				targetbf.makeDamage(uint(factor2 * dmg));
//				if(targetbf.getHP() == 0)
//					letDie = 1;
//				
//				if(skilltype == skillType.POISONTYPE && factor2 != 0)  //客户端表现中毒buffer
//				{
//					var pBuf:BtStatus = new BtStatus();
//					pBuf.atkorBackatk = 0;
//					pBuf.sideFrom = bf.getSide();
//					pBuf.toside = targetbf.getSide();
//					pBuf.fpos = bf.getPos();
//					pBuf.tpos = targetbf.getPos();
//					pBuf.skillType = skillType.POISONTYPE;
//					pBuf.type = (targetbf.getPRound() == 0) ? 2 : 1;   //为2，加上后立马让其消失，为1则持久加上中毒buffer
//					pBuf.data = uint(factor2 * dmg);
//					pBuf.letDie = letDie;
//					pPro.SChangeList.push(pBuf);
//				}
				
			}
			else
			{
				//如果miss取消中毒，眩晕等效果
				ap[i].type = 0;
				
				//首要目标躲闪，聚气
				if(bGather)
				{
					targetbf.addQiGather(0, true, pPro, 0);
				}
				
				defender.damage = -1;
				defender.leftHp = targetbf.getHP();
			}
			
			
			//有闪避的，减少一轮
			targetbf.MinusBuffRound(skillType.ADDDODGE, pPro, 0);
			//有添加防御的buff
			targetbf.MinusBuffRound(skillType.ADDDEFEND, pPro, 0);
			//有降低受到的法术伤害的buff
			targetbf.MinusBuffRound(skillType.REDUCESPELLDMG, pPro, 0);
			
			//有降低受到的暴击概率的buff，减少一轮
			targetbf.MinusBuffRound(skillType.REBECRITPROB, pPro, 0);
			//有降低受到的破击概率的buff，减少一轮
			targetbf.MinusBuffRound(skillType.REBEPIERCEPROB, pPro, 0);
		    
			//有反击buff的，减少一轮
			//targetbf.MinusBuffRound(skillType.ADDCOUNTER, pPro, 0);
			
			//被攻击者攻击完剩余hp，gauge
			defender.leftHp = targetbf.getHP();
			defender.leftGauge = targetbf.getGauge();
			
			//攻击者攻击完剩余hp，gauge
			defender.aterleftHp = bf.getHP();
			defender.aterleftGauge = bf.getGauge();
			
			pPro.defendList.push(defender);
			
			return fdmg;
		}
		
		private function fixAttackArea(cnt:int, ap:Array, apcnt:int, target_pos:int, atkarea:Area, isFullS:Boolean, isSkill:Boolean = true):int
		{
			var x_:int = target_pos % 5;
			var y_:int = target_pos / 5;
			var p:int = 0;
			var q:int = 0;
			if(isSkill)
				p = 0;
			else
				p = 1;
			//非全屏攻击
			if(!isFullS)
			{
				for( ; p < cnt; ++p)
				{
					var ad:Data = atkarea.getDataArray()[p];
					var x:int = x_ + ad.x;
					var y:int = y_ + ad.y;
					if(x < 0 || x > 4 || y < 0 || y > 4)
					{
						continue;
					}
					var pt1:AttackPoint = new AttackPoint();
					pt1.pos = x + y * 5; 
					pt1.type = ad.skilltype;
					pt1.factor = ad.factor;
					ap[apcnt] = pt1;
					apcnt++;
				}
			}
			else //全屏攻击
			{
				var ad1:Data = atkarea.getDataArray()[0];
				for( p = 0; p < 5; ++p)
				{
					for( q = 0; q < 5; ++q)
					{
						//if((p+q*5) != (x_+y_*5))
						{
							var pt2:AttackPoint = new AttackPoint();
							pt2.pos = p + q * 5; 
							pt2.type = ad1.skilltype;
							pt2.factor = ad1.factor;
							ap[apcnt] = pt2;
							apcnt++;
						}
					}
				}
			}
			return apcnt;
		}
	   
	   	private function doPhyAttack(bf:BattleFighter, pPro:BtProcess):uint
		{
	   		var dmg:Number = 0;
			var i:int = 0;
			var j:int = 0;
		
		    //获得被攻击方的pos
	   		var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
	   		if(target_pos < 0)
	   			return 0; 
			
	   		var otherside:int = 1 - bf.getSide();
	   		var targetObj:BattleFighter = _objs[otherside][target_pos];
	   		if(targetObj == null)
				return 0; 

			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;     //攻击的首要目标
			pPro.oneAtkInfo.skillType = -1;           //物理攻击
			
	   		//被攻击方
	   		var atkarea:Area = AttackData.arealist[bf.getWeaponType()];


	   		if(atkarea == null)
			{
	   			return 0; 
			}
	   		//判断是否是全屏攻击
	   		var isFullS:Boolean = false;
	   		if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
	   		{
				isFullS = true;     //全屏攻击
	   		}
	   		
	   		var cnt:int = atkarea.getCount();
	   		
	   		//判断是否是暴击，破击，暴破
	   		var isCrit:Boolean = false;
	   		isCrit = bf.isCritAttack(targetObj);
	   		var ispierce:Boolean = false;
	   		ispierce = bf.ispierceAttack(targetObj);
			
			///Logger.debug("--------------------------------------------");
			///Logger.debug(bf.getSide()+"/"+bf.getPos()+"--"+(isCrit? 1 : 0)+"--"+ (ispierce ? 1:0));
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;       //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;     //破击
			}
	   		
	   		//根据武器攻击类型
	   		if(cnt >= 1)
			{
	   			var ap:Array = [];
	   			var apcnt:int = 0;

				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS, false);
	   			dmg = attackOncePhy(bf, targetObj, atkarea.getDataArray()[0].factor, 1, isCrit, ispierce, true, pPro);

	   			for (i = 0; i < apcnt; ++i)
	   			{
	   				attackOncePhy(bf,  _objs[otherside][ap[i].pos], ap[i].factor, -1, isCrit, ispierce, false, pPro);
	   			}
	   		}
	   		else  //攻击对象等于1
	   		{
	   			dmg = attackOncePhy(bf, targetObj, atkarea.getDataArray()[0].factor, 1, isCrit, ispierce, true, pPro);
	   		}
			
			BtProcess.data.push(pPro);
	   		return 0; 
	   	}
	   
	   
		private function doSkillAttack(bf:BattleFighter, pPro:BtProcess):uint
		{
			if(bf == null)
				return 0;
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if(atkarea == null)
				return 0;
			var skilltype:Number = atkarea.getType();
			var skilltype1:uint = (skilltype * 100) / 100;
			var skilltype2:uint = (skilltype * 100) % 100;
			
		//	if(!skilltype)
		//		return 0;    0表示不带任何效果的法术攻击
			
			///Logger.debug("--------------------------------------------");
			//变动聚值
			bf.addQiGather(bf.getTrigger(), false, pPro, 0);
			
			if(skilltype2 == 0)
			{
				switch(skilltype)
				{
					case 0:
						return NormalSkillAttack(bf, pPro);
						break;
					case skillType.POISONTYPE:
						return poisonAttack(bf, pPro);
						break;
					case skillType.STUNTYPE:
						return doStunAttack(bf, pPro);
						break;
					case skillType.SLOWTYPE:
						return doSlowDownAttack(bf, pPro);
						break;
					case skillType.ADDHP:
						return doAtkBackHp(bf, pPro);
						break;
					case skillType.SUKHP:
						return doSukHp(bf, pPro);
						break;
					case skillType.RESISTANCE:
						return doResisTance(bf, pPro);
						break;
					case skillType.DEEPHURT:
						return doDeepHurt(bf, pPro);
						break;
					case skillType.ADDCOUNTER:
						return doAddBasePropAtk(bf, skillType.ADDCOUNTER, pPro);
						break;
					case skillType.ADDCRIT:
						return doAddBasePropAtk(bf, skillType.ADDCRIT, pPro);
					case skillType.ADDATTACK:
						return doAddAttack(bf, pPro);
						break;
					case skillType.REDUCEHITRATE:
						return doReduceHitRate(bf, pPro);
						break;
					//				case skillType.MULTIPLE:
					//					return doMultipleAtk(bf, pPro);
					//					break;
					case skillType.ADDDODGE:
						return doAddBasePropAtk(bf, skillType.ADDDODGE, pPro);
						break;
					case skillType.ADDDEFEND:
						return doAddBasePropAtk(bf, skillType.ADDDEFEND, pPro);
						break;
					case skillType.ADDPIERCE:
						return doAddBasePropAtk(bf, skillType.ADDPIERCE, pPro);
						break;
					case skillType.SPEEDTYPE:
						return 	doAddSpeedAttack(bf, pPro);
						break;
					case skillType.ADDGAUGE:
						return  doAddGauge(bf, pPro);
						break;
					case skillType.REDUCESPELLDMG:
						return doReduceSpellDmg(bf, pPro);
						break;
					case skillType.REBECRITPROB:
						return doReBeCritAtk(bf, pPro);
						break;
					case skillType.REBEPIERCEPROB:
						return doReBePierceAtk(bf, pPro);
						break;
					case skillType.ADDMYSELFATTACK:
						return doAddMySelfAttack(bf, pPro);
						break;
					case skillType.REDUCEATTACK:
						return doReDuceAttack(bf, pPro);
						break;
					case skillType.IMMUNITY:
						return doImmunity(bf, pPro);
						break;
					default:
						break;
				}
			}
			else
			{
				doDoubleSkillAtk(bf, skilltype1, skilltype2, pPro);
			}


			return 0; 
		}
	   
	   
		private function NormalSkillAttack(bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if(_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos

			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if(target_pos < 0)
			{
				return 0; 
			}
			var otherside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[otherside][target_pos];
			if(targetObj == null)
				return 0; 
			
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = 0;        //普通技能攻击
				
			var atkarea:Area = AttackData.arealist[AttackData.skilllist[bf.getSkillID()].atkID];
			if(atkarea == null)
				return 0; 
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount();
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji; //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;  //破击
			}
			
			///Logger.debug(bf.getSide()+"/"+bf.getPos()+"--"+(isCrit? 1 : 0)+"--"+ (ispierce ? 1:0));
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var side:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if(psd)
				{

					for( i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, 0, isCrit, ispierce, (i == 0 ?  true:false), pPro);
					}
				}
			}
			BtProcess.data.push(pPro);
			return 0; 
			
		}
		
		private function  poisonAttack(bf:BattleFighter, pPro:BtProcess):uint    //毒攻击
		{
			if(_winner != 0)
			{
				return 0; 
			}
			
			var i:int;
			var j:int;
			var targetfighter:BattleFighter = null;
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if(target_pos < 0)
				return 0; 
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = skillType.POISONTYPE;        //中毒攻击
			
			//被攻击方
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if(atkarea == null)
				return 0; 
			
			//判断是否全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;   //全屏攻击
			}
			var cnt:int = atkarea.getCount();
			
			//判断是否暴击， 破击， 暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji; //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji; //破击
			}
			
			///Logger.debug(bf.getSide()+"/"+bf.getPos()+"--"+(isCrit? 1 : 0)+"--"+ (ispierce ? 1:0));
			
			//第一次中毒攻击
			if( cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData =  AttackData.skilllist[bf.getSkillID()];
				if(psd)
				{
					var bPoison:Boolean = true;
					var BaseSpellAtk:Number = 0;
					for( i = 0; i < psd._atkFactorVec.length; ++i)
					{
						for( j = 0; j < apcnt; ++j)
						{
							targetfighter = _objs[otherside][ap[j].pos];
							if(targetfighter == null || targetfighter.getHP() == 0)
								continue;
							if(i == 0)
							{
								//释放技能概率
								if( ForRand.getRand() > psd.prob*10000 )
								{
									bPoison = false;
									targetfighter.setbDodge(true);  //未中技能
								}
								else//删除某人已经存在来自同一人的中毒效果
								{
									removeFSByMark(targetfighter, (bf.getSide()+1)*10000+bf.getPos()*100+skillType.POISONTYPE);
								}
									
								var skillfactor:Number = 0.0;
								if(ap[i].type == skillType.POISONTYPE)
									skillfactor = psd._atkFactorVec[0];
								else 
									skillfactor = 0.0;
								
								if(!bPoison)
								{
									skillfactor = 0.0;				
								}
								else
								{
//									if(ap[j].type == 1)
//										targetfighter.setPRound(psd._atkFactorVec.length);
//									else
//										targetfighter.setPRound(0);	
								}
								
								attackOnceSpell(bf, _objs[otherside][ap[j].pos], ap, j, ap[j].factor, skillfactor, skillType.POISONTYPE, isCrit, ispierce, (j == 0 ? true:false), pPro);
								
								if(isCrit && ispierce)  //触发暴破
								{
									BaseSpellAtk = bf.calcCritpierceSpellDamage(targetfighter);
								}
								else if(isCrit)
								{
									BaseSpellAtk = bf.calcCritSpellDamage(targetfighter);
								}
								else if(ispierce)
								{
									BaseSpellAtk = bf.calcPierceSpellDamage(targetfighter);
								}
								else
								{
									BaseSpellAtk = bf.calcNormalSpellDamage(targetfighter);								
								}
								
								
								//加buff
								if( targetfighter.getbDodge() == false)
								{
									var pff:buffEffect = new buffEffect();
									pff.bfside = bf.getSide();
									pff.btoside = targetfighter.getSide();
									pff.bfpos = bf.getPos();
									pff.btpos = targetfighter.getPos();
									pff.bround = psd._atkFactorVec.length-1;
									pff.btype = skillType.POISONTYPE;
									pff.bvalue = 0;
									pff.bfirst = true;
									pff.bskillid =  bf.getSkillID();
									targetfighter.AddBufferEffect(pff, pPro);		
								}
							}
							else
							{
								if(!bPoison)
									return 0;
								//设置中毒回合数
								if(ap[j].type == skillType.POISONTYPE && targetfighter.getbDodge() == false )
								{
									var fsp:FighterStatus = new FighterStatus(targetfighter, getMaxAction(), getMaxAction()*getMaxAction()/bf.getSpeed() * 3 * (i) / 4, getMaxAction()*getMaxAction()/bf.getSpeed() * 3 * (i) / 4, uint(BaseSpellAtk * psd._atkFactorVec[i]), (bf.getSide()+1)*10000+bf.getPos()*100+skillType.POISONTYPE);
									insertFighterStatus(fsp);
									///Logger.debug("@@@@@@----"+targetfighter.getSide()+"/" + targetfighter.getPos() + "hit poision");
									//控制buff轮数
								}
							}
						}
					}
				}
				
			}
			return 0; 
		} 
	   
		private function doStunAttack(bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if(_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if(target_pos < 0)
			{
				return 0; 
			}
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = skillType.STUNTYPE;        //中毒攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if(atkarea == null)
				return 0; 
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount();
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji; //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;  //破击
			}
			
			///Logger.debug(bf.getSide()+"/"+bf.getPos()+"--"+(isCrit? 1 : 0)+"--"+ (ispierce ? 1:0));
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if(psd)
				{
					var stunNum:int = 0;
					stunNum = psd._round;
					for(i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.STUNTYPE, isCrit, ispierce, (i == 0 ?  true:false), pPro);
					}
					
					
					for(j = 0; j < apcnt; ++j)
					{
						//释放技能概率
						if( ForRand.getRand() > psd.prob*10000 )
							continue;  //
						var targetfighter:BattleFighter = _objs[otherside][ap[j].pos];
						if( targetfighter && (targetfighter.getHP() > 0) && (targetfighter.getbDodge() == false) )
						{
							if(ap[j].type != 0)
							{
								if(stunNum > targetfighter.getStunRound())
								{
								   targetfighter.setStunRound(stunNum);

								   ///Logger.debug("@@@@@@----"+targetfighter.getSide()+"/" + targetfighter.getPos() + "hit stun");
								
								   var sff:buffEffect = new buffEffect();
								   sff.bfside = bf.getSide();
								   sff.btoside = targetfighter.getSide();
								   sff.bfpos = bf.getPos();
								   sff.btpos = targetfighter.getPos();
								   sff.bround = stunNum;
								   sff.btype = skillType.STUNTYPE;
								   sff.bvalue = 0;
								   sff.bfirst = true;
								   sff.bskillid =  bf.getSkillID();
								   targetfighter.AddBufferEffect(sff, pPro);		
								   
								}
							}
						}
					}
				}
			}

			return 0; 
		}
	   
	
		private function doSlowDownAttack(bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if(_winner != 0)
			{
				return 0; 
			}
		
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if(target_pos < 0)
			{
				return 0; 
			}
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = skillType.SLOWTYPE;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if(atkarea == null)
				return 0; 
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount();
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji; //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;  //破击
			}
			
			///Logger.debug(bf.getSide()+"/"+bf.getPos()+"--"+(isCrit? 1 : 0)+"--"+ (ispierce ? 1:0));
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if(psd)
				{
					var slowNum:int = 0;
					slowNum = psd._round;
					var slowFac:Number = 0.0;
					slowFac = psd._atkFactorVec[0];
					
					for(i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.SLOWTYPE, isCrit, ispierce, (i == 0 ?  true:false), pPro);
					}
					
					
					for (j = 0; j < apcnt; ++j)
					{
						//释放技能概率
						if( ForRand.getRand() > psd.prob*10000 )
							continue;  //未释放技能
						var targetfighter:BattleFighter = _objs[otherside][ap[j].pos];
						if (targetfighter && (targetfighter.getHP() > 0) && (targetfighter.getbDodge() == false) )
						{
							if(ap[j].type != 0)
							{
								//targetfighter->setCoolDown(static_cast<UInt32>(targetfighter->getCoolDown()*(1+slowFac)));
								var bff:buffEffect = new buffEffect();
								bff.bfside = bf.getSide();
								bff.btoside = targetfighter.getSide();
								bff.bfpos = bf.getPos();
								bff.btpos = targetfighter.getPos();
								bff.bround = slowNum;
								bff.btype = skillType.SLOWTYPE;
								bff.bvalue = slowFac;
								bff.bskillid = bf.getSkillID();
								bff.bfirst = true;
								targetfighter.AddBufferEffect(bff, pPro);
								
								//让客户端播放减速buff

								
								//变动间隔队列
								var c:int = 0;
								for (i = 0; i < _fgtlist.length; ++i)
								{
									if (_fgtlist[i].bfgt == targetfighter && _fgtlist[i].poisonAction == 0)
									{
										c = i;
										break;
									}
								}
								if (!targetfighter.HasBufferEffect(bff))
								{
									///Logger.debug("HitSlow before attack:    targetPos:" + targetfighter.getPos() + "Speed:" + _fgtlist[c].antiAction);
									_fgtlist[c].antiAction += uint(_fgtlist[c].bfgt.getBaseCoolDown()*bff.bvalue);
									//trace(uint(_fgtlist[c].bfgt.getBaseCoolDown()*bff.bvalue));
									var newFs:FighterStatus = new FighterStatus(_fgtlist[c].bfgt, _fgtlist[c].maxAction, _fgtlist[c].antiAction, _fgtlist[c].poisonAction, _fgtlist[c].poisonDamage, _fgtlist[c].atkMark);
									_fgtlist.splice(c, 1);
									insertFighterStatus(newFs);
									///Logger.debug("Slow after attack:    targetPos:" + targetfighter.getPos() + "Speed:" + newFs.antiAction);
								}
								
								//客户端如何表现
							}
						}
					}
				}
			}

			return 0; 
		}
		
		
		private function doAddSpeedAttack( bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if(_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if(target_pos < 0)
			{
				return 0; 
			}
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = skillType.SPEEDTYPE;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if(atkarea == null)
				return 0; 
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount();
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji; //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;     //破击
			}
			
			///Logger.debug(bf.getSide()+"/"+bf.getPos()+"--"+(isCrit? 1 : 0)+"--"+ (ispierce ? 1:0));
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if(psd)
				{
					var slowNum:int = 0;
					slowNum = psd._round;
					var slowFac:Number = 0.0;
					slowFac = psd._atkFactorVec[0];
					
					for(i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.SPEEDTYPE, isCrit, ispierce, (i == 0 ?  true:false), pPro);
					}
					
					//释放技能概率
					if( ForRand.getRand() > psd.prob*10000 )
						return 1;  //未释放技能
				
					if (bf)
					{
						//targetfighter->setCoolDown(static_cast<UInt32>(targetfighter->getCoolDown()*(1+slowFac)));
						var bff:buffEffect = new buffEffect();
						bff.bfside = bf.getSide();
						bff.btoside = bf.getSide();
						bff.bfpos = bf.getPos();
					    bff.btpos = bf.getPos();
						bff.bround = slowNum;
						bff.btype = skillType.SPEEDTYPE;
						bff.bvalue = slowFac;
						bff.bfirst = true;
						bff.bskillid = bf.getSkillID();
						bf.AddBufferEffect(bff, pPro);
								
	
						//变动间隔队列
						var c:int = 0;
						for (i = 0; i < _fgtlist.length; ++i)
						{
							if (_fgtlist[i].bfgt == bf && _fgtlist[i].poisonAction == 0)
							{
								c = i;
								break;
							}
						}
						if (!bf.HasBufferEffect(bff))
						{
							///Logger.debug("HitSpeed before attack:    targetPos:" + bf.getPos() + "Speed:" + _fgtlist[c].antiAction);
									
							_fgtlist[c].antiAction -= uint(_fgtlist[c].bfgt.getBaseCoolDown()*bff.bvalue);
							var newFs:FighterStatus = new FighterStatus(_fgtlist[c].bfgt, _fgtlist[c].maxAction, _fgtlist[c].antiAction, _fgtlist[c].poisonAction, _fgtlist[c].poisonDamage, _fgtlist[c].atkMark);
							_fgtlist.splice(c, 1);
							insertFighterStatus(newFs);
									
							///Logger.debug("HitSpeed after attack:    targetPos:" + bf.getPos() + "Speed:" + newFs.antiAction);
						}
								
						//客户端如何表现
					}
				}
			}
			return 0; 
		}



		private function doAtkBackHp(bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = skillType.ADDHP;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;       //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;     //破击
			}
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				var firstSpellDmg:uint = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var spellDmg:uint = 0;
					for ( i = 0; i < apcnt; ++i)
					{
						spellDmg = attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.ADDHP, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					    if(i == 0)
							firstSpellDmg = spellDmg;
					}
					
					//释放技能概率
					if( ForRand.getRand() > psd.prob*10000 )
						return 1;  //未释放技能
					
					//给自己方加血
					var effectNum:uint = uint(psd._atkFactorVec[0]);
					var effectFac:Number = psd._atkFactorVec[1];
					var addValue:uint = uint(firstSpellDmg * effectFac);
					var toSide:int = bf.getSide();
					var myFlist:Array = [];
					for ( i = 0; i < _fgtlist.length; ++i)
					{
						if (_fgtlist[i].bfgt.getSide() == toSide &&  (_fgtlist[i].bfgt as BattleFighter).getHP() > 0 && _fgtlist[i].poisonAction == 0)
						{
							myFlist.push(_fgtlist[i].bfgt);
						}
					}
					myFlist.sort(CompLess);

					for ( j = 0; j < myFlist.length && j < effectNum; ++j)
					{
						///Logger.debug("HPside:" + bf.getSide() + "/" + myFlist[j].getPos() +"HPConsume:" + myFlist[j].getHpConsume());
						
						var rescuer:BtRescued = new BtRescued();
						rescuer.side = bf.getSide();
						rescuer.pos = (myFlist[j] as BattleFighter).getPos();
						rescuer.addHp = addValue;
						
						(myFlist[j] as BattleFighter).AddHP(addValue);
						
						rescuer.leftHp =  (myFlist[j] as BattleFighter).getHP();
						pPro.rescuedList.push(rescuer);
						///Logger.debug("HPside:" + bf.getSide() + "/" + myFlist[j].getPos() +"addHPValue:" + addValue);	
					}
				   myFlist.splice(0, myFlist.length);
				}  
			}
			return 0;
		}
		
		private function doSukHp(bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = 0;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;       //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;     //破击
			}
			
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				var firstOneDmg:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var dmgs:uint = 0;
					for ( i = 0; i < apcnt; ++i)
					{
						dmgs = attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.SUKHP, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					    if(i == 0)
						{
							firstOneDmg = dmgs;
						}
					}
					
					//释放技能概率
					if( ForRand.getRand() > psd.prob*10000 )
						return 1;  //未释放技能
					
					if(targetObj.getbDodge() == false)
					{
						//给自己加血
						var beforeHp:int = 0;
						beforeHp = bf.getHP();
						var effectFac:Number = psd._atkFactorVec[0];
						bf.AddHP(uint(effectFac * firstOneDmg));
						
						///Logger.debug("@@@@@@@@hitsukhp--" + bf.getSide() +  "/" + bf.getPos()+ "suk--" + uint(effectFac * firstOneDmg));
						
						//给客户端表现给自己加血buff
						var rescuer:BtRescued = new BtRescued();
						rescuer.side = bf.getSide();
						rescuer.pos = bf.getPos();
						rescuer.addHp = uint(effectFac * firstOneDmg);
						rescuer.leftHp =  bf.getHP();
						pPro.rescuedList.push(rescuer);

					}
				}  
			}
			return 0;
		}
		
		private function doResisTance(bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = 0;        //普通技能攻击
			
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;     //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;     //破击
			}
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var resisNum:uint = 0;        //格挡轮数
					resisNum = psd._round;
					var resisFac:Number = 0.0;
					resisFac = psd._atkFactorVec[0];
					for ( i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.RESISTANCE, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					}
					
					//释放技能概率
					if( ForRand.getRand() > psd.prob*10000 )
						return 1;  //未释放技能
					
					
					//添加格挡
					var bff:buffEffect = new buffEffect();
					bff.bfside = bf.getSide();
					bff.btoside = bf.getSide();
					bff.bfpos = bf.getPos();
					bff.btpos = bf.getPos();
					bff.bround = resisNum;
					bff.btype = skillType.RESISTANCE;
					bff.bvalue = resisFac;
					bff.bfirst = true;
					bff.bskillid = bf.getSkillID()
					bf.AddBufferEffect(bff, pPro);
					
				}  
			}
			return 0;
		}
		
		private function doDeepHurt(bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = 0;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;       //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;     //破击
			}
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var deepHurtNum:uint = 0;        //加深轮数
					deepHurtNum = psd._round;
					var hurtFac:Number = 0.0;
					hurtFac = psd._atkFactorVec[0];
					var pTarget:BattleFighter = null;
					for ( i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.DEEPHURT, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					}
					
					
					for (j = 0; j < apcnt; ++j)
					{
						//释放技能概率
						if(ForRand.getRand() > psd.prob*10000)
							continue;
						pTarget = _objs[otherside][ap[j].pos];
							//给目标减去聚气
						if (pTarget && (pTarget.getHP() > 0) && (pTarget.getbDodge() == false))
						{
							if(ap[j].type != 0)
							{
								//加深伤害
								var deephurtbff:buffEffect = new buffEffect();
								deephurtbff.bfside = bf.getSide();
								deephurtbff.btoside = pTarget.getSide();
								deephurtbff.bfpos = bf.getPos();
								deephurtbff.btpos = pTarget.getPos();
								deephurtbff.bround = deepHurtNum;
								deephurtbff.btype = skillType.DEEPHURT;
								deephurtbff.bvalue = hurtFac;
								deephurtbff.bfirst = true;
								deephurtbff.bskillid = bf.getSkillID();
								pTarget.AddBufferEffect(deephurtbff, pPro);

							}
						}
					}
					
					
					
					/*//释放技能概率
					if( ForRand.getRand() > psd.prob*10000 )
						return 1;  //未释放技能
					
					var pTarget:BattleFighter = _objs[otherside][target_pos];
					if (pTarget == null || (pTarget.getbDodge() == true) )
						return 2;
					
					//加深伤害
					var bff:buffEffect = new buffEffect();
					bff.bfside = bf.getSide();
					bff.btoside = pTarget.getSide();
					bff.bfpos = bf.getPos();
					bff.btpos = pTarget.getPos();
					bff.bround = deepHurtNum;
					bff.btype = skillType.DEEPHURT;
					bff.bvalue = hurtFac;
					bff.bfirst = true;
					bff.bskillid = bf.getSkillID();
					pTarget.AddBufferEffect(bff, pPro);*/
					
					
					///Logger.debug("@@@@@HitDeephurt"+ pTarget.getSide() + "/", pTarget.getPos(), "-", hurtFac* 100);
				
					//是否客户端表现
					//让客户端播放加深伤害的buff
//					{
//						var sBuf:BtStatus = new BtStatus();
//						sBuf.atkorBackatk = 0;
//						sBuf.sideFrom = bf.getSide();
//						sBuf.toside = pTarget.getSide();
//						sBuf.fpos = bf.getPos();
//						sBuf.tpos = pTarget.getPos();
//						sBuf.skillid = bf.getSkillID();
//						sBuf.type = 2;  
//						sBuf.data = 0;
//						sBuf.letDie = 0;
//						pPro.SChangeList.push(sBuf);
//					}
				}  
			}
			return 0;
		}
		
		//加攻击
		private function doAddAttack(bf:BattleFighter ,pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = 0;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo;       //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;       //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;       //破击
			}
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var addAtkNum:uint = 0;        //
					addAtkNum = psd._round;
					var atkFac:Number = 0.0;
					atkFac = psd._atkFactorVec[0];
					for ( i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.ADDATTACK, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					}
					
					//释放技能概率
					if( ForRand.getRand() > psd.prob*10000 )
						return 1;  //未释放技能
					
					var pAddTarget:BattleFighter = null; 
					var joblist:Array = [2,3,1];
					for (i = 1; i < 4; i++)  //job从1到3
					{
						for ( j = 0; j < _fgtlist.length; ++j)
						{
							if (_fgtlist[j].bfgt.getSide() == bf.getSide() && _fgtlist[j].bfgt.getHP() > 0)
							{
								if (_fgtlist[j].bfgt.getJobID() == joblist[i-1] && _fgtlist[j].bfgt != bf )
								{
									pAddTarget = _fgtlist[j].bfgt;
									i = 4;
									break;
								}
							}
						}
					}
					
					//给队友添加攻击力
					if (pAddTarget)
					{							
						var addbff:buffEffect = new buffEffect();
						addbff.bfside = bf.getSide();
						addbff.btoside = pAddTarget.getSide();
						addbff.bfpos = bf.getPos();
						addbff.btpos = pAddTarget.getPos();
						addbff.bround = addAtkNum;
						addbff.btype = skillType.ADDATTACK;
						addbff.bvalue = atkFac;
						addbff.bfirst = true;
						addbff.bskillid = bf.getSkillID();
						pAddTarget.AddBufferEffect(addbff, pPro);
					}
				}  
			}
			return 0;
		}
		
		private function doAddMySelfAttack(bf:BattleFighter ,pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = 0;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo;       //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;       //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;       //破击
			}
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var addAtkNum:uint = 0;        //
					addAtkNum = psd._round;
					var atkFac:Number = 0.0;
					atkFac = psd._atkFactorVec[0];
					for ( i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.ADDMYSELFATTACK, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					}
					
					//释放技能概率
					if( ForRand.getRand() > psd.prob*10000 )
						return 1;  //未释放技能
					
					//给队友添加攻击力
					if (bf)
					{							
						var bff:buffEffect = new buffEffect();
						bff.bfside = bf.getSide();
						bff.btoside = bf.getSide();
						bff.bfpos = bf.getPos();
						bff.btpos = bf.getPos();
						bff.bround = addAtkNum+1;  //设置多一轮 
						bff.btype = skillType.ADDMYSELFATTACK;
						bff.bvalue = atkFac;
						bff.bfirst = true;
						bff.bskillid = bf.getSkillID();
						bf.AddBufferEffect(bff, pPro);
					}
					
				}  
			}
			return 0;
		}
		
		private function doReDuceAttack(bf:BattleFighter ,pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if(_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if(target_pos < 0)
			{
				return 0; 
			}
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = skillType.REDUCEATTACK;        //中毒攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if(atkarea == null)
				return 0; 
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount();
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji; //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;  //破击
			}
			
			///Logger.debug(bf.getSide()+"/"+bf.getPos()+"--"+(isCrit? 1 : 0)+"--"+ (ispierce ? 1:0));
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if(psd)
				{
					var reduceNum:int = 0;
					var reduceFac:Number = 0.0;
					reduceNum = psd._round;
					reduceFac = psd._atkFactorVec[0];
					
					for(i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.REDUCEATTACK, isCrit, ispierce, (i == 0 ?  true:false), pPro);
					}
					
					for(j = 0; j < apcnt; ++j)
					{
						//释放技能概率
						if( ForRand.getRand() > psd.prob*10000 )
							continue;  //
						var targetfighter:BattleFighter = _objs[otherside][ap[j].pos];
						if( targetfighter && (targetfighter.getHP() > 0) &&(targetfighter.getbDodge() == false) )
						{
							if(ap[j].type != 0)
							{
							
								///Logger.debug("@@@@@@----"+targetfighter.getSide()+"/" + targetfighter.getPos() + "hit stun");
									
								var reatkbuff:buffEffect = new buffEffect();
								reatkbuff.bfside = bf.getSide();
								reatkbuff.btoside = targetfighter.getSide();
								reatkbuff.bfpos = bf.getPos();
								reatkbuff.btpos = targetfighter.getPos();
								reatkbuff.bround = reduceNum;
								reatkbuff.btype = skillType.REDUCEATTACK;
								reatkbuff.bvalue = reduceFac;
								reatkbuff.bfirst = true;
								reatkbuff.bskillid =  bf.getSkillID();
								targetfighter.AddBufferEffect(reatkbuff, pPro);		
							}
						}
					}
				}
			}
			
			return 0; 
		}
		
		//攻击降低对方命中率
		private function doReduceHitRate(bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = 0;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;       //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;     //破击
			}
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var reduceHitNum:uint = 0;        //加深轮数
					reduceHitNum = psd._round;
					var reduceFac:Number = 0.0;
					reduceFac = psd._atkFactorVec[0];
					var reduceTarget:BattleFighter = null;
					for ( i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.REDUCEHITRATE, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					}
									
					//释放技能概率
					
					for (j = 0; j < apcnt; ++j)
					{
						if( ForRand.getRand() > psd.prob*10000 )
							continue;
						reduceTarget = _objs[otherside][ap[j].pos];
						//给目标减去聚气
						if (reduceTarget && (reduceTarget.getHP() > 0) && (reduceTarget.getbDodge() == false))
						{
							if(ap[j].type != 0)
							{
								//加深伤害
								var reducehitrbff:buffEffect = new buffEffect();
								reducehitrbff.bfside = bf.getSide();
								reducehitrbff.btoside = reduceTarget.getSide();
								reducehitrbff.bfpos = bf.getPos();
								reducehitrbff.btpos = reduceTarget.getPos();
								reducehitrbff.bround = reduceHitNum;
								reducehitrbff.btype = skillType.REDUCEHITRATE;
								reducehitrbff.bvalue = reduceFac;
								reducehitrbff.bfirst = true;
								reducehitrbff.bskillid = bf.getSkillID();
								reduceTarget.AddBufferEffect(reducehitrbff, pPro);
									
							}
						}
					}
				}  
			}
			return 0;
		}
		
		//多次攻击 
		private function doMultipleAtk(bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = 0;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;       //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;     //破击
			}
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					for ( i = 0; i < apcnt; ++i)
					{
						attackOnceSpecial(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.MULTIPLE, isCrit, ispierce, (i == 0 ?  true : false), psd._atkFactorVec, pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					}
				}  
			}
			BtProcess.data.push(pPro);
			return 0;
		}
		
		private function doAddGauge(bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			var k:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = 0;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;  //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;   //破击
			}
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var addGaugeFac:Number = 0.0;
					addGaugeFac = psd._atkFactorVec[0];
					
					for ( i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.ADDGAUGE, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					}
					
				
					for (j = 0; j < apcnt; ++j)
					{
						if(ForRand.getRand() > psd.prob*10000 )
							continue;
						var addfighter:BattleFighter= _objs[otherside][ap[j].pos];
						//给目标减去聚气
						if (addfighter && (addfighter.getHP() > 0 ) && (addfighter.getbDodge() == false))
						{
							if(ap[j].type != 0)
							{
								if(addGaugeFac > 0)
									addfighter.addQiGather( uint(addGaugeFac), false, pPro, 0);
									
								///Logger.debug("@@@@@@Hit Gauge--" + targetobj.getSide() +  "/" + targetobj.getPos() + "--before--"+ showgauge + "--after--" + targetobj.getGauge()+ "--value-- " + uint(addValue));
									
								//给客户端表现减聚气技能
								var gaugeBuf:BtStatus = new BtStatus();
								gaugeBuf.atkorBackatk = 0;
								gaugeBuf.sideFrom = bf.getSide();
								gaugeBuf.toside = addfighter.getSide();
								gaugeBuf.fpos = bf.getPos();
								gaugeBuf.tpos = addfighter.getPos();
								gaugeBuf.skillid = bf.getSkillID();
								gaugeBuf.type = 2;       //加血buffer
								gaugeBuf.data = 0;       //减少量
								pPro.SChangeList.push(gaugeBuf);
									
								for(k = 0; k < pPro.defendList.length; ++k)
								{
									if((pPro.defendList[k] as BtDefend).pos == addfighter.getPos())
									{
										(pPro.defendList[k] as BtDefend).aterleftGauge = addfighter.getGauge();
										break;
									}
								}
							}
								
						}
					}

					//myFlist.clear();
				}  
			}
			return 0;
		}
		
		private function doReBeCritAtk(bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = 0;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;  //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;   //破击
			}
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var reNum:int = 0;
					reNum = psd._round;
					var mFac:Number = 0.0;
					mFac = psd._atkFactorVec[0];
					
					for ( i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.REBECRITPROB, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					}
					
					//释放技能概率
					if( ForRand.getRand() > psd.prob*10000 )
						return 1;  //未释放技能
					
					//给客户端表现降低受暴击概率技能
					var bff:buffEffect = new buffEffect();
					bff.bfside = bf.getSide();
					bff.btoside = bf.getSide();
					bff.bfpos = bf.getPos();
					bff.btpos = bf.getPos();
					bff.bround = reNum;
					bff.btype = skillType.REBECRITPROB;
					bff.bvalue = mFac;
					bff.bfirst = true;
					bff.bskillid = bf.getSkillID();
					bf.AddBufferEffect(bff, pPro);
										
					///Logger.debug("@@@@@_HitReBeCrit-" + bf.getSide() +  "/" + bf.getPos() + "--" + mFac*100 +"--" + reNum);
				}  
			}
			return 0;
		}
		
		private function doReBePierceAtk(bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 

			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = 0;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;  //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;   //破击
			}
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var reNum:int = 0;
					reNum = psd._round;
					var mFac:Number = 0.0;
					mFac = psd._atkFactorVec[0];
					
					for ( i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.REBEPIERCEPROB, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					}
					
					//释放技能概率
					if( ForRand.getRand() > psd.prob*10000 )
						return 1;  //未释放技能
					
					//给客户端表现降低受破击概率技能
					var bff:buffEffect = new buffEffect();
					bff.bfside = bf.getSide();
					bff.btoside = bf.getSide();
					bff.bfpos = bf.getPos();
					bff.btpos = bf.getPos();
					bff.bround = reNum;
					bff.btype = skillType.REBEPIERCEPROB;
					bff.bvalue = mFac;
					bff.bfirst = true;
					bff.bskillid = bf.getSkillID();
					bf.AddBufferEffect(bff, pPro);
					
					///Logger.debug("@@@@@_HitReBePierce-" + bf.getSide() +  "/" + bf.getPos() + "--" + mFac*100 +"--" + reNum);
				}  
			}

			return 0;
		}
		
		private function doReduceSpellDmg(bf:BattleFighter, pPro:BtProcess):uint   //降低受到的仙术伤害
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = 0;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;  //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;   //破击
			}
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var reduceNum:int = 0;
					reduceNum = psd._round;
					var reduceFac:Number = 0.0;
					reduceFac = psd._atkFactorVec[0];
					
					for ( i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.REDUCESPELLDMG, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					}
					
					//释放技能概率
					if( ForRand.getRand() > psd.prob*10000 )
						return 1;  //未释放技能
					
					//降低下次受仙术攻击的伤害
					var bff:buffEffect = new buffEffect();
					bff.bfside = bf.getSide();
					bff.btoside = bf.getSide();
					bff.bfpos = bf.getPos();
					bff.btpos = bf.getPos();
					bff.bround = reduceNum;
					bff.btype = skillType.REDUCESPELLDMG;
					bff.bvalue = reduceFac;
					bff.bfirst = true;
					bff.bskillid = bf.getSkillID();
					bf.AddBufferEffect(bff, pPro);
										
					//myFlist.clear();
				    ///Logger.debug("@@@@@_HitReSpellDmg-" + bf.getSide() +  "/" + bf.getPos()+ "--" + int(reduceFac*100));
				}  
			}
			return 0;
		}
		
		
		//基础的加属性的攻击
		private function doAddBasePropAtk(bf:BattleFighter, addType:uint, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
					
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = 0;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;      //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;     //破击
			}
			
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var roundNum:int = 0;      //轮数
					var propFac:Number = 0.0;
					var propFacPlus:Number = 0.0;
					roundNum = psd._round;
					propFac = psd._atkFactorVec[0];
					if(addType == skillType.ADDCOUNTER || addType == skillType.ADDCRIT)
						propFacPlus = psd._atkFactorVec[1];
					var propTarget:BattleFighter = null; 
					for ( i = 0; i < apcnt; ++i)
					{
						attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, addType, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					}
					
					//触发该技能概率
					if( ForRand.getRand() > psd.prob*10000 )
						return 1;  //未释放技能
					
					//加基础属性buff
					var bff:buffEffect = new buffEffect();
					bff.bfside = bf.getSide();
					bff.btoside = bf.getSide();
					bff.bfpos = bf.getPos();
					bff.btpos = bf.getPos();
					if ( addType == skillType.ADDDODGE || addType == skillType.ADDDEFEND || addType == skillType.ADDCOUNTER)
						bff.bround = roundNum;
					else
						bff.bround = roundNum+1;
					bff.btype = addType;
					bff.bvalue = propFac;
					if(addType == skillType.ADDCOUNTER || addType == skillType.ADDCRIT)
					{
						bff.bvalue = propFac * 1000000 + propFacPlus*1000;
					}
					bff.bfirst = true;
					bff.bskillid = bf.getSkillID();
					bf.AddBufferEffect(bff, pPro);
					
					/*if(addType == skillType.ADDCRIT)
						Logger.debug("@@@@@___My add Crit : my side: " + bf.getSide() +  "my  Pos: " + bf.getPos()+ "add fac: " + propFac);
					else if(addType == skillType.ADDPIERCE)
						Logger.debug("@@@@@___My add Pierce : my side: " + bf.getSide() +  "my  Pos: " + bf.getPos()+ "add fac: " + propFac);
					else if(addType == skillType.ADDCOUNTER)
						Logger.debug("@@@@@___My add Counter : my side: " + bf.getSide() +  "my  Pos: " + bf.getPos()+ "afteradd: " + bf.getCounter()*100);
					else if(addType == skillType.ADDDODGE)
						Logger.debug("@@@@@___My add Aodge : my side: " + bf.getSide() +  "my  Pos: " + bf.getPos()+ "afteradd: " + bf.getdodge()*100);
					else if(addType == skillType.ADDDEFEND)
						Logger.debug("@@@@@___My add Defend : my side: " + bf.getSide() +  "my  Pos: " + bf.getPos()+ "afteradd: " + bf.getDefend());*/

				}  
			}
			return 0;
		}
		
		
		private function doDoubleSkillAtk(bf:BattleFighter, skilltype1:uint, skilltype2:uint, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			var SpellDmg:uint = 0;
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = skilltype1;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;       //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;     //破击
			}
			
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				var dmg:uint = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var roundNum:int = 0;      //轮数
					roundNum = psd._round;
					var propFac:Number = 0.0;
					propFac = psd._atkFactorVec[0];
					var propTarget:BattleFighter = null; 
					for ( i = 0; i < apcnt; ++i)
					{
						dmg = attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skilltype1, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
						if(i == 0)
							SpellDmg = dmg;
					}
					doPerSkillAtk(0, bf, targetObj, SpellDmg, skilltype1, apcnt, ap, pPro);
					doPerSkillAtk(1, bf, targetObj, SpellDmg, skilltype2, apcnt, ap, pPro);
				}
			}
			return 0;
		}
		
		private function clearPoision(tg:BattleFighter):void
		{
			for(var i:int = 0; i < _fgtlist.length; ++i)
			{
				if (_fgtlist[i].bfgt == tg && _fgtlist[i].poisonAction != 0)
				{
					_fgtlist.erase(_fgtlist.begin()+i);
					--i;
				}
			}
		}	
		
		private function doImmunity(bf:BattleFighter, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			if (_winner != 0)
			{
				return 0; 
			}
			
			//获得被攻击方的pos
			var target_pos:int = getPossibleTarget(bf.getSide(), bf.getPos());
			if (target_pos < 0)
				return 0;
			var nextside:int = 1 - bf.getSide();
			var targetObj:BattleFighter = _objs[nextside][target_pos];
			if(targetObj == null)
				return 0; 
			
			BtProcess.data.push(pPro);
			pPro.oneAtkInfo = new BtOneAtk();
			pPro.oneAtkInfo.atkerSide = bf.getSide();  //攻击者side
			pPro.oneAtkInfo.atkerPos = bf.getPos();
			pPro.oneAtkInfo.atkPos = target_pos;
			pPro.oneAtkInfo.skillType = skillType.IMMUNITY;        //普通技能攻击
			
			var pskilldata:skillData = AttackData.skilllist[bf.getSkillID()];
			if (pskilldata == null)
				return 0;
			var atkarea:Area = AttackData.arealist[pskilldata.atkID];
			if ( atkarea == null)
				return 0;
			//判断是否是全屏攻击
			var isFullS:Boolean = false;
			if(atkarea.getDataArray()[0].x == 6 && atkarea.getDataArray()[0].y == 6)
			{
				isFullS = true;    //全屏攻击
			}
			var cnt:int = atkarea.getCount(); 
			
			//判断是否暴击，破击，暴破
			var isCrit:Boolean = false;
			isCrit = bf.isCritAttack(targetObj);
			var ispierce:Boolean = false;
			ispierce = bf.ispierceAttack(targetObj);
			
			if( isCrit && ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baopo; //暴破
			}
			else if( isCrit )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Baoji;       //暴击
			}
			else if( ispierce )
			{
				pPro.oneAtkInfo.effectType = BTSystem.ID_Poji;     //破击
			}
			
			
			//第一次攻击
			if(cnt >= 1)
			{
				var ap:Array = [];
				var apcnt:int = 0;
				var dmg:uint = 0;
				apcnt = fixAttackArea(cnt, ap, apcnt, target_pos, atkarea, isFullS);
				
				var otherside:int = 1 - bf.getSide();
				var psd:skillData = AttackData.skilllist[bf.getSkillID()];
				if (psd)
				{	
					var rescuerRound:int = 0;      //轮数
					rescuerRound = psd._round;
					var rescuerNum:Number = 0.0;
					rescuerNum = psd._atkFactorVec[0];
					for ( i = 0; i < apcnt; ++i)
					{
						dmg = attackOnceSpell(bf, _objs[otherside][ap[i].pos], ap, i, ap[i].factor, 0, skillType.IMMUNITY, isCrit, ispierce, (i == 0 ?  true : false), pPro); //(i == 0 ?  true, false)首要目标才触发聚气
					}
					
					//释放技能概率
					if(ForRand.getRand() > psd.prob*10000 )
						return 1;  //
					
					var pTarget:BattleFighter = null;
					var effectNum:int = 0;
					for (i = 1; i < 4;  ++i)
					{
						for(j = 0; j < _fgtlist.length; ++j)
						{
							if(_fgtlist[j].bfgt.getSide() == bf.getSide() && _fgtlist[j].bfgt.getHP() > 0 && _fgtlist[j].poisonAction == 0)
							{
								if(_fgtlist[j].bfgt.getJobID() == i)
								{
									if(effectNum++ < rescuerNum)
									{
										pTarget = _fgtlist[j].bfgt;
										//清除不利效果
										pTarget.ClearNegativeBuff(pPro);
										
										//单独清除中毒
										clearPoision(pTarget);
									}
									else
									{
										break;
										i = 4;
									}
								}
							}
						}
					}
					
				}
			}
			return 0;
		}
		
		private function doPerSkillAtk(skillAB:uint, bf:BattleFighter, targetbf:BattleFighter, spellDmg:uint, skilltype:uint, apcnt:uint, ap:Array, pPro:BtProcess):uint
		{
			var i:int;
			var j:int;
			var k:int;
			var pskilldata:skillData;
			var skillround:uint = 0;
			var skillfac:Number = 0.0;
			var skillprob:Number = 0.0;
			var otherside:uint = 0;
			
			otherside = 1-bf.getSide();
			pskilldata = AttackData.skilllist[bf.getSkillID()];
			if(pskilldata == null)
				return 0;
			
			if(skillAB == 0)
			{
				skillround = pskilldata._round;
				skillfac = pskilldata._atkFactorVec[0];
				skillprob = pskilldata.prob;
			}
			else if(skillAB == 1)
			{
				skillround = pskilldata._round2;
				skillfac = pskilldata._atkFactorVec2[0];
				skillprob = pskilldata.prob2;
			}
			
			if(skilltype != skillType.STUNTYPE && skilltype != skillType.SLOWTYPE
			   && skilltype != skillType.ADDGAUGE && skilltype != skillType.DEEPHURT
			   && skilltype != skillType.REDUCEHITRATE && skilltype != skillType.REDUCEATTACK)
			{
			    //释放技能概率
				if(ForRand.getRand() > skillprob * 10000)
				return 1;
			}

			
			switch(skilltype)
			{
				case skillType.STUNTYPE:
				{
					for(j = 0; j < apcnt; ++j)
					{
						if( ForRand.getRand() > skillprob*10000 )
							continue;  //
						var targetfighter:BattleFighter = _objs[otherside][ap[j].pos];
						if( targetfighter && (targetfighter.getHP() > 0) && (targetfighter.getbDodge() == false) )
						{
							if(ap[j].type != 0)
							{
								if(skillround > targetfighter.getStunRound())
								{
									targetfighter.setStunRound(skillround);
									
									///Logger.debug("@@@@@@----"+targetfighter.getSide()+"/" + targetfighter.getPos() + "hit stun");
									
									var sff:buffEffect = new buffEffect();
									sff.bfside = bf.getSide();
									sff.btoside = targetfighter.getSide();
									sff.bfpos = bf.getPos();
									sff.btpos = targetfighter.getPos();
									sff.bround = skillround;
									sff.btype = skillType.STUNTYPE;
									sff.bvalue = 0;
									sff.bfirst = true;
									sff.bskillid =  bf.getSkillID();
									sff.bskillab = skillAB;
									targetfighter.AddBufferEffect(sff, pPro);		
									
								}
							}
						}
					}
				}
				break;
				case skillType.SLOWTYPE:
				{
					for (j = 0; j < apcnt; ++j)
					{
						if( ForRand.getRand() > skillprob*10000 )
							continue;  //
						var slowtarget:BattleFighter = _objs[otherside][ap[j].pos];
						if (slowtarget && (slowtarget.getHP() > 0) && (slowtarget.getbDodge() == false) )
						{
							if(ap[j].type != 0)
							{
								//targetfighter->setCoolDown(static_cast<UInt32>(targetfighter->getCoolDown()*(1+slowFac)));
								var slowbff:buffEffect = new buffEffect();
								slowbff.bfside = bf.getSide();
								slowbff.btoside = slowtarget.getSide();
								slowbff.bfpos = bf.getPos();
								slowbff.btpos = slowtarget.getPos();
								slowbff.bround = skillround;
								slowbff.btype = skillType.SLOWTYPE;
								slowbff.bvalue = skillfac;
								slowbff.bskillid = bf.getSkillID();
								slowbff.bfirst = true;
								slowbff.bskillab = skillAB;
								slowtarget.AddBufferEffect(slowbff, pPro);
								
								//让客户端播放减速buff
								
								
								//变动间隔队列
								var sc:int = 0;
								for (i = 0; i < _fgtlist.length; ++i)
								{
									if (_fgtlist[i].bfgt == slowtarget && _fgtlist[i].poisonAction == 0)
									{
										sc = i;
										break;
									}
								}
								if (!slowtarget.HasBufferEffect(slowbff))
								{
									///Logger.debug("HitSlow before attack:    targetPos:" + targetfighter.getPos() + "Speed:" + _fgtlist[c].antiAction);
									_fgtlist[sc].antiAction += uint(_fgtlist[sc].bfgt.getBaseCoolDown()*slowbff.bvalue);
									var newFs:FighterStatus = new FighterStatus(_fgtlist[sc].bfgt, _fgtlist[sc].maxAction, _fgtlist[sc].antiAction, _fgtlist[sc].poisonAction, _fgtlist[sc].poisonDamage, _fgtlist[sc].atkMark);
									_fgtlist.splice(sc, 1);
									insertFighterStatus(newFs);
									///Logger.debug("Slow after attack:    targetPos:" + targetfighter.getPos() + "Speed:" + newFs.antiAction);
								}
							}
						}
					}
				}
				break;	
				//bugggggggggggggggggggggggggggggggg
				case skillType.ADDHP:
				{
					//给自己方加血
					var effectNum:uint = 0;
					var effectFac:Number = 0.0;
					var addValue:uint = 0;
					
					if(skillAB == 0)
					{
						if(pskilldata._atkFactorVec.length >= 2)
						{
							effectNum = pskilldata._atkFactorVec[0];
							effectFac = pskilldata._atkFactorVec[1];
						}
					}
					else if(skillAB == 1)
					{
						if(pskilldata._atkFactorVec2.length >= 2)
						{
							effectNum = pskilldata._atkFactorVec2[0];
							effectFac = pskilldata._atkFactorVec2[1];
						}
					}
					addValue = uint( spellDmg * effectFac);
					
					var myFlist:Array = [];
					var toSide:int = bf.getSide();
					for ( i = 0; i < _fgtlist.length; ++i)
					{
						if (_fgtlist[i].bfgt.getSide() == toSide &&  (_fgtlist[i].bfgt as BattleFighter).getHP() > 0 && _fgtlist[i].poisonAction == 0)
						{
							myFlist.push(_fgtlist[i].bfgt);
						}
					}
					myFlist.sort(CompLess);
					
					for ( j = 0; j < myFlist.length && j < effectNum; ++j)
					{
						///Logger.debug("HPside:" + bf.getSide() + "/" + myFlist[j].getPos() +"HPConsume:" + myFlist[j].getHpConsume());
						
						var rescuer:BtRescued = new BtRescued();
						rescuer.side = bf.getSide();
						rescuer.pos = (myFlist[j] as BattleFighter).getPos();
						rescuer.addHp = addValue;
						
						(myFlist[j] as BattleFighter).AddHP(addValue);
						
						rescuer.leftHp =  (myFlist[j] as BattleFighter).getHP();
						pPro.rescuedList.push(rescuer);
						///Logger.debug("HPside:" + bf.getSide() + "/" + myFlist[j].getPos() +"addHPValue:" + addValue);
							
					}
				}
				break;
				//buggggggggggggggggggggggggggggggggggggggggg
				case skillType.SUKHP:
				{
					if(targetbf.getbDodge() == false)
					{
						//给自己加血
						var beforeHp:int = 0;
						beforeHp = bf.getHP();
						bf.AddHP(uint(skillfac * spellDmg));
						
						///Logger.debug("@@@@@@@@hitsukhp--" + bf.getSide() +  "/" + bf.getPos()+ "suk--" + uint(effectFac * firstOneDmg));
						
						//给客户端表现给自己加血buff
						var sukrescuer:BtRescued = new BtRescued();
						sukrescuer.side = bf.getSide();
						sukrescuer.pos = bf.getPos();
						sukrescuer.addHp = uint(skillfac * spellDmg);
						sukrescuer.leftHp =  bf.getHP();
						pPro.rescuedList.push(sukrescuer);

					}
				}
				break;
				case skillType.RESISTANCE:
				{
					//添加格挡
					var resistancebff:buffEffect = new buffEffect();
					resistancebff.bfside = bf.getSide();
					resistancebff.btoside = bf.getSide();
					resistancebff.bfpos = bf.getPos();
					resistancebff.btpos = bf.getPos();
					resistancebff.bround = skillround;
					resistancebff.btype = skillType.RESISTANCE;
					resistancebff.bvalue = skillfac;
					resistancebff.bfirst = true;
					resistancebff.bskillid = bf.getSkillID()
				    resistancebff.bskillab = skillAB;
					bf.AddBufferEffect(resistancebff, pPro);
				}
				break;
				case skillType.DEEPHURT:
				{
					var pTarget:BattleFighter;
					for (j = 0; j < apcnt; ++j)
					{
						if( ForRand.getRand() > skillprob*10000 )
							continue;  //
						pTarget = _objs[otherside][ap[j].pos];
						//给目标减去聚气
						if (pTarget && (pTarget.getHP() > 0)  && (pTarget.getbDodge() == false))
						{
							if(ap[j].type != 0)
							{
								//加深伤害
								var deephurtbff:buffEffect = new buffEffect();
								deephurtbff.bfside = bf.getSide();
								deephurtbff.btoside = pTarget.getSide();
								deephurtbff.bfpos = bf.getPos();
								deephurtbff.btpos = pTarget.getPos();
								deephurtbff.bround = skillround;
								deephurtbff.btype = skillType.DEEPHURT;
								deephurtbff.bvalue = skillfac;
								deephurtbff.bfirst = true;
								deephurtbff.bskillid = bf.getSkillID();
								deephurtbff.bskillab = skillAB;
								pTarget.AddBufferEffect(deephurtbff, pPro);
							}
						}
					}
				}
				break;
				case skillType.ADDCOUNTER:
				case skillType.ADDCRIT:
				case skillType.ADDDODGE:
				case skillType.ADDDEFEND:
				case skillType.ADDPIERCE:
				{
					var skillfacplus:Number = 0.0;
					if(skilltype == skillType.ADDCOUNTER)
					{
						if(skillAB == 0)
						{
							skillfacplus = pskilldata._atkFactorVec[1];
						}
						else if(skillAB == 1)
						{
							skillfacplus = pskilldata._atkFactorVec2[1];
						}
					}
					
					//加基础属性buff
					var baseprobbff:buffEffect = new buffEffect();
					baseprobbff.bfside = bf.getSide();
					baseprobbff.btoside = bf.getSide();
					baseprobbff.bfpos = bf.getPos();
					baseprobbff.btpos = bf.getPos();
					if ( skilltype == skillType.ADDDODGE || skilltype == skillType.ADDDEFEND)
						baseprobbff.bround = skillround;
					else
						baseprobbff.bround = skillround+1;
					baseprobbff.btype = skilltype;
					baseprobbff.bvalue = skillfac;
					if(skilltype == skillType.ADDCOUNTER)
						baseprobbff.bvalue = skillfac*1000000+skillfacplus*1000;  
					baseprobbff.bfirst = true;
					baseprobbff.bskillid = bf.getSkillID();
					baseprobbff.bskillab = skillAB;
					bf.AddBufferEffect(baseprobbff, pPro);
				}
			    break;
				case skillType.ADDATTACK:
				{
					var pAddTarget:BattleFighter = null; 
					var joblist:Array = [2,3,1];
					for (i = 1; i < 4; i++)  //job从1到3
					{
						for ( j = 0; j < _fgtlist.length; ++j)
						{
							if (_fgtlist[j].bfgt.getSide() == bf.getSide() && _fgtlist[j].bfgt.getHP() > 0)
							{
								if (_fgtlist[j].bfgt.getJobID() == joblist[i-1] && _fgtlist[j].bfgt != bf )
								{
									pAddTarget = _fgtlist[j].bfgt;
									i = 4;
									break;
								}
							}
						}
					}
					
					//给队友添加攻击力
					if (pAddTarget)
					{							
						var addbff:buffEffect = new buffEffect();
						addbff.bfside = bf.getSide();
						addbff.btoside = pAddTarget.getSide();
						addbff.bfpos = bf.getPos();
						addbff.btpos = pAddTarget.getPos();
						addbff.bround = skillround;
						addbff.btype = skillType.ADDATTACK;
						addbff.bvalue = skillfac;
						addbff.bfirst = true;
						addbff.bskillid = bf.getSkillID();
						addbff.bskillab = skillAB;
						pAddTarget.AddBufferEffect(addbff, pPro);
					}
				}
				break;
				case skillType.REDUCEHITRATE:
				{
					var reduceTarget:BattleFighter = null;
					//降低下次攻击的命中率	
					for (j = 0; j < apcnt; ++j)
					{
						//释放技能概率
						if(ForRand.getRand() > skillprob * 10000)
							continue;
						reduceTarget = _objs[otherside][ap[j].pos];
						//给目标减去聚气
						if (reduceTarget && (reduceTarget.getHP() > 0) && (reduceTarget.getbDodge() == false))
						{
							if(ap[j].type != 0)
							{
								//加深伤害
								var reducehitrbff:buffEffect = new buffEffect();
								reducehitrbff.bfside = bf.getSide();
								reducehitrbff.btoside = reduceTarget.getSide();
								reducehitrbff.bfpos = bf.getPos();
								reducehitrbff.btpos = reduceTarget.getPos();
								reducehitrbff.bround = skillround;
								reducehitrbff.btype = skillType.REDUCEHITRATE;
								reducehitrbff.bvalue = skillfac;
								reducehitrbff.bfirst = true;
								reducehitrbff.bskillid = bf.getSkillID();
								reducedmgbff.bskillab = skillAB;
								reduceTarget.AddBufferEffect(reducehitrbff, pPro);
								
							}
						}
					}
				}
				break;
				case skillType.SPEEDTYPE:
				{
					//targetfighter->setCoolDown(static_cast<UInt32>(targetfighter->getCoolDown()*(1+slowFac)));
					var speedbff:buffEffect = new buffEffect();
					speedbff.bfside = bf.getSide();
					speedbff.btoside = bf.getSide();
					speedbff.bfpos = bf.getPos();
					speedbff.btpos = bf.getPos();
					speedbff.bround = skillround;
					speedbff.btype = skillType.SPEEDTYPE;
					speedbff.bvalue = skillfac;
					speedbff.bfirst = true;
					speedbff.bskillid = bf.getSkillID();
					speedbff.bskillab = skillAB;
					bf.AddBufferEffect(speedbff, pPro);
					
					
					//变动间隔队列
					var spc:int = 0;
					for (i = 0; i < _fgtlist.length; ++i)
					{
						if (_fgtlist[i].bfgt == bf && _fgtlist[i].poisonAction == 0)
						{
							spc = i;
							break;
						}
					}
					if (!bf.HasBufferEffect(speedbff))
					{					
						_fgtlist[spc].antiAction -= uint(_fgtlist[spc].bfgt.getBaseCoolDown()*speedbff.bvalue);
						var speedFs:FighterStatus = new FighterStatus(_fgtlist[spc].bfgt, _fgtlist[spc].maxAction, _fgtlist[spc].antiAction, _fgtlist[spc].poisonAction, _fgtlist[spc].poisonDamage, _fgtlist[spc].atkMark);
						_fgtlist.splice(spc, 1);
						insertFighterStatus(speedFs);
					}	
				}
				break;
				case skillType.ADDGAUGE:
				{
					//释放技能概率
					for (  j = 0; j < apcnt; ++j)
					{
						if( ForRand.getRand() > skillprob*10000 )
							continue;  //
						
						var addfighter:BattleFighter= _objs[otherside][ap[j].pos];
						//给目标减去聚气
						if (addfighter && (addfighter.getHP() > 0) && (addfighter.getbDodge() == false))
						{
							if(ap[j].type != 0)
							{
								if(skillfac > 0)
									addfighter.addQiGather( uint(skillfac), false, pPro, 0);
								
								///Logger.debug("@@@@@@Hit Gauge--" + targetobj.getSide() +  "/" + targetobj.getPos() + "--before--"+ showgauge + "--after--" + targetobj.getGauge()+ "--value-- " + uint(addValue));
								
								//给客户端表现减聚气技能
								var gaugeBuf:BtStatus = new BtStatus();
								gaugeBuf.atkorBackatk = 0;
								gaugeBuf.sideFrom = bf.getSide();
								gaugeBuf.toside = addfighter.getSide();
								gaugeBuf.fpos = bf.getPos();
								gaugeBuf.tpos = addfighter.getPos();
								gaugeBuf.skillid = bf.getSkillID();
								gaugeBuf.type = 2;       //加血buffer
								gaugeBuf.data = 0;       //减少量
								gaugeBuf.skillab = skillAB;
								pPro.SChangeList.push(gaugeBuf);
								
								for(k = 0; k < pPro.defendList.length; ++k)
								{
									if((pPro.defendList[k] as BtDefend).pos == addfighter.getPos())
									{
										(pPro.defendList[k] as BtDefend).aterleftGauge = addfighter.getGauge();
										break;
									}
								}
							}
						}
					}
				}
				break;
				case skillType.REDUCESPELLDMG:
				{
					//降低下次受仙术攻击的伤害
					var reducedmgbff:buffEffect = new buffEffect();
					reducedmgbff.bfside = bf.getSide();
					reducedmgbff.btoside = bf.getSide();
					reducedmgbff.bfpos = bf.getPos();
					reducedmgbff.btpos = bf.getPos();
					reducedmgbff.bround = skillround;
					reducedmgbff.btype = skillType.REDUCESPELLDMG;
					reducedmgbff.bvalue = skillfac;
					reducedmgbff.bfirst = true;
					reducedmgbff.bskillid = bf.getSkillID();
					reducedmgbff.bskillab = skillAB;
					bf.AddBufferEffect(reducedmgbff, pPro);
				}
				break;
				case skillType.REBECRITPROB:
				{
					//给客户端表现降低受暴击概率技能
					var rebecritprobbff:buffEffect = new buffEffect();
					rebecritprobbff.bfside = bf.getSide();
					rebecritprobbff.btoside = bf.getSide();
					rebecritprobbff.bfpos = bf.getPos();
					rebecritprobbff.btpos = bf.getPos();
					rebecritprobbff.bround = skillround;
					rebecritprobbff.btype = skillType.REBECRITPROB;
					rebecritprobbff.bvalue = skillfac;
					rebecritprobbff.bfirst = true;
					rebecritprobbff.bskillid = bf.getSkillID();
					rebecritprobbff.bskillab = skillAB;
					bf.AddBufferEffect(rebecritprobbff, pPro);
				}
				break;
				case skillType.REBEPIERCEPROB:
				{
					//给客户端表现降低受破击概率技能
					var rebepiepbff:buffEffect = new buffEffect();
					rebepiepbff.bfside = bf.getSide();
					rebepiepbff.btoside = bf.getSide();
					rebepiepbff.bfpos = bf.getPos();
					rebepiepbff.btpos = bf.getPos();
					rebepiepbff.bround = skillround;
					rebepiepbff.btype = skillType.REBEPIERCEPROB;
					rebepiepbff.bvalue = skillfac;
					rebepiepbff.bfirst = true;
					rebepiepbff.bskillid = bf.getSkillID();
					rebepiepbff.bskillab = skillAB;
					bf.AddBufferEffect(rebepiepbff, pPro);
				}
				break;
				case skillType.ADDMYSELFATTACK:
				{
					var addmyatkbff:buffEffect = new buffEffect();
					addmyatkbff.bfside = bf.getSide();
					addmyatkbff.btoside = bf.getSide();
					addmyatkbff.bfpos = bf.getPos();
					addmyatkbff.btpos = bf.getPos();
					addmyatkbff.bround = skillround+1;  //设置多一轮 
					addmyatkbff.btype = skillType.ADDMYSELFATTACK;
					addmyatkbff.bvalue = skillfac;
					addmyatkbff.bfirst = true;
					addmyatkbff.bskillid = bf.getSkillID();
					addmyatkbff.bskillab = skillAB;
					bf.AddBufferEffect(addmyatkbff, pPro);
				}
				break;
				case skillType.REDUCEATTACK:
				{
					for(j = 0; j < apcnt; ++j)
					{
						if( ForRand.getRand() > skillprob*10000 )
							continue;  //
						var reduceatkfighter:BattleFighter = _objs[otherside][ap[j].pos];
						if( reduceatkfighter && (reduceatkfighter.getHP() > 0) && (reduceatkfighter.getbDodge() == false) )
						{
							if(ap[j].type != 0)
							{
								
								///Logger.debug("@@@@@@----"+targetfighter.getSide()+"/" + targetfighter.getPos() + "hit stun");
								
								var reatkbuff:buffEffect = new buffEffect();
								reatkbuff.bfside = bf.getSide();
								reatkbuff.btoside = targetfighter.getSide();
								reatkbuff.bfpos = bf.getPos();
								reatkbuff.btpos = targetfighter.getPos();
								reatkbuff.bround = skillround;
								reatkbuff.btype = skillType.REDUCEATTACK;
								reatkbuff.bvalue = skillfac;
								reatkbuff.bfirst = true;
								reatkbuff.bskillid =  bf.getSkillID();
								reatkbuff.bskillab = skillAB;
								reduceatkfighter.AddBufferEffect(reatkbuff, pPro);		
							}
						}
					}
				}
				break;
				default:
				{
					break;
				}
			}
			return 0;
		}
		//找到攻击者
		private function findFirstAttacker():int
		{
			var c:uint = 1;
			var cnt:uint = _fgtlist.length;
			var act:uint = _fgtlist[0].antiAction;
			while( c < cnt && _fgtlist[c].antiAction == act )
				++c;
			if( c == 1)
				return 0;
			return (ForRand.getRand(c));
		}
		
		private function addBufferByFormation():void
		{
			for (var i:int = 0; i < 2; i++)
			{
				for (var j:int = 0; j < 25; j++)
				{
					if (_objs[i][j] != null)
					{
						_objs[i][j].AddFEffect();
					}
				}
			}
		}
		
		public function setAllPlayerDodge(b:Boolean):void
		{
			var i:int;
			var j:int;
			for (i = 0; i < 2; ++i)
			{
				for (j = 0; j < 25; ++j)
				{
					if ( _objs[i][j] != null )
					{
						(_objs[i][j] as BattleFighter).setbDodge(b);
					}
				}
			}
		}
	   
		private var _id:int;
		private var _winner:int;
		private var _turns:int;
		private var _millisecs:int;
		private var _location:int;
		private var _maxTurns:int;
		private var _fgtlist:Array = [];
		private var _portrait:Array = [];
		private var _player:Array = [];
		private var _maxAction:uint;
		private var _randNumber:uint;
	   
		
	}
	
}