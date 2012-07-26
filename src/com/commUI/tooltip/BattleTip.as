package com.commUI.tooltip
{
	import com.utils.PotentialColorUtils;
	
	import game.core.item.sutra.sutraSkill.SutraManager;
	import game.module.battle.battleData.tipData;
	import game.module.battle.view.BattleTipBar;
	
	import gameui.data.GProgressBarData;
	import gameui.data.GToolTipData;
	import gameui.manager.UIManager;
	
	import net.AssetData;
	
	
	

	public class BattleTip extends ToolTip
	{
		public function BattleTip(data:ToolTipData)
		{
			data.width = 208;
			data.height = 85;
			super(data);
			addProgressBar();
		}
		
		private function addProgressBar() : void {
			if (_phBar)
				_phBar.value = 100;
			else {
				var data : GProgressBarData = new GProgressBarData();
				data.x = 44;
				data.y = 48;
				data.max = 100;
				data.value = 100;
				data.width = 140;
				data.trackAsset = new AssetData("Bar_Background", "Numbers");
				data.barAsset = new AssetData("Bar_RedFront","Numbers");
				data.toolTipData = new GToolTipData();
				data.paddingX = data.paddingY = data.padding = 1;
				_phBar = new BattleTipBar(data);
				_phBar.setSize(140, 12);
				addChild(_phBar);
			}
			
			if(_gaugeBar)
			{
				_gaugeBar.value = 100;
			}
			else
			{
				var data1 : GProgressBarData = new GProgressBarData();
				data1.x = 44;
				data1.y = 64;
				data1.max = 100;
				data1.value = 100;
				data1.width = 140;
				data1.trackAsset = new AssetData("Bar_Background", "Numbers");
				data1.barAsset = new AssetData("Bar_YellowFront", "Numbers");
				data1.toolTipData = new GToolTipData();
				data1.paddingX = data1.paddingY = data1.padding = 1;
				_gaugeBar = new BattleTipBar(data1);
				_gaugeBar.setSize(140, 12);
				addChild(_gaugeBar);
			}
			//updateDisplays();
		}
		
		override protected function getToolTipText():String
		{
			var text : String = "";
			var tipd:tipData = _source as tipData;
			var runetotemName:String = "";
			trace(SutraManager.instance.getMarksVo(tipd.playerSkillId));
			if(SutraManager.instance.getMarksVo(tipd.playerSkillId) != null  && SutraManager.instance.getMarksVo(tipd.playerSkillId).runetotemName != "")
			{
				runetotemName = SutraManager.instance.getMarksVo(tipd.playerSkillId).runetotemName;
				if(runetotemName != "")
				{
				   this.data.height = 105;
				   this.height = 105;
				   layout();
				   _phBar.y = 46 + 18;
				   _gaugeBar.y = 62+19;
				}
			}
			else
			{
				this.data.height = 88;
				this.height = 88;
				layout();
				_phBar.y = 49;
				_gaugeBar.y = 66;
			}
			
			var fcolor:String = "";
			fcolor = PotentialColorUtils.getColorOfStr(tipd.playerColor);
			if(_source)
			{
				if(tipd.playerLevel > 0)
					text += '<b><font size="14" color="'+ fcolor +'" letterSpacing = \"2\">' + tipd.playerName + '</font></b>'+ '<b><font size="14" color="'+ fcolor +'" letterSpacing = \"0\">' + "  " + tipd.playerLevel + '</font></b>'+ '<b><font size="14" color="'+ fcolor +'" >'  +"级" +'</font></b>' + "\n";
				else
					text += '<b><font size="14" color="'+ fcolor +'" letterSpacing = \"2\">' + tipd.playerName + '</font></b>' + "\n";
				//text += '<b><font size="14" color=fcolor letterSpacing = \"2\">' + tipd.playerName + '</font></b>'+ '<b><font size="14" color=\"#ff7e00\" letterSpacing = \"0\">' + "  " + tipd.playerLevel + '</font></b>'+ '<b><font size="14" color=\"#ff7e00\" >'  +"级" +'</font></b>' + "\r";
				text += '<font size="12" >'+ "技能：" + '<font color="'+ fcolor + '" >' + tipd.playerSkillName + '</font>'+ "\n";
				if(runetotemName != "")
					text += '<font size="12" >'+ "符印："+ runetotemName + "\n";
				text += '<font size="12" >'+ "生命：\n";
				text += '<font size="12" >'+ "聚气：\n";
				if(_phBar)
				{
					_phBar.setBarTextValue(tipd.playerHp, tipd.playerHPInit);					
				}
				if(_gaugeBar)
				{
					_gaugeBar.setBarTextValue(tipd.playerGauge, tipd.playerGaugeInit);
				}
			}
			return text;
		}
		
		override protected function layout() : void
		{
			_backgroundSkin.width = _width;
			_backgroundSkin.height = _height;
			
		}
		
		private var _phBar : BattleTipBar;
		private var _gaugeBar : BattleTipBar;
	}
}