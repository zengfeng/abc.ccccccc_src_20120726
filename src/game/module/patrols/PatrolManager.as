package game.module.patrols
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2011 2011-12-3 ����2:29:53
     */
    public class PatrolManager extends EventDispatcher
    {
        public function PatrolManager(target : IEventDispatcher = null)
        {
            super(target);
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        public var timer : Timer = new Timer(100);
        public var groupDic : Dictionary = new Dictionary();
        public var otherGroupDic : Dictionary = new Dictionary();

        /** 添加巡逻者 */
        public function addPatrol(patrol : Patrol) : void
        {
            if (patrol == null)
            {
                //trace("提示:PatrolManager.addPatrol(patrol);时patrol为空");
                return;
            }
            else if (patrol.group == null)
            {
                var group : PatrolGroup = new PatrolGroup();
                group.id = autoCreateGroupId();
                group.name = group.id.toString();
                patrol.group = group;
                addGroup(group);
            }
            patrol.group.add(patrol);
        }

        /** 移除巡逻者 */
        public function removePatrol(patrol : Patrol) : void
        {
            patrol.group.remove(patrol);
        }

        /** 添加组 */
        public function addGroup(group : PatrolGroup) : void
        {
            if(group.id <= 0)
            {
                group.id = autoCreateGroupId();
            }
            
            if (groupDic[group.id] != null) return;
            group.manager = this;
            groupDic[group.id] = group;
            addOtherGroups(group);
        }

        /** 移除组 */
        public function removeGroup(group : PatrolGroup) : void
        {
            if (group == null) return;
            group.stop();
            group.manager = null;
            if (groupDic[group.id]) delete group[group.id];
        }

        /** 加入其他阵营的敌对列表 */
        public function addOtherGroups(group : PatrolGroup) : void
        {
            if (group == null) return;
            for each (var enemyGroup:PatrolGroup in groupDic)
            {
                if (enemyGroup != group)
                {
                    enemyGroup.addEnemGroup(group);
                    group.addEnemGroup(enemyGroup);
                }
            }
        }

        /** 移除其他阵营的敌对列表 */
        public function removeOtherGroups(group : PatrolGroup) : void
        {
            if (group == null) return;
            for each (var enemyGroup:PatrolGroup in groupDic)
            {
                if (enemyGroup != group)
                {
                    enemyGroup.removeEnemGroup(group);
                }
            }
        }

        /** 清理 */
        public function clear() : void
        {
            for each (var group:PatrolGroup in groupDic)
            {
                group.clear();
                removeGroup(group);
            }
        }
        
        private var _autoCreateLastGroupId:uint = 10000;

        /** 自动生成组ID */
        public function autoCreateGroupId() : uint
        {
            return _autoCreateLastGroupId++;
        }

        /** 开始运行 */
        public function start() : void
        {
            for each (var group:PatrolGroup in groupDic)
            {
                group.start();
            }

            timer.addEventListener(TimerEvent.TIMER, runing);
            timer.start();
        }

        /** 停止 */
        public function stop() : void
        {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER, runing);

            for each (var group:PatrolGroup in groupDic)
            {
                group.stop();
            }
        }

        /** 退出 */
        public function quit() : void
        {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER, runing);
            for each (var group:PatrolGroup in groupDic)
            {
                group.quit();
            }
        }

        /** 运行中 */
        private function runing(event : TimerEvent) : void
        {
            for each (var group:PatrolGroup in groupDic)
            {
                for (var i : int = 0; i < group.list.length; i++)
                {
                    group.list[i].runing();
                }
            }
        }
    }
}
