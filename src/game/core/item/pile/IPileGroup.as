package game.core.item.pile
{
	/**
	 * @author jian
	 */
	public interface IPileGroup extends ISelectable
	{
		function get elements ():Array /* of IPileElement */;
	}
}
