package game.module.riding
{
	import game.core.avatar.AvatarFight;
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarType;
	import game.definition.UI;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	/**
	 * @author zhengyuang
	 */
	 	 
	public class RidingDescriptionPanel extends GComponent
	{
		// =====================
		// 定义
		// =====================
		
		// =====================
		// 属性
		// =====================
		private var _appearPlaceTF:TextField;
		private var _rarityTF:TextField;
		private var _getTypeTF:TextField;
		private var _descriptionTF:TextField;
		
		private var _apContentTF:TextField;
		private var _rContentTF:TextField;
		private var _gtContentTF:TextField;
		private var _desContentTF:TextField;
		
		// =====================
		// Getter/Setter
		// =====================
			
		
		// =====================
		// 方法
		// =====================
		
		
		public function RidingDescriptionPanel()
		{
			var data : GComponentData = new GComponentData();
			data.width = 500;
			data.height = 70;
			super(data);
		}
		
		protected override function create():void
		{
			addBg();
			addMountMovieClip();
			addMountTextFields();
		}
		
		private function addBg() : void 
		{
			var componentBg:Sprite=UIManager.getUI(new AssetData(UI.COMMON_BACKGROUND03));
			componentBg.x=0;
			componentBg.y=0;
			componentBg.width=500;
			componentBg.height=300;
			addChild(componentBg);
		}

		private function addMountTextFields() : void
		{
			_appearPlaceTF=UICreateUtils.createTextField("出现地点", null, 100, 25, 20, 180, UIManager.getTextFormat(12, 0xff2f1f00, TextFormatAlign.CENTER));
			addChild(_appearPlaceTF);
			_rarityTF=UICreateUtils.createTextField("稀有程度", null, 100, 25, 20, 210, UIManager.getTextFormat(12, 0xff2f1f00, TextFormatAlign.CENTER));
			addChild(_rarityTF);
			_getTypeTF=UICreateUtils.createTextField("获得方式", null, 100, 25, 20, 240, UIManager.getTextFormat(12, 0xff2f1f00, TextFormatAlign.CENTER));
			addChild(_getTypeTF);
			_descriptionTF=UICreateUtils.createTextField("描述", null, 100, 25, 20, 270, UIManager.getTextFormat(12, 0xff2f1f00, TextFormatAlign.CENTER));
	        addChild(_descriptionTF);		
			
			_apContentTF=UICreateUtils.createTextField("", null, 180, 25, 120, 180, UIManager.getTextFormat(12, 0xff2f1f00, TextFormatAlign.CENTER));
			addChild(_apContentTF);
			_rContentTF=UICreateUtils.createTextField("", null, 180, 25, 120, 210, UIManager.getTextFormat(12, 0xff2f1f00, TextFormatAlign.CENTER));
			addChild(_rContentTF);
			_gtContentTF=UICreateUtils.createTextField("", null, 180, 25, 120, 240, UIManager.getTextFormat(12, 0xff2f1f00, TextFormatAlign.CENTER));
			addChild(_gtContentTF);
			_desContentTF=UICreateUtils.createTextField("", null, 180, 25, 120, 270, UIManager.getTextFormat(12, 0xff2f1f00, TextFormatAlign.CENTER));
	        addChild(_desContentTF);	
			
		}

		private function addMountMovieClip() : void
		{
			
		}
		
		// ------------------------------------------------
		// 更新
		// ------------------------------------------------		
	    private var _player : AvatarFight;
		public function updateDescription(vo:RidingVO):void
		{
			_rContentTF.text=vo.mountRarity;
			_gtContentTF.text=vo.mountGetType;
			_desContentTF.text=vo.mountDescription;
			
			if (!_player)
			{
				_player = new AvatarFight();
				_player.x = 120;
				_player.y = 140;
				addChild(_player);
			}
				_player.initAvatar(vo.mountID, AvatarType.PLAYER_BATT_FRONT);
				_player.showNameAndHPbar(false);
				_player.setAction(AvatarManager.MAGIC_ATTACK);
				
		}
		
		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		
		
		// -------------------------------------------------
		// 其他
		// -------------------------------------------------		
	}
}
