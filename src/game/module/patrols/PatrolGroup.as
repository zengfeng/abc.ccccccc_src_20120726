package game.module.patrols
{
    import flash.geom.Point;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2011 2011-12-3 ����2:29:53
     */
    public class PatrolGroup extends EventDispatcher
    {
        public function PatrolGroup(manager:PatrolManager = null,id:uint = 0, name:String = "",target : IEventDispatcher = null)
        {
            this.manager = manager;
            this.id = id;
            this.name = name;
            super(target);
            if(this.manager) this.manager.addGroup(this);
        }
		
        /** 组ID */
        public var id:uint;
        /** 组名 */
        public var name:String;
        /** 巡逻管理 */
        public var manager:PatrolManager;
        /** 成员列表 */
        public var list:Vector.<Patrol> = new Vector.<Patrol>();
        /** 敌对组列表 */
        public var enemyGroupList:Vector.<PatrolGroup> = new Vector.<PatrolGroup>();
        
        /** 添加指定成员 */
        public function add(patrol : Patrol) : void {
            if(patrol == null)
            {
                //trace("提示: PatrolGroup(" + name + ") 在加入 Patrol 时出错");
                return;
            }
            else if(patrol.group && patrol.group != this)
            {
                patrol.group.remove(patrol);
                patrol.group = this;
            }
            
            var index:int = list.indexOf(patrol);
            if(index != -1) return;
            list.push(patrol);
        }
        
        /** 移除指定成员 */
        public function remove(patrol : Patrol):void
        {
            var index:int = list.indexOf(patrol);
            if(index != -1) list.splice(index, 1);
        }
        
        /** 添加敌对组 */
        public function addEnemGroup(enemyGroup:PatrolGroup):void
        {
            if(enemyGroup == null) return;
            if(enemyGroupList.indexOf(enemyGroup) == -1)
            {
                enemyGroupList.push(enemyGroup);
            }
        }
        
        /** 移除敌对组 */
        public function removeEnemGroup(enemyGroup:PatrolGroup):void
        {
            if(enemyGroup == null) return;
            if(enemyGroupList.indexOf(enemyGroup) != -1)
            {
                enemyGroupList.splice(enemyGroupList.indexOf(enemyGroup), 1);
            }
        }
        
        /** 移除所有敌对组 */
        public function removeALLEnemGroup():void
        {
            for(var i:int = 0; i < enemyGroupList.length; i ++)
            {
                removeEnemGroup(enemyGroupList[i]);
            }
        }
        
        /** 清空成员 */
        public function clear():void
        {
            for(var i:int = 0; i < list.length; i ++)
            {
                remove(list[i]);
            }
        }
        
        /** 开始 */
        public function start():void
        {
            for(var i:int = 0; i < list.length; i ++)
            {
                list[i].start();
            }
        }
        
        /** 停止 */
        public function stop():void
        {
            for(var i:int = 0; i < list.length; i ++)
            {
                list[i].stop();
            }
        }
        
        /** 退出 */
        public function quit():void
        {
            for(var i:int = 0; i < list.length; i ++)
            {
                removeALLEnemGroup();
                list[i].quit();
                if(manager) manager.removeGroup(this);
            }
        }
        
        /** 排序 */
        public function sort(target:Patrol):void
        {
			var sortFun:Function = function (a:Patrol, b:Patrol):Number
            {
                var distanceA:Number = Point.distance(a.origin, target.origin);
                var distanceB:Number = Point.distance(b.origin, target.origin);
                if(distanceA < distanceB)
                {
                    return -1;
                }
                else if(distanceA > distanceB)
                {
                    return 1;
                }
                return 0;
            };
            list.sort(sortFun);
        }
    }
}
