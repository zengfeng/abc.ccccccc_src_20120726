package game.module.battle.battleData {
	import flash.utils.Dictionary;
	public class AttackData
	{
//		public static const skillArray:Array = [];              //编号，攻击编号，轮数，触发概率，系数
//			[
//				[1,101],                      
//				[2,102,2,1,0.8,0.4],          
//				[3,103,1,1,0.8], 
//				[4,104,2,1],
//				[5,105,1,1,1],
//				[6,105,1,1,1],
//				[7,105,1,1,1],
//				[8,106,1,1,0.8],
//				[9,107,2,1,1],
//				[10,108,1,1,1],
//				[11,109,1,1,0.9]
//			];
		     //攻击范围表//攻击编号，坐标x，坐标y，伤害系数，（普通攻击/技能编号)
//		public static const areaArray:Array = [];
//			[
//				[0,[0,0,1.0,0]],
//				[1,[0,0,1.0,0]],                        
//				[2,[0,0,1.05,0]],
//				[3,[0,0,0.8,0],[0,1,0.4,0]],
//				[4,[0,0,0.7,0],[1,1,0.35,0],[-1,1,0.35,0]], 
//				[5,[0,0,0.6,0],[2,0,0.6,0],[1,1,0.2,0]],           
//				[6,[0,0,0.6,0],[0,1,0.6,2],[0,2,0.2,0],[0,3,0.6,2],[0,4,0.2,0]], 
//				[101,[0,0,1.0,0]],
//				[102,[0,0,1.0,1]],
//				[103,[0,0,0.8,1],[0,1,0.4,0]],
//				[104,[0,0,0.8,2],[0,1,0.4,0]],
//				[105,[0,0,0.8,3],[0,1,0.4,0]],
//				[106,[0,0,0.8,8],[0,1,0.4,0]],
//				[107,[0,0,1,5]],
//				[108,[0,0,1,12]],
//				[109,[0,0,1,16]]
//			];
		
		public static const skilllist:Array = []; 
		public static const arealist:Array =  [];
		public static const mapidlist:Array = [];
		public static const skilEffectDic:Dictionary = new Dictionary();
//		public static function LoadBattleData():void
//		{
//			LoadAtkTable();
//			LoadSkillTable();
//		} 
		
		public static function LoadSkillTable(skillArray:Array):Boolean
		{
			var i:int = 0;
			var j:int = 0;
			var atktypeSize:uint = skillArray.length;
			var _skillid:uint = 0;

			var _atkid:uint = 0;
			var _round:uint = 0;
			var _prob:Number = 0.0;
			var _round2:uint = 0;
			var _prob2:Number = 0.0;

			var _skillname:String = "";
			var _movetype:uint = 0;
			var _spelleftid:uint = 0;
			var _needbuff:Number = 0.0;
			var _needbuffplus:Number = 0.0;
			
			var _angletype:uint = 0;
			var _targettype:uint = 0;
			var _groundid:uint = 0;
			var _groundcanturnover:uint = 0;
			var _groundtype:uint = 0;
			var _updownwords:String = "";
			var _updownwordsplus:String = "";
			var _canturnover:uint = 0;
			var _buffPosition:uint = 0;
			
			var _spelleftid2:uint = 0;
			var _needbuff2:Number = 0;
			var _angletype2:uint = 0;
			var _targettype2:uint = 0;
			var _groundid2:uint = 0;
			var _groundtype2:uint = 0;
			var _updownwords2:String = "";
			var _canturnover2:uint = 0;
			var _buffPosition2:uint = 0;
			
			for( i = 0; i < atktypeSize; ++i)
			{
				var _vec:Array = [];
				var _vec2:Array = [];
//				_skillid = skillArray[i][0];
//				_skillname = skillArray[i][2]
//				_movetype = skillArray[i][3];
//				_spelleftid = skillArray[i][4];
//				_needbuff = skillArray[i][5];
//				_angletype = skillArray[i][6]; 
//				_targettype = skillArray[i][7];
//				_groundtype = skillArray[i][8];
//				_canturnover = skillArray[i][9]
				
				_skillid = skillArray[i][0];
				_skillname = skillArray[i][2];
				_movetype = skillArray[i][3];
				
				_spelleftid = skillArray[i][4];
				_angletype = skillArray[i][5];
				_canturnover = skillArray[i][6];
				_groundid = skillArray[i][7];
				_groundcanturnover = skillArray[i][8];    //需要翻转
				_groundtype = skillArray[i][9];
				_updownwords = skillArray[i][10];         //文字1
				_updownwordsplus = skillArray[i][11];     //文字2
				_targettype = skillArray[i][12];
				_needbuff = skillArray[i][13];
				_needbuffplus = skillArray[i][14];
				
				_spelleftid2 = skillArray[i][15];
				_angletype2 = skillArray[i][16];
				_canturnover2 = skillArray[i][17];
				_groundid2 = skillArray[i][18];
				
				_updownwords2 = skillArray[i][20];  //文字
				_targettype2 = skillArray[i][21];
				//_needbuff2 = skillArray[i][22];

				var tempArray:Array = (skillArray[i][1] as String).split("|");

				var tkArray:Array = [];
				var skArray:Array = [];
				if(tempArray.length == 1)
				{
					tkArray = (tempArray[0] as String).split(",");
					for( j = 0; j <tkArray.length; ++j)
					{
						if(0 == j)
						{
							_atkid = tkArray[0];
						}
						else if(1 == j)
						{
							_round = tkArray[1];
						}
						else if(2 == j)
						{
							_prob = tkArray[2];
						}
						else 
						{
							_vec.push(tkArray[j]);
						}
					}
					
					for(j = 0; j <2; ++j)
					{
						_vec2.push(0);
					}
				}
				else if(tempArray.length == 2)
				{
					tkArray = (tempArray[0] as String).split(",");
					skArray = (tempArray[1] as String).split(",");
					for( j = 0; j <tkArray.length; ++j)
					{
						if(0 == j)
						{
							_atkid = tkArray[0];
						}
						else if(1 == j)
						{
							_round = tkArray[1];
						}
						else if(2 == j)
						{
							_prob = tkArray[2];
						}
						else 
						{
							_vec.push(tkArray[j]);
						}
					}
					
					for( j = 0; j <skArray.length; ++j)
					{
                        if ( 0 == j)
						{
							_round2 = skArray[0];
						}
						else if(1 == j)
						{
							_prob2 = skArray[1];
						}
						else 
						{
							_vec2.push(skArray[j]);
						}
					}
				}

				
				var _psd:skillData = new skillData(_skillid, _needbuff, _atkid, _round,_prob, _vec, _round2, _prob2, _vec2);
		
				_psd.setSkillName(_skillname);
				_psd.setMoveType(_movetype);
				
				_psd.setSpellEftId(_spelleftid);
				_psd.setAngleType(_angletype);
				_psd.setCanTurnOver(_canturnover);
				_psd.setGroundSkillID(_groundid);
				_psd.setGroundCanTurnOver(_groundcanturnover);
				_psd.setGroundType(_groundtype);
				_psd.setUpDownWords(_updownwords);
				_psd.setUpDownWordsPlus(_updownwordsplus);
				_psd.setTargetType(_targettype);
				_psd.setNeedBuff(_needbuff);
				_psd.setNeedBuffPlus(_needbuffplus);
				
				_psd.setSpellEftId2(_spelleftid2);
				_psd.setAngleType2(_angletype2);
				_psd.setCanTurnOver2(_canturnover2);
				_psd.setGroundSkillID2(_groundid2);
				_psd.setGroundType2(_groundtype2);
				_psd.setUpDownWords2(_updownwords2);
				_psd.setTargetType2(_targettype2);
				_psd.setNeedBuff2(_needbuff2);
						
				skilllist[_skillid] = _psd;
			}
			return true;
		}
		
		public static function LoadAtkTable(areaArray:Array):void
		{
			var typeId:uint = 0;
			var _x:int = 0;
			var _y:int = 0;
			var _factor:Number = 0.0;
			var _skillType:Number = 0.0;
			for(var i:int = 0; i < areaArray.length; ++i)
			{
				var tempArray:Array = areaArray[i];
				var ar:Area = new Area();
	
				typeId = tempArray[0];

				var subArray:Array = (tempArray[1]).split("|") as Array;
				for(var k:int = 0; k < subArray.length; k++)
				{
					var moreSubArr:Array = subArray[k].split(",");

					_x = moreSubArr[0];
					_y = moreSubArr[1];
					_factor = moreSubArr[2];
					_skillType = moreSubArr[3];
					var ap:Data = new Data();
					ap.x = _x;
					ap.y = _y;
					ap.factor = _factor;
					ap.skilltype = _skillType;
					if(0 == k)
					{
						ar.setType(_skillType);
						//攻击移动类型
					}
				    ar.add(ap);	

				}
				
				arealist[typeId] = ar;
			}
		}
		
		public static function LoadBattleMapData(xml : XML):void
		{
			var mapId:uint;  //地图id
			var type:uint;   //配置类型
			var urlStr:String; //url地址
			var pointX:uint; //x坐标
			var pointY:uint; //y坐标
			mapId = uint(xml.@id);
			type = uint(xml.@type);
			urlStr = xml.@url;
			pointX = uint(xml.@x);
			pointY = uint(xml.@y);
			var mp:mapData = new mapData(mapId, type, urlStr, pointX, pointY);
			mapidlist[mapId] = mp;
		}
	}
	
}