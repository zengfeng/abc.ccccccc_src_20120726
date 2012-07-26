package com.debugTool
{
	import gameui.data.GPanelData;
	import gameui.containers.GPanel;
	import gameui.core.GComponentData;
	import game.module.battle.battleData.Data;
	import gameui.core.GComponent;
	/**
	 * @author 1
	 */
	public class DebugToolView extends GPanel
	{
		public function DebugToolView()
		{
			_data=new GPanelData();
			super(_data);
			
		}
	}
}
