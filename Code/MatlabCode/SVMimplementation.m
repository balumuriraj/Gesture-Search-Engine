function SVMimplementation(Path)
    files = dir(Path);
    isDir = [files(:).isdir];
    folders = {files(isDir).name};
    folders(ismember(folders,{'.','..','Outputs','test'})) = [];
    folderCount=length(folders);
    inputPath = strcat(Path,'\',folders{1},'\*.csv');
    csvFiles = dir(inputPath);
    num_files = length(csvFiles);   
%     finding all file names in numbers
    csvFileNameStrings = {csvFiles.name};
    str  = sprintf('%s#', csvFileNameStrings{:});
    num  = sscanf(str, '%d.csv#');
    [allCsvFileNames, index] = sort(num);
%     ending    
    [trainedFileNames,fileLabels] = xlsread(strcat(Path,'\labels.csv'));
    untrainedFiles = [];
    for i=1:num_files
%         checking if file is present in trained data
        if(size(find(trainedFileNames==allCsvFileNames(i,1)),1)==0)
            untrainedFiles = [untrainedFiles;allCsvFileNames(i,1)];
        end
    end
    trainingDataFilesCount = size(trainedFileNames,1);
    LabelNames = unique(fileLabels);
    labelCount = size(LabelNames,1);
    fileLabelMembership = zeros(trainingDataFilesCount,labelCount);
    for i=1:trainingDataFilesCount
       for j=1:labelCount
           if(fileLabels{i,1}==LabelNames{j,1})
               fileLabelMembership(i,j)=1;
               break;
           end
       end 
    end
    count = 1;
    SVMresultSum = zeros(size(untrainedFiles,1),labelCount);
    wValues = [];
    bValues = [];
    labelCombinations = [];
    for index1=1:labelCount-1
        for index2=index1+1:labelCount
            [queriesOutput,w,b] = binarySVM(Path,fileLabelMembership,allCsvFileNames,trainedFileNames,untrainedFiles,index1,index2);
            wValues = [wValues;w];
            bValues = [bValues;b];
            labelCombinations = [labelCombinations;index1 index2];
            untrainedCount = size(queriesOutput,1);
            svmLabelDecisions = zeros(untrainedCount,labelCount);
            for i=1:untrainedCount
                if(queriesOutput(i,2)>=1)
                    svmLabelDecisions(i,index1)=1;      
                end
                if(queriesOutput(i,2)<=-1)
                    svmLabelDecisions(i,index2)=1;
                end
            end
            SVMresultSum = SVMresultSum + svmLabelDecisions;
            count = count+1;
        end
        count = count+1;
    end
    labelProportions = zeros(size(untrainedFiles,1),labelCount);
    for i=1:size(untrainedFiles,1)
        rowSum = sum(SVMresultSum(i,:));
        for j=1:labelCount
           gestureLabelWeight =  SVMresultSum(i,j);
           if(gestureLabelWeight==0&&rowSum==0)
               labelProportions(i,j)=0;
           else
               labelProportions(i,j)=gestureLabelWeight/rowSum;
           end
        end
    end
    gestures = csvread(strcat(Path,'\Outputs\Phase2-Task1\Projected\output.csv'));
    finalOutput = zeros(size(labelProportions,1),1);
    for i=1:size(labelProportions,1)
        [C,I] = max(labelProportions(i,:));
        if(C>0.5)
            finalOutput(i,1) = I;
        else
            gestureIndex = find(allCsvFileNames==untrainedFiles(i,1));
            gestureVector = gestures(gestureIndex,:);
            gestureSigns = zeros(size(wValues,1),1);
            for j=1:size(wValues,1)
                distanceFromPlane = dot(wValues(j,:),gestureVector)+b;
                modW = norm(wValues(j,:));
                if(distanceFromPlane==0&&modW==0)
                    gestureSigns(j,1) = 0;
                else
                    gestureSigns(j,1) = distanceFromPlane/modW;
                end
            end
            [c1,I1] = max(abs(gestureSigns(:,1)));
            if(gestureSigns(I1,1)<0)
                finalOutput(i,1) = labelCombinations(I1,2);
            else
                finalOutput(i,1) = labelCombinations(I1,1);
            end
        end
    end
    javaMap = java.util.HashMap;
    outputToWrite = cell(size(untrainedFiles,1),2);
    for i=1:size(untrainedFiles,1)
        outputToWrite{i,1} = untrainedFiles(i);
        outputToWrite{i,2} = LabelNames{finalOutput(i,1),1};
        javaMap.put(untrainedFiles(i),LabelNames{finalOutput(i,1),1});
    end
    mkdir(strcat(Path,'\Outputs'),'Phase3-Task3\SVM');
    xlswrite(strcat(Path,'\Outputs\Phase3-Task3\SVM\output.csv'),outputToWrite);
    disp('hii');
end