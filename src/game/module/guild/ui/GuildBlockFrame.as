package game.module.guild.ui {
	import com.utils.TextFormatUtils;
	import flash.text.TextField;
	import game.definition.UI;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;

	/**
	 * @author zhangzheng
	 */
	public class GuildBlockFrame extends GComponent {
		
		private var _title:TextField ;
		
		public function GuildBlockFrame(base : GuildBlockFrameData) {
			super(base);
			initView( base );
		}

		private function initView(base : GuildBlockFrameData) : void {
			var bg:Sprite = UICreateUtils.createSprite( UI.GUILD_BLOCK_BODY , width , height );
			addChild(bg);
			
			bg = UICreateUtils.createSprite( UI.GUILD_BLOCK_TITLE , width - base.titlePadding * 2 , base.titleHeight , base.titlePadding , base.titlePadding );
			addChild(bg);
			
			_title = UICreateUtils.createTextField( base.title, null , bg.width, bg.height  , bg.x , bg.y + 3 , TextFormatUtils.panelSubTitleCenter );
			addChild(_title);
		}
		
		public function set title(value:String):void{
			_title.text = value ;
		}
	}
}
