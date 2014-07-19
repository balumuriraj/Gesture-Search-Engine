function projectTestFileIntoPC(Path,FileName,option)
    allPrComponents = csvread(strcat(Path,'\Outputs\Phase2-Task1\1A\',option,'\allSensorsPC.csv'));
    if (strcmp(option,'LDA')==1)
        testFileTF = csvread(strcat(Path,'\Outputs\Task3\',FileName,'-FREQ.csv'));
    else
        testFileTF = csvread(strcat(Path,'\Outputs\Task3\',FileName,'_TF-IDF.csv'));
    end
    testTranspose = transpose(testFileTF);
    testProjection = testTranspose*allPrComponents;
    csvwrite(strcat(Path,'\Outputs\Phase2-Task1\1B\',FileName,'_',option,'_TF-IDF.csv'),transpose(testProjection));
end