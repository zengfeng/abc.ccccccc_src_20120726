package game.module.battle.view
{
	import gameui.controls.GImage;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;
	import gameui.manager.UIManager;

	import com.utils.UICreateUtils;

	import flash.text.TextField;

	public class BTArtifactBuff extends GComponent
	{
		private var img:GImage;
		private var artifactNumTxt:TextField;
		public function BTArtifactBuff()
		{
			_base = new GComponentData();
			_base.width = 25;
			_base.height = 25;
			super(_base);
		}
	
		/** 初始化视图 */
		public function initViews(url:String, artifactLvl:uint, bufftype:uint) : void
		{
			var imageData : GImageData = new GImageData();
			imageData.width = 25;
			imageData.height = 25;
			img = new GImage(imageData);
			img.url = url;
			addChild(img);
			
			if(bufftype == 0)
			{
				var artifactNumStr:String = uint((artifactLvl+1)/2).toString();
				artifactNumTxt = UICreateUtils.createTextField(artifactNumStr, null, 30, 15, 4, 12, UIManager.getTextFormat(12,0xFFFF00, "center"));
				addChild(artifactNumTxt);
			}
		}
		
		/** TIP */
		public function set tip(value : String) : void
		{
			toolTip.source = value;
		}

	}
}