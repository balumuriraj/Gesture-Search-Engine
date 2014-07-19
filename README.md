Gesture-Search-Engine
=====================
This Project requires MatLab and Java installed on the system. The code and jar files are in the folder called Code where Java and MatLab files are in the folders called JavaCode and MatLabCode folders respectively. Below are the executions steps:

Task 2
------------
1.	Run the MWDB_Proj_LSH.jar from the command prompt. Then give the inputs appropriately as prompted by the program.
2.	After entering the values shown in the above screenshot, the program forms the database by calculated TF, TF-IDF2, TF-IDF2, PCA on the sensors, projecting the data etc.
3.	Then the program prompts the user to enter the number of layers and number of hash functions per layer for LSH.
4.	Then the user is prompted for entering the test gesture name that exits in the “test” folder at data “input path”. Also the number of similar gestures required is also asked. The results are displayed as shown in the below screenshot. Similar gestures for other gestures can be extracted by repeating this step, else ‘quit’ can be entered to exit the program.

Task 3-1
--------------
1.	Open Cmd prompt and go to the jar files folder path and run Task3-1.jar by using the command: Java –jar Task3-1.jar
2.	Select the input folder that consists of database
3.	Now enter k value.
4.	Now MatLab pops up, enter matlab path
5.	Now MatLab computes and generates the output.
Note: labels.csv file should be in database path.

Task 3-2
--------------
1.	Open Cmd prompt and go to the jar files folder path and run Task3-2.jar by using the command: Java –jar Task3-2.jar
2.	Enter require inputs as prompted for. 
3.	This is the tree formed by algorithm on console.
4.	output file will be generated.

Task 3-3
--------------
1.	Run MWDB_Proj_SVM.jar from the command prompt. Then give the inputs appropriately as prompted by the program, as shown in the below screenshot.
2.	The program considers the labels.csv as training data, then it finds out the classes or labels of the gestures missing in the labels.csv i.e. unlabeled gestures and then outputs it in “Phase3-Task3\SVM” under “Outputs” directory. A screenshot is shown below.


Task 5-6
-------------
1.	Open Cmd prompt and go to the jar files folder path and run Task5and6.jar by using the command: Java –jar Task5and6.jar
2.	A java interface will popup and we need to enter required input such as k value, database path, query path and matlab path.
3.	A MatLab will pop up and computes the top k similar gestures for the query gesture and prints them on the right side of the java interface.
4.	If the user is not satisfied with the result he can give the relevant and irrelevant files on the left side of the java interface. Here my query gesture is 270. The first result shown to the user shows that first 13 files belong to the class of 270. Therefore, the user enters 589 and 30 file numbers in irrelevant field and rest in relevant field and submits the data to the system to get improved results.
5.	Now the Matlab pops up again and computes the top k similar gestures and shows it to the user. As you can see, all the files belong to the class of 270 which is an improvised result when compared to the previous result.
Note: We need to delete files in the query folder for every iteration.

