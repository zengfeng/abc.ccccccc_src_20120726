package game.module.mapClanEscort.ui {
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.battle.view.BTSystem;
	import game.module.mapClanEscort.MCEController;
	import game.net.data.StoC.SCGEResult;
	import game.net.data.StoC.SCGEResult.PlayerDamage;

	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.button.KTButtonData;
	import com.utils.ColorUtils;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import com.utils.UIUtil;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;





    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-3-1   ����2:43:11 
     */
    public class ClanEscortResultPanel extends GComponent
    {
		
		private static const PAGE_SIZE:int = 5 ;
		
        public function ClanEscortResultPanel(single:singleton)
        {
			single ;
            _base = new GComponentData();
            _base.width = 390;
//            _base.height = 416;
			_base.height = 455 ;
            _base.parent = ViewManager.instance.uiContainer;
            super(_base);
        }
		
		private static var _instance:ClanEscortResultPanel ;
		
		public static function get instance():ClanEscortResultPanel{
			if( _instance == null ){
				_instance = new ClanEscortResultPanel(new singleton());
			}
			return _instance ;
		}

        override public function show() : void
        {
//			if (modalSkin)
//            {
//				modalSkin.x = modalSkin.y = 0;
//				modalSkin.width = stage.stageWidth;
//				modalSkin.height = stage.stageHeight;
//                if(_base.parent.contains(modalSkin) == false) _base.parent.addChild(modalSkin);
//            }
//			
            UIUtil.alignStageCenter(this);
            super.show();
            stage.addEventListener(Event.RESIZE, onStageResize);
        }

        override public function hide() : void
        {
            stage.removeEventListener(Event.RESIZE, onStageResize);
            super.hide();
//            if (modalSkin)
//            {
//                if (modalSkin.parent) modalSkin.parent.removeChild(modalSkin);
//            }
        }

        override public function get stage() : Stage
        {
            return UIUtil.stage;
        }

        private function onStageResize(event : Event) : void
        {
            UIUtil.alignStageCenter(this);
//			if (modalSkin)
//            {
//				modalSkin.x = modalSkin.y = 0;
//				modalSkin.width = stage.stageWidth;
//				modalSkin.height = stage.stageHeight;
//            }
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 文本 参与人数 */
        public const TEXT_JOIN_COUNT : String = "本次家族进献共参与__NUM__人";
        /** 文本 获得声望 */
        public const TEXT_HONOUR_TRUE : String = "进献蟠桃成功，你获得修为__NUM__";
        public const TEXT_HONOUR_FALSE : String = "进献蟠桃失败，没有获得奖励";
        /** 文本 获得银币 */
        public const TEXT_SILVER_TRUE : String = "进献仙酿成功，你获得银币__NUM__";
        public const TEXT_SILVER_FALSE : String = "进献仙酿失败，没有获得奖励";
		
		private var _winTitle:Sprite ;
		private var _failTitle:Sprite ;
		private var _memberRes:Vector.<EscorResultItem> ;
		private var _membercnt:TextField ;
		private var _resultText1:TextField ;
		private var _resultText2:TextField ;
		private var _btnLeave:GButton ;
		private var _hasInit:Boolean = false ;
//        /** 标题 */
//        private var titleLabel : GLabel;
//        /** 退出按钮 */
//        private var quitButton : GButton;
//        /** 参与人数 */
//        private var joinCountLabel : GLabel;
//        /** 获得声望 */
//        private var honourLabel : GLabel;
//        /** 获得银币 */
//        private var silverLabel : GLabel;
//        /** 列表容器 */
//        private var listContainer : Sprite;
//        private var modalSkin : Sprite;

		public function get hasInit():Boolean{
			return _hasInit;
		}

        /** 初始化视图 */
        public function initViews() : void
        {
			
			var fmt:TextFormat = new TextFormat() ;
			fmt.font = UIManager.defaultFont;
			fmt.color = 0x2F1F00;
			fmt.size = 12;
			fmt.leading = 3;
			fmt.align = TextFormatAlign.CENTER ;
			fmt.bold = true ;
			
			var bg:Sprite = UICreateUtils.createSprite( UI.WINDOW_BACKGROUND , width, height );
			addChild(bg);
			
			bg = UICreateUtils.createSprite( UI.VIP_BG,380,444,5,6 );
			addChild(bg);
			
			bg = UICreateUtils.createSprite( UI.COMMON_BACKGROUND03,356,159,17,116 );
			addChild(bg);
			
//			bg = UICreateUtils.createSprite( UI.COMMON_BACKGROUND03,356,83,17,255 );
//			addChild(bg);
			
			bg = UICreateUtils.createSprite( UI.GUILD_LIST_TITLE , 353,24,19,118 );
			addChild(bg);
			
			var txt:TextField = UICreateUtils.createTextField("排名",null,48,21,19,121,fmt);
			addChild(txt);
			
			txt = UICreateUtils.createTextField("族员",null,48,21,170,121,fmt);
			addChild(txt);
			
			txt = UICreateUtils.createTextField("造成伤害",null,72,21,292,121,fmt);
			addChild(txt);
			
			_winTitle = UIManager.getUI( new AssetData("escor_success","mce"));
			_winTitle.x = 19 ;
			_winTitle.y = 15 ;
//			UICreateUtils.createSprite( "escor_success",372,68,7,8 );
			addChild(_winTitle);
			
//			_failTitle = UICreateUtils.createSprite( "escor_fail",372,68,7,8 );
			_failTitle = UIManager.getUI( new AssetData("escor_fail","mce"));
			_failTitle.x = 19 ;
			_failTitle.y = 15 ;
			addChild(_failTitle);
			
			_memberRes = new Vector.<EscorResultItem>();
			for ( var i:int = 0 ; i < PAGE_SIZE ; ++ i )
			{
				var eri:EscorResultItem = new EscorResultItem(i+1) ;
				eri.x = 20 ;
				eri.y = 146 + 25 * i ;
				addChild(eri);
				_memberRes.push(eri);
			}
			
			_membercnt = UICreateUtils.createTextField(null,null,170,21,200,279,TextFormatUtils.panelContentRight);
			addChild(_membercnt);
			
			bg = UICreateUtils.createSprite( UI.AREA_BACKGROUND, 356, 83, 17, 299 );
			addChild(bg);
			
			bg = UICreateUtils.createSprite( UI.GUILD_BLOCK_TITLE, 353, 24, 19,301 );  
			addChild(bg);
			
			var tt:TextField = UICreateUtils.createTextField( "获得奖励" ,null, 352, 24, 20 , 302,TextFormatUtils.panelSubTitleCenter );
			addChild(tt);
			
			_resultText1 = UICreateUtils.createTextField(null,null,200,22,27,335,TextFormatUtils.panelContent );
			addChild(_resultText1);

			_resultText2 = UICreateUtils.createTextField(null,null,200,22,27,355,TextFormatUtils.panelContent );
			addChild(_resultText2);

			_btnLeave = UICreateUtils.createGButton("离开",88,30,151,400,KTButtonData.SMALL_BUTTON);
			addChild(_btnLeave);
			
			_btnLeave.addEventListener(MouseEvent.CLICK, onClickLeave);
			
			_hasInit = true ;
//			modalSkin =ASSkin.modalSkin;
//            // 背景
//            var bg : Sprite = UIManager.getUI(new AssetData("GPanel_backgroundSkin"));
//            bg.width = _base.width;
//            bg.height = _base.height;
//            addChild(bg);
//            // 内容背景
//            var contentBg : Sprite = UIManager.getUI(new AssetData("sutra_Explain"));
//            contentBg.x = 10;
//            contentBg.y = 10;
//            contentBg.width = _base.width - contentBg.x * 2;
//            contentBg.height = _base.height - contentBg.y * 2 - 5;
//            contentBg.alpha = 0.8;
//            addChild(contentBg);
//
//            contentBg = UIManager.getUI(new AssetData("chosenBar"));
//            contentBg.x = 20;
//            contentBg.y = 60;
//            contentBg.width = _base.width - contentBg.x * 2;
//            contentBg.height = 25;
//            contentBg.alpha = 0.5;
//            addChild(contentBg);
//
//            contentBg = UIManager.getUI(new AssetData("chosenBar"));
//            contentBg.x = 20;
//            contentBg.y = _base.height - 130;
//            contentBg.width = _base.width - contentBg.x * 2;
//            contentBg.height = 25;
//            contentBg.alpha = 0.5;
//            addChild(contentBg);
//
//            var textFormat : TextFormat = new GLabelData().textFormat;
//            textFormat.align = TextFormatAlign.CENTER;
//            textFormat.size = 30;
//            textFormat.bold = true;
//            textFormat.leading = 3;
//            // 标题
//            var label : GLabel = UICreateUtils.createGLabel({width:_base.width, height:30, y:10, textFormat:textFormat, enabled:false});
//            label.text = "胜利";
//            label.textColor = 0xFFCC00;
//            addChild(label);
//            titleLabel = label;
//            // 退出按钮
//            quitButton = UICreateUtils.createGButton("离开");
//            quitButton.x = (_base.width - quitButton.width) / 2;
//            quitButton.y = _base.height - quitButton.height - 25;
//            addChild(quitButton);
//            quitButton.addEventListener(MouseEvent.CLICK, cs_quit);
//
//            textFormat = new GLabelData().textFormat;
//            textFormat.align = TextFormatAlign.LEFT;
//            textFormat.size = 12;
//            textFormat.bold = true;
//            textFormat.leading = 6;
//            var textFieldFilters : Array = UIManager.getEdgeFilters(0xF8DBDA, 0.7);
//            // 字段 排名列表
//            label = UICreateUtils.createGLabel({width:_base.width - 40, height:20, textFormat:textFormat, enabled:false, textFieldFilters:textFieldFilters});
//            label.text = "排名             族员                       造成伤害";
//            label.textColor = 0x663300;
//            label.x = 30;
//            label.y = 65;
//            addChild(label);
//            // 字段 获得奖励
//            label = UICreateUtils.createGLabel({width:_base.width - 40, height:20, textFormat:textFormat, enabled:false, textFieldFilters:textFieldFilters});
//            label.text = "获得奖励";
//            label.textColor = 0x663300;
//            label.x = 30;
//            label.y = _base.height - 130 + 5;
//            addChild(label);
//
//            textFormat = new GLabelData().textFormat;
//            textFormat.align = TextFormatAlign.RIGHT;
//            textFormat.size = 12;
//            textFieldFilters = UIManager.getEdgeFilters(0xF8DBDA, 0.4);
//            // 本次家庭进南美酒共参与15人
//            label = UICreateUtils.createGLabel({width:_base.width - 40, height:20, textFormat:textFormat, enabled:false, textFieldFilters:textFieldFilters});
//            label.text = TEXT_JOIN_COUNT;
//            label.textColor = 0x666666;
//            label.x = 20;
//            label.y = _base.height - 150;
//            addChild(label);
//            joinCountLabel = label;
//
//            textFormat = new GLabelData().textFormat;
//            textFormat.size = 12;
//            textFieldFilters = UIManager.getEdgeFilters(0xF8DBDA, 0.4);
//            // 进献美酒成功，你获得声望
//            label = UICreateUtils.createGLabel({width:_base.width - 20, height:20, textFormat:textFormat, enabled:false, textFieldFilters:textFieldFilters});
//            label.htmlText = TEXT_HONOUR_TRUE;
//            label.textColor = 0x523321;
//            label.x = 20;
//            label.y = _base.height - 100;
//            addChild(label);
//            honourLabel = label;
//
//            // 进献仙桃成功，你获得银币
//            label = UICreateUtils.createGLabel({width:_base.width - 20, height:20, textFormat:textFormat, enabled:false, textFieldFilters:textFieldFilters});
//            label.htmlText = TEXT_SILVER_TRUE;
//            label.textColor = 0x523321;
//            label.x = 20;
//            label.y = _base.height - 80;
//            addChild(label);
//            silverLabel = label;
//
//            // 列表容器
//            listContainer = new Sprite();
//            listContainer.x = 28;
//            listContainer.y = 90;
//            addChild(listContainer);
        }

        private function onClickLeave(event : MouseEvent = null) : void
        {
            hide();
            MCEController.instance.cs_quit();
        }

        public function setTitle(result : Boolean) : void
        {
            if (result == true)
            {
				_winTitle.visible = true ;
				_failTitle.visible = false ;
//                titleLabel.text = "胜利";
//                titleLabel.textColor = 0xFFCC00;
            }
            else
            {
				_failTitle.visible = true ;
				_winTitle.visible = false ;
            }
        }

        public function setJoinCount(num : Number) : void
        {
			_membercnt.htmlText = TEXT_JOIN_COUNT.replace(/__NUM__/ig, StringUtils.addColor(num.toString(),ColorUtils.HIGHLIGHT) );
        }

        public function setHonour(result : Boolean, num : Number) : void
        {
            if (result == true)
            {
                _resultText1.htmlText = TEXT_HONOUR_TRUE.replace(/__NUM__/ig, StringUtils.addColor(num.toString(),ColorUtils.TEXTCOLOR[ColorUtils.GREEN]));
            }
            else
            {
                _resultText1.text = TEXT_HONOUR_FALSE;
            }
        }

        public function setSilver(result : Boolean, num : Number) : void
        {
            if (result == true)
            {
                _resultText2.htmlText = TEXT_SILVER_TRUE.replace(/__NUM__/ig, StringUtils.addColor(num.toString(),ColorUtils.TEXTCOLOR[ColorUtils.GREEN]));
            }
            else
            {
                _resultText2.text = TEXT_SILVER_FALSE;
            }
        }

        public function setPlayerList(playerList : Vector.<PlayerDamage>) : void
        {
			for( var i:int = 0 ; i < PAGE_SIZE ; ++ i )
			{
				if( i < playerList.length )
				{
					_memberRes[i].refresh(playerList[i]);
				}
				else 
				{
					_memberRes[i].refresh(null);
				}
			}
//            var playerDamage : PlayerDamage;
//            var sortItem : SortItem;
//            for (var i : int = 0; i < playerList.length; i++)
//            {
//                if (listContainer.numChildren > i)
//                {
//                    sortItem = listContainer.getChildAt(i) as SortItem;
//                }
//                else
//                {
//                    sortItem = new SortItem();
//                    listContainer.addChild(sortItem);
//                }
//
//                playerDamage = playerList[i];
//                sortItem.setSerial(i + 1);
//                sortItem.setDamage(playerDamage.damage);
////                sortItem.setPlayer(guildMember.id, guildMember.name, PotentialColorUtils.getColor(guildMember.potential));
//            }
//
//            var displayObject : DisplayObject;
//            for (i = 0; i < listContainer.numChildren; i++)
//            {
//                displayObject = listContainer.getChildAt(i);
//                displayObject.y = i * 22;
//            }
//
//            while (listContainer.numChildren > playerList.length)
//            {
//                listContainer.removeChildAt(listContainer.numChildren - 1);
//            }
        }
		
        public function scMsg(msg : SCGEResult) : void
        {
			msgData = msg;
//            Alert.show("BTSystem.isInBattle = " + BTSystem.isInBattle);
			if(BTSystem.INSTANCE().isInBattle == false)
			{
				setMsgData();
				return;
			}
			
			BTSystem.INSTANCE().addClickEndCall(btClickEndCall);
        }
		private var  btClickEndCall:Object = {fun:setMsgData, arg:[]};
		
		private var msgData:SCGEResult;
		private function setMsgData():void
		{
//            Alert.show("结算setMsgData msg=" + msgData );
			BTSystem.INSTANCE().removeClickEndCall(btClickEndCall);
			var msg : SCGEResult = msgData;
			if(msg == null) return;
			setJoinCount(msg.membercnt);
            setPlayerList(msg.player);
            if (msg.hasResult1 ) {
           	 	setHonour(msg.result1, msg.reward1);
			}else{
				_resultText1.text = "" ;
			}

            if (msg.hasResult2)
            {
                setSilver(msg.result2, msg.reward2);
            }
            else
            {
                _resultText2.text = "";
            }

            var isWin : Boolean = msg.result1 == true || msg.result2 == true;
            setTitle(isWin);
            show();
		}
    }
}
import game.module.guild.GuildManager;
import game.module.guild.GuildUtils;
import game.module.guild.vo.VoGuild;
import game.module.guild.vo.VoGuildMember;
import game.net.data.StoC.SCGEResult.PlayerDamage;

import com.utils.StringUtils;
import com.utils.TextFormatUtils;
import com.utils.UICreateUtils;

import flash.display.Sprite;
import flash.text.TextField;

class EscorResultItem extends Sprite{
	
	private var _memberTxt:TextField ; 
	private var _damageTxt:TextField ;
	private var _seqTxt:TextField ;
	
	public function EscorResultItem( seq:int ){
		var bg:Sprite = UICreateUtils.createSprite( (seq & 1)==0?GuildUtils.clanDeepBar:GuildUtils.clanLightBar,349,25 );
		addChild(bg);
		
		_seqTxt = UICreateUtils.createTextField( "第"+seq.toString()+"名",null,36,21,5,3,TextFormatUtils.panelContentCenter);
		addChild(_seqTxt);
		
		_memberTxt = UICreateUtils.createTextField( null,null,105,22,119,3,TextFormatUtils.panelContentCenter );
		addChild(_memberTxt);
		
		_damageTxt = UICreateUtils.createTextField( null,null,42,21,287,3 , TextFormatUtils.panelContentRight );
		addChild(_damageTxt);
	}
	
	internal function refresh( val:PlayerDamage ):void{
		
		var guild:VoGuild = GuildManager.instance.selfguild ;
		var mem:VoGuildMember = val == null || guild == null ? null : guild.memberDict[val.playerid];
		if( mem == null || val == null ){
			_seqTxt.visible = false ;
			_memberTxt.visible = false ;
			_damageTxt.visible = false ;
		}
		else{
			_seqTxt.visible = true ;
			_memberTxt.visible = true ;
			_damageTxt.visible = true ;
			_memberTxt.htmlText = mem.colorname() ;
			_damageTxt.text = StringUtils.numToMillionString(val.damage);
		}
	}
}

class singleton{
}
