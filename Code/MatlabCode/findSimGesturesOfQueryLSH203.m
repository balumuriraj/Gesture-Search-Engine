function [similarFiles,fileCounts] = findSimGesturesOfQueryLSH203(Path,allHashFunctions,allHashValues,allBckts,testFileName,noSimFilesReqd)
    files = dir(Path);
    isDir = [files(:).isdir];
    folders = {files(isDir).name};
    folders(ismember(folders,{'.','..','Outputs','test'})) = [];
    folderCount=length(folders);
    inputPath = strcat(Path,'\',folders{1},'\*.csv');
    csvFiles = dir(inputPath);
    num_files = length(csvFiles);   
    noLayers = size(allHashFunctions,1);
    allLayersHashValues = [];
    for layer=1:noLayers
        temp = allHashFunctions(layer,:,:);
        layerHashFns = squeeze(temp);
        noHashsInLayer = size(layerHashFns,1);
        layerHashValues = [];
        for i=1:noHashsInLayer
           folderWiseSum = [];
           for folder=1:folderCount
               testFile = csvread(strcat(Path,'\test\',folders{folder},'\',testFileName,'-Projected.csv'));
               product = layerHashFns(i,:) * transpose(testFile);
               nCols = size(product,2);
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
        allLayersHashValues = [allLayersHashValues; layerHashValues];
    end
    totalHashValues = size(allHashValues,1);
    bucketsToCheck = [];
    for i=1:noLayers
        for j=1:totalHashValues
            if(isequal(allLayersHashValues(i,:),allHashValues(j,:)))
                bucketsToCheck = [bucketsToCheck j];
                break;
            end
        end
    end
    totalFilesConsidered = 0;
    bucketCount = size(bucketsToCheck,2);
    javaSetObj = java.util.HashSet;
    for i=1:bucketCount
        filesInBucket = allBckts{1,bucketsToCheck(1,i)};
        arr = regexp(filesInBucket,';','split');
        noFiles = size(arr,2);
        totalFilesConsidered = totalFilesConsidered + noFiles;
        for j=1:noFiles
           javaSetObj.add(arr{j}); 
        end
    end
     
    extraBucketsToCheck = [];
    noMismatchingsAllowed = 1;
    while(javaSetObj.size()<noSimFilesReqd)
       for i=1:noLayers
           queryHash = allLayersHashValues(i,:);
           for j=1:totalHashValues
                  existingHash = allHashValues(j,:);
                  DigitsMatched = size(find(queryHash==existingHash),2);
                  if(DigitsMatched>=(noHashsInLayer-noMismatchingsAllowed)&&DigitsMatched<noHashsInLayer)
                      extraBucketsToCheck = [extraBucketsToCheck j];
                      break;
                  end
           end
       end       
       for i=1:size(extraBucketsToCheck,2)
            filesInBucket = allBckts{1,extraBucketsToCheck(1,i)};
            arr = regexp(filesInBucket,';','split');
            noNewFiles = size(arr,2);
            totalFilesConsidered = totalFilesConsidered + noNewFiles;
            for j=1:noNewFiles
                javaSetObj.add(arr{j}); 
            end
       end   
       noMismatchingsAllowed = noMismatchingsAllowed + 1;
    end
    uniqueFileCount = javaSetObj.size(); 
    javaIteratorObj = javaSetObj.iterator();
    allFilesDistances = [];
    hm = java.util.HashMap;
    count = 1;
    while(javaIteratorObj.hasNext())
        folderwiseDistance = [];
        fileName = javaIteratorObj.next();
        hm.put(count,fileName);
        for folder=1:folderCount
           cosSimilarity = [];
           normProducts = [];
           gestureFile = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-Projected\',fileName));
           gestureFile = transpose(gestureFile);
           query = csvread(strcat(Path,'\test\',folders{folder},'\',testFileName,'-Projected.csv'));
           query = transpose(query);
           dotProduct = dot(query,gestureFile);
           nColumns = size(dotProduct,2);
           for j=1:nColumns
               normProducts = [normProducts norm(gestureFile(:,j))*norm(query(:,j))];
           end
           for k=1:nColumns
               if(dotProduct(1,k)==0&&normProducts(1,k)==0)
                   cosSimilarity(1,k) = 0;
               else
                   cosSimilarity(1,k) = dotProduct(1,k)/normProducts(1,k);
               end
           end
           folderwiseDistance = [folderwiseDistance sum(cosSimilarity,2)];
        end
        allFilesDistances = [allFilesDistances; sum(folderwiseDistance,2)];
        count = count + 1;
    end
    [sortedDist,sortedIndex] = sort(allFilesDistances(:),'descend');
    topFilesIndex = sortedIndex(1:noSimFilesReqd);
    topFiles = cell(noSimFilesReqd,1);
    for i=1:noSimFilesReqd
       topFiles{i} = hm.get(topFilesIndex(i));
    end
    output2 = cell(1,2);
    output2{1,1} = int2str(totalFilesConsidered);
    output2{1,2} = int2str(uniqueFileCount);
    similarFiles = topFiles;
    fileCounts = output2;
%     fid=fopen(strcat(Path,'\Outputs\Phase3-Task2\',testFileName,'-topSimilarFiles.csv'),'wt');
%     csvFun = @(str)sprintf('%s,',str);
%     xchar = cellfun(csvFun, topFiles, 'UniformOutput', false);
%     xchar = strcat(xchar{:});
%     xchar = strcat(xchar(1:end-1),'\n');
%     fprintf(fid,xchar);
%     fclose(fid);
end