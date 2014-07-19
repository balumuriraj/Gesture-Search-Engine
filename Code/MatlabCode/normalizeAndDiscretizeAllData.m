function normalizeAndDiscretizeAllData(Path,dimensionFolder)
    mkdir(Path,'Outputs');
    mkdir(strcat(Path,'\Outputs'),'Task1');
    mkdir(strcat(Path,'\Outputs'),'Task2');
    mkdir(strcat(Path,'\Outputs'),'Task3');
    mkdir(strcat(Path,'\Outputs\Task1'),strcat(dimensionFolder,'-Normalized')); 
    mkdir(strcat(Path,'\Outputs\Task1'),strcat(dimensionFolder,'-Discretized')); 
    inputPath = strcat(Path,'\',dimensionFolder,'\*.csv');
    files = dir(inputPath);
    num_files = length(files);
    for doc=1:num_files
      normData = normalizeCSV(strcat(Path,'\',dimensionFolder,'\'),files(doc).name,strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Normalized\',files(doc).name));
      discretizeNormData(Path,normData,strcat('\Outputs\Task1\',dimensionFolder,'-Discretized\',files(doc).name));
    end
end