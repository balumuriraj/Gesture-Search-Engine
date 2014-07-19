import javax.swing.JFrame;
import javax.swing.SwingUtilities;

public class Phase3Task6 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				JFrame frame = new MainFrame("MWDB - Phase 3");
				frame.setSize(1000, 700);
				frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
				frame.setVisible(true);
			}
		});
	}
	}

