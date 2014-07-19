function projectDataIntoPC(Path,dimensionFolder,option)
    if (strcmp(option,'LDA')==1)
        inputPath = strcat(Path,'\Outputs\Task1\',dimensionFolder,'-FREQ\','*.csv');
    else
        inputPath = strcat(Path,'\Outputs\Task1\',dimensionFolder,'_TF-IDF\','*.csv');
    end
    files = dir(inputPath);
    num_files = length(files);
    randomTFIDFFile = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'_TF-IDF\',files(1).name));
    nColumns = size(randomTFIDFFile,2);
    allPrComponents = [];
    for i=1:nColumns
        pcFilePath = strcat(Path,'\Outputs\Phase2-Task1\1A\',option,'\Sensor-',int2str(i),'\LatentSemantics.csv');
        pcFile = csvread(pcFilePath);
        allPrComponents = [allPrComponents pcFile];
    end
    csvwrite(strcat(Path,'\Outputs\Phase2-Task1\1A\',option,'\allSensorsPC.csv'),allPrComponents);
    mkdir(strcat(Path,'\Outputs\Phase2-Task1\1B\'),strcat(dimensionFolder,'_',option,'_TF-IDF'));
    for i=1:num_files
        if (strcmp(option,'LDA')==1)
            tfIdfFile = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-FREQ\',files(i).name));
        else
            tfIdfFile = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'_TF-IDF\',files(i).name));
        end
        transposeFile = transpose(tfIdfFile);
        projectionInPC = transposeFile*allPrComponents;
        csvwrite(strcat(Path,'\Outputs\Phase2-Task1\1B\',dimensionFolder,'_',option,'_TF-IDF\',files(i).name),transpose(projectionInPC));
    end
%     testFileTF = csvread(strcat(Path,'\Outputs\Task3\',FileName,'_TF-IDF.csv'));
%     testTranspose = transpose(testFileTF);
%     testProjection = testTranspose*allPrComponents;
%     csvwrite(strcat(Path,'\Outputs\Phase2-Task1\1B\',FileName,'_',option,'_TF-IDF.csv'),transpose(testProjection));
end