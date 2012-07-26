package game.module.guild.vo {
	import flash.utils.Dictionary;
	/**
	 * @author 1
	 */
	public class VoGuildAction {
		
		private static const STATE_MASK:Array = [0,0,3,3,0];
		private static const STATE_BIT:Array = [0,0,0,2,0];
		private static const CONFIG_MASK:Array = [0,0,63,0,0] ;
		private static const CONFIG_BIT:Array = [0,0,0,0,0] ;
		private static const REMAIN_MASK:Array = [0,0,1,1,0] ;
		private static const REMAIN_BIT:Array = [0,0,0,1,0] ;
		private static const PER_REMAIN_BIT:Array = [0,4,2,6,0];
		private static const PER_REMAIN_MASK:Array = [3,3,3,3,0];
		public static var actioncfgdic:Dictionary = new Dictionary();
		public static var actioncfgarr:Array = new Array();
		
		public static function parseGuildActionConfig( arr:Array ):void{
			for each ( var obj:Object in arr )
			{
				var cfg:VoGuildActionConfig = new VoGuildActionConfig() ;
				cfg.parse( obj );
				if( actioncfgdic.hasOwnProperty(cfg.actId) )
					( actioncfgdic[ cfg.actId ] as Vector.<VoGuildActionConfig> ).push( cfg );
				else {
					actioncfgdic[cfg.actId] = new Vector.<VoGuildActionConfig>() ;
					( actioncfgdic[ cfg.actId ] as Vector.<VoGuildActionConfig> ).push( cfg );
					actioncfgarr.push(actioncfgdic[cfg.actId]);
				}
			}
		}
		
		public var actId:uint ;
		public var personalremain:uint ;	//个人剩余次数
		public var guildremain:uint ; //家族剩余次数
		public var config:uint ;
		public var state:uint ;			// 0:not start 1:prepare 2:begin 3:end ;
		
		private var _vo : VoGuildActionConfig ;
		private var _glvl:int ;
		
		public function update( glvl:int ):void{
			if( glvl == _glvl || volist == null )
				return ;
			_glvl = glvl ;
			for( var i:int = 0 ; i < volist.length ; ++ i ){
				if( volist[i].openlvl > glvl )
				{
					_vo = volist[ i == 0 ? 0 : i - 1 ];
					return ;
				}
			}
			_vo = volist[ volist.length - 1 ];
		
		}
		
		public function VoGuildAction( i:int , l:int ){
			actId = i ;
			update( l );
		}
		
		public function get volist():Vector.<VoGuildActionConfig>{
			return actioncfgdic[actId];
		}
		
		public function get title():String{
			return _vo == null ? "" : _vo.title ;
		}
		
		public function get reward():String{
			return _vo == null ? "" : _vo.reward ;
		}
		
		public function get intro():String{
			return _vo == null ? "" : _vo.intro ;
		}
		
		public function get openlvl():int{
			return _vo == null ? 0 : _vo.openlvl ;
		}
		
		public function get paneltype():int{
			return _vo == null ? 0 : _vo.paneltype ;
		}
		
		public function get beginstamp():Number{
			return _vo == null ? 0 : _vo.beginstamp ;
		}
		public function get begintime():String {
			return _vo == null ? "" : _vo.begintime ;
		}
		public function get shortcutmap():Number{
			return _vo == null ? 0 : _vo.shortcutmap ;
		}
		public function get shortcutx():Number {
			return _vo == null ? 0 : _vo.shortcutx ;
		}
		public function get shortcuty():Number {
			return _vo == null ? 0 : _vo.shortcuty ;
		}
		
		public function setRemain(i:int):void{
			guildremain = ( i >> REMAIN_BIT[actId] ) & REMAIN_MASK[actId];
		}
		
		public function setConfig(i:int):void{
			config = ( i >> CONFIG_BIT[actId] ) & CONFIG_MASK[actId];
		}
		
		public function setState(i:int):void{
			state = (i >> STATE_BIT[actId]) & STATE_MASK[actId];
		}
		
		public function setPersonalRemain(i:int):void{
			personalremain = (i >> PER_REMAIN_BIT[actId]) & PER_REMAIN_MASK[actId];
		}
	}
}
