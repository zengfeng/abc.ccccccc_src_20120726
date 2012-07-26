package com.utils.dataStruct
{
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-17 ����3:07:58
     * 双向非循环链表
     */
    public class LinkList
    {
        public var headNode : LinkNode;
        protected var lastNode : LinkNode;
        protected var _length : uint;

        function LinkList() : void
        {
        }

        /** 添加 */
        public function addNode(node : LinkNode, index : int = -1) : void
        {
            if (node == null) return;
            if (index > length)
            {
                throw new Error("LinkList::addNode 参数出错(index 大于 length)");
                return;
            }

            if (headNode == null)
            {
                headNode = node;
                lastNode = node;
                node.preNode = null;
                node.nextNode = null;
                _length++;
                return;
            }

            var preNode : LinkNode;
            var nextNode : LinkNode;
            if (index == 0)
            {
                preNode = null;
                nextNode = headNode;
                headNode = node;
            }
            else if (index == -1 || index == length)
            {
                preNode = lastNode;
                nextNode = null;
                lastNode = node;
            }
            else
            {
                preNode = getNodeByIndex(index - 1);
                nextNode = preNode.nextNode;
            }

            if (preNode != null)
            {
                preNode.nextNode = node;
            }
            node.preNode = preNode;
            node.nextNode = nextNode;
            if (nextNode != null && nextNode != headNode)
            {
                nextNode.preNode = node;
            }
            _length++;
        }

        /** 移除 */
        public function removeNode(node : LinkNode) : void
        {
            if(node.nextNode == null && node.preNode == null && headNode != node) return;
            if (node == null) return;
            var preNode : LinkNode;
            var nextNode : LinkNode;

            if (length == 1)
            {
                headNode = null;
                lastNode = null;
                _length--;
                return;
            }

            if (node == headNode)
            {
                preNode = null;
                nextNode = node.nextNode;
                headNode = nextNode;
            }
            else if (node == lastNode)
            {
                preNode = node.preNode;
                nextNode = null;
                lastNode = preNode;
            }
            else
            {
                preNode = node.preNode;
                nextNode = node.nextNode;
            }

            if (preNode != null) preNode.nextNode = nextNode;
            if (nextNode != null) nextNode.preNode = preNode;
            _length--;
        }

        /** 移除根据索引 */
        public function removeNodeByIndex(index : int) : void
        {
            var node : LinkNode = getNodeByIndex(index);
            removeNode(node);
        }

        /** 获取节点根据索引 */
        public function getNodeByIndex(index : int) : LinkNode
        {
            if (index >= length) return null;
            var i : int = 0;
            var node : LinkNode = headNode;
            while (node.nextNode != null)
            {
                if ( i == index)
                {
                    break;
                }

                i++;
                node = node.nextNode;
            }
            return node;
        }

        /** 获取长度 */
        public function get length() : uint
        {
            return _length;
        }

        /** 清理 */
        public function clear() : void
        {
            headNode = null;
            lastNode = null;
            _length = 0;
        }

        /** 打印 */
        public function print() : void
        {
            //trace(toString());
        }

        public function toString() : String
        {
            var str : String = "";
            if (headNode == null) return str;
            var i : int = 0;
            var node : LinkNode = headNode;
            str += i + "  " + node.toString() + "\n";
            while (node.nextNode != null)
            {
                i++;
                node = node.nextNode;
                str += i + "  " + node.toString() + "\n";
            }
            return str;
        }

        /** 排序添加 */
        public function sortAdd(node : LinkNode) : int
        {
            if (node == null) return index;

            // 如果头为空
            if (headNode == null)
            {
                addNode(node);
                return 0;
            }

            // 如果自己小于或等于头
            if (node.compare(headNode) <= 0)
            {
                addNode(node, 0);
                return 0;
            }

            // 如果自己大于或等于尾
            if (node.compare(lastNode) >= 0)
            {
                addNode(node);
                return length - 1;
            }

            var index : int = 1;
            var compareNode : LinkNode = headNode;
            while (compareNode != null)
            {
                if (node.compare(compareNode) >= 0)
                {
                    if (compareNode.nextNode != null && node.compare(compareNode.nextNode) <= 0)
                    {
                        addNode(node, index);
                        break;
                    }
                    else if(compareNode.nextNode == null)
                    {
                        addNode(node, index);
                        break;
                    }
                }
                index++;
                compareNode = compareNode.nextNode;
            }
            return index;
        }

        /** 
         * 更新排序
         * @return 返回是否改变
         */
        public function sortUpdate(node : LinkNode) : Boolean
        {
            var isChange : Boolean = false;
            var isMove : Boolean = false;
            if (node.preNode && node.compare(node.preNode) < 0)
            {
                while (node.preNode && node.compare(node.preNode) < 0)
                {
                    isMove = preMoveOnceNode(node);
                    if (isMove == true) isChange = true;
                }
            }
            else if (node.nextNode && node.compare(node.nextNode) > 0)
            {
                while (node.nextNode && node.compare(node.nextNode) > 0)
                {
                    isMove = nextMoveOnceNode(node);
                    if (isMove == true) isChange = true;
                }
            }
            return isChange;
        }

        /** 
         * 上移一个节点
         * @return 返回是否改变
         */
        public function preMoveOnceNode(node : LinkNode) : Boolean
        {
            if (node == null) return false;
            var isChange : Boolean = false;
            var preNode : LinkNode;
            var nextNode : LinkNode;
            var preNode2 : LinkNode;
            preNode = node.preNode;
            nextNode = node.nextNode;

            if (preNode != null) preNode2 = preNode.preNode;
            if (preNode != null)
            {
                if (preNode2 != null)
                {
                    preNode2.nextNode = node;
                }
                else if (headNode == preNode)
                {
                    headNode = node;
                }
                node.preNode = preNode2;
                node.nextNode = preNode;
                preNode.preNode = node;
                preNode.nextNode = nextNode;
                if (nextNode != null)
                {
                    nextNode.preNode = preNode;
                }
                else if (lastNode == node)
                {
                    lastNode = preNode;
                }

                isChange = true;
            }
            return isChange;
        }

        /** 
         * 下移一个节点
         * @return 返回是否改变
         */
        public function nextMoveOnceNode(node : LinkNode) : Boolean
        {
            if (node == null) return false;
            var isChange : Boolean = false;
            var preNode : LinkNode;
            var nextNode : LinkNode;
            var nextNode2 : LinkNode;
            preNode = node.preNode;
            nextNode = node.nextNode;
            if (nextNode != null) nextNode2 = nextNode.nextNode;
            if (nextNode != null)
            {
                if (preNode != null)
                {
                    preNode.nextNode = nextNode;
                }
                else if (headNode == node)
                {
                    headNode = nextNode;
                }
                nextNode.preNode = preNode;
                nextNode.nextNode = node;
                node.preNode = nextNode;
                node.nextNode = nextNode2;
                if (nextNode2 != null)
                {
                    nextNode2.preNode = node;
                }
                else if (lastNode == nextNode)
                {
                    lastNode = node;
                }
                isChange = true;
            }
            return isChange;
        }
    }
}
