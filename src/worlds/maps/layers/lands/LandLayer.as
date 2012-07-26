package worlds.maps.layers.lands
{
	import flash.display.Graphics;

	import log4a.Logger;


	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import worlds.maps.layers.lands.pools.BitmapPool;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-16
	 */
	public class LandLayer extends Sprite
	{
		/** 单例对像 */
		private static var _instance : LandLayer;

		/** 获取单例对像 */
		static public function get instance() : LandLayer
		{
			if (_instance == null)
			{
				_instance = new LandLayer(new Singleton());
			}
			return _instance;
		}

		// ===========
		// 配置
		// ===========
		/** 陆地块宽 */
		private var PIECE_WIDTH : int;
		/** 陆地块高 */
		private var PIECE_HEIGHT : int;
		// ===========
		// 网格区块Bitmap
		// ===========
		private var bitmapDic : Dictionary;
		private var bitmapList : Vector.<Bitmap>;
		private var bitmapPool : BitmapPool;
		private var blurLandBitmapData : BitmapData;
		// ===========
		// 地图宽高
		// ===========
		private var mapWidth : int;
		private var mapHeight : int;

		public function LandLayer(singleton : Singleton)
		{
			singleton;
		}

		public function init() : void
		{
			this.mouseChildren = false;
			this.mouseEnabled = true;
			PIECE_WIDTH = 256;
			PIECE_HEIGHT = 256;

			bitmapDic = new Dictionary(true);
			bitmapList = new Vector.<Bitmap>();
			bitmapPool = BitmapPool.instance;
		}

		/**  重设  */
		public function reset(mapWidth : int, mapHeight : int) : void
		{
			dispose();
			this.mapWidth = mapWidth;
			this.mapHeight = mapHeight;

			var x : int;
			var y : int;
			var countX : int = Math.ceil(mapWidth / PIECE_WIDTH);
			var countY : int = Math.ceil(mapHeight / PIECE_HEIGHT);
			var key : String;
			var bitmap : Bitmap;
			for (y = 0; y <= countY; y++)
			{
				for (x = 0; x <= countX; x++)
				{
					bitmap = bitmapPool.getObject();
					bitmap.x = x * PIECE_WIDTH;
					bitmap.y = y * PIECE_HEIGHT;
					addChild(bitmap);
					key = getPieceKey(x, y);
					bitmapDic[key] = bitmap;
				}
			}
		}

		/**  析构释放内存  */
		public function dispose() : void
		{
			cacheAsBitmap = false;
			if (blurLandBitmapData)
			{
				graphics.clear();
				blurLandBitmapData.dispose();
				blurLandBitmapData = null;
			}

			var keyArr : Array = [];
			var key : String;
			for (key in  bitmapDic)
			{
				keyArr.push(key);
			}
			var bitmap : Bitmap;
			while (keyArr.length > 0)
			{
				key = keyArr.shift();
				bitmap = bitmapDic[key];
				if (bitmap.bitmapData)
				{
					bitmap.bitmapData.dispose();
					bitmap.bitmapData = null;
				}
				bitmapPool.destoryObject(bitmap);
			}
		}

		// ========================
		// 绘制
		// ========================
		/** 绘制模糊陆地 */
		public function drawBlurLand(bitmapData : BitmapData) : void
		{
			blurLandBitmapData = bitmapData;
			var matrix : Matrix = new Matrix();
			matrix.a = mapWidth / bitmapData.width;
			matrix.d = mapHeight / bitmapData.height;
			var g : Graphics = graphics;
			g.clear();
			g.beginBitmapFill(bitmapData, matrix, false);
			g.drawRect(0, 0, mapWidth, mapHeight);
			g.endFill();
		}

		// ========================
		// 获取区块
		// ========================
		/** 用key 获取区块 */
		private function getBimapByKey(key : String) : Bitmap
		{
			return bitmapDic[key];
		}

		/** 用地图坐标 获取区块 */
		private function getPieceKey(pieceX : int, pieceY : int) : String
		{
			return  pieceY + "_" + pieceX;
		}

		// ========================
		// 绘制地图块
		// ========================
		/** 绘制高清陆地块 */
		public function drawPieceHD(pieceBitmapData : BitmapData, pieceX : int, pieceY : int) : void
		{
			if (!pieceBitmapData)
			{
				Logger.info("[Error] drawPieceHD pieceBitmapData=" + pieceBitmapData + " pieceX=" + pieceX + "  pieceY=" + pieceY);
				return;
			}
			var bitmap : Bitmap = getBimapByKey(getPieceKey(pieceX, pieceY));
			bitmap.bitmapData = pieceBitmapData;
		}
	}
}
class Singleton
{
}