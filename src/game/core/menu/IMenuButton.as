package game.core.menu
{
	import gameui.core.GComponent;

	/**
	 * @author yangyiqiang
	 */
	public interface IMenuButton
	{
		function set vo(value : VoMenuButton) : void;

		function get vo() : VoMenuButton;

		function set target(value : GComponent) : void;

		function get target() : GComponent;
		
		function setClass(cl:Class):void;

		function addMenuMc(type : int = 1, text : String = "", x : int = 10, y : int = -26) : void;

		function removeMenuMc() : void;

		function showTargetView() :Boolean;

		function hideTargetView() : void;
	}
}
