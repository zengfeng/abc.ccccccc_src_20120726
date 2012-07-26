package game.module.soul.abyss
{
	import com.commUI.icon.ItemIcon;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import game.core.item.Item;
	import game.core.item.soul.Soul;
	import game.module.soul.soulBD.SoulBD;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;




	/**
	 * @author jian
	 */
	public class AwardIcon extends GComponent
	{
		public var arrived : Boolean = false;
		public var looting : Boolean = false;
		public var lastClickTime : int = 0;
		private var _icon : Sprite;
		private var _item : Item;
		private var _index : int; 

		public function AwardIcon(item : Item, index : int)
		{
			_item = item;
			_index = index;
			var data : GComponentData = new GComponentData();
			data.width = 50;
			data.height = 50;
			super(data);
		}

		public function set showName(value : Boolean) : void
		{
			if (_icon is SoulBD)
				(_icon as SoulBD).showName = value;
		}

		public function set showRollOver(value : Boolean) : void
		{
			if (_icon is SoulBD)
				(_icon as SoulBD).showRollOver = value;
			else
				(_icon as ItemIcon).showRollOver = value;
		}

		public function get index() : uint
		{
			return _index;
		}

		override public function get source() : *
		{
			return _item;
		}

		override protected function create() : void
		{
			if (_item is Soul)
			{
				var bd : SoulBD = new SoulBD();
				bd.source = _item as Soul;
				bd.x = 24;
				bd.y = 20;
				_icon = bd;
			}
			else if (_item)
			{
				var icon : ItemIcon = UICreateUtils.createItemIcon({x:0, y:0, showNums:true, showBorder:false, showBg:false, showRollOver:true, showToolTip:true});
				icon.source = _item;
				_icon = icon;
			}
			addChild(_icon);
		}

		public function destroy() : void
		{
			if (parent)
				parent.removeChild(this);
				
			if (_icon is SoulBD)
				(_icon as SoulBD).clear();

			if (_icon && _icon.parent)
				_icon.parent.removeChild(_icon);
		}
	}
}
