package game.module.guild {
	import flash.events.Event;
	/**
	 * @author zhangzheng
	 */
	public class GuildEvent extends Event {
		
		//manager to view
		public static const GUILD_ENTER:String = "guild_enter" ;
		public static const GUILD_LEAVE:String = "guild_leave" ;
		public static const GUILD_BASE_CHANGE:String = "guild_base_change" ;
		public static const GUILD_MEMBER_LIST_CHANGE:String = "guild_member_list_change";
		public static const GUILD_MEMBER_INFO_CHANGE:String = "guild_member_info_change";
		public static const GUILD_APPLY_CHANGE:String = "guild_apply_change" ;
		public static const GUILD_ACTION_CHANGE:String = "guild_action_change";
		public static const GUILD_TREND_CHANGE:String = "guild_trend_change";
		public static const SELF_POSITION_CHANGE:String = "self_position_change";
		public static const GUILD_LIST:String = "guild_list";
		public static const GUILD_LIST_CHANGE:String = "guild_list_change";
		public static const GUILD_VOTE_CHANGE:String = "guild_vote_change";
		public static const VIEW_GUILD_BUILD:String = "view_guild_build";
		//view to view
		public static const CLOSE_VIEW:String = "close_view";
		public static const CHANGE_STATE:String = "change_state";
//		public static const SET_SELF_GUILD:String = "set_self_guild";
//		public static const VIEW_GUILD:String = "view_guild";
//		public static const APPLY_CHANGE:String = "apply_change";
//		public static const BASE_INFO_CHANGE:String = "base_info_change";
//		public static const ACTION_CONFIG_CHANGE:String = "action_config_change";
//		public static const ACTION_STATUS_CHANGE:String = "action_status_change";
//		public static const MEMBER_INFO_CHANGE:String = "member_info_change";
//		public static const VOTE_INFO_CHANGE:String = "vote_info_change";
//		public static const LEAVE_GUILD:String = "leave_guild";
//		public static const GUILD_LIST_CHANGE:String = "guild_list_change";
//		public static const APPLY_LOAD:String = "apply_load";
//		public static const CLOSE_WINDOW : String = "close_window";
//		public static const LIST_TREND : String = "LIST_TREND";
		
		public var param : int = 0 ;

		public function GuildEvent( type : String) {
			super(type);
		}
	}
}
