function [allHFunctions,allHValues,allBckts] = LSHimplementation(Path,noLayers,noHashs)
    files = dir(Path);
    isDir = [files(:).isdir];
    folders = {files(isDir).name};
    folders(ismember(folders,{'.','..','Outputs','test'})) = [];
    folderCount=length(folders);
    inputPath = strcat(Path,'\',folders{1},'\*.csv');
    csvFiles = dir(inputPath);
    num_files = length(csvFiles);
    tempFile = csvread(strcat(Path,'\',folders{1},'\',csvFiles(1).name));
    nDims = size(tempFile,1) * 3;
    allHashFunctions = zeros(noLayers,noHashs,nDims);
    allHashValues = [];
    allBuckets = {};
    mkdir(strcat(Path,'\Outputs'),'Phase3-Task2');
%     mkdir(strcat(Path,'\Outputs\Phase3-Task2'),'HashFunctions');
    for layer=1:noLayers
        r = randn(noHashs,nDims);
        unitR = [];
        for i=1:noHashs
            vectorLength = norm(r(i,:));
            unitVector = r(i,:)/vectorLength;
            unitR = [unitR; unitVector];
        end
        allHashFunctions(layer,:,:) = unitR;
%         csvwrite(strcat(Path,'\Outputs\Phase3-Task2\HashFunctions\Layer',int2str(layer),'.csv'),unitR);
        for i=1:num_files
            layerHashValues = [];
            for j=1:noHashs
                folderWiseSum = [];
                for folder=1:folderCount
                   tfIdfFile = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_PCA_TF-IDF\',csvFiles(i).name));
                   nCols = size(tfIdfFile,2);
                   product = unitR(j,:) * tfIdfFile;
                   for k=1:nCols
                       if(product(1,k)>=0)
                          product(1,k) = 1; 
                       else
                          product(1,k) = 0;
                       end
                   end
                   folderWiseSum = [folderWiseSum; product];
                end
                for k=1:folderCount-1
                    xorTempResult = xor(folderWiseSum(k,:),folderWiseSum(k+1,:));
                    folderWiseSum(k+1,:) = xorTempResult;
                end
                xorResult = folderWiseSum(folderCount,:);
                gestureHash = ceil(sum(xorResult,2)/10);
                layerHashValues = [layerHashValues gestureHash];
            end
            layerHashValues = [layer layerHashValues];
            nRows = size(allHashValues,1);
            if(nRows>0)
                flag = 0;
                for row=1:nRows
                    if(isequal(allHashValues(row,:),layerHashValues))
                        flag = 1;
                        temp = strcat(allBuckets{row},';',csvFiles(i).name);
                        allBuckets{row} = temp;
                        break;
                    end
                end
                if(flag==0)
                    allHashValues = [allHashValues; layerHashValues];
                    allBuckets{nRows+1} = csvFiles(i).name;
                end
            else
                allHashValues = [allHashValues; layerHashValues];
                allBuckets = {csvFiles(i).name};
            end
        end        
    end
    allHFunctions = allHashFunctions;
    allHValues = allHashValues;
    allBckts = allBuckets;
end