function calculateGestureGestureSimilarity(Path,option)
    foldersList = dir(Path);
    isDir = [foldersList(:).isdir];
    folders = {foldersList(isDir).name}';
    folders(ismember(folders,{'.','..','Outputs','test'})) = [];
    foldersCount=length(folders);
    mkdir(strcat(Path,'\Outputs'),'Phase2-Task2');
%     mkdir(strcat(Path,'\Outputs\Phase2-Task2'),'2B');
    for folder=1:foldersCount
        csvPath = strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_',option,'\*.csv');
        csvFiles = dir(csvPath);
        num_files = length(csvFiles);
        similarityMatrix = [];
        if(folder==1)
            similaritySum = zeros(num_files,num_files);
        end
        fileNamesOrder = cell(num_files);
        for i=1:num_files
            fileNamesOrder{i} = csvFiles(i).name;
            baseFile = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_',option,'\',csvFiles(i).name));
            nColumns = size(baseFile,2);
            AllFilesSimVector = [];
            for j=1:num_files
                testFile = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_',option,'\',csvFiles(j).name));
                normProducts = [];
                cosSimilarity = [];
                dotProduct = dot(baseFile,testFile);
                for k=1:nColumns
                    normProducts = [normProducts norm(baseFile(:,k))*norm(testFile(:,k))];
                end
               for k=1:nColumns
                   if(dotProduct(1,k)==0&&normProducts(1,k)==0)
                       cosSimilarity(1,k) = 0;
                   else
                       cosSimilarity(1,k) = dotProduct(1,k)/normProducts(1,k);
                   end
               end
               AllFilesSimVector = [AllFilesSimVector; cosSimilarity];                
            end
            allFilesDistances = sum(AllFilesSimVector,2);
            similarityMatrix = [similarityMatrix; transpose(allFilesDistances)];
        end
%         csvwrite(strcat(Path,'\Outputs\Phase2-Task2\2B\',folders{folder},'_Similarity_',option,'.csv'),similarityMatrix);
        similaritySum = similaritySum + similarityMatrix;
        fid=fopen(strcat(Path,'\Outputs\Phase2-Task2\',folders{folder},'-fileOrderInMatrix-',option,'.csv'),'wt');
        csvFun = @(str)sprintf('%s,',str);
        xchar = cellfun(csvFun, fileNamesOrder, 'UniformOutput', false);
        xchar = strcat(xchar{:});
        xchar = strcat(xchar(1:end-1),'\n');
        fprintf(fid,xchar);
        fclose(fid);
    end
%     similaritySum = zeros(num_files,num_files);
%     for folder=1:foldersCount
%         compSim = csvread(strcat(Path,'\Outputs\Phase2-Task2\2B\',folders{folder},'_Similarity_',option,'.csv'));
%         similaritySum = similaritySum + compSim;
%     end
    csvwrite(strcat(Path,'\Outputs\Phase2-Task2\gestureSimilarity-',option,'.csv'),similaritySum);
end