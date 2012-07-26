package game.module.battle
{
	import game.module.battle.battleData.BtProcess;
	import game.module.battle.battleData.BtStatus;
	import game.module.battle.battleData.PointEffect;
	import game.module.battle.battleData.PropInfo2Base;
	import game.module.battle.battleData.Vars;
	import game.module.battle.battleData.buffEffect;
	import game.module.battle.battleData.skillType;
	
	import log4a.Logger;
	

	public class BattleFighter
	{

		public function BattleFighter(prop : PropInfo2Base = null, weaponType : uint = 0, skillId : uint = 0, side : uint = 0, pos : uint = 0, nstr:String = "", pEf:PointEffect = null, jobID:uint = 0)
		{
			_propInfo2 = prop;
			_hpNow = prop.health;
			_gauge = prop.gaugeInit;
			_weaponType = weaponType;
			_skillId = skillId;
			_side = side;
			_pos = pos;
			_stunRound = 0;
			bPointEffect = false;
			_coolDown = 0;
			_bftNmae = nstr;
			pEffect = pEf;
			_jobID = jobID;
			b_Dodge = false;
		}

		public function setSideAndPos(side : uint, pos : uint) : void
		{
			_side = side;
			_pos = pos;
		}

		public function getSide() : uint
		{
			return _side;
		}

		public function getPos() : uint
		{
			return _pos;
		}

		public function getId() : uint
		{
			return _id;
		}

		public function getLevel() : uint
		{
			return _level;
		}

		public function getColor() : uint
		{
			return _color;
		}
		
		public function getFighterName():String
		{
			return _bftNmae;
		}
		
		public function getJobID():uint
		{
			return _jobID;
		}

		public function setBaseInfo(id : uint, level : uint, color : uint) : void
		{
			_id = id;
			_level = level;
			_color = color;
		}

		public function setPorpertyB(pb : PropInfo2Base) : void
		{
			_propInfo2 = pb.clone();
		}

		public function getHP() : uint
		{
			return _hpNow;
		}
		
		public function getMaxHP():uint
		{
			return _propInfo2.health;
		}
		public function AddHP(ahp:uint):void
		{
			if(ahp + _hpNow >= _propInfo2.maxhp)
			{
				_hpNow = _propInfo2.maxhp;
			}
			else
			{
				_hpNow += ahp;
			}
		}
		
		public function getHpConsume():uint 
		{
			//return _propInfo2.health - _hpNow;
			return _propInfo2.maxhp - _hpNow;
			
		}
//		public function getAddHpConsume():uint
//		{
//			return _propInfo2.maxhp - _hpNow;
//		}
		
		public function getBaseCoolDown():uint
		{
			return _BaseCoolDown;
		}

		public function getAttack() : uint
		{
			var addFac:Number = 0;
			for (var i:int = 0; i < _vecBuff.length;)
			{
				if ( skillType.ADDATTACK == _vecBuff[i].btype || skillType.ADDMYSELFATTACK == _vecBuff[i].btype)
				{
					if ( 0 == _vecBuff[i].bround )
					{
						_vecBuff.erase(_vecBuff.begin()+i);
					}
					else
					{
						addFac += _vecBuff[i].bvalue;
						i++;
					}
				}
				else if(skillType.REDUCEATTACK == _vecBuff[i].btype)
				{
					if ( 0 == _vecBuff[i].bround )
					{
						_vecBuff.erase(_vecBuff.begin()+i);
					}
					else
					{
						addFac -= _vecBuff[i].bvalue;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			return uint(_propInfo2.attack) + uint(addFac*_propInfo2.attack);
		}

		public function getSpellDamage() : int
		{
			return _propInfo2.spellPow;
		}

		public function getDefend() : int
		{
			var defendFac:int = 0;
			for (var i:int = 0; i < _vecBuff.length;)
			{
				if ( skillType.ADDDEFEND == _vecBuff[i].btype)
				{
					if ( 0 == _vecBuff[i].bround )
					{
						_vecBuff.erase(_vecBuff.begin()+i);
					}
					else
					{
						defendFac += _vecBuff[i].bvalue;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			
			if(_propInfo2.damageAmp > 0)
				return (_propInfo2.defend * (1.0 - _propInfo2.damageAmp)) + defendFac;
			else
				return _propInfo2.defend + defendFac;
		}
		
		public function getDamageDef():Number
		{
			return _propInfo2.damageDef;
		}
		
		public function getHitrate() : Number
		{
			var hitRateBufFac:Number = 0.0;
			for (var i:int = 0; i < _vecBuff.length;)
			{
				if ( skillType.REDUCEHITRATE == _vecBuff[i].btype)
				{
					if ( 0 == _vecBuff[i].bround )
					{
						_vecBuff.erase(_vecBuff.begin()+i);
					}
					else
					{
						hitRateBufFac += _vecBuff[i].bvalue;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			return _propInfo2.hitrate - hitRateBufFac;
		}

		public function getdodge() : Number
		{
			var dodgeBufFac:Number = 0.0;
			for (var i:int = 0; i < _vecBuff.length;)
			{
				if ( skillType.ADDDODGE == _vecBuff[i].btype)
				{
					if ( 0 == _vecBuff[i].bround )
					{
						_vecBuff.erase(_vecBuff.begin()+i);
					}
					else
					{
						dodgeBufFac += _vecBuff[i].bvalue;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			return _propInfo2.dodge + dodgeBufFac;
		}

		public function getSpeed() : uint
		{
			var speedBufFac:Number = 0.0;  //the same to cooldownBufFac
			for (var i:int = 0; i < _vecBuff.length;)
			{
				if ( skillType.SPEEDTYPE == _vecBuff[i].btype || skillType.SLOWTYPE == _vecBuff[i].btype)
				{
					if ( 0 == _vecBuff[i].bround )
					{
						_vecBuff.erase(_vecBuff.begin()+i);
					}
					else if( skillType.SLOWTYPE == _vecBuff[i].btype)
					{
						speedBufFac -= _vecBuff[i].bvalue;
						i++;
					}
					else if ( skillType.SPEEDTYPE == _vecBuff[i].btype)
					{
						speedBufFac += _vecBuff[i].bvalue;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			return (_propInfo2.speed + _propInfo2.speed * speedBufFac);
		}

		public function getCrit(targobj:BattleFighter = null) : Number
		{
			var critBufFac:Number = 0.0;
			for (var i:int = 0; i < _vecBuff.length;)
			{
				if ( skillType.ADDCRIT == _vecBuff[i].btype)
				{
					if ( 0 == _vecBuff[i].bround )
					{
						_vecBuff.splice(i, 1, _vecBuff[i]);
					}
					else
					{
						critBufFac += uint(_vecBuff[i].bvalue/10000)*10/1000.0;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			if(targobj == null)
				return _propInfo2.critical + critBufFac;
			else
				return _propInfo2.critical + critBufFac - targobj.getReProbability(skillType.REBECRITPROB);
		}

		public function getHighExplosive() : Number
		{
			var critBufFac:Number = 0.0;
			for (var i:int = 0; i < _vecBuff.length;)
			{
				if ( skillType.ADDCRIT == _vecBuff[i].btype)
				{
					if ( 0 == _vecBuff[i].bround )
					{
						_vecBuff.splice(i, 1, _vecBuff[i]);
					}
					else
					{
						critBufFac += uint(_vecBuff[i].bvalue%10000)/1000.0;
						i++;
					}
				}
				else
				{
					i++;
				}
			}

			return _propInfo2.critMul+ critBufFac;
		}

		
		public function getPierce(targobj:BattleFighter = null) : Number
		{
			var pierceBufFac:Number = 0.0;
			for (var i:int = 0; i < _vecBuff.length;)
			{
				if ( skillType.ADDPIERCE == _vecBuff[i].btype)
				{
					if ( 0 == _vecBuff[i].bround )
					{
						_vecBuff.splice(i, 1, _vecBuff[i]);
					}
					else
					{
						pierceBufFac += _vecBuff[i].bvalue;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			if(targobj == null)
				return _propInfo2.pierce + pierceBufFac;
			else
				return _propInfo2.pierce + pierceBufFac - targobj.getReProbability(skillType.REBEPIERCEPROB);
		}

		public function getCounter() : Number
		{
			var counterBufFac:Number = 0.0;
			for (var i:int = 0; i < _vecBuff.length;)
			{
				if ( skillType.ADDCOUNTER == _vecBuff[i].btype)
				{
					if ( 0 == _vecBuff[i].bround )
					{
						_vecBuff.erase(_vecBuff.begin()+i);
					}
					else
					{
						counterBufFac += uint(_vecBuff[i].bvalue/10000)*10/1000.0;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			return _propInfo2.counter + counterBufFac;
		}

		public function getCounterMul() : Number
		{
			var counterBufFac:Number = 0.0;
			for (var i:int = 0; i < _vecBuff.length;)
			{
				if ( skillType.ADDCOUNTER == _vecBuff[i].btype)
				{
					if ( 0 == _vecBuff[i].bround )
					{
						_vecBuff.erase(_vecBuff.begin()+i);
					}
					else
					{
						counterBufFac += uint(_vecBuff[i].bvalue)%10000/1000.0;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			return _propInfo2.counterMul + counterBufFac;
		}


		public function getPierceDef() : Number
		{
			return _propInfo2.pierceDef;
		}

		public function getWeaponType() : uint
		{
			return _weaponType;
		}

		public function getSpellDMultiple() : Number
		{
			return _propInfo2.spellMul;
		}
		
		public function getResistanceFac():Number
		{
			var mfac:Number = 0.0;
			for(var i:int = 0; i < _vecBuff.length; ++i)
			{
				if(_vecBuff[i].btype == skillType.RESISTANCE)
				{
					mfac += _vecBuff[i].bvalue;
				}
			}
			return mfac;
		}
		
		public function getDeepHurtFac():Number
		{
			var mfac:Number = 0.0;
			for(var i:int = 0; i < _vecBuff.length; ++i)
			{
				if(_vecBuff[i].btype == skillType.DEEPHURT)
				{
					mfac += _vecBuff[i].bvalue;
				}
			}
			return mfac;
		}
		
		public function getReSpelldmgFac():Number
		{
			var dfac:Number = 0.0;
			for (var i:int = 0; i < _vecBuff.length; ++i)
			{
				if (_vecBuff[i].btype == skillType.REDUCESPELLDMG)
				{
					dfac += _vecBuff[i].bvalue;
				}
			}
			return dfac;
		}
		
		public function getReProbability(type:uint):Number
		{
			var probFac:Number = 0.0;
			for (var i:int = 0; i < _vecBuff.length;)
			{
				if ( type == _vecBuff[i].btype)
				{
					if ( 0 == _vecBuff[i].bround )
					{
						_vecBuff.erase(_vecBuff.begin()+i);
					}
					else
					{
						probFac += _vecBuff[i].bvalue;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			return probFac;
		}

		public function makeDamage(u : uint) : void
		{
			if (_hpNow < u)
				_hpNow = 0;
			else
				_hpNow -= u;
		}

		public function isCalcHit(pdefender : BattleFighter) : Boolean              // 命中判断
		{
			// 实际命中率
			var thehitrate : Number = (getHitrate() - pdefender.getdodge()) * 10000;
			if (thehitrate >= 10000)  // 必中
				return true;
			return ForRand.getRand() < thehitrate;
		}

		public function isCritAttack(targobj:BattleFighter) : Boolean            // 暴击判读
		{
			return ForRand.getRand() < getCrit(targobj) * 10000;
		}

		public function ispierceAttack(targobj:BattleFighter) : Boolean         // 破击判断
		{
			return ForRand.getRand() < getPierce(targobj) * 10000;
		}

		public function isCounter() : Boolean           // 反击判断
		{
			return ForRand.getRand() < getCounter() * 10000;
		}

		public function calcDefendPercent() : Number      // 计算防御百分比
		{
			var m_defend:int = getDefend();
			return Number(m_defend) / (m_defend + Vars.defendcontrol);
		}

		public function calcCritMultiple() : Number
		{
			return Vars.critfactor * (1.0 + getHighExplosive());
		}

		public function calcBackAtkMultiple() : Number
		{
			return Vars.backatkfactor * (1.0 + getCounterMul());
		}

		public function getGauge() : int
		{
			return _gauge;
			// 当前聚气值
		}
		
		public function getInitGauge() : int
		{
			return _propInfo2.gaugeInit;          //初始聚气值
		}
		
		public function getMaxGauge() : int
		{
			return _propInfo2.gaugeMax;           //最大聚气值
		}

		public function getTrigger() : int                           // 触发点
		{
			return _propInfo2.gaugeUse;
		}

		public function getSkillID() : int
		{
			return _skillId;
			// 技能id
		}

		public function getPRound() : int                          // 中毒回合数
		{
			return _pRound;
		}

		public function setPRound(pr : int) : void
		{
			_pRound = pr;
			if (pr < 0)
				_pRound = 0;
		}

		public function setStunRound(s : int) : void                        // 设置眩晕回合数
		{
			if(s <= 0)
				_stunRound = 0;
			else
				_stunRound = s;
		}

		public function getStunRound() : int
		{
			return _stunRound;
		}

		public function calcNormalPhyAtk(pdefender : BattleFighter) : Number          // 物理攻击---普通攻击伤害
		{
			return getAttack() * ( 1.0 - pdefender.calcDefendPercent());
		}

		public function calcCritPhyAtk(pdefender : BattleFighter) : Number            // 物理攻击---暴击伤害
		{
			return calcCritMultiple() * getAttack() * (1.0 - pdefender.calcDefendPercent());
		}

		public function calcpiercePhyAtk(pdefender : BattleFighter) : Number          // 物理攻击---破击伤害
		{
			return getAttack() * ( 1.0 - pdefender.getPierceDef());
		}

		public function calcCritpiercePhyAtk(pdefender : BattleFighter) : Number      // 物理攻击---爆破伤害
		{
			return getAttack() * calcCritMultiple() * ( 1.0 - pdefender.getPierceDef());
		}

		public function calcNormalSpellDamage(pdefender : BattleFighter) : Number     // 法术伤害没有触发暴破时
		{
			//return getAttack() * (1.0 + getSpellDMultiple()) * (1.0 - pdefender.calcDefendPercent()) + getSpellDamage() * (1.0 - pdefender.calcDefendPercent());
			return (getAttack()+getSpellDamage())* (1.0 + getSpellDMultiple()) * (1.0 - pdefender.calcDefendPercent());
		}

		public function calcCritSpellDamage(pdefender : BattleFighter) : Number        // 法术伤害触发暴击时
		{
			//return (calcCritMultiple() * Vars.weakenfactor + getSpellDMultiple() ) * getAttack() * (1.0 - pdefender.calcDefendPercent()) + getSpellDamage() * calcCritMultiple() * Vars.weakenfactor * ( 1.0 - pdefender.calcDefendPercent());
		
			return (getAttack()+getSpellDamage())* (1.0 + getSpellDMultiple()) * (1.0 - pdefender.calcDefendPercent())*calcCritMultiple() * Vars.weakenfactor;
		}

		public function calcPierceSpellDamage(pdefender : BattleFighter) : Number      // 法术伤害触发破击时
		{
			//return getAttack() * ( 1.0 + getSpellDMultiple()) * ( 1.0 - pdefender.getPierceDef()) + getSpellDamage() * (1.0 - getPierceDef());
			return (getAttack()+getSpellDamage())* (1.0 + getSpellDMultiple()) * (1.0 - pdefender.getPierceDef()); 
		}

		public function calcCritpierceSpellDamage(pdefender : BattleFighter) : Number  // 法术伤害触发暴破时
		{
			//return ( calcCritMultiple() * Vars.weakenfactor + getSpellDMultiple() ) * getAttack() * ( 1.0 - pdefender.getPierceDef() ) + getSpellDamage() * calcCritMultiple() * Vars.weakenfactor * ( 1.0 - pdefender.getPierceDef() );
			return (getAttack()+getSpellDamage())* (1.0 + getSpellDMultiple()) * (1.0 - pdefender.getPierceDef()) * calcCritMultiple() * Vars.weakenfactor; 	
		}
		
		public function AddFEffect() : void       //ÔÚ¿ªÊ¼Õ½¶·Ç°µ÷ÓÃÒ»´Î
		{
			if(pEffect != null)
			{
			//	if (this.getPos() == pEffect.getPointPos())
				{
					var fmBuff:buffEffect = new buffEffect();
					fmBuff.bfside = -1;
					fmBuff.btoside = -1;
					fmBuff.bfpos = -1;
					fmBuff.btpos = this.getPos();
					fmBuff.bround = 1;
					switch(pEffect.getEffectType())
					{
						case Formation.FORMATION1 :
							this.addQiGather(pEffect.m_addExtra,true);
							break;
						case  Formation.FORMATION2 :                    //¶ÔÓ¦Ôö¼Ó±©»÷
						{
							fmBuff.btype = skillType.SPEEDTYPE;
							fmBuff.bvalue = pEffect.m_addExtra;
							fmBuff.bfirst = true;
							AddBufferEffect(fmBuff);
						}
							break;
						case  Formation.FORMATION3:                     //¶ÔÓ¦¼õËÙ
						{
							fmBuff.btype = skillType.ADDCRIT;
							fmBuff.bvalue = pEffect.m_addExtra*1000000;
							fmBuff.bfirst = true;
							AddBufferEffect(fmBuff);
						}
							break;
						case  Formation.FORMATION4:
						{
							fmBuff.btype = skillType.ADDPIERCE;
							fmBuff.bvalue = pEffect.m_addExtra;
							fmBuff.bfirst = true;
							AddBufferEffect(fmBuff);
						}
							break;
					}
					bPointEffect = true;
				}
			}
		}

		public function addQiGather(gNum : int,bAdd : Boolean = true, pPro:BtProcess = null, atkorBackatk:int = 0) : void                // 计算聚气
		{
			if (bAdd)
			{
				_gauge += gNum;
				if ( _gauge >= _propInfo2.gaugeMax )
					_gauge = _propInfo2.gaugeMax;
			}
			else
			{
				_gauge -= gNum;
				if (_gauge <= 0)
					_gauge = 0;
			}
			
			if(pPro != null)
			{
				//trace(this);		
				if(b_hasGaugebuff == false && bAdd == true && _gauge >= this.getTrigger())
				{
					var bgAdd:BtStatus = new BtStatus();
					bgAdd.atkorBackatk = atkorBackatk;
					bgAdd.sideFrom = this.getSide();
					bgAdd.toside = this.getSide();
					bgAdd.fpos = this.getPos();
					bgAdd.tpos = this.getPos();
					bgAdd.skillid = skillType.GAUGEFULL;
					bgAdd.type = 1;   //聚气满
					pPro.SChangeList.push(bgAdd);
					b_hasGaugebuff = true;
				}
				
			    if(b_hasGaugebuff == true && bAdd == false && (_gauge < this.getTrigger()) ) //取消聚气
				{
					var bgCancel:BtStatus = new BtStatus();
					bgCancel.atkorBackatk = atkorBackatk;
					bgCancel.sideFrom = this.getSide();
					bgCancel.toside = this.getSide();
					bgCancel.fpos = this.getPos();
					bgCancel.tpos = this.getPos();
					bgCancel.skillid = skillType.GAUGEFULL;
					bgCancel.type = 0;   //聚气释放
					pPro.SChangeList.push(bgCancel);
					b_hasGaugebuff = false;
				}
			}

		}
			
		public function getCoolDown():uint
		{
			var coolDownBufFac:Number = 0.0;
			for (var i:int = 0; i < _vecBuff.length;)
			{
				if ( skillType.SPEEDTYPE == _vecBuff[i].btype || skillType.SLOWTYPE == _vecBuff[i].btype)
				{
					if ( 0 == _vecBuff[i].bround )
					{
						_vecBuff.splice(i, 1, _vecBuff[i]);
					}
					else if(skillType.SLOWTYPE == _vecBuff[i].btype)
					{
						coolDownBufFac += _vecBuff[i].bvalue;
						i++;
					}
					else if(skillType.SPEEDTYPE == _vecBuff[i].btype)
					{
						coolDownBufFac -= _vecBuff[i].bvalue;
						i++;
					}
				}
				else
				{
					i++;
				}
			}
			return uint(_coolDown + _BaseCoolDown * coolDownBufFac);
		}
		
		public function setCoolDown(cd:uint):void
		{
			_coolDown = cd;
			_BaseCoolDown = _coolDown;
		}
		public function MinusBuffRound(buffType:uint, pPro:BtProcess, atkorBackatk:int, bs:BtStatus = null):void
		{
			var cancelArray:Array = new Array();
			var ebuf:buffEffect = null;
			var pBuf:BtStatus = null;
			if(bs == null)
				pBuf = new BtStatus();
			for (var i:int = 0; i < _vecBuff.length; ++i)
			{
				ebuf = _vecBuff[i];
				if (ebuf.btype == buffType)
				{
					ebuf.bround--;
					
					if(buffType == skillType.POISONTYPE && bs != null)
					{													
						bs.atkorBackatk = 0;
						bs.sideFrom =ebuf.bfside;
						bs.toside = ebuf.btoside;
						bs.fpos = ebuf.bfpos;
						bs.tpos = ebuf.btpos;
						bs.skillid = ebuf.bskillid;
						bs.type =(ebuf.bround > 0) ? 1 : 0;   //取消
						pPro.SChangeList.push(bs);
						BtProcess.data.push(pPro);
						break;
					}
					else if(buffType == skillType.STUNTYPE)
					{
						if(ebuf.bround == 0)
						{
							pBuf.atkorBackatk = 0;
							pBuf.sideFrom =ebuf.bfside;
							pBuf.toside = ebuf.btoside;
							pBuf.fpos = ebuf.bfpos;
							pBuf.tpos = ebuf.btpos;
							pBuf.skillid = ebuf.bskillid;
							pBuf.type = 0;   //取消
							pBuf.skillab = ebuf.bskillab;
							pPro.SChangeList.push(pBuf);
							BtProcess.data.push(pPro);
						}
						
					}
					else if(
						     buffType == skillType.ADDCRIT    ||
					         buffType == skillType.ADDPIERCE)
					{
						if(ebuf.bround == 1)
						{
							pBuf.atkorBackatk = 0;
							pBuf.sideFrom =ebuf.bfside;
							pBuf.toside = ebuf.btoside;
							pBuf.fpos = ebuf.bfpos;
							pBuf.tpos = ebuf.btpos;
							pBuf.skillid = ebuf.bskillid;
							pBuf.type = 0;   //取消
							pBuf.skillab = ebuf.bskillab;
							pPro.SChangeList.push(pBuf);
						}
					}
					else 
					{
						if(ebuf.bround == 0)
						{
							pBuf.atkorBackatk = 0;
							pBuf.sideFrom =ebuf.bfside;
							pBuf.toside = ebuf.btoside;
							pBuf.fpos = ebuf.bfpos;
							pBuf.tpos = ebuf.btpos;
							pBuf.skillid = ebuf.bskillid;
							pBuf.type = 0;   //取消
							pBuf.skillab = ebuf.bskillab;
							pPro.SChangeList.push(pBuf);
						}
					}
					
					if(ebuf.bround == 0)
					{				
						_vecBuff.splice(i, 1);
						i--;
					}
				}
			}
		}
		
		public function AddBufferEffect(bff:buffEffect, pPro:BtProcess = null):void
		{
			for(var i:int = 0; i < _vecBuff.length; ++i)
			{
				if (_vecBuff[i].bfside == bff.bfside && _vecBuff[i].bfpos == bff.bfpos && _vecBuff[i].btype == bff.btype )
				{
					_vecBuff[i].bround = bff.bround;
					_vecBuff[i].bfirst = false;
					return;
				}
			}
			
			if(pPro != null && _vecBuff != null && bff != null)
			{
				var rsBs:BtStatus = new BtStatus();
				rsBs.sideFrom = bff.bfside;
				rsBs.toside = bff.btoside;
				rsBs.fpos = bff.bfpos
				rsBs.tpos = bff.btpos;
				rsBs.skillid = bff.bskillid;
				rsBs.type = 1;   //加buff
				rsBs.skillab = bff.bskillab;
				pPro.SChangeList.push(rsBs);
			}
			
			_vecBuff.push(bff);
		}
		
		public function HasBufferEffect(bff:buffEffect):Boolean
		{
			for (var i:int = 0;  i < _vecBuff.length; ++i)
			{
				if (_vecBuff[i].bfside == bff.bfside && _vecBuff[i].bfpos == bff.bfpos && _vecBuff[i].btype == bff.btype && _vecBuff[i].bfirst == false)
				{
					return true;
				}
			}
			return false;
		}
		
		public function getPerBufRound(type:int, pos:int = -1):int
		{
			var round:int = 0;
			var i:int = 0;
			if (pos == -1)
			{
				for ( i = 0;  i < _vecBuff.length; ++i)
				{
					if (_vecBuff[i].btype == type )
					{
						round += _vecBuff[i].bround;
					}
				}
			}
			else
			{
				for ( i = 0;  i < _vecBuff.length; ++i)
				{
					if (_vecBuff[i].btype == type && _vecBuff[i].bfpos == pos)
					{
						round += _vecBuff[i].bround;
					}
				}
			}
			return round;
		}
		
		public function ClearNegativeBuff(pPro:BtProcess):void
		{
			for (var i:int = 0; i < _vecBuff.size(); ++i)
			{
				if ( _vecBuff[i].btype ==  skillType.STUNTYPE || _vecBuff[i].btype ==  skillType.SLOWTYPE
					|| _vecBuff[i].btype ==  skillType.DEEPHURT || _vecBuff[i].btype ==  skillType.REDUCEHITRATE
					|| _vecBuff[i].btype ==  skillType.REDUCESPELLDMG || _vecBuff[i].btype ==  skillType.REDUCEATTACK)
				{
					this.setStunRound(0);
					_vecBuff.erase(_vecBuff.begin()+i);
					var pBuf:BtStatus = new BtStatus();
					var ebuf:buffEffect = _vecBuff[i] as buffEffect;
					pBuf.atkorBackatk = 0;
					pBuf.sideFrom =ebuf.bfside;
					pBuf.toside = ebuf.btoside;
					pBuf.fpos = ebuf.bfpos;
					pBuf.tpos = ebuf.btpos;
					pBuf.skillid = ebuf.bskillid;
					pBuf.type = 0;   //取消
					pBuf.skillab = ebuf.bskillab;
					pPro.SChangeList.push(pBuf);
					
					--i;
				}
			}
		}

		public function updateAllAttr() : void
		{
		}
		
		public function setbHasGaugebuff(b_has:Boolean):void
		{
			b_hasGaugebuff = b_has;
		}
		
		public function setbDodge(b:Boolean):void
		{
			b_Dodge = b;
		}
		
		public function getbDodge():Boolean
		{
			return b_Dodge;
		}

		private var _side : uint;

		// 边
		private var _pos : uint;

		// 位置
		private var _id : uint;

		// id
		private var _level : uint;

		// level
		private var _color : uint;
		
		private var _bftNmae:String = "";    //fighter Name
		
		private var _jobID:uint;         //职业id

		// 颜色
		private var _propInfo2 : PropInfo2Base;
		
		private var _coolDown:uint;     //攻击间隔
		
		private var _BaseCoolDown:uint;
		
		private var _vecBuff:Array = []; //来自其他除了中毒，眩晕外的效果
		
		private var pEffect:PointEffect = null;
		
		private var bPointEffect:Boolean;

		// 二级属性
		private var _gauge : int;

		private var _weaponType : uint;

		private var _skillId : uint;
		
		private var _hpNow:int;

		private var _pRound : uint;

		//是否已经有中毒的buff
		private var b_hasGaugebuff:Boolean = false;
		
		// 回合(中毒)
		private var _stunRound : uint;
		// 眩晕回合(次数最后一位表示眩晕数量)
		private var b_Dodge:Boolean;
	}
}