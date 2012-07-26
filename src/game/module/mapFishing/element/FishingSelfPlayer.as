package game.module.mapFishing.element
{
	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-15 ����5:56:52
	 */
	public class FishingSelfPlayer extends FishingPlayer
	{
		override protected function onStand() : Boolean
		{
			return false;
		}
	}
}
