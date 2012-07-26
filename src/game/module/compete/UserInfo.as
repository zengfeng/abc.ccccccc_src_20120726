package game.module.compete
{
	import com.utils.StringUtils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import gameui.containers.GPanel;
	import gameui.controls.GLabel;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;





	/**
	 * @author zheng
	 */
	public class UserInfo extends GPanel
	{
		// =====================
		// @定义
		// =====================
	   private	var _userRank:TextField;
	   private	var _useHighRank:TextField;
	   private	var _win:TextField;
	   private	var _obtain:TextField;
		// =====================
		// @属性
		// =====================
	   private var _vo : UserData=UserData.instance;		
		
	   private	var _userName:GLabel;
	   private	var _userRankText:TextField;
	   private	var _useHighRankText:TextField;
	   private	var _winText:TextField;
	   private	var _obtainGoldText:TextField;
	   private	var _obtainSilverText:TextField;	   
		// =====================
		// @创建
		// =====================		
		public function  UserInfo(_data:GPanelData)
		{
			_data.width = 500;
			_data.height =130;
			_data.bgAsset = new AssetData(SkinStyle.emptySkin);
			super(_data);
			initView();
			//setView();
		}
		


//		private function setView() : void
//		{
//			
//			var xml : XML = RSSManager.getInstance().getData("competerank");
//			if (!xml) return;
//			var lable : GLabel;
//			var data : GLabelData = new GLabelData();
//			for each (var item:XML in xml["userinfo"]["item"])
//			{
//				data = data.clone();
//				data.width=500;
//				data.height=130;
//				data.x = item.@x;
//				data.y = item.@y;
//				data.textFieldFilters=[];
//				
//				if (xml.@tips == undefined || item.@tips == "")
//				{
//					data.toolTipData = null;
//				}
//				else
//				{
////					data.toolTipData = new GToolTipData();
//				}
//				lable = new GLabel(data);
//				if (data.toolTipData)
//					lable.toolTip.source = item.@tips;
//				add(lable);
//				_prop[Number(item.@id)] = lable;
//			}
//		}
//
//		public function refreshUserInfo() : void
//		{
//			var xml : XML = RSSManager.getInstance().getData("competerank");
//			if (!xml) return;
//			var lable : GLabel;
//			var str : String = "";
//			for each (var item:XML in xml["userinfo"]["item"])
//			{
//				lable = _prop[Number(item.@id)];
//				str = item.children();
//				switch(Number(item.@id))
//				{
//					case 81:
////						str = str.replace("******",_vo.playerName);   //名字
//					//	str = str.replace("******",_voHero.htmlName);   //名字
//						str = str.replace("######",VoCompete.myRank);   //名字
//						str = str.replace("+++++",VoCompete.bestRank);   //名字
//						break;
//					case 82:
//					    str = str.replace("******",VoCompete.winStreak);   //名字
//						break;
//					case 83:
//					     str = str.replace("####",VoCompete.silverGot);   //金钱
//					     str = str.replace("****",VoCompete.silverTotal);   //总金钱
//						break;
//					case 84:
//					     str = str.replace("####",VoCompete.honorGot);   //声望
//					     str = str.replace("****",VoCompete.honorTotal);   //总声望
//						break;
//					case 85:
//						break;
//					default :
//						//str = str.replace("*****","XXOO");
//						//str = str.replace("#####","OOXX");
//						break;
//				}
//				if (!lable) continue;
//				lable.text = str;
//			}
//		}
		
		
		// =====================
		// @创建
		// =====================		
	    private function initView() : void
		{
			
			addBg();
			addRankSort();
			addNameLabel();
			addUserInfoText();
			addUserCompeteInfo();
		}	
		
		
		private function addNameLabel() : void
		{
			var _data:GLabelData = new GLabelData();
            _data.x = 15;
            _data.y = 10;
            _data.width = 100;
            _data.height = 30;
            _data.textFieldFilters = [];
       //     _data.textFormat.align=TextFormatAlign.CENTER;
			_data.textFormat.size=24;
            _userName = new GLabel(_data);
			_userName.htmlText=_vo.myHero.htmlName;
            addChild(_userName);
   //         GLayout.layout(_userName);
   
		}
		
		private function addUserInfoText() : void
		{
		var _format:TextFormat=new TextFormat();
			_format.size=12;
			_format.color=0xFFFF33;
//			_format.align=TextFormatAlign.CENTER;
			_userRank=new TextField();
			_userRank.defaultTextFormat=_format;
			_userRank.width=30;
			_userRank.height=18;
			_userRank.x=120;
			_userRank.y=20;
			_userRank.text="排名:";
			addChild(_userRank);
						
			_useHighRank=new TextField();
			_useHighRank.defaultTextFormat=_format;
			_useHighRank.width=90;
			_useHighRank.height=18;
			_useHighRank.x=190;
			_useHighRank.y=20;
			_useHighRank.text="历史最高排名:";
			addChild(_useHighRank);
			
			_win=new TextField();
			_win.defaultTextFormat=_format;
			_win.width=30;
			_win.height=18;
			_win.x=15;
			_win.y=48;
			_win.text="连胜";
			addChild(_win);
			
			
			_obtain=new TextField();
			_obtain.defaultTextFormat=_format;
			_obtain.width=55;
			_obtain.height=18;
			_obtain.x=15;
			_obtain.y=68;
			_obtain.text="今日可得:";
			addChild(_obtain);
			
			_format.align=TextFormatAlign.CENTER;
			_userRankText=new TextField();
			_userRankText.defaultTextFormat=_format;
			_userRankText.width=40;
			_userRankText.height=18;
			_userRankText.x=150;
			_userRankText.y=20;
			_userRankText.text="";
			addChild(_userRankText);
			
			_useHighRankText=new TextField();
			_useHighRankText.defaultTextFormat=_format;
			_useHighRankText.width=40;
			_useHighRankText.height=18;
			_useHighRankText.x=270;
			_useHighRankText.y=20;
			_useHighRankText.text="";
			addChild(_useHighRankText);
			
			_winText=new TextField();
			_winText.defaultTextFormat=_format;
			_winText.width=40;
			_winText.height=18;
			_winText.x=45;
			_winText.y=48;
			_winText.text="";
			addChild(_winText);
			
			
			_format.align=TextFormatAlign.LEFT;
			_obtainGoldText=new TextField();
			_obtainGoldText.defaultTextFormat=_format;
			_obtainGoldText.width=60;
			_obtainGoldText.height=18;
			_obtainGoldText.x=92;
			_obtainGoldText.y=68;
			_obtainGoldText.text="";
			addChild(_obtainGoldText);

			_obtainSilverText=new TextField();
			_obtainSilverText.defaultTextFormat=_format;
			_obtainSilverText.width=60;
			_obtainSilverText.height=18;
			_obtainSilverText.x=92;
			_obtainSilverText.y=86;
			_obtainSilverText.text="";
			addChild(_obtainSilverText);			
			
		}
		
	    private function addUserCompeteInfo() : void
		{
			
		}
		
		private function addBg() : void {
			
			var bg:Sprite = UIManager.getUI(new AssetData("info_panel"));
			
			bg.width = 500;
			
			bg.height = 130;
						
			_content.addChild(bg);
			
			var bg1:Sprite = UIManager.getUI(new AssetData("title"));
			
			bg1.x=6;
			
			bg1.y=40.7;
			
			bg1.width = 364.15;
			
			bg1.height = 1;
						
			_content.addChild(bg1);
			
			var SILVERBG:Sprite = UIManager.getUI(new AssetData(UI.MONEY_ICON_SILVER));
			
			SILVERBG.x=75;
			
			SILVERBG.y=73;
			
			SILVERBG.width = 12;
			
			SILVERBG.height = 12;
						
			_content.addChild(SILVERBG);
			
			var SILVERS:Sprite = UIManager.getUI(new AssetData(UI.MONEY_ICON_SILVERS));
			
			SILVERS.x=75;
			
			SILVERS.y=89;
			
			SILVERS.width = 14;
			
			SILVERS.height = 12;
						
			_content.addChild(SILVERS);
					
		}
		
		private function addRankSort() : void 
		{
			
			var _data:GLabelData = new GLabelData();
			_data.textColor=0xFF9900;
			_data.width = 66.4;
			_data.height =17.35;
			_data.x=415;
			_data.y=105;
			_data.textFormat.size=12;
			_data.textFieldFilters = [];
			_data.clone();
			var lable:GLabel = new GLabel(_data);
			var rankSortString:String;
			rankSortString = StringUtils.addLine("查看排行榜");
			lable.htmlText=rankSortString;
            lable.addEventListener(MouseEvent.CLICK,openRank);
			 _content.addChild(lable);	
		}
		
		
		// =====================
		// @更新
		// =====================			
		public function updateUserInfo():void
		{
			
			var str:String=VoCompete.myRank.toString();
			_userRankText.text=str;
			str=VoCompete.bestRank.toString();
			_useHighRankText.text=str;
			str=VoCompete.winStreak.toString();
			_winText.text=str;
			str=VoCompete.silverGot.toString()+"/"+VoCompete.silverTotal.toString();
		    _obtainGoldText.text=str;
			str=VoCompete.honorGot.toString()+"/"+VoCompete.honorTotal.toString();
		    _obtainSilverText.text=str;
		}
		
		// =====================
		// @交互
		// =====================		
		private function openRank(event:MouseEvent):void
		{
		    StateManager.instance.checkMsg(18);			
		}
	    override public function show():void
		{
			super.show();
			GLayout.layout(this);
		}
		
		override public function hide():void
		{
			
			super.hide();
		}		
		
	}
}
