package game.module.daily {
	import com.commUI.transanim.AnimationId;
	import com.commUI.transanim.KeyFrameAnimEvent;
	import com.commUI.transanim.KeyFrameAnimation;
	import com.utils.StringUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import game.definition.UI;
	import game.manager.ViewManager;
	import gameui.controls.GButton;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.manager.UIManager;
	import net.AssetData;











	/**
	 * @author zhangzheng
	 */
	public class NoticeWindow extends KeyFrameAnimation {
		
		private var _bg:Sprite ;
//		private var _icon:GImage ;
//		private var _glow:Sprite ;
//		private var _timer:TextField ;
		private var _button:NoticeButton ;
		private var _info:TextField ;
		private var _shortcut:TextField ;
		private var _closeBtn:GButton ;
		private var _callback:Function ;
		private var _timeLeft:int ;
		private var _state:int ;
		private var _foldstatus:int ;	//展开状态,0:收起,1:展开动画中,2:展开状态,3:收起动画中
		
		public function NoticeWindow() {
			
			var base : GComponentData = new GComponentData() ;
			base.width = 243.5 ;
			base.height = 85.5 ;
			base.parent = ViewManager.instance.uiContainer ;
			super(base);
			initPanel() ;
		}
		
		private function initPanel():void
		{
			// background
			_bg = UIManager.getUI(new AssetData(UI.DAILY_NOTIFY_BACKROUND));
			_bg.width = 243.5 ;
			_bg.height = 85.5 ;
			addChild(_bg);
			
//			_glow = UIManager.getUI(new AssetData(UI.DAILY_NOTIFY_GLOW));
//			addChild(_glow);
//
//			var idata:GImageData = new GImageData() ;
//			_icon = new GImage(idata) ;
//			addChild(_icon);
//			
//			_timer = new TextField() ;
//			var timfmt:TextFormat = new TextFormat() ;
//			timfmt.color = 0xFFFFFF; 
//			timfmt.size = 12 ;
//			timfmt.align = "center";
//			_timer.defaultTextFormat = timfmt ;
//			_timer.selectable = false ;
//			_timer.filters = [FilterUtils.defaultTextEdgeFilter];
//			_timer.width = 63 ;
//			_timer.height = 20 ;
//			addChild(_timer);
			
			_info = new TextField() ;
			var infmt:TextFormat = new TextFormat() ;
			infmt.color = 0xFFFFFF ;
			infmt.size = 14 ;
			infmt.align = "center";
			_info.defaultTextFormat = infmt ;
			_info.selectable = false ;
			_info.width = 140 ;
			_info.height = 24 ;
			addChild(_info);
			
			_shortcut = new TextField();
			var shtfmt:TextFormat = new TextFormat() ;
			shtfmt.color = 0xFF6633 ;
			shtfmt.size = 12 ;
			shtfmt.align = "center";
			_shortcut.defaultTextFormat = shtfmt ;
			_shortcut.selectable = false ;
			_shortcut.width = 140 ;
			_shortcut.height = 20 ;
			addChild(_shortcut);

			_button = new NoticeButton() ;
			addChild(_button);
			_button.addEventListener(MouseEvent.CLICK, onClickButton);
			
			var btndata:GButtonData = new GButtonData();
			btndata.width = 16 ;
			btndata.height = 16 ;
			btndata.overAsset = new AssetData(UI.COMMON_WINDOW_BUTTON_CLOSE_OVER);
			btndata.upAsset = new AssetData(UI.COMMON_WINDOW_BUTTON_CLOSE_UP);
			btndata.downAsset = new AssetData(UI.COMMON_WINDOW_BUTTON_CLOSE_UP);
			_closeBtn = new GButton(btndata);
			_closeBtn.addEventListener(MouseEvent.CLICK, onClickClose);
			addChild(_closeBtn);
			
		}

		private function onClickButton(event : MouseEvent) : void {
			
			if( _state != 0 )
				return ;
			//收起状态下
			if( _foldstatus == 0 )
				fadeIn();
			else if( _foldstatus == 2 )
				fadeOut();
		}
		
		
		public function closeWindow():void
		{
			DailyNotice.instance.closeNotice();
		}
		
		private function onClickClose(evt:Event):void
		{
			if( _foldstatus != 2 )
				return ;
			if( _state == 0 )
			{
				_foldstatus = 0;
				stopAnimation() ;
				applyAnimationFrame(0);
			}
			else 
			{
				stopAnimation() ;
				DailyNotice.instance.closeNotice() ;
			}
			
		}
		
		private function onShortCut( evt:Event ):void
		{
			if( _callback != null )
				_callback.apply() ;
			_foldstatus = 0 ;
			if( _state == 0 )
				applyAnimationFrame(0);
			else 
				DailyNotice.instance.closeNotice() ;
		}
		
		public function update( vo : VoNotice, state : int, fun : Function , timer:int = 0 ) : void {
			

			_button.update(vo,timer,state);
			unbindAnimationAll() ;

			bindAnimation(_bg, AnimationId.NOTICE_FADEIN_BACK);
			bindAnimation(_closeBtn, AnimationId.NOTICE_FADEIN_CLOSE);
			
			
			bindAnimation(_button, AnimationId.NOTICE_FADEIN_GLOW);
			
			_info.htmlText = vo.description(state);
			_info.visible = true ;
			bindAnimation(_info, AnimationId.NOTICE_FADEIN_INFO);
			
//			_icon.url = vo.iconUrl ;
//			bindAnimation(_icon, AnimationId.NOTICE_FADEIN_ICON);
			
			_callback = fun ;
			if( fun != null )
			{
				_shortcut.htmlText = StringUtils.addEvent(StringUtils.addLine(vo.joinString), "to") ;
				_shortcut.visible = true ;
				_shortcut.addEventListener(TextEvent.LINK, onShortCut);
				bindAnimation(_shortcut, AnimationId.NOTICE_FADEIN_SHORT);
			}
			else 
			{
				_shortcut.visible = false ;
			}
			
			_timeLeft = timer ;
			_state = state ;
			
			if( state == 0 )
			{
				this.applyAnimationFrame(0);
				_foldstatus = 0 ;
				_button.showTooltip() ;
			}
			else if( state == 1 )
			{
				_foldstatus = 2 ;
				this.applyAnimationFrame(-1);
				_button.hideTooltip() ;
			}
			
//			if( state == 0 )
//			{
//				_timer.visible = true ;
//				_timer.text = TimeUtil.toMMSS( _timeLeft );
//				bindAnimation(_timer, AnimationId.NOTICE_FADEIN_TIMER);
//			}
//			else 
//			{
//				_timer.visible = false; 
//			}
		}

		public function fadeIn() : void {
			_foldstatus = 1 ;
			this.applyAnimationFrame(0);
			this.playAnimation(0);
			this.addEventListener(KeyFrameAnimEvent.Animation_Finish, onAnimFinish);
			_button.hideTooltip() ;
		}
		
		public function fadeOut() :void {
			_foldstatus = 3 ;
			this.applyAnimationFrame(-1);
			this.playAnimation(-1,false,true);
			this.addEventListener(KeyFrameAnimEvent.Animation_Finish, onAnimFinish);
		}
		
		private function onAnimFinish(evt:Event):void{
			if( _foldstatus == 1 )
				_foldstatus = 2 ;
			else if( _foldstatus == 3 )
			{
				_foldstatus = 0 ;
				_button.showTooltip() ;
			}
			removeEventListener(KeyFrameAnimEvent.Animation_Finish, onAnimFinish);
		}
		
		public function get timeLeft():int
		{
			return _timeLeft ;
		}
		
		public function set timeLeft(time:int):void
		{
			_timeLeft = time ;
			_button.timeLeft = _timeLeft ;
//			_timer.text = TimeUtil.toMMSS(time);
		}
	}
}

