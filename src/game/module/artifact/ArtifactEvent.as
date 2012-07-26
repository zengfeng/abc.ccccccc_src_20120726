package game.module.artifact
{
	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class ArtifactEvent extends Event
	{
		public static const ARTIFACT_CLICK : String = "artifactClick";

		private var _data : Object;

		public function ArtifactEvent(type : String, data : Object)
		{
			super(type, true, false);
			_data = data;
		}

		public function get data() : Object
		{
			return _data;
		}

		override public function clone() : Event
		{
			return new ArtifactEvent(type, data);
		}
	}
}
