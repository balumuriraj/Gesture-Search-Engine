import java.awt.BorderLayout;
import java.awt.Container;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

public class MainFrame extends JFrame{

	private DetailsPanel detailsPanel;
	
	public MainFrame(String title){
		super(title);
		//set layout manager
		setLayout(new BorderLayout());

		//create Swing component
		final JTextArea textArea = new JTextArea(42, 42);
		JScrollPane scrollPane  = new JScrollPane(textArea);
		scrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
		scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);


		detailsPanel = new DetailsPanel();
		detailsPanel.addDetailListener(new DetailListener() {
			public void detailEventOccurred(DetailEvent event){
				String text  = event.getText();
				textArea.append(text);
			}
		});
		
		//Add Swing components to content pane
		getContentPane().add(scrollPane, BorderLayout.EAST);
		getContentPane().add(detailsPanel, BorderLayout.WEST);

		/*Container c = getContentPane();
		c.add(textArea, BorderLayout.CENTER);
		c.add(detailsPanel, BorderLayout.WEST);
		c.add(scrollPane, BorderLayout.CENTER);*/

	}

}
