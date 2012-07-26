// ActionScript file
package game.module.battle.battleData
{
	public class skillData
	{
		public var skillID:uint;        //技能id
		public var atkID:uint;          //攻击方式id
		public var _round:uint;          //攻击回合
		public var prob:Number;
		public var _atkFactorVec:Array;  //技能系数
		
		public var _round2:uint;
		public var prob2:Number;
		public var _atkFactorVec2:Array;
		
		private var _skillname:String = "";    //技能名字
		private var _movetype:uint;       //移动类型
		private var _spelleftid:uint;     //法术效果id
		private var _needbuff:Number;       //一技能id   0：表示没有buff  >0: 表示有buff   举例：21.111 （小数点第一位：1表示上层 2表示下层  第二位：1表示头顶位置 2表示叠在身上 第三位：1表示表示动态循环播放 2表示播放到最后一帧）
		private var _needbuffplus:Number;   //二技能id   0：表示没有buff  >0: 表示有buff   举例：21.111 （小数点第一位：1表示上层 2表示下层  第二位：1表示头顶位置 2表示叠在身上 第三位：1表示表示动态循环播放 2表示播放到最后一帧） 
		
		private var _angletype:uint;      //技能效果有无角度
		private var _targettype:uint;     //效果播放目标 
		private var _groundid:uint;       //地面效果
		private var _groundcanturnover:uint; //地面效果翻转 0:不需要翻转 1：程序翻转 2：美术翻转
		private var _groundtype:uint;     //上层还是下层
		private var _updownwords:String = "";
		private var _updownwordsplus:String = "";
		private var _canturnover:uint;    //技能动画是否可以翻转
		
		private var _spelleftid2:uint;     //法术效果id
		private var _needbuff2:Number;       //0：表示没有buff  >0: 表示有buff   举例：21.111 （小数点第一位：1表示上层 2表示下层  第二位：1表示头顶位置 2表示叠在身上 第三位：1表示表示动态循环播放 2表示播放到最后一帧）
		private var _angletype2:uint;      //技能效果有无角度
		private var _targettype2:uint;     //效果播放目标 
		private var _groundid2:uint;       //地面效果
		private var _groundtype2:uint;     //上层还是下层
		private var _updownwords2:String = "";
		private var _canturnover2:uint;    //技能动画是否可以翻转
		
		
		public function getSkillName():String
		{
			return _skillname;
		}
		public function setSkillName(name:String):void
		{
			_skillname = name;
		}
		public function getMoveType():uint
		{
			return _movetype;
		}
		public function setMoveType(m:uint):void
		{
			_movetype = m;
		}
		
		public function getSpellEftId():uint
		{
			return _spelleftid;
		}
		
		public function setSpellEftId(s:uint):void
		{
			_spelleftid = s;
		}
		
		
		public function getSpellEftId2():uint
		{
			return _spelleftid2;
		}
		
		public function setSpellEftId2(s:uint):void
		{
			_spelleftid2 = s;
		}
		
		
		public function getBuffID():uint
		{
			return uint(_needbuff);
		}
		public function setNeedBuff(n:Number):void
		{
			_needbuff = n;
		}
		public function getBuffIndex():uint   //1：上层 2：下层
		{
			return uint(_needbuff*1000%1000/100);
		}
		
		public function getBuffPosition():uint //1：头顶 2：身上
		{
			return uint(_needbuff*1000%100/10);
		}
		
		public function getBuffPlayType():uint //1:动态循环 2：播放到最后一帧
		{
			return uint(_needbuff*1000%10);
		}
		
		public function getBuffPlusID():uint
		{
			return uint(_needbuffplus);
		}
		public function setNeedBuffPlus(n:Number):void
		{
			_needbuffplus = n;
		}
		public function getBuffPlusIndex():uint   //1：上层 2：下层
		{
			return uint(_needbuffplus*1000%1000/100);
		}
		
		public function getBuffPlusPosition():uint //1：头顶 2：身上
		{
			return uint(_needbuffplus*1000%100/10);
		}
		
		public function getBuffPlusPlayType():uint //1:动态循环 2：播放到最后一帧
		{
			return uint(_needbuffplus*1000%10);
		}
		
		
		
		public function getBuffID2():uint
		{
			return uint(_needbuff2);
		}
		public function setNeedBuff2(n:Number):void
		{
			_needbuff2 = n;
		}
		public function getBuffIndex2():uint   //1：上层 2：下层
		{
			return uint(_needbuff2*1000%1000/100);
		}
		
		public function getBuffPosition2():uint //1：头顶 2：身上
		{
			return uint(_needbuff2*1000%100/10);
		}
		
		public function getBuffPlayType2():uint //1:动态循环 2：播放到最后一帧
		{
			return uint(_needbuff2*1000%10);
		}
		

			
		public function getAngleType():uint
		{
			return _angletype;
		}
		public function setAngleType(a:uint):void
		{
			_angletype = a;
		}
		
		public function getAngleType2():uint
		{
			return _angletype2;
		}
		public function setAngleType2(a:uint):void
		{
			_angletype2 = a;
		}
		
		public function getTargetType():uint
		{
			return _targettype;
		}
		
		public function setTargetType(t:uint):void
		{
			_targettype = t;
		}
		
		public function getTargetType2():uint
		{
			return _targettype2;
		}
		
		public function setTargetType2(t:uint):void
		{
			_targettype2 = t;
		}
		
		public function getGroundSkillID():uint
		{
			return _groundid;
		}
	    public function setGroundSkillID(g:uint):void
		{
			_groundid = g;
		}
		
		public function setGroundCanTurnOver(g:uint):void
		{
			_groundcanturnover = g;
			
		}
		public function getGroundCanTurnOver():uint
		{
			return _groundcanturnover;
		}
		
		public function getGroundType():uint             //上下层
		{
			return _groundtype;
		}
		public function setGroundType(g:uint):void
		{
			_groundtype = g;
		}
		
		public function getGroundSkillID2():uint
		{
			return _groundid2;
		}
		public function setGroundSkillID2(g:uint):void
		{
			_groundid2 = g;
		}
	
		public function getGroundType2():uint
		{
			return _groundtype2;
		}
		public function setGroundType2(g:uint):void
		{
			_groundtype2 = g;
		}
		
		
		public function getUpDownWords():String
		{
			return _updownwords;
		}
		public function setUpDownWords(u:String):void
		{
			_updownwords = u;
		}

		public function getUpDownWordsPlus():String
		{
			return _updownwordsplus;
		}
		
		public function setUpDownWordsPlus(u:String):void
		{
			_updownwordsplus = u;
		}
		
		public function getUpDownWords2():String
		{
			return _updownwords2;
		}
		public function setUpDownWords2(u:String):void
		{
			_updownwords2 = u;
		}
		
		public function getCanTurnOver():uint
		{
			return _canturnover;
		}
		public function setCanTurnOver(c:uint):void
		{
			_canturnover = c;
		}
		
		public function getCanTurnOver2():uint
		{
			return _canturnover2;
		}
		public function setCanTurnOver2(c:uint):void
		{
			_canturnover2 = c;
		}
		
		public function skillData(id:uint = 0, needbuff:uint = 0, atkid:uint = 0, rd:uint = 0, pb:Number = 0.0, vec:Array = null, rd2:uint = 0, pb2:Number = 0, vec2:Array = null)
		{
			skillID = id;
			_needbuff = needbuff;
			atkID = atkid;
			
			_round = rd;
			prob = pb;
			_atkFactorVec = vec;
			
			_round2 = rd2;
			prob2 = pb2;
			_atkFactorVec2 = vec2;
		}
		
		public function clone():skillData
		{
			var tmp:skillData = new skillData();
			tmp.skillID = skillID;
			tmp._needbuff = _needbuff;
			tmp.atkID = atkID;
			tmp._round = _round;
			tmp.prob = prob;
			tmp._atkFactorVec = _atkFactorVec;
			
			tmp._round2 = _round2;
			tmp.prob2 = prob2;
			tmp._atkFactorVec2 = _atkFactorVec2;
			return tmp;
		}
	}
}
