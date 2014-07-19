function normalizeAndDiscretizeDB(Path,windowSize,shift)  
%     files = dir(inputPath);
%     filesCount = length(files);
    files = dir(Path);
    isDir = [files(:).isdir];
    folders = {files(isDir).name}';
    folders(ismember(folders,{'.','..','Outputs','test'})) = [];
    filesCount=length(folders);
%     mkdir(strcat(Path,'\Outputs\'),'Phase2-Task1'); 
    for i=1:filesCount
        mkdir(strcat(Path,'\Outputs\Phase2-Task1'),strcat(folders{i},'-Normalized'));
        mkdir(strcat(Path,'\Outputs\Phase2-Task1'),strcat(folders{i},'-Discretized'));
        newInputPath = strcat(Path,'\',folders{i},'\*.csv');
        csvFiles = dir(newInputPath);
        num_files = length(csvFiles);
        for j=1:num_files
            normData = normalizeCSV(strcat(Path,'\',folders{i},'\'),csvFiles(j).name,strcat(Path,'\Outputs\Phase2-Task1\',folders{i},'-Normalized\',csvFiles(j).name));
            discretizeNormData(Path,normData,strcat('\Outputs\Phase2-Task1\',folders{i},'-Discretized\',csvFiles(j).name));
        end
    end
    identifyGestureWordsDB(Path,folders,windowSize,shift);
    calculateTFvaluesDB(Path,folders,windowSize,shift);
    calculateFrequecyValuesDB(Path,folders,windowSize,shift);
%     findTopFiveGesturesInDB_TFIDF(Path,folders,FileName,windowSize,shift);
%     findTopFiveGesturesInDB_TFIDF2(Path,folders,FileName);
end