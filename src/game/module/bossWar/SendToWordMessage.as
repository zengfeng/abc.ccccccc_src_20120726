package game.module.bossWar {
	/**
	 * @author Lv
	 */
	public class SendToWordMessage {
		
		private static var _instance:SendToWordMessage;
		
		public function SendToWordMessage(mess:message):void{}
		
		public static function get instance():SendToWordMessage
		{
			if(_instance == null)
			{
				_instance = new SendToWordMessage(new message());
			}
			
			return _instance;
		}
		
		/**
		 * boss诞生 消息
		 */
		public function bossBirthMessage():void{
			
		}
		/**
		 * boss血量 消耗到50%时 消息
		 */
		public function bossBloodHalfMessage():void{
			
		}
		/**
		 * boss未被击退  消息
		 */
		public function bossNotRepelMessage():void{
			
		}
		/**
		 * boss血量在 80-30%内  消息
		 */
		 public function bossBloodMessage():void{
			
		 }
	}
}
class message{}
