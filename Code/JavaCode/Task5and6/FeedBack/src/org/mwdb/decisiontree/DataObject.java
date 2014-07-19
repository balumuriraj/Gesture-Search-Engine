package org.mwdb.decisiontree;

public class DataObject {
	
	double[] values;
	String label;
	String name;
	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public DataObject(double[] values) {
		super();
		this.values = values;
	}

	public DataObject(double[] values2, String string) {
		this.values = values2;
		this.name = string;
	}

	public double[] getValues() {
		return values;
	}

	public void setValues(double[] values) {
		this.values = values;
	}
	

}
