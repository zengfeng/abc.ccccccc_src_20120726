package game.module.notification
{
	import game.net.data.StoC.NotificationItem;

	/**
	 * @author yangyiqiang
	 */
	public class VoNotification
	{
		public var  value : NotificationItem;

		public function VoNotification(value : NotificationItem)
		{
			this.value = value;
		}

		// 唯一编号，取最近的不重复的时间戳
		public function get id() : int
		{
			return value ? value.id : -1;
		}
		
		public function get typeId() : int
		{
			return value ? value.typeId : -1;
		}
	}
}
