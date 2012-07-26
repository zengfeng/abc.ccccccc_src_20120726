package game.module.guild {
	import com.utils.TextFormatUtils;
	import mx.utils.StringUtil;
	import game.core.user.UserData;
	import game.module.guild.vo.VoGuildMember;

	import com.commUI.tips.PlayerTip;
	import com.utils.ColorUtils;
	import com.utils.PotentialColorUtils;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;




	/**
	 * @author zhangzheng
	 */
	public class GuildMemberItem extends Sprite {
		
		private var _deepbg:Sprite ;
		private var _lightbg:Sprite ;
		private var _name:TextField ;
		private var _level:TextField ;
		private var _post:TextField ;
		private var _rank:TextField ;
		private var _devote:TextField ;
		private var _login:TextField ;
		private var _vo:VoGuildMember ;
		private var _enabled:Boolean = true ;

		public function GuildMemberItem() {
			addBg();
			initView();
		}

		private function initView() : void {
			
			var fmt:TextFormat = TextFormatUtils.panelContentCenter;
//			fmt.size = 12 ;
//			fmt.align = TextFormatAlign.CENTER ;
//			fmt.color =  ColorUtils.PANELTEXT0X;
			_name = UICreateUtils.createTextField( null, null, 115,25,0,4 , fmt );
			_name.selectable = false ;
			_name.mouseEnabled = true ;
			_name.autoSize = "center";
			addChild(_name);
			
			_level = UICreateUtils.createTextField( null, null, 55 ,25 ,115, 4 , fmt );
			_level.selectable = false ;
			addChild(_level);
			
			_post = UICreateUtils.createTextField( null, null, 40 ,25 ,170, 4 , fmt );
			_post.selectable = false ;
			addChild(_post);
			
			_rank = UICreateUtils.createTextField( null, null, 75 ,25 ,210, 4 , fmt );
			_rank.selectable = false ;
			addChild(_rank);
			
			_devote = UICreateUtils.createTextField( null, null, 65 ,25 ,285, 4 , fmt );
			_devote.selectable = false ;
			addChild(_devote);
			
			_login = UICreateUtils.createTextField( null, null, 88 ,25 ,348, 4 , fmt );
			_login.selectable = false ;
			addChild(_login);
			
			_name.addEventListener(MouseEvent.CLICK, onClickName);
			_name.addEventListener(MouseEvent.ROLL_OVER, onRollOverName );
			_name.addEventListener(MouseEvent.ROLL_OUT, onRollOutName);
		}

		private function onRollOutName(event : MouseEvent) : void {
			_name.htmlText = _vo == null ? "" :_vo.name ;
		}

		private function onRollOverName(event : MouseEvent) : void {
			_name.htmlText = StringUtils.addLine(_vo.name)  ;
		}

		private function onClickName(event : MouseEvent) : void {
			
			var self:VoGuildMember = GuildManager.instance.selfmember ;
			if( _vo != null && self != null && _vo.id != UserData.instance.playerId )
			{
				if( self.position == 2 ){
					if( _vo.position == 1 )
						PlayerTip.show(_vo.id,_vo.name,GuildUtils.tiplist[GuildUtils.TL_MEMBER_LEADER_VICE]);
					else
						PlayerTip.show(_vo.id,_vo.name,GuildUtils.tiplist[GuildUtils.TL_MEMBER_LEADER_NORM]);
				}
				else if( self.position == 1 ){
					if( _vo.position == 2 )
						PlayerTip.show(_vo.id,_vo.name,GuildUtils.tiplist[GuildUtils.TL_MEMBER_VICE_LEADER]);
					else
						PlayerTip.show(_vo.id,_vo.name,GuildUtils.tiplist[GuildUtils.TL_MEMBER_VICE_NORM]);
				}
				else 
					PlayerTip.show(_vo.id ,_vo.name ,GuildUtils.tiplist[GuildUtils.TL_MEMBER_NORM]);
			}
		}

		private function addBg() : void {
			
			_deepbg = UICreateUtils.createSprite(GuildUtils.clanDeepBar,425,25);
			_lightbg = UICreateUtils.createSprite(GuildUtils.clanLightBar,425,25);
			addChild(_deepbg);
		}
		
		public function set vo( value:VoGuildMember ):void{
			_vo = value ;
			if( _vo == null )
			{
				_name.visible = false ;
				_level.visible = false ;
				_post.visible = false ;
				_rank.visible = false ;
				_devote.visible = false ;
				_login.visible = false ;
			}
			else 
			{
				_name.visible = true ;
				_level.visible = true ;
				_post.visible = true ;
				_rank.visible = true ;
				_devote.visible = true ;
				_login.visible = true ;
				_name.text = _vo.name ;
				_level.text = _vo.level.toString() ;
				_post.text = _vo.positionStr() ;
				_rank.text = _vo.rank.toString();
				_devote.text = _vo.devote.toString();
				_login.text = _vo.isOnline ? "在线":getTimeOpposite(_vo.latestonl);
				enabled = _vo.isOnline ;
			}
		}
		
		public function get vo():VoGuildMember {
			return _vo ;
		}
		
		private function getTimeOpposite(unt : uint) : String
		{
			var thisDate : Date = new Date();
			var date : Date = new Date( unt*1000 );
			var mins : String = "";
			if ((thisDate.fullYear == date.fullYear) && (thisDate.month == date.month) && (thisDate.date == date.date))
			{
				if (date.minutes > 9)
					mins = String(date.minutes);
				else
					mins = "0" + date.minutes;
				return "今日 " + date.hours + ":" + mins;
			}
			else
			{
				var a : Number = thisDate.time / 1000 - unt + 28800 ;
				// return int(a / 86400) + (a % 86400 ? 1 : 0 ) + " 天以前";
				if (int(a / 86400) + (a % 86400 ? 1 : 0 ) == 0) return "今天";
				else return int(a / 86400) + (a % 86400 ? 1 : 0 ) + " 天以前";
			}
		}
		
		public function updatebg(seq:int):void
		{
			removeChildAt(0);
			addChildAt( ( seq & 1 ) == 0 ? _lightbg : _deepbg , 0);
		}
		
		public function refresh():void{
			if( vo != null )
			{
				_name.htmlText = StringUtils.addEvent( _vo.colorname() , "to" );
				_level.text = _vo.level.toString() ;
				_post.text = _vo.positionStr() ;
				_rank.text = _vo.rank.toString();
				_devote.text = _vo.devote.toString();
				_login.text = _vo.isOnline ? "在线":getTimeOpposite(_vo.latestonl);
				enabled = _vo.isOnline ;
			}
		}
		
		private function set enabled(value:Boolean):void{
			_enabled = value ;
			if( _enabled )
			{
				_name.textColor = PotentialColorUtils.getColor(_vo.potential);
				_level.textColor =  0x2F1F00;
				_post.textColor = 0x2F1F00 ;
				_rank.textColor = 0x2F1F00 ;
				_devote.textColor = 0x2F1F00 ;
				_login.textColor = 0x2F1F00 ;
			}
			else
			{
				_name.textColor = ColorUtils.GRAY0X;
				_level.textColor = ColorUtils.GRAY0X;
				_post.textColor = ColorUtils.GRAY0X;
				_rank.textColor = ColorUtils.GRAY0X;
				_devote.textColor = ColorUtils.GRAY0X;
				_login.textColor = ColorUtils.GRAY0X;
			}
		}
	}
}
