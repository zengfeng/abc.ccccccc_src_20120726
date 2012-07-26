package com.commUI {
	import flash.events.MouseEvent;
	import com.commUI.button.KTButtonData;
	import gameui.controls.GButton;
	import game.manager.ViewManager;

	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;

	import com.utils.UIUtil;

	import flash.display.Stage;
	/**
	 * @author zhangzheng
	 */
	
	public class BossWarUI extends GComponent{

		private var _headpanel:BossHeadPanel ;
		private var _damagePanel:BossDamagePanel ;
		private static var _instance:BossWarUI ;
		private var _initialize:Boolean = false ;
		private var _setup:Boolean = false ;
		private var _exitBtn:GButton ;
		public var exitCall:Function ;
	
		public static function get instance():BossWarUI{
			if( _instance == null )
				_instance = new BossWarUI(new singleton());
			return _instance ;
		}
		
		public function BossWarUI(s:singleton){
			s;
			var data:GComponentData = new GComponentData() ;
			data.align = new GAlign(0,0,0,0);
			data.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
			super(data);
		}
		
		public function setup():void{
			if( !_initialize ){
				initUI();
			}
			if( !_setup ){
				show();
				ViewManager.addStageResizeCallFun(onStageResize);
				_setup = true ;
				onStageResize();
			}
		}

		private function onStageResize(s:Stage = null , w:Number = 0 , h:Number = 0) : void {
			_exitBtn.x = UIManager.stage.stageWidth - 90;
			_damagePanel.x = UIManager.stage.stageWidth - _damagePanel.width ;
			UIUtil.alignStageHCenter(_headpanel);
		}
		
		public function unsetup():void{
			if( _setup ){
				clearup() ;
				hide() ;
				ViewManager.removeStageResizeCallFun(onStageResize);
				_setup = false ;				
			}
		}

		private function clearup() : void {
			_damagePanel.clearup();
		}

		private function initUI() : void {
			
			_initialize = true ;
			var cdata:GComponentData = new GComponentData() ;
			_headpanel = new BossHeadPanel(cdata) ;
			_headpanel.x = 342.5 ;
			addChild(_headpanel);
			
			var pdata:GPanelData = new GPanelData();
			_damagePanel = new BossDamagePanel(pdata);
			_damagePanel.y = 342 ;
			addChild(_damagePanel);
			
			var ktbdata:KTButtonData = new KTButtonData(KTButtonData.EXIT_BUTTON);
			_exitBtn = new GButton(ktbdata);
			_exitBtn.x = UIManager.stage.stageWidth - 90;
			_exitBtn.y = 20;
			_exitBtn.addEventListener(MouseEvent.CLICK, onExitCall);
			addChild(_exitBtn);

		}

		private function onExitCall(event : MouseEvent) : void {
			if( exitCall != null )
				exitCall.apply();
		}
		

		
		public function set damageList( arr:Vector.<Object> ):void{
			_damagePanel.damageList = arr ;
		}
		
		public function setSelfdamage( damage:int , total:int ):void{
			_damagePanel.setSelfdamage(damage, Number(damage)*100/total);
		}
		
		public function setboss( id:int , level:int ):void{
			_headpanel.setboss(id, level);
		}
		
		public function bosshp( current : int , total : int  ):void{
			_headpanel.bosshp(current, total);
		}
		
		public function set timeLeft( i:int ):void{
			_headpanel.timeLeft = i ;
		}
		
		public function damage( i:int ):void{
			_headpanel.damage(i);
		}
	}
		
}
import com.utils.ColorUtils;
import game.config.StaticConfig;
import game.definition.UI;
import game.manager.RSSManager;
import game.manager.VersionManager;
import game.module.battle.view.BattleNumber;

import gameui.containers.GPanel;
import gameui.controls.GImage;
import gameui.controls.GProgressBar;
import gameui.core.GComponent;
import gameui.core.GComponentData;
import gameui.data.GPanelData;
import gameui.data.GProgressBarData;
import gameui.manager.UIManager;

import net.AssetData;
import net.LibData;
import net.RESManager;

import com.greensock.TweenLite;
import com.utils.FilterUtils;
import com.utils.StringUtils;
import com.utils.TextFormatUtils;
import com.utils.TimeUtil;
import com.utils.UICreateUtils;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

class singleton{
}

class BossHeadPanel extends GComponent {
	
	private var _nameLabel:TextField ;
	private var _levelLabel:TextField ;
	private var _timeLabel:TextField ;
	private var _hpbar:GProgressBar ;
	private var _hplabel:TextField ;
	private var _bossimg:GImage ;
	private var _damagefont : Vector.<Bitmap> ;	
	
	public function BossHeadPanel(cdata : GComponentData) {
		cdata.width = 564 ;
		cdata.height = 91 ;
		super(cdata);
		initView();
		RESManager.instance.load(new LibData(StaticConfig.cdnRoot + "assets/ui/numberTest.swf", "bossNum"), onLoadNumber);
	}
	
	public function damage(i:int):void{
		if( _damagefont != null && i > 0 ){
			var bx:int = 0;
			var by:int = 0;
	        var numBitmap:BattleNumber = new BattleNumber();
	        numBitmap.initNumbers(_damagefont, Math.abs(i), 0,4);
			numBitmap.toNumber();
			numBitmap.visible = true;
			numBitmap.scaleX = 0.5;
			numBitmap.scaleY = 0.5;
			numBitmap.alpha = 0.3;
	        addChild(numBitmap);
	        numBitmap.x = 435;
	        numBitmap.y = 40;
	            
	        bx = numBitmap.x;
			by = numBitmap.y;
			TweenLite.to(numBitmap,2,{delay:0, scaleX:1, scaleY:1,y:by-38, alpha:1, overwrite:0});
			TweenLite.to(numBitmap,1,{delay:1	,scaleX:1.1, scaleY:1.1, alpha:0,y:by-45, onComplete:function(tf : BattleNumber):void{removeChild(tf);}, onCompleteParams:[numBitmap], overwrite:0});
		}
	}

	private function onLoadNumber() : void
    {
		_damagefont = new Vector.<Bitmap>();
        for(var  i:int = 0; i < 12; i++ )
		{
			if(i == 0)
				_damagefont[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_Hurt_a", "bossNum")));
			else if(i == 1)
				_damagefont[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_Hurt_b", "bossNum")));
			else 
				_damagefont[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_Hurt_" + (i-2).toString(), "bossNum")));
		}
    }
	private function initView() : void {
		
		var bg:Sprite = UICreateUtils.createSprite(UI.BACKGROUND_ROUND_50,533,64,31,14);
		addChild(bg);
		
		var bardata:GProgressBarData = new GProgressBarData();
		bardata.trackAsset = new AssetData("BossBloodPro_bg");
		bardata.barAsset = new AssetData("BossBloodPro_HP");
		bardata.height=19.85;
		bardata.width=463.1;
		bardata.x = 85;
		bardata.y = 35.3;
		bardata.paddingX = 2;
		bardata.paddingY = 1;
		bardata.padding = 17;		
		_hpbar = new GProgressBar(bardata);
		addChild(_hpbar);

		bg = UICreateUtils.createSprite(UI.COMPETE_USERHEADBG,92,92);
		addChild(bg);
				
		_bossimg = UICreateUtils.createGImage(null,121,175,-6,-91);
		addChild(_bossimg);
		
		var namefmt:TextFormat = new TextFormat() ;
		namefmt.color = 0xFFFFFF ;
		namefmt.font = UIManager.defaultFont ;
		namefmt.size = 18 ;
		_nameLabel = UICreateUtils.createTextField( null,null,150,28,93,14,namefmt );
		addChild(_nameLabel);
		
		var levelfmt:TextFormat = new TextFormat() ;
		levelfmt.color = 0xFFFFFF ;
		levelfmt.font = UIManager.defaultFont ;
		levelfmt.size = 14 ;
		
		_levelLabel = UICreateUtils.createTextField( null,null, 66,20,261,16,levelfmt );
		addChild(_levelLabel);
		
		_timeLabel = UICreateUtils.createTextField( "剩余时间",null, 120,22,(564-120)/2,58, TextFormatUtils.contentCenter );
		addChild(_timeLabel);
		
		_hplabel = UICreateUtils.createTextField( "/" , null , 140,20,(564-140)/2,37,TextFormatUtils.contentCenter );
		_hplabel.filters = [FilterUtils.defaultTextEdgeFilter];
		addChild(_hplabel);
	}
	
	internal function setboss( id:int , level:int ):void{
		_nameLabel.text = RSSManager.getInstance().getNpcById(id).name ;
		_levelLabel.text = level > 0 ? level.toString() + "转" : "" ;
		var str:String = VersionManager.instance.getUrl( "assets/ico/BossHeadIcon/" + id.toString() + ".png" );
		_bossimg.url = str;
	}
	
	internal function bosshp( current : int , total : int  ):void{
		_hplabel.text = current.toString() + "/" + total.toString() ;
		_hpbar.value = total == 0 ? 100 : current / total * 100 ;
	}
	
	internal function set timeLeft( i:int ):void{
		_timeLabel.text = "剩余时间  " + TimeUtil.toMMSS( i );
	}
}

class BossDamagePanel extends GPanel {
	
	private var _damagePlayer:Vector.<TextField> ;
	private var _damageValue:Vector.<TextField> ;
	private var _selfDamage:TextField ;
	private const PAGE_SIZE:int = 5;
	
	public function BossDamagePanel(pdata : GPanelData) {
		pdata.width = 220 ;
		pdata.height = 140 ;
		pdata.bgAsset = new AssetData(UI.BACKGROUND_ROUND_50);
		super(pdata);
		
		initView();
	}
	
	private function initView():void{
		
		var line:Sprite = UICreateUtils.createSprite(UI.DIVIDE_LINE_GOLD,220,1,0,27);
		addChild(line);
		
		line = UICreateUtils.createSprite(UI.DIVIDE_LINE_GOLD,220,1,0,118);
		addChild(line);
		
		var title:TextField = UICreateUtils.createTextField("伤害列表",null,80,24,70,5,TextFormatUtils.bossDamageTitle);
		title.filters = [FilterUtils.bossDamageTextFilter] ;
		addChild(title);
		
		_damagePlayer = new Vector.<TextField>();
		_damageValue = new Vector.<TextField>();
		for ( var i:int = 0 ; i < PAGE_SIZE ; ++ i ){
			var txt:TextField = UICreateUtils.createTextField(null,null,124,20,8,30+i*17,TextFormatUtils.bossDamageContent);
			txt.filters = [FilterUtils.bossDamageTextFilter] ;
			addChild(txt);
			_damagePlayer.push(txt);
			txt = UICreateUtils.createTextField(null,null,56,20,152,30+i*17,TextFormatUtils.bossDamageContentRight);
			addChild(txt);
			_damageValue.push(txt);
		}
		
		_selfDamage = UICreateUtils.createTextField("我的伤害:",null,186,22,34,120,TextFormatUtils.bossDamageSelf);
		_selfDamage.filters = [FilterUtils.bossDamageTextFilter];
		addChild(_selfDamage);
	}
	
	internal function set damageList( arr:Vector.<Object> ):void{
		for ( var i:int = 0 ; i < PAGE_SIZE ; ++ i ){
			if( i < arr.length ){
				if( arr[i].damage == 0 )
					break ;
				_damagePlayer[i].htmlText = (i+1).toString() +  ".  " + arr[i].name ;
				_damageValue[i].text = StringUtils.numToString(arr[i].rate) + "%"; 
			}
		}
	}
	
	internal function setSelfdamage( abs:int , rate:Number ):void{
		_selfDamage.text = "我的伤害: "+ abs.toString() + " (" + StringUtils.numToString(rate) + "%)" ;
	}

	public function clearup() : void {
		for ( var i:int = 0 ; i < PAGE_SIZE ; ++ i ){
			_damagePlayer[i].text = "" ;
			_damageValue[i].text = "" ; 
		}
	}
	
}
