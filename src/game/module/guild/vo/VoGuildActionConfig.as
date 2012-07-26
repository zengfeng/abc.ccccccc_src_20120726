package game.module.guild.vo {
	/**
	 * @author zhangzheng
	 */
	public class VoGuildActionConfig {

		public var actId:uint ;
		public var actlvl:uint ;
		public var title:String ;
		public var reward:String ;
		public var intro:String ;
		public var openlvl:uint ; 	//开启等级
		public var paneltype:uint ;
		public var shortcutmap:Number ;
		public var shortcutx:Number ;
		public var shortcuty:Number ;
		public var beginstamp:Number ;
		public var begintime:String ;
		public function parse( obj:Object ):void
		{
			actId = obj[0];
			actlvl = obj[1];
			title = obj[2] ;
			reward = obj[3] ;
			intro = obj[4];
			openlvl = obj[5];
			paneltype = obj[6]=="" ? actId : obj[6];
			if( obj[11] )
			{
				var strtime:Array = (obj[11] as String ).split(":");
				var hour:int = int(strtime[0]) ;
				var min:int = int(strtime[1]);
				beginstamp = hour*3600000+min*60000 ;
				begintime = obj[11];
			}
			shortcutmap = obj[12];
			if( obj[13] != "" )
			{
				if(obj[13] == null)return;
				var strpos:Array = (obj[13] as String ).split(",");
				shortcutx = int(strpos[0]);
				shortcuty = int(strpos[1]);
			}
		}
	}
}
