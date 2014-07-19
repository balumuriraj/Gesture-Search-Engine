/**
 * 
 */
package org.mwdb.decisiontree;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Scanner;
import java.util.Set;
import java.util.TreeSet;

import au.com.bytecode.opencsv.CSVReader;

/**
 * @author satyaswaroop
 * 
 */
public class DecisonTreeMain {

	Set<Integer> setOffeatures;
	HashMap<String, Integer> mapAfterMapping;

	public DecisonTreeMain() {
		super();
		setOffeatures = new TreeSet<Integer>();
	}

	public HashMap<String, Integer> getMapAfterMapping() {
		return mapAfterMapping;
	}

	public void setMapAfterMapping(HashMap<String, Integer> mapAfterMapping) {
		this.mapAfterMapping = mapAfterMapping;
	}

	/**
	 * @param args
	 */
	public void formTree() {

		String[] fileName = null;
		Scanner ob = new Scanner(System.in);
		System.out.println("Enter data folder to know the file names: ");
		String folderPath = ob.nextLine();
		File folder = new File(folderPath);
		// Creating a filter to return only files.
		FileFilter fileFilter = new FileFilter() {
			@Override
			public boolean accept(File file) {
				return !file.isDirectory() && file.getName().contains("csv");
			}
		};

		File[] fileList = folder.listFiles(fileFilter);
		fileName = new String[fileList.length];
		// Sort files by name
		Arrays.sort(fileList, new Comparator<File>() {
			@Override
			public int compare(File f1, File f2) {
				String filename1 = f1.getName();
				String filename2 = f2.getName();
				int file1 = Integer.parseInt(((filename1.split("\\.")))[0]);
				int file2 = Integer.parseInt(((filename2.split("\\.")))[0]);
				if (file1 > file2) {
					return 1;
				}
				if (file1 == (file2))
					return 0;
				if (file1 < file2)
					return -1;
				return 0;

			}

		});
		int filecount = 0;
		// Prints the files in file name ascending order
		for (File file : fileList) {
			fileName[filecount] = file.getName();
			filecount++;
		}
		Map<String, DataObject> result = null;
		System.out.println("Enter data path: ");
		String path = ob.nextLine();
		CSVReader reader = null;
		try {
			reader = new CSVReader(new InputStreamReader(new FileInputStream(
					new File(path))));
			result = new HashMap<String, DataObject>();
			int count = 0;
			for (String[] row : reader.readAll()) {
				double[] values = getDoubleArray(row);

				result.put(fileName[count], new DataObject(values,
						fileName[count]));
				count++;
			}
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				reader.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		System.out.println("Enter path to label file\n");
		String labelPath = ob.nextLine();
		System.out.println("Enter the number of Classes: ");
		int noOfClasses = ob.nextInt();

		ob.close();
		DecisionTree tree = new DecisionTree();
		tree.root = new Node();
		int len = result.get("1.csv").values.length;
		List<String> fList = Arrays.asList(fileName);
		Map<String, DataObject> labeledData = null;
		labeledData = new HashMap<String, DataObject>();
		CSVReader reader2 = null;
		try {
			reader2 = new CSVReader(new InputStreamReader(new FileInputStream(
					new File(labelPath))));

			for (String[] row : reader2.readAll()) {

				labeledData.put(row[0] + ".csv", result.get(row[0] + ".csv"));
				result.get(row[0] + ".csv").label = row[1];
			}
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				reader.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		Map<String, DataObject> unLabelled = new HashMap<String, DataObject>();
		Iterator<Entry<String, DataObject>> it = result.entrySet().iterator();
		while (it.hasNext()) {

			Map.Entry<String, DataObject> pairs = (Map.Entry<String, DataObject>) it
					.next();

			if (pairs.getValue().label == null) {
				unLabelled.put(pairs.getKey(), pairs.getValue());
			}

		}

		partition(tree.root, len, labeledData);
		System.out.println("Done");
		printTree(tree.root, -1);
		labelData(unLabelled, tree, labelPath.substring(0, labelPath.lastIndexOf(File.separator)));
	}

	private void labelData(Map<String, DataObject> unLabelled, DecisionTree tree, String outputFolder) {
		File f = new File(outputFolder+File.separator+"afterLabeling.csv");
		mapAfterMapping = new HashMap<String, Integer>();
		Iterator<Entry<String, DataObject>> it = unLabelled.entrySet()
				.iterator();
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream(f);
		
		while (it.hasNext()) {
			Map.Entry<String, DataObject> pairs = (Map.Entry<String, DataObject>) it
					.next();
			String label = parseTree(pairs.getValue(), tree);
			
			
				fos.write((pairs.getKey() + "," + label + "\n").getBytes());
			
		}
		} catch (FileNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally{
			try {
				fos.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	private String parseTree(DataObject value, DecisionTree tree) {
		String label = null;
		
		Node present = tree.root;
		int i = -1;
		while (label == null && present != null && present.lists != null) {
			if (present.className != null) {
				if(i!=-1)
				mapAfterMapping.put(value.name, i);
				value.setLabel(present.className);
				return present.className;
			}
			if (present.splitvalue <= value.values[present.feature]) {

				if (present.rightNode == null) {
					i = present.feature;
					present = present.leftNode;
				} else {
					i = present.feature;
					present = present.rightNode;
				}
			} else if (present.splitvalue > value.values[present.feature]) {

				if (present.leftNode == null) {
					i = present.feature;
					present = present.rightNode;
				} else {
					i = present.feature;
					present = present.leftNode;
				}
			}
		}

		return null;
	}

	public void ignoreFeatures(ArrayList<String> listOfIrrelevant) {
		for (String s : listOfIrrelevant) {
			setOffeatures.add(mapAfterMapping.get(s));
		}
	}

	public List<Integer> correctTree(String dataPath, String filePath,
			HashMap<String, String> labels, String outputFolder) {
		if (mapAfterMapping != null) {
			Iterator<Entry<String, String>> iterator = labels.entrySet()
					.iterator();
			while (iterator.hasNext()) {
				Entry<String, String> e = iterator.next();
				if (e.getValue().equalsIgnoreCase("I")) {
					setOffeatures.add(mapAfterMapping.get(e.getKey()));
				}
			}
		}
		HashMap<String, DataObject> data = new HashMap<String, DataObject>();
		CSVReader reader = null;
		String[] fileName;
		File folder = new File(filePath);
		// Creating a filter to return only files.
		FileFilter fileFilter = new FileFilter() {
			@Override
			public boolean accept(File file) {
				return !file.isDirectory() && file.getName().contains("csv");
			}
		};

		File[] fileList = folder.listFiles(fileFilter);
		fileName = new String[fileList.length];
		// Sort files by name
		Arrays.sort(fileList, new Comparator<File>() {
			@Override
			public int compare(File f1, File f2) {
				String filename1 = f1.getName();
				String filename2 = f2.getName();
				int file1 = Integer.parseInt(((filename1.split("\\.")))[0]);
				int file2 = Integer.parseInt(((filename2.split("\\.")))[0]);
				if (file1 > file2) {
					return 1;
				}
				if (file1 == (file2))
					return 0;
				if (file1 < file2)
					return -1;
				return 0;

			}

		});
		int filecount = 0;
		// Prints the files in file name ascending order
		for (File file : fileList) {
			fileName[filecount] = file.getName();
			filecount++;
		}

		int len = 0;
		try {

			reader = new CSVReader(new InputStreamReader(new FileInputStream(
					new File(dataPath))));
			int count = 0;
			for (String[] row : reader.readAll()) {
				double[] values = getDoubleArray(row);
				len = values.length;
				if (setOffeatures != null) {
					for (int i : setOffeatures) {
						int dimension = i / 60;
						int sensor = (i - 60 * dimension) / 3;
						int j = dimension * 60 + sensor * 3;
						System.out.println("Actual:" + i + "\nDeleteing from:"
								+ j);
						values[j] = 0;
						values[j + 1] = 0;
						values[j + 2] = 0;

					}
				}
				data.put(fileName[count], new DataObject(values,
						fileName[count]));
				count++;
			}
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				reader.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		Map<String, DataObject> labeledData = null;
		labeledData = new HashMap<String, DataObject>();

		Iterator<Entry<String, String>> iterator = labels.entrySet().iterator();
		while (iterator.hasNext()) {
			Entry<String, String> e = iterator.next();
			labeledData.put(e.getKey(), data.get(e.getKey()));
			data.get(e.getKey()).label = e.getValue();
		}
		DecisionTree tree = new DecisionTree();
		tree.root = new Node();
		partition(tree.root, len, labeledData);

		Map<String, DataObject> unLabelled = new HashMap<String, DataObject>();
		Iterator<Entry<String, DataObject>> it = data.entrySet().iterator();
		while (it.hasNext()) {

			Map.Entry<String, DataObject> pairs = (Map.Entry<String, DataObject>) it
					.next();

			if (pairs.getValue().label == null) {
				unLabelled.put(pairs.getKey(), pairs.getValue());
			}

		}
		System.out.println("Done");
		printTree(tree.root, -1);
		labelData(unLabelled, tree,outputFolder);
		Iterator<Entry<String, DataObject>> iterator2 = unLabelled.entrySet()
				.iterator();
		ArrayList<Integer> listOfRelevance = new ArrayList<Integer>();
		while (iterator2.hasNext()) {
			Entry<String, DataObject> e = iterator2.next();
			if ((e.getValue().label).equalsIgnoreCase("R")) {
				listOfRelevance
						.add(Integer.parseInt((e.getKey().split(".csv"))[0]));
			}
		}
		iterator2 = labeledData.entrySet().iterator();
		while (iterator2.hasNext()) {
			Entry<String, DataObject> e = iterator2.next();
			if ((e.getValue().label).equalsIgnoreCase("R")) {
				listOfRelevance
						.add(Integer.parseInt((e.getKey().split(".csv"))[0]));
			}
		}
		return listOfRelevance;
	}

	private void printTree(Node node, int parent) {

		if (node.className != null) {
			System.out.println("Class Label:" + node.className + "\t Parent:"
					+ parent);
		} else {
			if (node.rightNode != null && node.leftNode != null) {
				System.out.println("Feature: " + node.feature + "\tValue: "
						+ node.splitvalue + "\tChildren: Right:"
						+ node.rightNode.feature + "\tChildren: Left:"
						+ node.leftNode.feature);
			} else if (node.rightNode == null && node.leftNode != null) {
				System.out.println("Feature: " + node.feature + "\tValue: "
						+ node.splitvalue + "\tChildren: Right: null"
						+ "\tChildren: Left:" + node.leftNode.feature);
			} else if (node.rightNode != null && node.leftNode == null) {
				System.out.println("Feature: " + node.feature + "\tValue: "
						+ node.splitvalue + "\tChildren: Right: "
						+ node.rightNode.feature + "\tChildren: Left: null");
			} else if (node.rightNode == null && node.leftNode == null) {
				System.out.println("Feature: " + node.feature + "\tValue: "
						+ node.splitvalue + "\tChildren: Right: null"
						+ "\tChildren: Left: null");
			}
			if (node.rightNode != null && node.rightNode.lists != null) {
				printTree(node.rightNode, node.feature);

			}
			if (node.leftNode != null && node.leftNode.lists != null) {
				printTree(node.leftNode, node.feature);
			}
		}

	}

	private void findSplitFeature(Node node) {

		Iterator<Entry<Integer, AttributeList>> it = node.lists.entrySet()
				.iterator();
		it = node.lists.entrySet().iterator();
		int maxGainIndex = 0;
		double maxGain = 0;
		while (it.hasNext()) {

			Map.Entry<Integer, AttributeList> pairs = (Map.Entry<Integer, AttributeList>) it
					.next();
			AttributeList value = pairs.getValue();
			if (maxGain < value.maxInfoGain) {
				maxGain = value.maxInfoGain;
				maxGainIndex = pairs.getKey();
			}

		}

		node.feature = maxGainIndex;
		node.splitvalue = node.lists.get(node.feature).splitValue;
		System.out.println("Feature identified:" + node.feature + "\nSplit:"
				+ node.splitvalue);
	}

	private double[] getDoubleArray(String[] row) {
		double[] ret = new double[row.length];
		for (int i = 0; i < row.length; i++) {
			ret[i] = Double.parseDouble(row[i]);
		}
		return ret;
	}

	private void partition(Node node, int len, Map<String, DataObject> data) {

		System.out.print("\nStarted");
		for (int i = 0; i < len; i++) {
			AttributeList att = new AttributeList(i, new ArrayList<Element>());
			Iterator<Entry<String, DataObject>> it = data.entrySet().iterator();
			while (it.hasNext()) {

				Map.Entry<String, DataObject> pairs = (Map.Entry<String, DataObject>) it
						.next();
				Element e = new Element();
				e.label = pairs.getValue().label;
				e.featureValue = (pairs.getValue().getValues())[i];
				e.object = pairs.getValue();
				att.elements.add(e);
			}
			att.findSplit();
			node.lists.put(i, att);
		}
		findSplitFeature(node);
		Node rightNode = new Node();
		node.rightNode = rightNode;
		Node leftNode = new Node();
		node.leftNode = leftNode;
		Map<String, DataObject> rightObjects = new HashMap<String, DataObject>();
		Map<String, DataObject> leftObjects = new HashMap<String, DataObject>();
		node.lists.get(node.feature).splitObjects(rightObjects, leftObjects);
		System.out.println(node.lists.get(node.feature).right.size());

		if (rightObjects.size() > 3) {
			double maxPer = 0;
			String label = null;
			Iterator<Entry<String, Integer>> att1 = node.lists
					.get(node.feature).right.entrySet().iterator();
			while (att1.hasNext()) {
				Entry<String, Integer> entry = att1.next();
				int size = rightObjects.size();
				double per = ((double) entry.getValue() / (double) size) * 100;
				if (maxPer < per && per > 80) {
					maxPer = per;
					label = entry.getKey();
				}
			}
			if (node.lists.get(node.feature).right.size() != 1 && label == null)
				partition(rightNode, len, rightObjects);
			else {
				if (label == null) {
					Iterator<String> att = rightObjects.keySet().iterator();
					if (att.hasNext()) {
						String key = att.next();
						node.rightNode.className = rightObjects.get(key).label;
					}
				} else {
					node.rightNode.className = label;
				}

			}
		} else {
			if (node.lists.get(node.feature).right.size() == 1) {
				Iterator<String> att = rightObjects.keySet().iterator();
				if (att.hasNext()) {
					String key = att.next();
					node.rightNode.className = rightObjects.get(key).label;
				}
			} else
				node.rightNode = null;
		}
		if (leftObjects.size() > 3) {
			double maxPer = 0;
			String label = null;
			Iterator<Entry<String, Integer>> att1 = node.lists
					.get(node.feature).left.entrySet().iterator();
			while (att1.hasNext()) {
				Entry<String, Integer> entry = att1.next();
				int size = leftObjects.size();
				double per = (entry.getValue() / size) * 100;
				if (maxPer < per && per > 80) {
					maxPer = per;
					label = entry.getKey();
				}
			}
			if (node.lists.get(node.feature).left.size() != 1 && label == null)
				partition(leftNode, len, leftObjects);
			else {
				if (label == null) {
					Iterator<String> att = leftObjects.keySet().iterator();
					if (att.hasNext()) {
						String key = att.next();
						node.leftNode.className = leftObjects.get(key).label;
					}
				} else {
					node.leftNode.className = label;
				}

			}
		} else {

			if (node.lists.get(node.feature).left.size() == 1) {
				Iterator<String> att = leftObjects.keySet().iterator();
				if (att.hasNext()) {
					String key = att.next();
					node.leftNode.className = leftObjects.get(key).label;
				}
			} else
				node.leftNode = null;
		}

		System.out.print("\n node:" + node.feature + "\n Valaue:"
				+ node.splitvalue);
	}
}
