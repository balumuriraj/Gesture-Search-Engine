import java.io.File;
import java.util.Scanner;
import matlabcontrol.*;

import javax.swing.*;


public class Phase3Task3 {

	/**
	 * @param args
	 */
	public static void main(String[] args) throws MatlabConnectionException, MatlabInvocationException{
		Scanner in= null;
		try {
			in= new Scanner(System.in);
		    //rest of the code
			
			System.out.println("Please select Database folder (Output Path of Phase 2 Task 1): ");
			JFileChooser chooser = new JFileChooser(".");
			chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
			chooser.showOpenDialog(null);
            File f1 = chooser.getSelectedFile();
            String databasepath = f1.getAbsolutePath();//get the absolute path to selected file
            System.out.println("Folder selected:"+databasepath);
            
		 	System.out.println("Enter K value:");
			int k = Integer.parseInt(in.nextLine());
			
			// TODO Auto-generated method stub
			MatlabProxyFactory factory = new MatlabProxyFactory();
			MatlabProxy proxy = factory.getProxy();
			
			System.out.println("Enter Matlab Path:");
			String matlabpath = in.nextLine();
			
			proxy.eval("addpath('"+matlabpath+"')");
	        proxy.feval(new String("KNearestNeighborfin"), databasepath, k);
	        proxy.eval("rmpath('"+matlabpath+"')");
			proxy.disconnect();
	
		}
		finally {
		if(in!=null)
		in.close();
		}

	}

}
