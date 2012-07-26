package game.module.compete
{
	import game.manager.RSSManager;
	import game.net.core.Common;
	import game.net.data.CtoS.CSBattleReplay;

	import gameui.containers.GPanel;
	import gameui.controls.GLabel;
	import gameui.controls.GTextArea;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.data.GTextAreaData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.tips.PlayerTip;
	import com.utils.StringUtils;
	import com.utils.TimeUtil;

	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;


	/**
	 * @author zheng
	 */
	public class BattleInfo extends GPanel
	{
		
		
	    // =====================
		// @属性
		// =====================	
		private var battleInfo_str :String="";
		
		
	    // =====================
		// @创建
		// =====================	
		public function  BattleInfo(_data : GPanelData)
		{
			_data.width = 500;
			_data.height = 200;
			_data.bgAsset = new AssetData(SkinStyle.emptySkin);
			super(_data);
			initView();
			initEvent();
		}

		private var _Userinfo : GPanel;
		private var _currentText : GTextArea;
		private var _nameString : String;
		private var _reportString : String;
		private var _textData : GTextAreaData = new GTextAreaData();

		private function initView() : void
		{
			addBg();

			addLabel();
			_textData.width = 485;
			_textData.height = 150;
			_textData.selectable = false;
			_textData.editable = false;
			_textData.x = 15;
			_textData.y = 48;
			_textData.backgroundAsset = new AssetData(SkinStyle.emptySkin);
			_textData.textFormat=new TextFormat();
			_textData.textFormat.leading=8;
			_currentText = new GTextArea(_textData);

			_currentText.textField.antiAliasType = AntiAliasType.NORMAL;
			_currentText.textField.addEventListener(TextEvent.LINK, linkHandler);
			addChild(_currentText);
		}

		private function addLabel() : void
		{
			var data : GLabelData = new GLabelData();
			data.x = 220;
			data.y = 15;
			data.width = 100;
			data.height = 19.6;
			data.text = "<b><font size='14' color='#FFCC00'>战报列表</font> </b>";
			var _battlelabel : GLabel = new GLabel(data);
			_content.addChild(_battlelabel);
		}
		
		private function addBg() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData("info_panel"));

			bg.width = 500;

			bg.height = 300;

			_content.addChild(bg);

			var bg1 : Sprite = UIManager.getUI(new AssetData("title"));

			bg1.x = 17;

			bg1.y = 40.7;

			bg1.width = 425.8;

			bg1.height = 1;

			_content.addChild(bg1);
		}

		private function initEvent() : void
		{
		}


	    // =====================
		// @刷新
		// =====================	
		public function refreshBattleInfo() : void
		{
			var xml : XML = RSSManager.getInstance().getData("competerank");
			if (!xml) return;

			var vy : int = 1;
			var count : int = 0;
			for (var i : int = VoCompete.record.length - 1;i > -1;i--)
			{
				if (count == 15)
					break;
				for each (var item:XML in xml["battledata"]["item"])
				{
					if (Number(item.@id) == VoCompete.record[i].result + 90)
					{
						battleInfo_str =battleInfo_str+item.children();
						var _eventsring : String ="name"+VoCompete.record[i].name;
						_nameString = StringUtils.addColorById(StringUtils.addLine(VoCompete.record[i].name),VoCompete.record[i].color);
						_nameString = StringUtils.addEvent(_nameString, _eventsring);

            //                         VoCompete.record[i].battleId;
                        _eventsring="zhan"+VoCompete.record[i].battleId;
						_reportString = StringUtils.addLine("战报");
						_reportString = StringUtils.addEvent(_reportString, _eventsring);
                        var _timestr:String=TimeUtil.sysTimeToLocal(VoCompete.record[i].challengeTime,false,true,true,true,true,false);
						_timestr=_timestr.replace("时",":");
						_timestr=_timestr.replace("分","");
						var _date:Date=new Date();
						var Istoday:int=_date.getDate();
						var start:int=_timestr.search("月");
						var end:int=_timestr.search("日");
						var substr:String;
						substr=_timestr.substring(start+1,end);
						if(substr==Istoday.toString())
						{
							_timestr="今日"+_timestr.substring(end+1,_timestr.length);
						}

						switch(Number(item.@id))
						{
							case 90:
								battleInfo_str = battleInfo_str.replace("######", _nameString);
								battleInfo_str = battleInfo_str.replace("******", _timestr);
								battleInfo_str = battleInfo_str.replace("++++++", VoCompete.record[i].newRank);
								battleInfo_str = battleInfo_str.replace("##", _reportString);
								break;
							case 91:
								battleInfo_str = battleInfo_str.replace("######", _nameString);
								battleInfo_str = battleInfo_str.replace("******",_timestr);
								battleInfo_str = battleInfo_str.replace("##", _reportString);
								break;
							case 92:
								battleInfo_str = battleInfo_str.replace("######", _nameString);
								battleInfo_str = battleInfo_str.replace("******",_timestr);
								battleInfo_str = battleInfo_str.replace("##", _reportString);
								break;
							case 93:
								battleInfo_str = battleInfo_str.replace("######", _nameString);
								battleInfo_str = battleInfo_str.replace("******",_timestr);
								battleInfo_str = battleInfo_str.replace("++++++", VoCompete.record[i].newRank);
								battleInfo_str = battleInfo_str.replace("##", _reportString);
								break;
							case 94:
								battleInfo_str = battleInfo_str.replace("######", _nameString);
								battleInfo_str = battleInfo_str.replace("******",_timestr);
								battleInfo_str = battleInfo_str.replace("##", _reportString);
								break;
							case 95:
								battleInfo_str = battleInfo_str.replace("######", _nameString);
								battleInfo_str = battleInfo_str.replace("******",_timestr);
								battleInfo_str = battleInfo_str.replace("##", _reportString);
								break;
						}
				//		_currentText.textField.antiAliasType = AntiAliasType.NORMAL;
				//      _currentText.textField.addEventListener(TextEvent.LINK, linkHandler);
						battleInfo_str=battleInfo_str+"<br>";
						vy++;
					}
				}
				
				count++;
			}
			_currentText.htmlText=battleInfo_str;
			_currentText.scrollToTop();
			//_content.addChild(_currentText);
		}

		public function addNewBattleInfo() : void
		{
			var xml : XML = RSSManager.getInstance().getData("competerank");
			var str1 : String = "";
			for each (var item:XML in xml["battledata"]["item"])
			{
				if (Number(item.@id) == VoCompete.voNewBattle.result + 90)
				{
					if (_textData.toolTipData)
						_currentText.toolTip = item.@tips;

					str1 = item.children();
					var _eventsring : String = "name"+VoCompete.voNewBattle.name;
					_nameString = StringUtils.addColorById(StringUtils.addLine(VoCompete.voNewBattle.name),VoCompete.voNewBattle.color);
					_nameString = StringUtils.addEvent(_nameString, _eventsring);
                    
					_eventsring="zhan"+VoCompete.voNewBattle.battleId;
					_reportString = StringUtils.addLine("战报");
					_reportString = StringUtils.addEvent(_reportString, _eventsring);
					
					var _timestr:String=TimeUtil.sysTimeToLocal(VoCompete.voNewBattle.challengeTime,false,true,true,true,true,false);
				        _timestr=_timestr.replace("时",":");
						_timestr=_timestr.replace("分","");
					var _date:Date=new Date();
					var Istoday:int=_date.getDate();
					var start:int=_timestr.search("月");
					var end:int=_timestr.search("日");
					var substr:String;
				        substr=_timestr.substring(start+1,end);
						if(substr==Istoday.toString())
						{
							_timestr="今日"+_timestr.substring(end+1,_timestr.length);
						}

					switch(Number(item.@id))
					{
						case 90:
							str1 = str1.replace("######", _nameString);
							str1 = str1.replace("******", _timestr);
							str1 = str1.replace("++++++", VoCompete.voNewBattle.newRank);
							str1 = str1.replace("##", _reportString);
							break;
						case 91:
							str1 = str1.replace("######", _nameString);
							str1 = str1.replace("******",_timestr);
							str1 = str1.replace("##", _reportString);
							break;
						case 92:
							str1 = str1.replace("######", _nameString);
							str1 = str1.replace("******",_timestr);
							str1 = str1.replace("##", _reportString);
							break;
						case 93:
							str1 = str1.replace("######", _nameString);
							str1 = str1.replace("******",_timestr);
							str1 = str1.replace("++++++", VoCompete.voNewBattle.newRank);
							str1 = str1.replace("##", _reportString);
							
						case 94:
							str1 = str1.replace("######", _nameString);
							str1 = str1.replace("******",_timestr);
							str1 = str1.replace("##", _reportString);
							break;
						case 95:
							str1 = str1.replace("######", _nameString);
							str1 = str1.replace("******",_timestr);
							str1 = str1.replace("##", _reportString);
							break;							
							break;
					}
				}
			}
            			
						battleInfo_str=str1+"<br>"+battleInfo_str;
						_currentText.htmlText=battleInfo_str;
			            _currentText.scrollToTop();
//			if(_currentText.h_sb){
//				_currentText.h_sb.scroll(100);
//			}
		}
	    // =====================
		// @交互
		// =====================	
		private function linkHandler(event : TextEvent) : void
		{
            var sign:String=event.text.slice(0,4);
			
            if(sign=="zhan")
			{
				
	//			VoCompete.voNewBattle.battleId
				var id:int=int(event.text.slice(4));                      //这是战报ID
				var cmd : CSBattleReplay = new CSBattleReplay();
			    cmd.replayId=id;
			    Common.game_server.sendMessage(0x62, cmd);
				return;
			}
           else if(sign=="name")
		   {
			 var name:String=event.text.slice(4);
			 PlayerTip.show(0, name,[PlayerTip.NAME_LOOK_INFO,PlayerTip.NAME_ADD_FRIEND]);
		   }
		}

		override public function show() : void
		{
			super.show();
			GLayout.layout(this);
		}

		override public function hide() : void
		{
			super.hide();
		}
	}
}