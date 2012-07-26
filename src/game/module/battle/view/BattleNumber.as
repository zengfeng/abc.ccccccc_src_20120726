package game.module.battle.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BattleNumber extends Bitmap
	{
		private var _pWidth:int;  //宽度
		private var _pHeight:int; //高度
		private var _pW:uint;          //单个数字的宽度
		private var _pH:uint;          //单个数字的高度
		private var _numberBmp:Bitmap;
		private var _Num:uint;
		private var _flag:int;    //0:带符号负数 1:带符号正数, 2:不带符号的数
		private var _imageVec:Vector.<Bitmap>;
		private var _type:uint;  //0一张大图，1多张小图
		private var sidePixel:Number;
		
		public function BattleNumber()
		{
			super();
		}
		
		//切分好的小图
		//资源，去除符号后的数字，符号（flag：0或者1）， 间隔的像素（需自己调整）
		public function initNumbers(numVec:Vector.<Bitmap>, num:uint, flag:int, mpixel:Number = 3):void
		{
			if(numVec.length < 0)
			{
				//trace("numMap 数字图片加载错误！！！");
				return;
			}	
			_Num = num;
			_flag = flag;
			_imageVec = numVec;
			_type = 1;
			sidePixel = mpixel;
		}
		
		// 一张png大图
		public function initNumber(numMap:Bitmap, num:uint, flag:int, w:uint, h:uint):void  //flg ：0
		{
			if(numMap)
			{
			   //trace("numMap 数字图片加载错误！！！");
			   return;	  
			}
				
			var i:int = 0;
			var column:int = 0;
			var row:int = 0;
			var rect:Rectangle;
			var singlNumImgBmpData:BitmapData;
			var singleNumImage:Bitmap;
			_type = 0;
			
			_pW = w;
			_pH = h;
			_Num = num;
			_numberBmp = numMap;
			_flag = flag;
			if(_flag == 2)
				_pWidth = _pW * (_Num.toString().length + 1);   //带一个符号
			else
				_pWidth = _pW * (_Num.toString().length + 1);   //带一个符号
			_pHeight = _pH;
			
			for( i = 0; i < 12; i++)
			{
				rect = new Rectangle(column*_pW,row*_pH,_pW,_pH);
				singlNumImgBmpData = new BitmapData(_pW,_pH);
				singlNumImgBmpData.copyPixels(this._numberBmp.bitmapData,rect,new Point(0, 0));
				singleNumImage = new Bitmap(singlNumImgBmpData);
				this._imageVec[i] = singleNumImage;
				if( (column+1)*_pW < this._numberBmp.width )
				{
					column++;
				}
				else
				{
					column = 0;
					row++;
				}        
			}
		}
		
		public function toNumber():void
		{
			var i:int = 0;
			var bmp:Bitmap;
			var pt:Point;
			var str:String;
			var len:int = _Num.toString().length+1;
			var tempWidth:uint = 0;
			var m_height:uint = 0;
			if(this._imageVec == null || this._imageVec.length == 0)
				return;
			if(_type == 0)
			{
				this.bitmapData = new BitmapData(_pW*len, _pH,true,0);
			}
			else
			{
				var m_width:Number = 0;
				for( i = 0; i < len; i++)
				{
					if(i == 0)
					{
						m_height = this._imageVec[0].height;
						if(_flag == 0)
						{
							m_width += this._imageVec[1].width-sidePixel;
						}
						else
						{
							m_width += this._imageVec[0].width-sidePixel;
						}
					}
					else
					{
						str = _Num.toString().charAt(i-1);
						if(int(str) == 1)
							m_width += this._imageVec[int(str)+2].width-sidePixel-4;
						else
							m_width += this._imageVec[int(str)+2].width-sidePixel;
					}
				}
				this.bitmapData = new BitmapData(m_width, m_height,true,0);
				this.width = m_width;
				this.height = _pH;
			}
				
			//this.dspContainer.bitmapData = bmpData;
			for( i = 0; i < len; i++)
			{
				if( i == 0)  //符号位
				{
					if(_flag==2)continue;
					if(_flag == 0) //负数
						bmp = this._imageVec[1];
					else
						bmp = this._imageVec[0];
				}
				else
				{
					str = _Num.toString().charAt(i-1);
					bmp = this._imageVec[int(str)+2];
				}
				
				pt = new Point(tempWidth,0);
				this.bitmapData.copyPixels(bmp.bitmapData,bmp.bitmapData.rect,pt);
				if(int(str) == 1)
					tempWidth += bmp.width-sidePixel-4;
				else
					tempWidth += bmp.width-sidePixel;
				
			}
			this.height = m_height;
			this.smoothing = true;
		}
	}
}
