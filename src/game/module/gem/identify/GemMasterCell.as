package game.module.gem.identify
{
	import game.definition.UI;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.text.TextField;









	/**
	 * @author jian
	 */
	public class GemMasterCell extends GComponent
	{
		// =====================
		// @属性
		// =====================
		private var _icon:Sprite;
		private var _name:TextField;
		private var _bg:Sprite;
		private var _master:GemMasterVO;
		
		// =====================
		// @方法
		// =====================
		public function GemMasterCell(master:GemMasterVO)
		{
			_master = master;
			
			var data:GComponentData = new GComponentData();
			data.width = 66;
			data.height = 85;
			super(data);
			
			_bg = UIManager.getUI(new AssetData(UI.GEM_MASTER_ICON_BG));
			_bg.width = 66;
			_bg.height = 85;
			_bg.visible = false;
			addChild(_bg);
			
			_icon = UIManager.getUI(master.iconAsset);
			_icon.x = 5;
			_icon.y = 11;
							
//			DecoratorManager.instance.registerDecorator(_icon, TristateDecorator);
			addChild(_icon);
			
			_name = UICreateUtils.createTextField(null, StringUtils.addColorById(master.name, master.color), 66, 16, 0, 66, TextFormatUtils.panelContent);
			_name.width = 66;
			_name.height = 16;
			addChild(_name);
		}
		
		public function set selected(value:Boolean):void
		{
			_bg.visible = value;
		}
		
		public function get master():GemMasterVO
		{
			return _master;
		}
	}
}
