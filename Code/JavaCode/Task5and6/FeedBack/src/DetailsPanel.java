import java.awt.Dimension;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.event.EventListenerList;

import matlabcontrol.MatlabConnectionException;
import matlabcontrol.MatlabInvocationException;
import matlabcontrol.MatlabProxy;
import matlabcontrol.MatlabProxyFactory;
import matlabcontrol.extensions.MatlabTypeConverter;

import org.mwdb.decisiontree.DecisonTreeMain;

public class DetailsPanel extends JPanel {
	private static final long serialVersionUID = 6915622549267792262L;
	private EventListenerList listenerList = new EventListenerList();
	MatlabProxyFactory factory = new MatlabProxyFactory();
	

	public DetailsPanel() {

		Dimension size = getPreferredSize();
		size.width = 500;
		setPreferredSize(size);

		setBorder(BorderFactory.createTitledBorder("Input details"));

		JLabel kLabel = new JLabel("Enter K value: ");
		JLabel inputPath = new JLabel("Database Input Path: ");
		JLabel queryPath = new JLabel("Query Input Path: ");
		JLabel matlabPath = new JLabel("Matlab Path: ");

		final JTextField kField = new JTextField(20);
		final JTextField inputPathField = new JTextField(20);
		final JTextField queryPathField = new JTextField(20);
		final JTextField matlabPathField = new JTextField(20);
		
		JButton addBtn = new JButton("Submit");
		// Add behaviour
		addBtn.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				String k = kField.getText();
				String text = "K value is" + ": " + k + "\n";
				fireDetailEvent(new DetailEvent(this, text));
				int kvalue = Integer.parseInt(k);

				String Path = inputPathField.getText();
				String text1 = "Database Path is" + ": " + Path + "\n";
				fireDetailEvent(new DetailEvent(this, text1));

				String queryPath = queryPathField.getText();
				String text2 = "Query Path is" + ": " + Path + "\n";
				fireDetailEvent(new DetailEvent(this, text2));
				
				List<Integer> listOfRelevance = new ArrayList<Integer>();

				try {
					MatlabProxy proxy = factory.getProxy();
					proxy.eval("addpath('"+matlabPathField.getText()+"')");
					/*proxy.eval("[topkoutput] = topksimilar(\'" + Path + "\',\'"
							+ queryPath + "\'," + (relevant).toArray() + ","
							+ kvalue + ")");
					proxy.eval("[topkoutput] = topksimilar(\'" + Path + "\',\'"
							+ queryPath + "\', [] ,"
							+ kvalue + ")");
					MatlabTypeConverter processor = new MatlabTypeConverter(
							proxy);
					double[][] topkoutput = processor.getNumericArray(
							"topkoutput").getRealArray2D();*/
					
					Object obj[]=proxy.returningFeval("topksimilar",1,inputPathField.getText(),queryPathField.getText(),listOfRelevance,(kField.getText()));
					double topkoutput[]=(double[]) obj[0];
					fireDetailEvent(new DetailEvent(this,
							"-----------Top K Similar Files---------\n"));
					for (int i = 0; i < Integer.parseInt(kField.getText()); i++) {
						String text3 = "";
						for (int j = 0; j < 1; j++) {
							if (j == 0) {
								System.out.print((int) topkoutput[i]
										+ ".csv");
								text3 = text3 + (int) topkoutput[i] + ".csv";
							} else {
								System.out.print(topkoutput[i] + " ");
								text3 = text3 + topkoutput[i] + " ";
							}

						}
						System.out.println();
						text3 = " [" + (i + 1) + "] " + text3 + "\n";
						fireDetailEvent(new DetailEvent(this, text3));
					}
					fireDetailEvent(new DetailEvent(this,
							"-----------------------------------------------\n"));

				} catch (MatlabInvocationException | MatlabConnectionException e1) {
					e1.printStackTrace();
				}

			}
		});

		JLabel relavent = new JLabel("Relevent file no.s with comas: ");
		JLabel irrelavent = new JLabel("Irelevent file no.s with comas: ");

		final JTextField relaventField = new JTextField(20);
		final JTextField irrelaventField = new JTextField(20);

		JButton dtreebtn = new JButton("Submit");
		final DecisonTreeMain tree = new DecisonTreeMain();
		dtreebtn.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				String rel = relaventField.getText();
				String text = "Relevent Files are" + ": " + rel + "\n";
				fireDetailEvent(new DetailEvent(this, text));

				String irr = irrelaventField.getText();
				String text1 = "Irrelevent Files are" + ": " + irr + "\n";
				fireDetailEvent(new DetailEvent(this, text1));

				String dataPath = inputPathField.getText();
				dataPath = dataPath
						+ "\\Outputs\\Phase2-Task1\\Projected\\output.csv";

				String filePath = inputPathField.getText();
				filePath = filePath + "\\X";

				String[] arrayrel = rel.split(",");
				String[] arrayirr = irr.split(",");

				HashMap<String, String> labels = new HashMap<String, String>();
				for (String string : arrayirr) {
					labels.put(string, "I");
				}
				for (String string : arrayrel) {
					labels.put(string, "R");
				}

				List<Integer> listOfRelevance = tree.correctTree(dataPath,
						filePath, labels,inputPathField.getText());
				
				try {
					MatlabProxy proxy = factory.getProxy();
					proxy.eval("addpath('"+matlabPathField.getText()+"')");
					Object obj[]=proxy.returningFeval("topksimilar",1,inputPathField.getText(),queryPathField.getText(),listOfRelevance,(kField.getText()));
					double topkoutput[]=(double[]) obj[0];
					fireDetailEvent(new DetailEvent(this,
							"-----------Top K Similar Files---------\n"));
					for (int i = 0; i < (topkoutput.length/2); i++) {
						String text3 = "";
						for (int j = 0; j < 1; j++) {
							if (j == 0) {
								System.out.print((int) topkoutput[i]
										+ ".csv");
								text3 = text3 + (int) topkoutput[i] + ".csv";
							} else {
								System.out.print(topkoutput[i] + " ");
								text3 = text3 + topkoutput[i] + " ";
							}

						}
						System.out.println();
						text3 = " [" + (i + 1) + "] " + text3 + "\n";
						fireDetailEvent(new DetailEvent(this, text3));
					}
					fireDetailEvent(new DetailEvent(this,
							"-----------------------------------------------\n"));

					
				} catch (MatlabInvocationException | MatlabConnectionException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

			}
		});

		setLayout(new GridBagLayout());

		GridBagConstraints gc = new GridBagConstraints();

		// // First ////////////////
		gc.anchor = GridBagConstraints.LINE_END;
		gc.weightx = 0.5;
		gc.weighty = 0.5;

		gc.gridx = 0;
		gc.gridy = 0;
		add(kLabel, gc);

		gc.gridx = 0;
		gc.gridy = 1;
		add(inputPath, gc);

		gc.gridx = 0;
		gc.gridy = 2;
		add(queryPath, gc);
		
		gc.gridx = 0;
		gc.gridy = 3;
		add(matlabPath, gc);

		gc.gridx = 0;
		gc.gridy = 6;
		add(relavent, gc);

		gc.gridx = 0;
		gc.gridy = 7;
		add(irrelavent, gc);

		// // Second
		gc.anchor = GridBagConstraints.LINE_START;
		gc.gridx = 1;
		gc.gridy = 0;
		add(kField, gc);

		gc.gridx = 1;
		gc.gridy = 1;
		add(inputPathField, gc);

		gc.gridx = 1;
		gc.gridy = 2;
		add(queryPathField, gc);
		
		gc.gridx = 1;
		gc.gridy = 3;
		add(matlabPathField, gc);

		gc.gridx = 1;
		gc.gridy = 6;
		add(relaventField, gc);

		gc.gridx = 1;
		gc.gridy = 7;
		add(irrelaventField, gc);

		// Third////////////////////////
		gc.weighty = 10;
		gc.anchor = GridBagConstraints.FIRST_LINE_START;
		gc.gridx = 1;
		gc.gridy = 4;
		add(addBtn, gc);

		gc.weighty = 10;
		gc.anchor = GridBagConstraints.FIRST_LINE_START;
		gc.gridx = 1;
		gc.gridy = 8;
		add(dtreebtn, gc);

	}

	public void fireDetailEvent(DetailEvent event) {
		Object[] listeners = listenerList.getListenerList();
		for (int i = 0; i < listeners.length; i += 2) {
			if (listeners[i] == DetailListener.class) {
				((DetailListener) listeners[i + 1]).detailEventOccurred(event);
			}
		}
	}

	public void addDetailListener(DetailListener listener) {
		listenerList.add(DetailListener.class, listener);
	}

	public void removeDetailListener(DetailListener listener) {
		listenerList.remove(DetailListener.class, listener);
	}

}
