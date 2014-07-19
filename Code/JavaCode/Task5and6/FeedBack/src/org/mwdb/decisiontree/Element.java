package org.mwdb.decisiontree;

public class Element implements Comparable<Element>{
	
	String label;
	DataObject object; 
	double featureValue;
	
	

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		long temp;
		temp = Double.doubleToLongBits(featureValue);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + ((label == null) ? 0 : label.hashCode());
		result = prime * result + ((object == null) ? 0 : object.hashCode());
		return result;
	}



	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Element other = (Element) obj;
		if (Double.doubleToLongBits(featureValue) != Double
				.doubleToLongBits(other.featureValue))
			return false;
		if (label == null) {
			if (other.label != null)
				return false;
		} else if (!label.equals(other.label))
			return false;
		if (object == null) {
			if (other.object != null)
				return false;
		} else if (!object.equals(other.object))
			return false;
		return true;
	}



	@Override
	public int compareTo(Element o) {
		if(featureValue>o.featureValue)
			return 1;
		else if(featureValue<o.featureValue)
			return -1;
		else
		return 0;
	}

}
