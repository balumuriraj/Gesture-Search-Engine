package mwdb.project.phase1;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import matlabcontrol.MatlabConnectionException;
import matlabcontrol.MatlabInvocationException;
import matlabcontrol.MatlabProxy;
import matlabcontrol.MatlabProxyFactory;
import matlabcontrol.extensions.MatlabTypeConverter;

public class LSHashing 
{
	public static void main(String[] args) throws MatlabConnectionException, MatlabInvocationException, IOException
	{
		MatlabProxyFactory factory = new MatlabProxyFactory();
		MatlabProxy proxy = factory.getProxy();	
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		
		System.out.println("Enter the matlab path\n");
    	String mPath = br.readLine();
    	String matlabPath = "cd(\'"+mPath+"\')";
    	proxy.eval(matlabPath);
    	System.out.println("Enter the input path\n");
    	String dataPath = br.readLine();
    	System.out.println("Enter the value of r\n");
    	String rValue = br.readLine();
    	System.out.println("Enter the value of mean\n");
    	String mean = br.readLine();
    	System.out.println("Enter the value of standard deviation\n");
    	String stdDeviation = br.readLine();
    	System.out.println("Enter the value of window size\n");
    	String wVal = br.readLine();
    	System.out.println("Enter the value of shift\n");
    	String shiftVal = br.readLine();
    	proxy.eval("getGaussianBands(\'"+dataPath+"\',"+mean+","+stdDeviation+","+rValue+")");
    	proxy.eval("normalizeAndDiscretizeDB(\'"+dataPath+"\',"+wVal+","+shiftVal+")");
 	    proxy.eval("calculatePCAForSensor_DB(\'"+dataPath+"\')");
 	    proxy.eval("ProjectDataForTree(\'"+dataPath+"\')");	
		System.out.println("Enter the number of layers");
		String nLayers = br.readLine();
		System.out.println("Enter the number of hash functions per layer");
		String nHashes = br.readLine();
	    proxy.eval("[allHFunctions,allHValues,allBckts] = LSHimplementation203(\'"+dataPath+"\',"+nLayers+","+nHashes+")");
		MatlabTypeConverter processor = new MatlabTypeConverter(proxy);
		double[][][] allHashFunctions = processor.getNumericArray("allHFunctions").getRealArray3D();    	
		double[][] allHashValues =processor.getNumericArray("allHValues").getRealArray2D();
		String[] allBuckets = (String[])proxy.getVariable("allBckts");
		/*for(int i=0;i<allBuckets.length;i++)
		{
			System.out.println(allBuckets[i]);
		}
		System.out.println("total buckets: "+allBuckets.length);*/
		while(true)
		{
			System.out.println("Enter the test file name(enter 'quit' to exit)");
			String testFile = br.readLine();
			if(testFile.equalsIgnoreCase("quit"))
				System.exit(0);
			System.out.println("Enter the number of similar files required");
			String count = br.readLine();
			proxy.eval("calculateTFvaluesForGivenGesture(\'"+dataPath+"\','"+testFile+"',"+wVal+","+shiftVal+")");
			proxy.eval("projectTestGestureInTo203(\'"+dataPath+"\','"+testFile+"','PCA')");
			proxy.eval("[similarFiles,fileCounts] = findSimGesturesOfQueryLSH203(\'"+dataPath+"\',allHFunctions,allHValues,allBckts,'"+testFile+"',"+count+")");
			String[] filesReturned = (String[])proxy.getVariable("similarFiles");
			String[] fileCounts = (String[])proxy.getVariable("fileCounts");
			System.out.println("Overall no of gestures considered: "+fileCounts[0]);
			System.out.println("No of unique gestures considered: "+fileCounts[1]);
			for(int i=0;i<filesReturned.length;i++)
			{
				System.out.println(filesReturned[i]);
			}
		}
	}
}
