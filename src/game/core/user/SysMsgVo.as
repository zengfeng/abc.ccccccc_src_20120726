package game.core.user {
	import game.manager.ViewManager;
	import game.module.chat.ManagerChat;
	import game.module.chat.marquee.MarqueeManager;
	import game.module.settings.SettingData;

	import com.commUI.ScrollMessage;
	import com.commUI.alert.Alert;
	import com.utils.RegExpUtils;

	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class SysMsgVo {
		public var id : int;
		/**
		 * 第16位表示弹框
		 *     弹框类型的对应（单选）和第16位组合
		 *     第1位表示错误浮动框
		 *     第2位表示玩家身上滚动内容
		 *     第3位表示只有<确定>按钮的框
		 *     第4位表示有<确定>、<取消>按钮的框
		 *     第5位表示有<确定>、<取消>、勾选（下次不再提示）的框
		 * 
		 * 第17位表示在聊天频道中显示
		 * 
		 * 第18位表示弹框大滚屏中显示
		 * 
		 * 第19位表示弹框跑马灯中显示
		 */
		public var type : int;
		public var text : String;

		public function prase(xml : XML) : void {
			if (xml.@id == undefined) return;
			id = xml.@id;
			type = xml.@type;
			text = xml.children();
			if (text == "") text = xml.@text;
		}

		/**
		 * type = 0 则用sysmsg 里面的type运行
		 * 其它用传过来的类型滚
		 * <msg id="154" type="147456" name="MSG_154" text="消耗xx1元宝" description="通用-消耗元宝"/>
		<msg id="155" type="147456" name="MSG_155" text="消耗xx1绑元宝" description="通用-消耗绑元宝"/>
		<msg id="156" type="147456" name="MSG_156" text="消耗xx1银币" description="通用-消耗银币"/>
		<msg id="157" type="147456" name="MSG_157" text="消耗xx1修为" description="通用-消耗修为"/>
		<msg id="158" type="147456" name="MSG_158" text="获得xx1经验" description="通用-获得经验（大滚屏）"/>
		<msg id="159" type="147456" name="MSG_159" text="获得xx1元宝" description="通用-获得元宝（大滚屏）"/>
		<msg id="160" type="147456" name="MSG_160" text="获得xx1绑元宝" description="通用-获得绑元宝（大滚屏）"/>
		<msg id="161" type="135170" name="MSG_161" text="获得xx1银币" description="通用-获得银币（身上）"/>
		<msg id="162" type="147456" name="MSG_162" text="获得xx1修为" description="通用-获得修为（大滚屏）"/>
		 */
		public function runMsg(arg : *=null, yesFun : Function = null, arg2 : *=null, type : uint = 0,text:String=null) : Alert {
			var msg : String ;
			if(text!=null){
				msg=text;
			}else{
				msg=RegExpUtils.getRegExpContent(this.text, arg, arg2);
			}
			var alert : Alert;
			if (type == 0) type = this.type;
			if ((type & 0x1000) == 0x1000) {
				var num : int = type & 0xFFF;
				switch(num) {
					case 1:
						ScrollMessage.instance.soroll(msg);
						break;
					case 2:
						ScrollMessage.instance.sorollOnMyAvatar(msg);
						break;
					case 4:
						alert = Alert.show(msg, "", Alert.OK);
						break;
					case 8:
						alert = Alert.show(msg, "", Alert.OK | Alert.CANCEL, yesFun);
						break;
					case 16:
						// 带确定，取消，勾选
						if (SettingData.getDataById(id) && yesFun != null)
							yesFun(Alert.OK_EVENT);
						else {
							alert = Alert.show(msg, "", Alert.OK | Alert.CANCEL, yesFun, Alert.RADIO);
							alert.addEventListener(Alert.CLOSE_EVENT, onClose);
						}
						break;
				}
			}
			// 聊天提示
			if ((type & 0x2000) == 0x2000) {
				ManagerChat.instance.prompt(msg, true);
			}
			// 大滚屏
			if ((type & 0x4000) == 0x4000) {
				ViewManager.instance.rollMessage(msg);
			}
			// 跑马灯
			if ((type & 0x8000) == 0x8000) {
				MarqueeManager.instance.showMarquee(msg);
			}
			// 在mouse坐标 滚屏
			if ((type & 0x10000) == 0x10000) {
				ScrollMessage.instance.sorollMssage(msg);
			}
			// 聊天系统
			if ((type & 0x20000) == 0x20000) {
				ManagerChat.instance.system(msg, true);
			}
			// 在身上滚
			if ((type & 0x40000) == 0x40000) {
				ScrollMessage.instance.sorollOnMyAvatar(msg);
			}
			// 聊天系统通告
			if ((type & 0x40000) == 0x40000) {
				ManagerChat.instance.system(msg);
			}
			// 聊天家族
			if ((type & 0x80000) == 0x80000) {
				ManagerChat.instance.system(msg);
			}
			return alert;
		}

		private function onClose(event : Event) : void {
			(event.target as Alert).removeEventListener(Alert.CLOSE_EVENT, onClose);
			SettingData.setDataById(id, (event.target as Alert).selected);
		}
	}
}