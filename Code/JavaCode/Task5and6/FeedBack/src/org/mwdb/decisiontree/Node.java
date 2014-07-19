package org.mwdb.decisiontree;

import java.util.HashMap;

public class Node {
		int feature;
		double splitvalue;
		String className;
		Node rightNode;
		Node leftNode;
		HashMap<Integer, AttributeList> lists;
		
		public Node getRightNode() {
			return rightNode;
		}
		public void setRightNode(Node rightNode) {
			this.rightNode = rightNode;
		}
		public Node getLeftNode() {
			return leftNode;
		}
		public void setLeftNode(Node leftNode) {
			this.leftNode = leftNode;
		}
		public int getFeature() {
			return feature;
		}
		public void setFeature(int feature) {
			this.feature = feature;
		}
		public double getSplitvalue() {
			return splitvalue;
		}
		public void setSplitvalue(double splitvalue) {
			this.splitvalue = splitvalue;
		}
		public Node() {
			super();
			lists=new HashMap<Integer, AttributeList>();
		}
		
		
}
