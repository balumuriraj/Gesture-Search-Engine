function projectTestGestureInTo203(Path,testFileName,option)
    files = dir(Path);
    isDir = [files(:).isdir];
    folders = {files(isDir).name};
    folders(ismember(folders,{'.','..','Outputs','test'})) = [];
    folderCount=length(folders);
    inputPath = strcat(Path,'\',folders{1},'\*.csv');
    csvFiles = dir(inputPath);
    tempFile = csvread(strcat(Path,'\',folders{1},'\',csvFiles(1).name));
    sensorCount = size(tempFile,1);
    for folder=1:folderCount
        folderProjectedData = [];
        testFile = csvread(strcat(Path,'\test\',folders{folder},'\',testFileName,'_TF-IDF.csv'));
        for i=1:sensorCount
            sensorTopSemantics = csvread(strcat(Path,'\Outputs\Phase2-Task1\',option,'_DB\Sensor-',int2str(i),'\LatentSemantics.csv'));
            gestureSensorData = testFile(:,i);
            product = transpose(gestureSensorData)*sensorTopSemantics;
            folderProjectedData = [folderProjectedData; product];
        end
        csvwrite(strcat(Path,'\test\',folders{folder},'\',testFileName,'-Projected.csv'),folderProjectedData);
    end
end