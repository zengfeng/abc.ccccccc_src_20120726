package game.module.patrols
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

    /**
     * @author ZengFeng Email:zengfeng75[AT]163.com)  2011  2011-12-1 ����7:22:27
     * 巡逻者
     */
    public class Patrol extends EventDispatcher
    {
        public function Patrol(target : IEventDispatcher = null)
        {
            super(target);
        }

        /** 是否自动 */
        public var isAuto : Boolean = true;
        /** 原点 */
        public var origin : Point = new Point();
        /** 随机移动点 */
        public var standPoint : Vector.<Point> = new Vector.<Point>();
        /** 移动范围 */
        public var moveRadius : uint;
        /** 攻击范围 */
        public var attackRadius : uint;
        /** 当前位置 */
        private var _position : Point = new Point();
        /** 要移动到的位置 */
        public var moveTo : Point = new Point();
        /** 状态 */
        private var _status : uint = PatrolStatus.STAND;
        /** 阵营 */
        public var group : PatrolGroup;
        /** 敌方目标 */
        public var enemy : Patrol;
        /** 绑定对像 */
        // public var avatar : IPatrolAvatar;
        /** 站立概率 */
        private var standProbability : Number = 0.5;
        /** 最长睡眠时间 */
        private var maxSleepTime : uint = 6000;
        /** 最短睡眠时间 */
        private var minSleepTime : uint = 300;
        /** 睡眠时间 */
        private var sleepTime : Number;
        /** 上次运行时间 */
        private var preTime : Number;
        /** 回调函数 */
        protected var callFuns : Vector.<Function> = new Vector.<Function>();
        /** 检测敌人率 */
        private var checkEnemyRate : int = 1;
        private var frame : int = 0;
        /** 追踪敌人率 */
        private var trackEnemyRate : int = 1;
        /** 绑定对像 */
        public var bindObj : *;
        /** 获取随机走路时遍历了的次数 */
        protected var randomMoveToRunTime:int = 0;
        /** 是否是BOSS */
        public var isBoss:Boolean = false;

        /** 开始 */
        public function start() : void
        {
            status = PatrolStatus.STAND;
            enemy = null;
            sleepTime = minSleepTime + Math.round(Math.random() * 10) / 10 * maxSleepTime;
            preTime = new Date().time + Math.round(Math.random() * 1000);

            if (isAuto == false)
            {
                _position = origin;
            }
            else if (isAuto == true && _position == null)
            {
                _position = new Point(origin.x, origin.y);
            }

            runing();
        }

        /** 运行中 */
        public function runing() : void
        {
            if (isAuto == false) return;

            if (status == PatrolStatus.STOP || status == PatrolStatus.QUIT || status == PatrolStatus.BATTLE || status == PatrolStatus.DIE)
            {
                return;
            }
            else if (status == PatrolStatus.TRACK)
            {
                track();
                return;
            }

            // 检查自己范围是否有敌方阵营的人
            var enemy : Patrol = checkEnemy();
            if (enemy)
            {
                this.enemy = enemy;
                track();
                return;
            }
            
            if(isBoss == true)
            {
                return;
            }
            
            frame = 0;

            var nowTime : Number = new Date().time;
            if (nowTime - preTime < sleepTime)
            {
                return;
            }
            
            preTime = nowTime;
            sleepTime = minSleepTime + Math.round(Math.random() * 10) / 10 * maxSleepTime;

            var _status : int = Math.random() < standProbability ? PatrolStatus.STAND : PatrolStatus.MOVE;
            if (_status == PatrolStatus.MOVE)
            {
                randomMoveToRunTime = 0;
                moveTo = randomMoveTo();
            }

            status = _status;
        }

        /** 停止 */
        public function stop() : void
        {
            status = PatrolStatus.STOP;
        }

        /** 退出 */
        public function quit() : void
        {
            // if (isAuto == false) return;
            if (group) group.remove(this);
            status = PatrolStatus.QUIT;
            clearCallFun();
            // if (avatar && avatar.parent) avatar.parent.removeChild(avatar as DisplayObject);
            // avatar = null;
            enemy = null;
        }

        /** 死亡 */
        public function die() : void
        {
            if (group) group.remove(this);
            status = PatrolStatus.DIE;
            enemy = null;
        }

        /** 当前位置 */
        public function get position() : Point
        {
            return _position;
        }

        public function set position(postion : Point) : void
        {
            if (postion && (_position == null || _position.equals(postion) == false))
            {
                _position.x = postion.x;
                _position.y = postion.y;
                if (isAuto == false) origin = _position;
            }
        }

        public function set position2(postion : Point) : void
        {
            if (postion && (_position == null || _position.equals(postion) == false))
            {
                _position.x = postion.x;
                _position.y = postion.y;
                if (isAuto == false) origin = _position;
                if (status == PatrolStatus.STOP) return;
                frame++;
                if (frame % checkEnemyRate != 0)
                {
                    return;
                }

                if (status == PatrolStatus.TRACK && frame % trackEnemyRate == 0)
                {
                    // //trace("trackEnemyFrame = " + frame);
                    track();
                }
                else if (frame % checkEnemyRate == 0)
                {
                    // //trace("checkEnemyFrame = " + frame);
                    // 检查自己范围是否有敌方阵营的人
                    var enemy : Patrol = checkEnemy();
                    if (enemy)
                    {
                        this.enemy = enemy;
                        moveTo = enemy.position;
                        status = PatrolStatus.TRACK;
                    }

                    if (this.enemy && isAuto == false)
                    {
                        this.enemy.enemy = this;
                        this.enemy.moveTo = this.position;
                        //trace("手动引发" + this.enemy.toString() + "追踪");
                        this.enemy.status = PatrolStatus.TRACK;
                        this.enemy.track();
                    }
                }
            }
        }

        /** 状态 */
        public function get status() : uint
        {
            return _status;
        }

        public function set status(status : uint) : void
        {
            if (_status != status || _status == PatrolStatus.TRACK || _status == PatrolStatus.MOVE)
            {
                _status = status;
                if (status == PatrolStatus.BATTLE)
                {
                    if (enemy) enemy.status = PatrolStatus.BATTLE;
                    //trace("开始战斗........");
                }

                if (status == PatrolStatus.BATTLE && group.enemyGroupList.length <= 0)
                {
                    //trace("坑爹呀");
                }
                // var event : Event = new Event(Event.CHANGE, true);
                // dispatchEvent(event);
                // if (avatar) avatar.patrolCall(status);
                runCallFuns();
            }
        }

        /** 追踪 */
        private function track() : void
        {
            // 如果找到在敌人，并且敌人没有挂掉或在战斗
            if (enemy && enemy.status != PatrolStatus.BATTLE && enemy.status != PatrolStatus.QUIT && enemy.status != PatrolStatus.DIE)
            {
                // 如果在攻击范围
                var distance : uint = Math.round(Point.distance(enemy.position, position));
                if (distance <= attackRadius)
                {
                    status = PatrolStatus.BATTLE;
                    return;
                }

                // 如果跟丢了
                distance = Math.round(Point.distance(enemy.position, origin));
//                //trace("追 distance" + distance + "moveRadius "  + moveRadius + "origin " + origin + "enemy.position " + enemy.position );
                if (distance > moveRadius)
                {
                    // 走回原点
                    moveToOrigin();
                    return;
                }

                if (isAuto == true)
                {
                    moveTo.x = enemy.position.x;
                    moveTo.y = enemy.position.y;
                    status = PatrolStatus.TRACK;
                }
            }
            else
            {
                // 走回原点
                moveToOrigin();
            }
        }

        /** 走回原点 */
        public function moveToOrigin() : void
        {
            enemy = null;
            moveTo.x = origin.x;
            moveTo.y = origin.y;
            status = PatrolStatus.MOVE;
        }

        /** 检查自己范围是否有敌方阵营的人 */
        private function checkEnemy() : Patrol
        {
            // 如果已经找到敌人
            if (this.enemy != null || group == null) return null;

            var enemy : Patrol;
            var patrol : Patrol;

            for (var i : int = 0; i < group.enemyGroupList.length; i++)
            {
                for (var j : int = 0; j < group.enemyGroupList[i].list.length; j++)
                {
                    patrol = group.enemyGroupList[i].list[j];
                    if (patrol.enemy && patrol.enemy == this) return patrol;

                    if (patrol.status == PatrolStatus.BATTLE || patrol.status == PatrolStatus.QUIT || patrol.status == PatrolStatus.STOP || patrol.status == PatrolStatus.DIE) continue;
                    // if (patrol.enemy != null || patrol.status == PatrolStatus.QUIT || patrol.status == PatrolStatus.STOP) continue;
                    var originDistance : uint = Math.round(Point.distance(patrol.position, origin));
                    var postionDistance : uint = Math.round(Point.distance(patrol.position, position));
                     if (originDistance <= moveRadius || postionDistance <= moveRadius)
//                    if (originDistance <= moveRadius)
                    {
                        enemy = patrol;
                        break;
                    }
                    else if (originDistance > moveRadius)
                    {
                        break;
                    }
                }

                if (enemy) break;
            }
            return enemy;
        }

        /** 随机要移动到的点 */
        private function randomMoveTo() : Point
        {
            if (standPoint == null || standPoint.length == 0) return moveTo;
            var index : uint = Math.round(Math.random() * (standPoint.length - 1));
            var point : Point = standPoint[index];
            randomMoveToRunTime ++;
            if (point.equals(moveTo) == true && randomMoveToRunTime < 5)
            {
                return randomMoveTo();
            }
            return point;
        }

        /** 随机要移动到的点 */
        private function randomMoveTo2() : Point
        {
            var point : Point = new Point();
            var angle : uint = Math.round(Math.random() * 360);
            var distance : uint = Math.round(Math.random() * moveRadius);
            point.x = Math.floor(Math.cos(angle * Math.PI / 180) * distance);
            point.y = Math.floor(Math.sin(angle * Math.PI / 180) * distance);
            point.x += origin.x;
            point.y += origin.y;
            return point;
        }

        /** 移动到 */
        public function setMoveTo(moveTo : Point) : void
        {
            this.moveTo = moveTo;
            status = PatrolStatus.MOVE;
        }

        /** 加入回调函数 */
        public function addCallFun(fun : Function) : void
        {
            if (callFuns.indexOf(fun) == -1) callFuns.push(fun);
        }

        /** 移除回调函数 */
        public function removeCallFun(fun : Function) : void
        {
            if (callFuns.indexOf(fun) != -1) callFuns.splice(callFuns.indexOf(fun), 1);
        }

        /** 清空回调函数 */
        public function clearCallFun() : void
        {
            while (callFuns.length > 0)
            {
                callFuns.shift();
            }
        }

        /** 运行回调函数 */
        public function runCallFuns() : void
        {
            for (var i : int = 0; i < callFuns.length; i++)
            {
                callFuns[i](this);
            }
        }

        override public function toString() : String
        {
            return "Patrol{}";
        }
    }
}
