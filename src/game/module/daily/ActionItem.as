package game.module.daily {
	import gameui.controls.GImage;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.RESManager;

	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	/**
	 * @author yangyiqiang
	 */
	public class ActionItem extends GComponent
	{
		private var _vo : VoAction;

		public function ActionItem(vo : VoAction)
		{
			_base = new GComponentData();
			_vo = vo;
			if (_vo.isToday)
			{
				_base.width = 170;
				_base.height = 100;
			}
			else
			{
				_base.width = 520;
				_base.height = 100;
			}
			super(base);
		}

		private var _back : Sprite;

		private var _img : GImage;

		override protected function create() : void
		{
			var data:GImageData=new GImageData();
			if (_vo.isToday)
			{
				addLable();
				data.x=20;
				data.y=10;
				data.iocData.align=new GAlign();
				_img = new GImage(data);
				_img.url = _vo.getBigIcoUrl();
				addChild(_img);
			}
			else
			{
				_back = UIManager.getUI(new AssetData("common_background_11"));
				_back.width = 170;
				_back.height = 100;
				addChild(_back);
				addLable();
				data.iocData.align=new GAlign();
				_img = new GImage(data);
				_img.url = _vo.getIcoUrl();
				_img.x = 5;
				_img.y = 31;
				addChild(_img);
				var mc3 : MovieClip = RESManager.getMC(new AssetData("topGoldLine"));
				mc3.width=160;
				mc3.x = 5;
				mc3.y = 27;
				addChild(mc3);
			}
		}

		private var _name : TextField;

		private var _name2 : TextField;

		public var _description : TextField ;

		private function addLable() : void
		{
			if (_vo.isToday)
			{
				_name = UICreateUtils.createTextField(null, StringUtils.addBold(_vo.getName()), 170, 25, 110, 14, UIManager.getTextFormat(14));
				_name2 = UICreateUtils.createTextField(null, DailyManage.WEEKDAY[_vo.id], 170, 25, 110, 36, UIManager.getTextFormat());
				_description = UICreateUtils.createTextField(_vo.description, null, 344, 81, 110, 56, UIManager.getTextFormat(12, 0x695939));
				addChild(_name2);
			}
			else
			{
				_name = UICreateUtils.createTextField(null, StringUtils.addBold(_vo.getName()), 170, 25, 0, 5, UIManager.getTextFormat(12, 0x2f1f00, TextFormatAlign.CENTER));
				_description = UICreateUtils.createTextField(_vo.description, null, 112, 50, 55, 29, UIManager.getTextFormat(12, 0x695939));
			}
			addChild(_name);
			addChild(_description);
		}
	}
}
