package game.module.chatwhisper.icon
{
	import net.AssetData;
	import gameui.controls.GButton;
	import gameui.data.GButtonData;

	/**
	 * @author ME
	 */
	public class ChatWhisperIconButton extends GButton
	{
		// =====================
		// 单例
		// =====================
		private static var __instance : ChatWhisperIconButton;

		public static function get instance() : ChatWhisperIconButton
		{
			if (!__instance)
				__instance = new ChatWhisperIconButton(new GButtonData());

			return __instance;
		}

		public function ChatWhisperIconButton(data : GButtonData)
		{
			super(data);

			if (__instance)
				throw(Error("单例错误"));
		}
		
		// ======================================================
		// 方法
		// ======================================================
		 public function chatWhisperIconButton() : GButton
		 {
			var button : GButton;
			var buttonData : GButtonData = new GButtonData();
			buttonData.upAsset = new AssetData("ChatWhisperIconButton_Up");
			buttonData.overAsset = new AssetData("ChatWhisperIconButton_Over");
			buttonData.downAsset = new AssetData("ChatWhisperIconButton_Down");
			button = new GButton(buttonData);
			button.width = 35;
			button.height = 35;
			
			return button;
		 }
	}
}
