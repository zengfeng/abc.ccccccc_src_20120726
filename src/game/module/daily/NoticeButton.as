package game.module.daily {
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.commUI.transanim.AnimationId;
	import com.commUI.transanim.KeyFrameAnimation;
	import com.utils.FilterUtils;
	import com.utils.TimeUtil;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import game.core.avatar.AvatarManager;
	import game.definition.UI;
	import gameui.controls.BDPlayer;
	import gameui.controls.GImage;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;
	import gameui.manager.GToolTipManager;
	import gameui.manager.UIManager;
	import net.AssetData;









	/**
	 * @author zhangzheng
	 */
	public class NoticeButton extends KeyFrameAnimation {

		private var _image:GImage ;
		private var _glow:Sprite ;
		private var _effect:BDPlayer ;
		private var _timer:TextField ;
		private var _timeLeft:int ;
		private var _isup:Boolean = false ;
		private var _vo:VoNotice ;
		private var _state:int ;
		private var _showTooltip:Boolean ;
		
		public function NoticeButton() {
			var data:GComponentData = new GComponentData();
//			data.width = 63 ;
//			data.height = 63 ;
			super(data);
			initButton();
		}
		
		private function initButton():void
		{	
			_glow = UIManager.getUI(new AssetData(UI.DAILY_NOTIFY_GLOW));
			addChild(_glow);
			bindAnimation(_glow, AnimationId.NOTICE_GLOW_OVER);
			
			_effect=AvatarManager.instance.getCommBDPlayer(AvatarManager.COMM_CIRCLEEFFECT, new GComponentData());
			_effect.x = 34 ;
			_effect.y = 31 ;
			_effect.scaleX = 0.65 ;
			_effect.scaleY = 0.65 ;
			addChild(_effect);
			
			var idata:GImageData = new GImageData() ;
			idata.x = 7.5 ;
			idata.y = 7.5 ;
			idata.width = 48 ;
			idata.height = 48 ;
			_image = new GImage(idata);
			addChild(_image);
			
			_timer = new TextField() ;
			_timer.x = 0 ;
			_timer.y = 47 ;
			
			var format:TextFormat = new TextFormat() ;
			format.color = 0xFFFFFF;
			format.size = 12 ;
			format.align = "center" ;
			_timer.defaultTextFormat = format ;
			_timer.filters = [FilterUtils.defaultTextEdgeFilter];
			_timer.selectable = false ;
			_timer.height = 20 ;
			_timer.width = 63 ;
			addChild(_timer);
			
			_toolTip = ToolTipManager.instance.getToolTip(ToolTip);	
			GToolTipManager.registerToolTip(this);
			_showTooltip = true ;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
		}
		
		public function setIcon( url:String ):void
		{
			_image.url = url ;
		}
		
		private function onMouseDown(evt:MouseEvent):void
		{
			if( _state != 0 )
				return ;
			if( _isup )
			{
				btndown() ;
				stopAnimation() ;
				applyAnimationFrame(0);
			}
		}

		private function onMouseUp(evt:MouseEvent):void
		{
			if( _state != 0 )
				return ;
			if( _isup )
			{
				btndown() ;
				stopAnimation() ;
				applyAnimationFrame(0);
			}
		}

		private function onMouseOver(evt:MouseEvent):void
		{
			if( _state != 0 )
				return ;
			if( !_isup )
			{
				btnup() ;
			}
			applyAnimationFrame(0);
			playAnimation(0,false);
			if( _showTooltip )
				_toolTip.source = _vo == null ? "" : _vo.name ;
		}

		private function onMouseLeave(evt:MouseEvent):void
		{
			if( _state != 0 )
				return ;
			if( _isup )
			{
				btndown();
				stopAnimation() ;
				applyAnimationFrame(0);
			}
		}
		
		private function btnup():void
		{
			y -= 2 ;
			_isup = true ;
		}
		
		private function btndown():void
		{
			y += 2 ;
			_isup = false ;
		}

		public function update(vo : VoNotice , tim:int = 0 , state:int = 0) : void {
			_vo = vo ;
			setIcon( vo.iconUrl );
			_timeLeft = tim ;
			_timer.visible = state == 0 ;
			_effect.visible = state == 0 ;
			if( state == 0 ){
				_effect.play(80,null,0) ;
			}else{
				_effect.stop();
			}
			_state = state ;
			if( _state != 0 && _isup )
				btndown() ;
			applyAnimationFrame(0);
				
		}
		
//		override protected function onShow():void{
//			applyAnimationFrame(0);
//			super.onShow();
//			_effect.gotoAndPlay(0);
//		}
//		
//		override protected function onHide():void{
//			super.onHide();
//			stopAnimation();
//			_effect.stop();
//		}
		
		public function get timeLeft():int
		{
			return _timeLeft ;
		}
		
		public function set timeLeft(time:int):void
		{
			_timeLeft = time ;
			_timer.text = TimeUtil.toMMSS(time);
		}
		
		public function showTooltip():void
		{
			if( !_showTooltip )
			{
				_showTooltip = true ;
				GToolTipManager.registerToolTip(this);
			}
		}
		
		public function hideTooltip():void
		{
			if( _showTooltip )
			{
				_showTooltip = false ;
				GToolTipManager.destroyToolTip(this);
			}
		}
		

	}
}
