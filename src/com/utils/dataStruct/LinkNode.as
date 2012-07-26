package com.utils.dataStruct
{
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-17 ����3:08:10
     */
    public class LinkNode
    {
        public var preNode : LinkNode;
        public var nextNode : LinkNode;
        public var data : *;

        public function compare(node : LinkNode) : int
        {
            if (data < node.data)
            {
                return -1;
            }
            else if (data > node.data)
            {
                return 1;
            }
            return 0;
        }

        public function toString() : String
        {
            return data + "";
        }
    }
}
