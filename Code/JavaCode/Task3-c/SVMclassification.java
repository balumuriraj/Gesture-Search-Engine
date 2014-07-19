package mwdb.project.phase1;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import matlabcontrol.MatlabConnectionException;
import matlabcontrol.MatlabInvocationException;
import matlabcontrol.MatlabProxy;
import matlabcontrol.MatlabProxyFactory;

public class SVMclassification 
{
  public static void main(String[] args) throws MatlabConnectionException, IOException, MatlabInvocationException
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
  	  proxy.eval("SVMimplementation(\'"+dataPath+"\')");
  	  proxy.disconnect();
  	  System.exit(0);
  }
}
