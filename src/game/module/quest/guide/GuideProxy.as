package game.module.quest.guide {
	import game.core.user.UserData;
	import game.net.core.Common;
	import game.net.data.CtoS.CSGuideUpdate;
	import game.net.data.StoC.SCGuideUpdate;

	/**
	 * @author yangyiqiang
	 */
	public class GuideProxy
	{
		private static var _instance : GuideProxy;
		
		
		public function GuideProxy(){
			init();
		}

		public static function getInstance() : GuideProxy
		{
			if (_instance == null)
			{
				_instance = new GuideProxy();
			}
			return _instance;
		}

		public function init() : void
		{
			Common.game_server.addCallback(0x12, scGuideUpdate);
		}
		
		private function getMask(step:uint):uint
		{
			return 1<<((step%32)-1);
		}
		
		/*
		 * 0 表示没完成    1 表示完成
		 * false 没完成    true  完成
		 */
		public function isFinish(step:uint):Boolean
		{
			if(step>100)return false;
			return (getMask(step)&UserData.instance.guideSteps[int(step/32)])>0;
		}

		/**
		 * 更新新手步骤 c--->s
		 */
		public function guideUpdate(step : uint) : void
		{
			var cmd : CSGuideUpdate = new CSGuideUpdate();
			cmd.step = step;
			Common.game_server.sendMessage(0x12, cmd);
		}

		/**
		 * 更新新手步骤 s--->c
		 */
		private function scGuideUpdate(msg : SCGuideUpdate) : void
		{
			UserData.instance.guideSteps[uint(msg.newStep/32)]=UserData.instance.guideSteps[uint(msg.newStep/32)]|getMask(msg.newStep);
			if(msg.newStep<21)return;
			GuideMange.getInstance().checkGuideByMenuid(GuideMange.getInstance().getVo(msg.newStep).targetId);
		}
	}
}
