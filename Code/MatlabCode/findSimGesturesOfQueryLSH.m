function findSimGesturesOfQueryLSH(Path,allHashFunctions,allHashValues,allBckts,testFileName,noSimFilesReqd)
    files = dir(Path);
    isDir = [files(:).isdir];
    folders = {files(isDir).name};
    folders(ismember(folders,{'.','..','Outputs','test'})) = [];
    folderCount=length(folders);
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
               testFile = csvread(strcat(Path,'\test\',folders{folder},'\',testFileName,'_PCA_TF-IDF_DB.csv'));
               nCols = size(testFile,2);
               product = layerHashFns(i,:) * testFile;
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
    bucketCount = size(bucketsToCheck,2);
    javaSetObj = java.util.HashSet;
    for i=1:bucketCount
        filesInBucket = allBckts{1,i};
        arr = regexp(filesInBucket,';','split');
        noFiles = size(arr,2);
        for j=1:noFiles
           javaSetObj.add(arr{j}); 
        end
    end
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
           gestureFile = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_PCA_TF-IDF\',fileName)); 
           query = csvread(strcat(Path,'\test\',folders{folder},'\',testFileName,'_PCA_TF-IDF_DB.csv'));
           nColumns = size(gestureFile,2);
           dotProduct = dot(query,gestureFile);
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
    fid=fopen(strcat(Path,'\Outputs\Phase3-Task2\',testFileName,'-topSimilarFiles.csv'),'wt');
    csvFun = @(str)sprintf('%s,',str);
    xchar = cellfun(csvFun, topFiles, 'UniformOutput', false);
    xchar = strcat(xchar{:});
    xchar = strcat(xchar(1:end-1),'\n');
    fprintf(fid,xchar);
    fclose(fid);
end