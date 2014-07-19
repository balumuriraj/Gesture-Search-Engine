function getClusters_New(Path,mainOption,subOption)
    foldersList = dir(Path);
    isDir = [foldersList(:).isdir];
    folders = {foldersList(isDir).name}';
    folders(ismember(folders,{'.','..','Outputs','test'})) = [];
%     foldersCount=length(folders);
    mkdir(strcat(Path,'\Outputs'),'Phase2-Task3');
    if(strcmp(mainOption,'PCA')==1)
        gestureLatentSemantics = csvread(strcat(Path,'\Outputs\Phase2-Task2\2B\top3-PrincipalComponents',mainOption,'-',subOption,'.csv'));
    else
        gestureLatentSemantics = csvread(strcat(Path,'\Outputs\Phase2-Task2\2C\top3-PrincipalComponents',mainOption,'-',subOption,'.csv'));
    end
    simMatrix = csvread(strcat(Path,'\Outputs\Phase2-Task2\gestureSimilarity-',subOption,'.csv'));
    projectSimMatrix = simMatrix*gestureLatentSemantics;
    IDX = kmeans(projectSimMatrix,3);
    nRows = size(IDX,1);
%     [C,I] = max(gestureLatentSemantics,[],2);
    csvPath = strcat(Path,'\Outputs\Phase2-Task1\',folders{1},'_',subOption,'\*.csv');
    csvFiles = dir(csvPath);
    num_files = length(csvFiles);
    fileNamesOrder = cell(num_files);
    for i=1:num_files
        fileNamesOrder{i} = csvFiles(i).name;
    end
    firstCluster = cell(num_files);
    secondCluster = cell(num_files);
    thirdCluster = cell(num_files);
    firstCount = 0;
    secondCount = 0;
    thirdCount = 0;
    for i=1:nRows
%         for j=1:3
%            if(clusterBool(i,j)==1)
               switch(IDX(i,1))
                    case 1
                        firstCount = firstCount+ 1;
                        firstCluster{firstCount} =  fileNamesOrder{i};
                    case 2
                        secondCount = secondCount+ 1;
                        secondCluster{secondCount} =  fileNamesOrder{i};
                    case 3
                        thirdCount = thirdCount+ 1;
                        thirdCluster{thirdCount} =  fileNamesOrder{i};
               end 
%            end
%         end
    end
    fid=fopen(strcat(Path,'\Outputs\Phase2-Task3\',mainOption,'-',subOption,'-clusters.csv'),'wt');
    csvFun = @(str)sprintf('%s,',str);
    xchar = cellfun(csvFun,firstCluster,'UniformOutput', false);
    xchar = strcat(xchar{:});
    xchar = strcat(xchar(1:end-1),'\n');
    ychar = cellfun(csvFun,secondCluster,'UniformOutput', false);
    ychar = strcat(ychar{:});
    ychar = strcat(ychar(1:end-1),'\n');
    zchar = cellfun(csvFun,thirdCluster,'UniformOutput', false);
    zchar = strcat(zchar{:});
    zchar = strcat(zchar(1:end-1),'\n');
    fprintf(fid,xchar);
    fprintf(fid,ychar);
    fprintf(fid,zchar);
    fclose(fid);
end