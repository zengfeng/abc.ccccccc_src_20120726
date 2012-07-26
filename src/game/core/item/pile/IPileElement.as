package game.core.item.pile
{
	/**
	 * @author jian
	 */
	public interface IPileElement extends ISelectable
	{
		function get group():IPileGroup;
	}
}
