package game.module.battle.view
{
	import game.core.item.prop.ItemProp;
	import game.module.artifact.ArtifactManage;
	
	import log4a.Level;
	

	public class BTArtifactData
	{
		private var allArtifactProps:ItemProp;
		
		private var allArtifactName:String;
		
		private var Level:uint = 0;
		
		public function BTArtifactData(level:uint, bufftype:uint):void //种类
		{
			if( level <= 0 || bufftype != 0)
			{
				Level = level;
				return;
			}
			Level = level;
			allArtifactProps = ArtifactManage.instance().getArtifactProps(level);
			allArtifactName = ArtifactManage.instance().getAllArtifactPropsName(level);
		}
		
		public function bHasArtifacts():Boolean
		{
			return (allArtifactProps != null);
		}
		
		public function getAllArtifactProps():ItemProp
		{
			return allArtifactProps;
		}

		public function getAllArtifactPropsName():String
		{
			return allArtifactName
		}
		
		public function getArtfactLevel():uint
		{
			return Level;
		}
	}
}