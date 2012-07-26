package game.manager
{
	import net.AssetData;
	import com.greensock.loading.SWFLoader;
	import net.LibData;
	import net.RESManager;
	import game.config.StaticConfig;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;

	/**
	 * @author ZengFeng Email:zengfeng75[AT]163.com)  2011  2011-11-18 ����8:18:49
	 */
	public class MouseManager
	{
		/** 自动 */
		public static const AUTO : String = "auto";
		/** 指针 */
		public static const ARROW : String = "arrow";
		public static const BUTTON : String = "button";
		public static const HAND : String = "hand";
		public static const IBEAM : String = "ibeam";
		/** 对话 */
		public static const DIALO : String = "dialo";
		/** 警告 */
		public static const WARNING : String = "warning";
		/** 正确 */
		public static const CORRECT : String = "correct";
		/** 拾物品 */
		public static const PICK_UP : String = "pickUp";
		/** 战斗 */
		public static const BATTLE : String = "battle";
		/** 矿镐 */
		// TODO: 换成斧子
		public static const AXE : String = "pickUp";
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 地图鼠标点击特效 */
		public static var MapMouseDownEffect : Class;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 鼠标ICO资源文件路径 */
		public static var url : String = StaticConfig.cdnRoot + "assets/MouseIcon.swf";
		/** 地图 */
		public static var map : DisplayObject;

		public static function load() : void
		{
			var libData:LibData = new LibData(url, "mouseIcon");
			RESManager.instance.load(libData, loader_completeHandler);
		}


		private static function loader_completeHandler() : void
		{
			var vector : Vector.<BitmapData>;
			var mouseCursorData : MouseCursorData;
			var ICO : Class;
			// 地图鼠标点击特效
			MapMouseDownEffect = RESManager.getClass(new AssetData("ClickEffect", "mouseIcon"));
			// 指针,自动
			vector = new Vector.<BitmapData>();
			mouseCursorData = new MouseCursorData();
			ICO = RESManager.getClass(new AssetData("Default", "mouseIcon"));
			vector.push(new ICO());
			mouseCursorData.data = vector;
			Mouse.registerCursor(MouseManager.ARROW, mouseCursorData);
			Mouse.registerCursor(MouseManager.AUTO, mouseCursorData);
			// 对话
			vector = new Vector.<BitmapData>();
			mouseCursorData = new MouseCursorData();
			ICO = RESManager.getClass(new AssetData("dialog", "mouseIcon"));
			vector.push(new ICO());
			mouseCursorData.data = vector;
			Mouse.registerCursor(DIALO, mouseCursorData);
			// 警告
			vector = new Vector.<BitmapData>();
			mouseCursorData = new MouseCursorData();
			ICO = RESManager.getClass(new AssetData("Warning", "mouseIcon"));
			vector.push(new ICO());
			mouseCursorData.data = vector;
			Mouse.registerCursor(WARNING, mouseCursorData);
			// 正确
			vector = new Vector.<BitmapData>();
			mouseCursorData = new MouseCursorData();
			ICO = RESManager.getClass(new AssetData("Correct", "mouseIcon"));
			vector.push(new ICO());
			mouseCursorData.data = vector;
			Mouse.registerCursor(CORRECT, mouseCursorData);
			// 拾取
			vector = new Vector.<BitmapData>();
			mouseCursorData = new MouseCursorData();
			ICO = RESManager.getClass(new AssetData("pickUp", "mouseIcon"));
			vector.push(new ICO());
			mouseCursorData.data = vector;
			Mouse.registerCursor(PICK_UP, mouseCursorData);

			// 战斗
			vector = new Vector.<BitmapData>();
			mouseCursorData = new MouseCursorData();
			ICO = RESManager.getClass(new AssetData("mouseBattle", "mouseIcon"));
			vector.push(new ICO());
			mouseCursorData.data = vector;
			Mouse.registerCursor(BATTLE, mouseCursorData);
		
			cursor = ARROW;
			RESManager.instance.remove("mouseIcon");
		}

		public static function set cursor(str : String) : void
		{
			Mouse.cursor = str;
		}

		public static function get cursor() : String
		{
			return Mouse.cursor;
		}
	}
}
