package com.utils
{
    import flash.geom.Point;
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-13 ����7:15:43
     */
    public class Ellipse
    {
        public var centerX : int = 0;
        public var centerY : int = 0;
        public var radiusX : int = 100;
        public var radiusY : int = 50;
        public var angle : Number = 0;
        public var drawSpeed : Number = 0.1;

        function Ellipse(radiusX : int = 100, radiusY : int = 50, centerX : int = 0, centerY : int = 0) : void
        {
            this.radiusX = radiusX;
            this.radiusY = radiusY;
            this.centerX = centerX;
            this.centerY = centerY;
        }

        /** 随机获得面积内的点 */
        public function getRandomAreaPoint() : Point
        {
            var point : Point = new Point();
            var angle : Number = Math.random() * 2 * Math.PI;
            var radiusX : Number = Math.random() * this.radiusX;
            var radiusY : Number = Math.random() * this.radiusY;
            point.x = centerX + Math.cos(angle) * radiusX;
            point.y = centerY + Math.sin(angle) * radiusY;
            return point;
        }
        
        /** 是否在区域内 */
        public function isInArea(x:int, y:int):Boolean
        {
            return x >= centerX - radiusX && x <= centerX + radiusX && y >= centerY - radiusY && y <= centerY + radiusY;
        }
    }
}
