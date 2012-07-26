package game.module.battle.view
{
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipData;
	import gameui.core.ScaleMode;

	public class BTArtifactBuffTip extends ToolTip
	{	
		public function BTArtifactBuffTip(data:ToolTipData)
		{
			//data.width = 100;
			//data.height = 100;
			data.labelData.wordWrap = true;
			data.labelData.scaleMode = ScaleMode.SCALE9GRID;
			super(data);
		}
		
//		public protected function layout():void
//		{
//			_backgroundSkin.width = _width;
//			_backgroundSkin.height = _height;
//		}
		
		override protected function getToolTipText():String
		{
			var tips:String = "";
			var tipd:BTArtifactData = _source as BTArtifactData;
			if(tipd)
			{
				tips = "<b><font size= '14' color='#FFFF00'>"+ "神器属性" + "</font></b>\r";
				tips += "\r";
				if(tipd.getAllArtifactProps().hp_add > 0)
					tips +="生命<font color = '#279F15'>" + " +" + tipd.getAllArtifactProps().hp_add + "</font>\r";
				
				if(tipd.getAllArtifactProps().act_add > 0)
					tips += "攻击<font color = '#279F15'>" + " +" + tipd.getAllArtifactProps().act_add + "</font>\r";
				
				if(tipd.getAllArtifactProps().magic_act > 0)
					tips += "仙攻<font color = '#279F15'>" + " +" +tipd.getAllArtifactProps().magic_act + "</font>\r";
				
				if(tipd.getAllArtifactProps().speed > 0)
					tips += "速度<font color = '#279F15'>" + " +" +tipd.getAllArtifactProps().speed + "%" + "</font>\r"; 
				
				if(tipd.getAllArtifactProps().hit > 0)
					tips += "命中<font color = '#279F15'>" + " +" +tipd.getAllArtifactProps().hit + "%" + "</font>\r";
				
				if(tipd.getAllArtifactProps().dodge > 0)
					tips += "躲闪<font color = '#279F15'>" + " +" +tipd.getAllArtifactProps().dodge + "%" + "</font>\r";
				
				if(tipd.getAllArtifactProps().crit > 0)
					tips += "暴击<font color = '#279F15'>" + " +" +tipd.getAllArtifactProps().crit + "%" + "</font>\r";
				
				if(tipd.getAllArtifactProps().pierce > 0)
					tips += "破击<font color = '#279F15'>" + " +" +tipd.getAllArtifactProps().pierce + "%" + "</font>\r";
				
				if(tipd.getAllArtifactProps().counter > 0)
					tips += "反击<font color = '#279F15'>" + " +" +tipd.getAllArtifactProps().counter + "%" + "</font>\r";
				
				if(tipd.getAllArtifactProps().critmul > 0)
					tips += "高爆<font color = '#279F15'>" + " +" +tipd.getAllArtifactProps().critmul + "%" + "</font>\r";
				
				if(tipd.getAllArtifactProps().piercedef > 0)
					tips += "防破<font color = '#279F15'>" + " +" +tipd.getAllArtifactProps().piercedef + "%" + "</font>\r";
				
				if(tipd.getAllArtifactProps().countermul > 0)
					tips += "高反<font color = '#279F15'>" + " +" +tipd.getAllArtifactProps().countermul + "%" + "</font>\r";
				
				if(tipd.getAllArtifactProps().predef > 0)
					tips += "伤害减少<font color = '#279F15'>" + " +" +tipd.getAllArtifactProps().predef + "%" + "</font>\r";
				
				tips += "\r";
				
				tips += "已取得神器：" + "<font color = '#FFFF00'>" + tipd.getAllArtifactPropsName() + "</font>\r";
			}
			return tips;
		}

	}
}