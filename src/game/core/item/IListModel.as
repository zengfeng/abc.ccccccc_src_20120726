package game.core.item
{
	/**
	 * @author jian
	 */
	public interface IListModel
	{
		function add (item:Object):void;
		function setAt (index:int, item:Object):void;
		function getAt (index:int):Object;
		function removeAt (index:int):void;
	}
}
