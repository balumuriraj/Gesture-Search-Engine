function projectTestFileIntoPC_DB_New(Path,FileName,option)
    files = dir(Path);
    isDir = [files(:).isdir];
    folders = {files(isDir).name}';
    folders(ismember(folders,{'.','..','Outputs','test'})) = [];
    foldersCount=length(folders);
    allPrComponents = csvread(strcat(Path,'\Outputs\Phase2-Task1\',option,'_DB\allSensorsPC.csv'));
    for folder=1:foldersCount
        if (strcmp(option,'LDA')==1)
            testFileTF = csvread(strcat(Path,'\test\',folders{folder},'\',FileName,'-FREQ.csv'));
        else
            testFileTF = csvread(strcat(Path,'\test\',folders{folder},'\',FileName,'_TF-IDF.csv'));
        end
        testTranspose = transpose(testFileTF);
        testProjection = testTranspose*allPrComponents;
        csvwrite(strcat(Path,'\test\',folders{folder},'\',FileName,'_',option,'_TF-IDF_DB.csv'),transpose(testProjection));
    end  
end