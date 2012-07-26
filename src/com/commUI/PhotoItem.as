package com.commUI
{
    import com.utils.Download;
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.Sprite;
    import game.config.StaticConfig;
    import gameui.core.GComponent;
    import gameui.core.GComponentData;
    import gameui.manager.UIManager;
    import net.AssetData;






    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011-11-2  ����3:05:34 
     * 玩家头像
     * @example 1
     * var imageItem:ImageItem = new ImageItem();
     * imageItem.file = "asset/1.jpg";
     * imageItem.load();
     * 
     * @example 2
     * var imageItem:ImageItem = new ImageItem();
     * var photo:Bitmap = ....;
     * imageItem.photo = photo;
     */
    public class PhotoItem extends GComponent
    {
        /** 背景 */
        protected var _backgroundSkin : DisplayObject;
        /** 边框 */
        protected var _borderSkin : DisplayObject;
        /** 容容 */
        protected var _container : Sprite = new Sprite();
        /** 图片 */
        protected var _photo : DisplayObject;
        /** 图片绝对地址 */
        protected var _url : String;
        /** 图片相对地址 */
        protected var _file : String;
        /** 边宽 */
        protected var _borderWidth : uint = 2;
        protected var loader : Loader;

        public function PhotoItem(width : uint = 60, height : uint = 45, photo : DisplayObject = null)
        {
            _photo = photo;
            var componentData : GComponentData = new GComponentData();
            componentData.width = width;
            componentData.height = height;
            super(componentData);
            initViews();
        }

        protected function initViews() : void
        {
            _backgroundSkin = UIManager.getUI(new AssetData("ItemBack"));
            _backgroundSkin.width = this.width;
            _backgroundSkin.height = this.height;
            //addChild(_backgroundSkin);
            addChild(_container);
            _borderSkin = UIManager.getUI(new AssetData("ItemBorder"));
            _borderSkin.width = this.width;
            _borderSkin.height = this.height;
            //addChild(_borderSkin);

            initPhtoto();
        }

        protected function initPhtoto() : void
        {
            for (var i : int = 0; i < _container.numChildren; i++)
            {
                var displayObject : DisplayObject = _container.getChildAt(i);
                _container.removeChild(displayObject);
            }

            if (_photo)
            {
                _photo.x = _photo.y = _borderWidth;
                _photo.width = this.width - _borderWidth * 2;
                _photo.height = this.height - _borderWidth * 2;
                _container.addChild(_photo);
            }
        }

        /** 图片 */
        public function get photo() : DisplayObject
        {
            return _photo;
        }

        public function set photo(photo : DisplayObject) : void
        {
            if (photo == null)
            {
                _photo = null;
                if (loader) Download.kill(loader);
                loader = null;
            }

            if (photo == null && _photo && _photo.parent)
            {
                _photo.visible = false;
                _photo.parent.removeChild(_photo);
            }
            _photo = photo;
            initPhtoto();
        }

        /** 图片绝对地址 */
        public function get url() : String
        {
            return _url;
        }

        public function set url(str : String) : void
        {
            _url = str;
            load();
        }

        /** 图片相对地址 */
        public function get file() : String
        {
            return _file;
        }

        public function set file(str : String) : void
        {
            _file = str;
            _url = StaticConfig.cdnRoot + str;
        }

        public function load() : void
        {
            if (_photo == null && _photo && _photo.parent) _photo.parent.removeChild(_photo);
            loader = Download.load(_url, loadCompleted, [Download.SELF]);
        }

        /** 加载完表情文件 */
        protected function loadCompleted(loader : Loader) : void
        {
            _photo = loader;
            initPhtoto();
        }
    }
}
