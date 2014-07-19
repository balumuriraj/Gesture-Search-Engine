function projectTestFileIntoPC_DB(Path,FileName,option)
    allPrComponents = csvread(strcat(Path,'\Outputs\Phase2-Task1\',option,'_DB\allSensorsPC.csv'));
    if (strcmp(option,'LDA')==1)
        testFileTF = csvread(strcat(Path,'\Outputs\Phase2-Task1\',FileName,'-FREQ.csv'));
    else
        testFileTF = csvread(strcat(Path,'\Outputs\Phase2-Task1\',FileName,'_TF-IDF.csv'));
    end
    testTranspose = transpose(testFileTF);
    testProjection = testTranspose*allPrComponents;
    csvwrite(strcat(Path,'\Outputs\Phase2-Task1\',FileName,'_',option,'_TF-IDF_DB.csv'),transpose(testProjection));
end