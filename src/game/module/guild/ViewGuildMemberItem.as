package game.module.guild {
	import game.core.user.UserData;
	import com.utils.TextFormatUtils;
	import game.module.friend.ManagerFriend;
	import game.module.guild.vo.VoGuildMember;

	import com.commUI.tips.PlayerTip;
	import com.utils.ColorUtils;
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
	public class ViewGuildMemberItem extends Sprite {
		
		private var _name:TextField ;
		private var _level:TextField ;
		private var _post:TextField ;
		private var _rank:TextField ;
		private var _deepbg:Sprite ;
		private var _lightbg:Sprite ;
		
		private var _vo:VoGuildMember ;
		
		public function ViewGuildMemberItem() {
			addbg();
			initView();
		}

		private function initView() : void {
			var fmt:TextFormat = TextFormatUtils.panelContentCenter ;
//			fmt.size = 12 ;
//			fmt.align = TextFormatAlign.CENTER ;
//			fmt.color =  ColorUtils.PANELTEXT0X;
			_name = UICreateUtils.createTextField(null,null,100, 25, 12, 4, fmt);
			_name.mouseEnabled = true ;
			_name.selectable = false ;
			addChild(_name);
			
			_level = UICreateUtils.createTextField(null,null,24, 25, 125, 4, fmt);
			_level.selectable = false ;
			addChild(_level);

			_post = UICreateUtils.createTextField(null,null,40, 25, 166, 4, fmt);
			_post.selectable = false ;
			addChild(_post);
			
			_rank = UICreateUtils.createTextField(null,null,37, 25, 230, 4, fmt);
			_rank.selectable = false ;
			addChild(_rank);
			
			_name.addEventListener(MouseEvent.ROLL_OVER, onMouseOverName);
			_name.addEventListener(MouseEvent.ROLL_OUT, onMouseLeaveName);
			_name.addEventListener(TextEvent.LINK, onClickName);

		}

		private function onClickName(event : TextEvent) : void {
			if( _vo.id == UserData.instance.playerId )
				return ;
			var fm:ManagerFriend = ManagerFriend.getInstance();
			if( fm.isInBackListByPlayerId(_vo.id) )
				PlayerTip.show( _vo.id,_vo.name , GuildUtils.tiplist[GuildUtils.TL_GUILD_VIEW_BLOCK] );
			else if( fm.isInFriendListByPlayerId(_vo.id) )
				PlayerTip.show( _vo.id,_vo.name , GuildUtils.tiplist[GuildUtils.TL_GUILD_VIEW_FRIEND] );
			else 
				PlayerTip.show(_vo.id,_vo.name, GuildUtils.tiplist[GuildUtils.TL_GUILD_VIEW_NORM]);
		}

		private function onMouseLeaveName(event : MouseEvent) : void {
			if( _vo != null )
				_name.htmlText = StringUtils.addEvent(_vo.colorname(), "to");
		}

		private function onMouseOverName(event : MouseEvent) : void {
			if( _vo != null )
				_name.htmlText = StringUtils.addEvent(_vo.linecolorname(), "to");
		}
		private function addbg() : void {
			
			_deepbg = UICreateUtils.createSprite( GuildUtils.clanDeepBar, 290, 25 );
			_lightbg = UICreateUtils.createSprite( GuildUtils.clanLightBar , 290 , 25 );
			addChild(_deepbg);
		}
		
		public function changebg(seq:int):void{
			removeChildAt(0);
			addChildAt((seq&1)==0?_lightbg:_deepbg, 0);
		}
		
		public function set vo(value:VoGuildMember):void{
			_vo = value ;
			if( _vo == null )
			{
				_name.visible = false ;
				_level.visible = false ;
				_post.visible = false ;
				_rank.visible = false ;
			}
			else
			{
				_name.visible = true ;
				_level.visible = true ;
				_post.visible = true ;
				_rank.visible = true ;
				_name.htmlText = _vo.colorname() ;
				_level.text = _vo.level.toString();
				_post.text = _vo.positionStr() ;
				_rank.text = _vo.rank.toString() ;
			}
		}
	}
}
