function projectAllDBDataIntoPC(Path,option)
    files = dir(Path);
    isDir = [files(:).isdir];
    folders = {files(isDir).name}';
    folders(ismember(folders,{'.','..','Outputs','test'})) = [];
    folderCount=length(folders);
    randomPath = strcat(Path,'\Outputs\Phase2-Task1\',folders{1},'_TF-IDF\*.csv');
    randomFiles = dir(randomPath);
    randomTFIDFFile = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{1},'_TF-IDF\',randomFiles(1).name));
    nColumns = size(randomTFIDFFile,2);
    allPrComponents = [];
    for i=1:nColumns
        pcFilePath = strcat(Path,'\Outputs\Phase2-Task1\',option,'_DB\Sensor-',int2str(i),'\LatentSemantics.csv');
        pcFile = csvread(pcFilePath);
        allPrComponents = [allPrComponents pcFile];
    end
    csvwrite(strcat(Path,'\Outputs\Phase2-Task1\',option,'_DB\allSensorsPC.csv'),allPrComponents);
    for folder=1:folderCount
        mkdir(strcat(Path,'\Outputs\Phase2-Task1'),strcat(folders{folder},'_',option,'_TF-IDF'));
        csvFilePath = strcat(Path,'\Outputs\Phase2-Task1\',folders{1},'_TF-IDF\*.csv');
        tfIdfFiles = dir(csvFilePath);
        num_files = length(tfIdfFiles);
        for i=1:num_files
            if (strcmp(option,'LDA')==1)
               tfIdf = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-FREQ\',tfIdfFiles(i).name));
            else
               tfIdf = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_TF-IDF\',tfIdfFiles(i).name));
            end
            transposeFile = transpose(tfIdf);
            projectionInPC = transposeFile*allPrComponents;
            csvwrite(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_',option,'_TF-IDF\',tfIdfFiles(i).name),transpose(projectionInPC));
        end
    end
%     testFileTF = csvread(strcat(Path,'\Outputs\Phase2-Task1\',FileName,'_TF-IDF.csv'));
%     testTranspose = transpose(testFileTF);
%     testProjection = testTranspose*allPrComponents;
%     csvwrite(strcat(Path,'\Outputs\Phase2-Task1\',FileName,'_',option,'_TF-IDF_DB.csv'),transpose(testProjection));
end