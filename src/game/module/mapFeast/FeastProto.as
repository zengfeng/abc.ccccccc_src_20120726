package game.module.mapFeast
{
	import game.net.core.Common;
	import game.net.data.CtoS.CSFeastEnter;
	import game.net.data.CtoS.CSFeastLeave;
	import game.net.data.CtoS.CSFeastQueue;
	import game.net.data.StoC.SCFeastFinish;
	import game.net.data.StoC.SCFeastStart;
	import game.net.data.StoC.SCFeastStatus;
	/**
	 * @author 1
	 */
	public class FeastProto {
		
		private static var _instance:FeastProto ; 
		
		public static function get instance():FeastProto{
			
			if( _instance == null )
				_instance = new FeastProto(new Singleton());
			return _instance ;
		}
		
		public function FeastProto( single:Singleton ){
			sToC() ;
			single ;
		}
		
		public function sToC():void{
			Common.game_server.addCallback(0x302, onFeastStart);
			Common.game_server.addCallback(0x303, onFeastFinish);
			Common.game_server.addCallback(0x301, onFeastStatus);
		}
		
		public function onFeastStart( msg:SCFeastStart ):void
		{
			msg ;
			FeastController.instance.feastBegin();
		}
		
		public function onFeastFinish( msg:SCFeastFinish):void
		{
			msg ;
			FeastController.instance.feastEnd();
		}
		
		public function onFeastStatus( msg:SCFeastStatus ):void
		{
			
			if( msg.hasName )
				FeastController.instance.mateName = msg.name ;
			
			if( msg.hasColor )
				FeastController.instance.mateColor = msg.color ;
				
			if( msg.hasId )
				FeastController.instance.mateId = msg.id ;
						
			FeastController.instance.setFeastStatus( msg.status&0xFF , (msg.status>>8)&0xFFF , msg.status >> 20 );
					
		}
		
		public function sendFeastEnter():void
		{
			var msg:CSFeastEnter = new CSFeastEnter();
			Common.game_server.sendMessage(0x300, msg);
		}
		
		public function sendFeastQueue():void
		{
			var msg:CSFeastQueue = new CSFeastQueue();
			Common.game_server.sendMessage(0x301, msg);
		}
		
		public function sendFeastLeave():void
		{
			var msg:CSFeastLeave = new CSFeastLeave();
			Common.game_server.sendMessage(0x302, msg);
		}		
	}
}

class Singleton{
}
