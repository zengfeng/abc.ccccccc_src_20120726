package game.module.mapFeast {
	import com.utils.UrlUtils;
	import game.core.user.ExperienceConfig;
	import game.core.user.StateManager;
	import game.core.user.StateType;
	import game.core.user.UserData;
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.module.mapFeast.ui.UIFeastMatch;
	import game.module.mapFeast.ui.UIFeastSearch;
	import game.module.mapFeast.ui.UIFeastStart;
	import game.module.mapFeast.ui.UIFeastTimerPanel;
	import game.module.userBuffStatus.Buff;
	import game.module.userBuffStatus.BuffStatusManager;

	import gameui.controls.GButton;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;

	import log4a.Logger;

	import net.LibData;
	import net.RESManager;

	import worlds.apis.BarrierOpened;
	import worlds.apis.MPlayer;
	import worlds.apis.MTo;
	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;
	import worlds.apis.ModelId;
	import worlds.apis.validators.Validator;
	import worlds.roles.cores.Player;

	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.tips.PlayerTip;
	import com.utils.ColorUtils;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import com.utils.UIUtil;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	/**
	 * @author 1
	 */
	public class FeastController {
		
		//离开派对
		public static const FEAST_LEAVE:int = 0 ;
		//离开派对弹筐中
		public static const FEAST_PRELEAVE:int = 1 ;
		//参加派对
		public static const FEAST_ENTER:int = 2 ;
		//点击开始派对后,等待匹配
		public static const FEAST_BEGIN:int = 3 ;	
		//匹配成功，派对进行中
		public static const FEAST_MATCH:int = 4 ;
		
		public static const FEAST_STATE_DEFAULT:int = -1 ;
		
		private var _feastStatus:int = 0 ;

//		private var _feastMap:Dictionary = new Dictionary() ;
		private var _statusMap:Dictionary = new Dictionary() ;
//		private var _uiList:Vector.<DisplayObject> = new Vector.<DisplayObject>() ;

		/* UI */
		private var _cancelUI:GButton ;
		private var _startUI:UIFeastStart ;
		private var _searchUI:UIFeastSearch ;
		private var _matchUI:UIFeastMatch ;
		private var _timePanel:UIFeastTimerPanel ;
		private var _matePanel:Sprite ;
		private var _mateText:TextField ;
		private var _setup:Boolean = false ;
		private var _uisetup:Boolean = false ;
		private var _timeLeft:uint = 0 ;
		private var _mouseMoveState:int = 0xFFFF ;
		private var _tempValid:Validator ;
		private var _feastAlert:Alert ;


//		public var selfPartner:uint ;
		public var mateName:String ;
		public var mateId:uint ;
		public var mateColor:uint ;
		public var selfAvatar:uint = 0xFFFF ;
		
		public function checkEnter():void{
			if( MapUtil.isFeastMap() ){
				if( !_setup ){
					enter() ;
				}
			}
			else{
				if( _setup ){
					leave();
				}
			}
		}
		
		private function leave():void{
			_setup = false;
			_feastStatus = 0 ;
//			_feastMap = new Dictionary() ;
			mateId = 0 ;
			mateName = null ;
			mateColor = 0 ;
			if( _uisetup ){
				_startUI.hide() ;
				_searchUI.hide() ;
				_matchUI.hide() ;
				_cancelUI.hide() ;
				_timePanel.hide() ;				
			}
			selfAvatar = 0xFFFF ;
			BuffStatusManager.instance.updateBuffTime(200, 0);
			BuffStatusManager.instance.updateBuffTime(201, 0);
			BuffStatusManager.instance.updateBuffTime(202, 0);
			BuffStatusManager.instance.updateBuffTime(203, 0);
			BuffStatusManager.instance.updateBuffTime(204, 0);
			BuffStatusManager.instance.updateBuffTime(205, 0);
			BuffStatusManager.instance.updateBuffTime(210 ,0);
			StateManager.instance.changeState( StateType.FEASTING , false );
			ViewManager.removeStageResizeCallFun(layout);
		}
		
		private function enter() :void{

			_setup = true  ;
			if( !_uisetup )
				RESManager.instance.load(new LibData(UrlUtils.getLangSWF("mapFeast.swf"), "mf"),initUI);
			else{
				layout();
				refreshUI();
			}
			StateManager.instance.changeState( StateType.FEASTING , true);
			ViewManager.addStageResizeCallFun(layout);
			playerSingleMouseMove() ;
//			MMouse.enableWalk = _walkEnabled ;
			
			//init players
//			for each( var ps:PlayerStruct in PlayerManager.instance.getPlayerList() ){
//				updatePlayerAvatar(ps);
//			}
//			updatePlayerAvatar(CurrentMapData.instance.selfPlayerStruct);
		}
		
		private function playerSingleMouseMove():void{
			
			if( _mouseMoveState == 1 ){
				return ;
			}
			_mouseMoveState = 1 ;
			MTo.validWalk.reset().endChange();
			MTo.validMapTo.reset().add(checkSingleLeave).endChange();
			MTo.validTrans.reset().add(checkSingleLeave).endChange();
			MTo.validChangeAct.reset().add(checkSingleLeave).endChange();
		}

		private function playerMatchMouseMove():void{
			
			if( _mouseMoveState == 0 ){
				return ;
			}
			_mouseMoveState = 0 ;
			MTo.validWalk.add(checkMatchWalk).endChange() ;
			MTo.validTrans.reset().add(checkMatchLeave).endChange() ;
			MTo.validMapTo.reset().add(checkMatchLeave).endChange() ;
			MTo.validChangeAct.reset().add(checkMatchLeave).endChange() ;
		}
		
		private function playerLeaveMouseMove():void{
			_mouseMoveState = 0xFFFF; 
			MTo.validWalk.reset().endChange();
			MTo.validTrans.reset().endChange();
			MTo.validMapTo.reset().endChange();
			MTo.validChangeAct.reset().endChange();
		}

		private function checkSingleLeave(val:Validator) : Boolean {
			
			if( _feastAlert != null ){
				_feastAlert.hide() ;
				_feastAlert = null ;
			}
			
			StateManager.instance.checkMsg(28,null,onMsgChkOk,null);
			_tempValid = val ;
			return false;
		}
		
		private function checkMatchWalk(val:Validator):Boolean{
			StateManager.instance.checkMsg(27);
			return false ;
		}
		private function checkMatchLeave(val:Validator):Boolean{

			if( _feastAlert != null ){
				_feastAlert.hide() ;
				_feastAlert = null ;
			}

			StateManager.instance.checkMsg(29,[mateName],onMsgChkOk,[mateColor]);
			_tempValid = val ;
			return false;
		}
		
		private function onMsgChkOk( val:String ):Boolean{
			if( val == Alert.OK_EVENT || val == Alert.YES_EVENT ){
				if( _tempValid )
					_tempValid.go();
				_tempValid = null ;
			}
			return true ;
		}

//		private function updatePlayerAvatar(ps:PlayerStruct):void{
//			control.updateAvatar(ps.id);
//			if( PlayerModelUtil.isFeastMatch(ps.model) ){
//				playerMatch(ps);
//			}
//			else if( PlayerModelUtil.isFeastPartner(ps.model) ){
//				playerPartner(ps);
//			}
//			else{
//				if( ps.id == UserData.instance.playerId )
//					animalManger.selfPlayer.updateAvatar();
//				else
//					control.updateAvatar(ps.id);
//			}
//		}
		
		private function refreshUI():void{
			
			if( _feastStatus == 0 )
				return ;
			if( !_uisetup )
				return ;
			switch( _feastStatus ){
				case FEAST_ENTER:
					_startUI.show() ;
					_searchUI.hide() ;
					_matchUI.hide() ;
					break ;
				case FEAST_BEGIN:
					_startUI.hide() ;
					_searchUI.show() ;
					_matchUI.hide() ;
					break ;
				case FEAST_MATCH:
					_startUI.hide() ;
					_searchUI.hide() ;
					_matchUI.show() ;
					break ;
				default :
					;
			}
			_cancelUI.show() ;
			_timePanel.show() ;
		}
		
		
		public function get feastStatus():int
		{
			return _feastStatus ;
		}

		public function FeastController(single : Singleton)
		{
			single ;
			registFeastCall();
		}

		private function registFeastCall() : void {
			MPlayer.MODEL_FEAST_IN.add(onPlayerEnterModel);
			MPlayer.MODEL_FEAST_OUT.add(onPlayerLeaveModel);
			MPlayer.MODEL_FEAST_CHANGE.add(onPlayerChangeModel);
			MWorld.sInstallComplete.add(checkEnter);
		}
		
		private function onPlayerEnterModel(playerid:uint , model:uint):void{
			//
			Logger.info("ENTER MODEL"+ "playerid: " + playerid + "  model: " + model );
			
			if( playerid == UserData.instance.playerId && model == ModelId.FEAST_PARTNER ){
				model = MPlayer.getStruct(mateId).modelId;
			}
			else if( playerid == mateId && ModelId.isFeastMatch(model) ){
				model = ModelId.FEAST_PARTNER ;
			}
			
			_statusMap[playerid] = model ;
			var p:Player = MPlayer.getPlayer(playerid);
			if( ModelId.isFeastSingle(model) ){
				p.changeModel(model);
			}
			else if( ModelId.isFeastMatch(model) ){
				p.changeModel(model);
				p.setNameVisible(false);
				p.setShodowVisible(false);
				if(playerid == UserData.instance.playerId)
					p.uiAdd(_matePanel);
			}
			else if( ModelId.isFeastSingle(model) ){
				p.changeModel(model);
			}
			else if( ModelId.isFeastPartner(model) ){
				p.removeFromLayer();			
			}
			
			if( playerid == UserData.instance.playerId && !ModelId.isFeastSingle(model) ){
				playerMatchMouseMove();
			}
		}
		
		private function onPlayerLeaveModel(playerid:uint ):void{
			
			Logger.info("LEAVE MODEL"+ "playerid: " + playerid );
			var m:uint = _statusMap[playerid];
			var p:Player = MPlayer.getPlayer(playerid);
			
			if( ModelId.isFeastSingle(m) ){
				p.changeModel(0);
			}
			else if( ModelId.isFeastMatch(m) ){
				p.changeModel(0);
				p.setNameVisible(true);
			}
			else if( ModelId.isFeastPartner(m) ){
				p.addToLayer();
				p.changeModel(0);
				p.setNameVisible(true);
				p.setShodowVisible(true);
				if(playerid == UserData.instance.playerId)
					p.uiRemove(_matePanel);
			}
			
			if( playerid == UserData.instance.playerId ){
				playerLeaveMouseMove();
			}
			
			delete _statusMap[playerid] ;
		}
		
		private function onPlayerChangeModel( playerid:uint , model:uint ):void{
			
			Logger.info("CHANGE MODEL"+ "playerid: " + playerid );
			var prem:uint = _statusMap[playerid];
			var p:Player = MPlayer.getPlayer(playerid);

			Logger.info("CHANGE MODEL"+ "playerid: " + playerid + " fromMODEL:" + prem + " toMODEL:" + model );

			if( playerid == UserData.instance.playerId && model == ModelId.FEAST_PARTNER && MPlayer.getStruct(mateId) != null ){
				model = MPlayer.getStruct(mateId).modelId;
			}
			else if( playerid == mateId && ModelId.isFeastMatch(model) ){
				model = ModelId.FEAST_PARTNER ;
			}
			
			if( prem == model ){
				return ;
			}
			
			if( ModelId.isFeastPartner(prem) ){
				p.addToLayer();
			}
			else if( ModelId.isFeastMatch(prem) ){
				p.setNameVisible(true);
				p.setShodowVisible(true);
				if( playerid == UserData.instance.playerId )
					p.uiRemove(_matePanel);
			}
//			else if( playerid == UserData.instance.playerId ){
//				(p as SelfPlayer).walkStop() ;
//			}
			
			if( ModelId.isFeastSingle(model) ){
				p.changeModel(model);
			}
			else if ( ModelId.isFeastMatch(model) ){
				p.setNameVisible(false);
				p.changeModel(model);
				p.setShodowVisible(false);
				if(playerid == UserData.instance.playerId){
					p.uiAdd(_matePanel);
				}
			}
			else if( ModelId.isFeastPartner(model) ){
				p.removeFromLayer() ;
			}
			
			if( playerid == UserData.instance.playerId){
				if( ModelId.isFeastSingle(model) ){
					playerSingleMouseMove();
				}
				else{
					playerMatchMouseMove();
				}
			}
			_statusMap[playerid] = model ;
		}
		
//		private function setEnableWalk( value:Boolean ):void{
//			_walkEnabled = value ;
//			if( MWorld.isInstallComplete ){
//				MMouse.enableWalk = value ;
//			}
//		}

		
		public function set feastStatus( stat:int ):void
		{
			if( _feastStatus == stat )
				return ;

			if ( stat == FEAST_MATCH )
			{
				setMatchText();
			}
			
			if( !_setup ){
				_feastStatus = stat ;
				return ;
			}

			if( _feastStatus == FEAST_MATCH  )
			{
				// 之前的状态是配对中
				mateId = 0 ;
				mateName = null ;
				mateColor = 0 ;
			}

			
			_feastStatus = stat ;
			refreshUI();
		}
		
		public function set timeLeft(time:uint):void
		{
			_timeLeft = time  ;
			if( _timePanel )
				_timePanel.timeLeft = time ;
		}

		public function setFeastStatus(stat : uint, tim : uint = 0, timtotal : uint = 0) : void
		{
			selfAvatar = stat & 0xF ;
			var b1 : Buff = BuffStatusManager.instance.getBuff(200 + selfAvatar);
			var rep : Array = [["__EXP__", updBufferExp]];
			b1.extendReplace(rep);
			BuffStatusManager.instance.updateBuffTime(200 + selfAvatar, timtotal);

			if ( stat > 0x1F  )
			{
				BuffStatusManager.instance.updateBuffTime(210, tim);
			}
			else if ( _feastStatus == 4 && ( stat >> 4 ) != 2 )
			{
				BuffStatusManager.instance.updateBuffTime(210, 0);
				if ( MPlayer.getStruct(UserData.instance.playerId).modelId != 0 )
					StateManager.instance.checkMsg(26, [mateName]);
			}
			
			this.timeLeft = timtotal ;

			this.feastStatus = ( stat >> 4 ) + 2 ;

			if( !_uisetup )
				return  ;
				
			if( stat < 0x10 )
				_startUI.cooldown =  tim ;
			else if( stat > 0x1F )
				_matchUI.timeLeft =  tim ;
		}

		public function updBufferExp() : String
		{
			var exp : Number = ExperienceConfig.getPracticeExperience(UserData.instance.level) * 6 ;
			return exp.toString() ;
		}

		public function setMatchText() : void
		{
			_mateText.htmlText = "与" + StringUtils.addEvent(StringUtils.addLine(StringUtils.addColor(mateName, ColorUtils.TEXTCOLOR[mateColor])), "to") + "</a>" + "派对中....." ;
		}
		
//		private function get control():MapController
//		{
//			if ( _mapController == null )
//				_mapController = MapController.instance;
//			return _mapController;
//		}

		public static function get instance() : FeastController
		{
			if ( _instance == null )
				_instance = new FeastController(new Singleton());
			return _instance ;
		}

		private function initUI() : void {
			
			var startdata:GPanelData = new GPanelData();
			startdata.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER) ;
			_startUI = new UIFeastStart(startdata);
			_startUI.addEventListener(MouseEvent.CLICK, onClickQueue);
			
			var sdata:GPanelData = new GPanelData();
			sdata.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER) ;
			_searchUI = new UIFeastSearch(sdata);
			
			var pandata:GPanelData = new GPanelData();
			pandata.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER) ;
			_matchUI = new UIFeastMatch(pandata);

			//test ui ;
			_timePanel = new UIFeastTimerPanel();
			_timePanel.tabEnabled = false ;
			_timePanel.setParent(ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER));
//			
			_matePanel = new Sprite() ;
			_matePanel.mouseChildren = true ;
			_matePanel.mouseEnabled = false ;
			_mateText = UICreateUtils.createTextField( null,null,180,24,-90,-150,TextFormatUtils.contentCenter );
			_mateText.mouseEnabled = true ;
			_mateText.selectable = false ;
//			_mateText.width = 180 ;
//			var tf:TextFormat = new TextFormat() ;
//			tf.color = 0xFFFFFF ;
//			tf.size = 14 ;
//			tf.font = "黑体" ;
//			tf.align = TextFormatAlign.LEFT ;
//			_mateText.defaultTextFormat = tf ;
//			_mateText.selectable = false ;
			_mateText.addEventListener(TextEvent.LINK, onClickMate);
//			_mateText.antiAliasType = AntiAliasType.NORMAL ;
			_mateText.filters = UIManager.getEdgeFilters(0x111111, 0.8, 17);
			_matePanel.addChild(_mateText);
			
			var ktdata:KTButtonData = new KTButtonData(KTButtonData.EXIT_BUTTON) ;
			ktdata.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER) ;
			_cancelUI = new GButton(ktdata);
			_cancelUI.x = UIManager.stage.stageWidth - 90;
			_cancelUI.y = 20;
			_cancelUI.addEventListener(MouseEvent.CLICK, onClickLeave);
			
			_uisetup = true ;
			_timePanel.timeLeft = _timeLeft ;
			layout();
			refreshUI();
		}

		private function layout(s : Stage = null, w : Number = 0, h : Number = 0) : void
		{
			s;
			w;
			h;
//			if( _currentUI != null ){
//				UIUtil.alignStageHCenter(_currentUI);
//				_currentUI.y = 28.5 ;
//			}
			if( !_uisetup )
				return ;

			UIUtil.alignStageHCenter(_startUI);
			_startUI.y = 28.5 ;
			UIUtil.alignStageHCenter(_searchUI);
			_searchUI.y = 28.5 ;
			UIUtil.alignStageHCenter(_matchUI);
			_matchUI.y = 28.5 ;
			
			UIUtil.alignStageHCenter(_timePanel);
			_timePanel.y = 7.55 ;
			
			_cancelUI.x = UIManager.stage.stageWidth - 90 ;
			_cancelUI.y = 20 ;
		}

		public function openPathPass() : void
		{
			BarrierOpened.setState(FeastConfig.FEAST_AREA_COLOR, true);
		}

		public function feastBegin() : void
		{
		}

		public function feastEnd() : void
		{
		}

		private static var _instance : FeastController ;

		public function playerLeave(id : int) : void
		{
			/** 如果是自己就关闭面板 */
			if ( id == UserData.instance.playerId )
			{
				feastStatus = 0 ;

				BuffStatusManager.instance.updateBuffTime(200, 0);
				BuffStatusManager.instance.updateBuffTime(201, 0);
				BuffStatusManager.instance.updateBuffTime(202, 0);
				BuffStatusManager.instance.updateBuffTime(203, 0);
				BuffStatusManager.instance.updateBuffTime(204, 0);
				BuffStatusManager.instance.updateBuffTime(205, 0);

				BuffStatusManager.instance.updateBuffTime(210, 0);
				selfAvatar = 0xFFFF ;
			}
		}

		public function playerEnter(id : int) : void
		{
			/**如果是自己就打开面板*/
			if ( id == UserData.instance.playerId )
			{
				feastStatus = 2 ;
			}
		}

		public function onClickLeave(evt : Event = null) : void
		{
			if( _feastAlert != null ){
				_feastAlert.hide() ;
				_feastAlert = null ;
			}
			
			if ( _feastStatus == FEAST_MATCH )
				_feastAlert = StateManager.instance.checkMsg(29, [mateName], onAlert,[mateColor]);
			else
				_feastAlert = StateManager.instance.checkMsg(28, null, onAlert);
			_feastAlert.modal = true ;
			_feastAlert.show();
		}

		public function onAlert(evt : String) : Boolean
		{
			if ( evt == Alert.CANCEL_EVENT )
			{
				// var self:SelfPlayerStruct = currData.selfPlayerStruct ;
				// if( !checkArea( self.x , self.y ) )
				// {
				// self.x = _lx ;
				// self.y = _ly ;
				// control.transport(self);
				// }
			}
			else if ( evt == Alert.OK_EVENT )
			{
				FeastProto.instance.sendFeastLeave() ;
			}
			return true ;
		}

		public function onClickMate(evt : Event) : void
		{
			if ( mateId != 0 )
				PlayerTip.show(mateId, mateName);
		}

		public function onClickQueue(evt : Event) : void
		{
			if( _startUI.cooldown == 0 )
			{
				FeastProto.instance.sendFeastQueue();
			}
		}

		public function onClickText(evt : Event) : void
		{
			evt.stopPropagation();
		}

//		public function removeCouple(id : uint) : void
//		{
//			if ( _feastMap.hasOwnProperty(id) )
//			{
//				//
//				var anim : CoupleAnimal = _feastMap[id];
//				if ( anim.avatar.contains(_mateText) )
//					anim.avatar.removeChild(_mateText);
//				delete _feastMap[id];
//				animalManger.removeAnimal(anim.id, AnimalType.COUPLE);
//			}
//		}
	}
}
class Singleton
{
}