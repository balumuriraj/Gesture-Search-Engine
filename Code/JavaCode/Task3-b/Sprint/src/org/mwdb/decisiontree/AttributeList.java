package org.mwdb.decisiontree;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

public class AttributeList {

	int feature;
	ArrayList<Element> elements;
	Map<String, Integer> right;
	Map<String, Integer> left;
	double splitValue;
	double maxInfoGain;
	int splitIndex;

	public AttributeList(int feature, ArrayList<Element> elements) {
		super();
		this.feature = feature;
		this.elements = elements;

	}

	public int getFeature() {
		return feature;
	}

	public void setFeature(int feature) {
		this.feature = feature;
	}

	public ArrayList<Element> getElements() {
		return elements;
	}

	public void setElements(ArrayList<Element> elements) {
		this.elements = elements;
	}

	public double findSplit() {
		double[] infoGain = new double[elements.size()];
		Collections.sort(elements);
		int index = 0;
		double prev = 999;
		for (Element i : elements) {
			if (prev != i.featureValue) {
				Map<String, Integer> right = getAbove(i.featureValue);
				Map<String, Integer> left = getBelow(i.featureValue);
				double ent_left = 0;
				double ent_after = 0;
				double ent_right = 0;
				double ent_before = 0;
				double sumleft = 0, sumright = 0;
				Iterator<Entry<String, Integer>> it = right.entrySet()
						.iterator();
				while (it.hasNext()) {
					Entry<String, Integer> entry = it.next();
					sumright = sumright + entry.getValue();
				}

				it = left.entrySet().iterator();
				while (it.hasNext()) {
					Entry<String, Integer> entry = it.next();
					sumleft = sumleft + entry.getValue();
				}

				Map<String, Integer> m = this.getRootCount();
				Iterator<Entry<String, Integer>> it2 = m.entrySet().iterator();
				while (it2.hasNext()) {
					Entry<String, Integer> entry = it2.next();
					ent_before = -nlog2(entry.getValue()
							/ ((double) (sumleft + sumright)));
					if (left.get((entry.getKey())) != null)
						ent_left = -nlog2(left.get((entry.getKey()))
								/ (double) sumleft);
					if (right.get((entry.getKey())) != null)
						ent_right = -nlog2(right.get((entry.getKey()))
								/ (double) sumright);
				}
				ent_after = (((double) (sumleft / (sumleft + sumright))) * ent_left)
						+ (((double) (sumright / (sumleft + sumright))) * ent_right);
				infoGain[index] = ent_before - ent_after;
				if (maxInfoGain < infoGain[index]
						|| (maxInfoGain == 0 && infoGain[index] == 0)) {
					if (infoGain[index] == 0)
						maxInfoGain = -1;
					else
						maxInfoGain = infoGain[index];
					splitValue = elements.get(index).featureValue;
					splitIndex = index;
					this.right = right;
					this.left = left;
				}
				prev = elements.get(index).featureValue;
			}
			index++;
		}

		return splitValue;

	}

	private static double nlog2(double value) {
		if (value == 0)
			return 0;

		return value * Math.log(value) / Math.log(2);
	}

	private Map<String, Integer> getAbove(double i) {
		Map<String, Integer> right = new HashMap<String, Integer>();
		for (Element e : elements) {
			if (e.featureValue >= i) {
				Integer f = right.get(e.label);
				if (f == null)
					right.put(e.label, 1);
				else
					right.put(e.label, ++f);
			}
		}
		return right;
	}

	private Map<String, Integer> getBelow(double i) {
		Map<String, Integer> left = new HashMap<String, Integer>();
		for (Element e : elements) {
			if (e.featureValue < i) {
				Integer f = left.get(e.label);
				if (f == null)
					left.put(e.label, 1);
				else
					left.put(e.label, ++f);
			}
		}
		return left;
	}

	public Map<String, Integer> getRootCount() {
		Map<String, Integer> left = new HashMap<String, Integer>();
		for (int j = 0; j < elements.size(); j++) {
			Integer f = left.get(elements.get(j).label);
			if (f == null)
				left.put(elements.get(j).label, 1);
			else
				left.put(elements.get(j).label, ++f);
		}
		return left;
	}

	public void splitObjects(Map<String, DataObject> rightObjects,
			Map<String, DataObject> leftObjects) {
		if (right != null || left != null) {
			System.out.println("Split  of objects at feature:" + this.feature);
			for (Element i : elements) {
				int index = elements.indexOf(i);

				if (index >= splitIndex) {
					DataObject obj = i.object;
					rightObjects.put(obj.name, obj);
					System.out.print("\t :right ;" + obj.name);
				}
				if (index < splitIndex) {
					DataObject obj = i.object;
					leftObjects.put(obj.name, obj);
					System.out.print("\t :left ;" + obj.name);
				}

			}
		}
	}

}
