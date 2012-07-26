package game.module.compete
{
	import flash.utils.setTimeout;
	import flash.utils.getTimer;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.VersionManager;
	import game.net.core.Common;
	import game.net.data.CtoS.CSAthleticsChallenge;

	import gameui.containers.GPanel;
	import gameui.controls.GImage;
	import gameui.controls.GLabel;
	import gameui.core.GAlign;
	import gameui.data.GImageData;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;
	import net.LibData;

	import com.commUI.tips.PlayerTip;
	import com.commUI.tooltip.CompeteUserTip;
	import com.commUI.tooltip.ToolTipData;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.ColorChange;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;





	/**
	 * @author zheng
	 */
	public class UserItem extends GPanel
	{
		// =====================
		// @定义
		// =====================
		private static var DIR_COMPLAYER_HEAD_PHOTO : String = "assets/ico/heroHeadInCompete/";
		// =====================
		// @属性
		// =====================
		public var centsName : GLabel;
		private var _item_x:int;
		private var _userName : String;
		private var _userRank : String;
		private var _userLevel : int;
		private var _userHead : GImage ;
		private var _isuser : Boolean;
		
		private var _rankTitleText1 : TextField=new TextField();
		private var _rankTitleText2 : TextField=new TextField();
		private var _userNameText : TextField;
		private var _rankText : TextField;
		private var _userVO : UserData = UserData.instance;
		private var _competeToolTipVO : VoCompeteToolTip = new VoCompeteToolTip();
		
		// 控制
		private var _index:int=10;

		// =====================
		// Getter/Setter
		// =====================
		override public function get source ():*
		{
			
			return _competeToolTipVO;
		}
		
		// =====================
		// @创建
		// =====================
		public function UserItem(item_x:int,headid : int = 0, name : String = "", rank : String = "", color : int = 0, level : int = 0, isuser : Boolean = false,hasuser:Boolean=true)
		{
			_data = new GPanelData();

			initData();

			super(_data);

			initView();
		}

		private function initData() : void
		{
			_data.width = 130;

			_data.height = 155;

			_data.bgAsset = new AssetData(SkinStyle.emptySkin);

			// 取消背景
		}

		private function initView() : void
		{
			addBG();
			addRankText();
		}
        
		private function addBG() : void
		{
			addUserPanel();
			// 添加排名文字
			_rankTitleText1=addNewRankTitle(25, 12, "第");
			addChild(_rankTitleText1);
			_rankTitleText2=addNewRankTitle(85, 12, "名");
			addChild(_rankTitleText2);
		}

		private function addNewRankTitle(x : uint, y : uint, text : String) : TextField
		{
			var _rankTitleText:TextField = new TextField();
			_rankTitleText.defaultTextFormat = TextFormatUtils.rankTitle;
			_rankTitleText.text = text;
			_rankTitleText.x = x;
			_rankTitleText.y = y;
			_rankTitleText.width = 25;
			_rankTitleText.height = 20;
			_rankTitleText.mouseEnabled=false;
			return _rankTitleText;
		}
        private var rank_format:TextFormat;
		private function addRankText() : void
		{
			_rankText = new TextField();
			rank_format = new TextFormat();
			rank_format.size = 24;
			_rankText.textColor = 0xffffff;
			rank_format.align = TextFormatAlign.CENTER;
			_rankText.mouseEnabled = false;
			
			_rankText.width = 62;
			_rankText.height = 31;
			_rankText.filters = [new GlowFilter(0, 0.8, 2, 2, 15, 1, false, false)];
			_rankText.defaultTextFormat = rank_format;
			_rankText.x = 35;
			_rankText.y = 4;
		// _rankText.border=true;

			addChild(_rankText);
		}

		private var _userPanel : GPanel;
		private var	userhead_bg : Sprite;
		private var userhead_bigbg1 : Sprite;
		private var userhead_bigbg2 : Sprite;
		private var bg_myPlay:Boolean=false;
		
		
		private function addUserPanel() : void
		{
			var _data : GPanelData = new GPanelData();

			_data.x = 5;
			_data.y = 35;
			_data.height = 120;
			_data.width = 150;
			_data.bgAsset = new AssetData(SkinStyle.emptySkin);
		//	_data.toolTipData = new GToolTipData();
			_userPanel = new GPanel(_data);
			addChild(_userPanel);
			userhead_bigbg1 = UIManager.getUI(new AssetData(UI.COMMON_BACKGROUND03));

			userhead_bigbg1.width = 124;

			userhead_bigbg1.height = 149;

			userhead_bigbg1.x = 1;

			userhead_bigbg1.y = 1;

			_userPanel.addChildAt(userhead_bigbg1,0);
					
			addUserName();
            
			addUserHeadPanel();
			
		}
		private var _userHeadPanel:GPanel;
		private function addUserHeadPanel() : void
		{
			var _hitArea:Sprite=new Sprite();
			_hitArea.graphics.beginFill(0xffffff);
		    _hitArea.graphics.drawCircle(50, 52, 50);
			_hitArea.alpha=0;
			
			
			var _data : GPanelData = new GPanelData();

			_data.x = 18;
			_data.y = 45;
			_data.height = 100;
			_data.width = 92;
			_data.bgAsset = new AssetData(SkinStyle.emptySkin);
			_userHeadPanel = new GPanel(_data);
			_userHeadPanel.hitArea=_hitArea;
			_userHeadPanel.mouseChildren = false;
			
			addChild(_userHeadPanel);
			_userHeadPanel.addChild(_hitArea);
			
			userhead_bg = UIManager.getUI(new AssetData(UI.COMPETE_USERHEADBG,"compete"));

			userhead_bg.width = 92;

			userhead_bg.height = 91;

			userhead_bg.x = 4.5;

			userhead_bg.y = 13;

			_userHeadPanel.addChildAt(userhead_bg,1);
			
			addHeroHead();
	
	  }
		
		
		
		

		private function onOver(event : MouseEvent) : void
		{
			_userHeadPanel.removeChild(userhead_bg);
			userhead_bg = UIManager.getUI(new AssetData(UI.COMPETE_USERHEADBG_OVER,"compete"));
			userhead_bg.width = 92;
			userhead_bg.height = 91;
			userhead_bg.x = 4.5;
			userhead_bg.y = 13;
			_userHeadPanel.addChildAt(userhead_bg, 1);

         // userhead_bg.filters=[colorMatrixFilter_disable];
		}
		
		private function onDown(event : MouseEvent) : void
		{
			_userHeadPanel.enabled=false;
			setTimeout(afun, 500);

			var cmd : CSAthleticsChallenge;
			if (VoCompete.todayCountLeft > 0)
			{
				cmd = new CSAthleticsChallenge();
				cmd.name = _userName;
				Common.game_server.sendMessage(0x1A1, cmd);				
			}
			else
			{
				    StateManager.instance.checkMsg(125);
			}
			return;
		}

		private function afun() : void
		{
			_userHeadPanel.enabled=true;
		}
		

		private function onOut(event : MouseEvent) : void
		{
			_userHeadPanel.removeChild(userhead_bg);
			userhead_bg = UIManager.getUI(new AssetData(UI.COMPETE_USERHEADBG,"compete"));
			userhead_bg.width = 92;
			userhead_bg.height = 91;
			userhead_bg.x = 4.5;
			userhead_bg.y = 13;
			_userHeadPanel.addChildAt(userhead_bg, 1);
		}
        private var _imgData : GImageData 
		
		private function addHeroHead() : void
		{
		//	var heroid : int = headId;

			_imgData = new GImageData();

			_imgData.iocData.align = new GAlign(-2,-1,-1,80);

			_imgData.libData = new LibData(getComHeadPhotoByHeroId(0));

			_userHead = new GImage(_imgData);
//			_userHead.align=new GAlign(-3,-1,-1,80);

			_userHeadPanel.addChildAt(_userHead,2);
		//	_userHead.mouseEnabled=false;
		}

		private function addUserName() : void
		{
			_userNameText = new TextField();

			var _format : TextFormat = new TextFormat();
			_format.size = 12;
			_format.align = TextFormatAlign.CENTER;
			_userNameText.defaultTextFormat = _format;
			_userNameText.x = 3;
			_userNameText.y = 120;
			_userNameText.width = 120;
			_userNameText.height = 20;
			_userNameText.selectable=false;
			_userPanel.addChildAt(_userNameText,1);

		}
		
		
		private function onNameOver(event : MouseEvent) : void
		{
              _userNameText.htmlText=StringUtils.addColorById(StringUtils.addLine(_userName),_userColor);
		}

		private function onNameDown(event : MouseEvent) : void
		{
			    var text:String=(event.target as TextField).text;
           	PlayerTip.show(0, text,[PlayerTip.NAME_LOOK_INFO,PlayerTip.NAME_ADD_FRIEND]);
		}

		private function onNameOut(event : MouseEvent) : void
		{
               _userNameText.htmlText=StringUtils.addColorById(_userName,_userColor);
		}

		// =====================
		// @更新
		// =====================
		override protected function onShow() : void
		{
			super.onShow();

		}
		
		private function provideToolTipData():VoCompeteToolTip
		{
			return _competeToolTipVO;
		}

		override protected function onHide() : void
		{
			super.onHide();
		}
        private var _userColor:int;
		private var _isToolTip:Boolean;
		public function upDateUserItem(headid : int = 0, name : String = "", rank : String = "", level : int = 0, color : int = 0,battlePoints:int=0,isuser:Boolean=false,istooltip:Boolean=true,hasUser:Boolean=true) : void
		{
			_isuser=isuser;
			var _data : ToolTipData = new ToolTipData();
			_data.width = 150;
			_data.height = 150;
			_isToolTip=istooltip;
			
			updateBg();	
			
			if (isuser == false)
			{
				_userNameText.htmlText = StringUtils.addColorById(name, color);		
			}
			else
			{
				_userNameText.htmlText = _userVO.myHero.htmlName;
				_competeToolTipVO.isuser=true;				
			}
			
			if(hasUser==false)
			{			
			  _rankTitleText1.visible=false;
			  _rankTitleText2.visible=false;
			  userhead_bg.filters=[colorMatrixFilter_disable];
			}
			else
			{
			  _rankTitleText1.visible=true;
			  _rankTitleText2.visible=true;
			}
			
			if(_isuser==false&&hasUser==true)
			{
			_userNameText.addEventListener(MouseEvent.CLICK, onNameDown);
			_userNameText.addEventListener(MouseEvent.MOUSE_OVER, onNameOver);
			_userNameText.addEventListener(MouseEvent.MOUSE_OUT, onNameOut);
			}
			else
			{
				_userNameText.mouseEnabled=false;
			}
			
			if(_isuser==false&&hasUser==true)	
		    {
			   _userHeadPanel.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			   _userHeadPanel.addEventListener(MouseEvent.ROLL_OVER, onOver);
			   _userHeadPanel.addEventListener(MouseEvent.ROLL_OUT, onOut);
		    }	
						
			_userName = name;
			_userRank = rank;
			_userLevel = level;
			_rankText.text = rank;
            _userColor=color;
			_isuser=isuser;
			_userHead.url = getComHeadPhotoByHeroId(headid);
			
			_competeToolTipVO.color=color;
			_competeToolTipVO.name = name;
			_competeToolTipVO.level = level.toString();
			_competeToolTipVO.rank = rank;
			_competeToolTipVO.isuser=isuser;
			_competeToolTipVO.battlePoints=battlePoints;
			
			readString();
			
			if(istooltip)
			{
				ToolTipManager.instance.registerToolTip(_userHeadPanel, CompeteUserTip, provideToolTipData);
			}
			else
			{
				ToolTipManager.instance.destroyToolTip(this);
			}
		}
		
        public function updateBg():void
		{
			if(_isuser==false&&bg_myPlay==true)
			{
			_userPanel.removeChild(userhead_bigbg2);
			
			userhead_bigbg1 = UIManager.getUI(new AssetData(UI.COMMON_BACKGROUND03));

			userhead_bigbg1.width = 124;

			userhead_bigbg1.height = 149;

			userhead_bigbg1.x = 1;

			userhead_bigbg1.y = 1;
			
			_userPanel.addChildAt(userhead_bigbg1,0);
			
			_rankText.textColor = 0xffffff;
			
			bg_myPlay=false;
			}
            
			else if(_isuser==true&&bg_myPlay==false)
			{
			_userPanel.removeChild(userhead_bigbg1);
			
			userhead_bigbg2 = UIManager.getUI(new AssetData(UI.COMPETE_MYUSERBG_LIGHT,"compete"));

			userhead_bigbg2.width = 124;

			userhead_bigbg2.height = 149;

			userhead_bigbg2.x = 1;

			userhead_bigbg2.y = 0;

			_userPanel.addChildAt(userhead_bigbg2,0);
			
			_rankText.textColor= 0xffcc00;
			
			bg_myPlay=true;
			}
			
		}
		
		// ===================
		// 滤镜区域
		// ===================
		private static var _colorMatrixFilter_disable : ColorMatrixFilter;
		
	    public static function get colorMatrixFilter_disable() : ColorMatrixFilter
		{
			if (_colorMatrixFilter_disable == null)
			{
				var colorChange : ColorChange = new ColorChange();
				colorChange.adjustSaturation(-100);
				_colorMatrixFilter_disable = new ColorMatrixFilter(colorChange);
			}
			return _colorMatrixFilter_disable;
		}

		public function readString() : void
		{
			var silverstr : String = "";
			var xiuweistr : String = "";
			var rank_string : String = _userRank;
			var rank_int : int = int(rank_string);
			var equipment : String = "";
			if (rank_int == 1)
			{
				equipment = "高级装备×1（绑定）";
				silverstr = "25000";
				xiuweistr = "1200";
			}
			else if (rank_int == 2)
			{
//				equipment = "高级装备×1";
				silverstr = "22500";
				xiuweistr = "800";
			}
			else if (rank_int == 3)
			{
//				equipment = "高级装备×1";
				silverstr = "20000";
				xiuweistr = "600";
			}
			else if (rank_int <= 10 && rank_int >= 4)
			{
				silverstr = (15000 + (11 - rank_int) * 500).toString();
				xiuweistr = "500";
			}
			else if (rank_int <= 30 && rank_int >= 11)
			{
				silverstr = (13000 + (31 - rank_int) * 100).toString();
				xiuweistr = "400";
			}
			else if (rank_int <= 100 && rank_int >= 31)
			{
				silverstr = (9500 + (101 - rank_int) * 50).toString();
				xiuweistr = "300";
			}
			else if (rank_int <= 500 && rank_int >= 101)
			{
				silverstr = (4500 + (501 - rank_int) * 10).toString();
				xiuweistr = "200";
			}
			else if (rank_int <= 1000 && rank_int >= 501)
			{
				silverstr = (2000 + (1001 - rank_int) * 5).toString();
				xiuweistr = "150";
			}
			else if (rank_int > 1000)
			{
				silverstr = "2000";
				xiuweistr = "100";
			}

			_competeToolTipVO.silver = silverstr;
			_competeToolTipVO.honor = xiuweistr;
			_competeToolTipVO.equipment=equipment;
		}

		// =====================
		// @交互
		// =====================
		public function get GetUserRank() : String
		{
			return _userRank;
		}

		public function get GetUserItemX() : int
		{
			return _item_x;
		}

		public function get GetUserName() : String
		{
			return _userName;
		}
		
	    public function set UserItemX(x:int) : void
		{
			_item_x=x;
		}
		
		public function set index(index:int):void
		{
			_index=index;
		}
		
		public function get index():int
		{
			return _index;
		}
		


		// =====================
		// @其他
		// =====================
		/** 获取玩家头像路径,根据将领ID */
		public static function getComHeadPhotoByHeroId(heroId : uint) : String
		{
			return VersionManager.instance.getUrl(DIR_COMPLAYER_HEAD_PHOTO + heroId + ".png");
		}
	}
}
