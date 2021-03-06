function topFive = findTopFiveGesturesInDB_TFIDF_New(Path,FileName)
   files = dir(Path);
   isDir = [files(:).isdir];
   folders = {files(isDir).name}';
   folders(ismember(folders,{'.','..','Outputs','test'})) = [];
   foldersCount=length(folders);
   hm = java.util.HashMap;
   allFilesDistances = [];
   for folder=1:foldersCount
       testFileTF = csvread(strcat(Path,'\test\',folders{folder},'\',FileName,'_TF-IDF.csv'));
       nColumns = size(testFileTF,2);
       inputPath = strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_TF-IDF\','*.csv');
       files = dir(inputPath);
       num_files = length(files);
       AllFilesSimVector = [];
       for i=1:num_files
            hm.put(i,files(i).name);
            normProducts = [];
            cosSimilarity = [];
            sheetTF = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_TF-IDF\',files(i).name));
            dotProduct = dot(testFileTF,sheetTF);
            for j=1:nColumns
                normProducts = [normProducts norm(sheetTF(:,j))*norm(testFileTF(:,j))];
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
       allFilesDistances = [allFilesDistances sum(AllFilesSimVector,2)];     
   end
    allDimDistances =  sum(allFilesDistances,2);
   [sortedDist,sortedIndex] = sort(allDimDistances(:),'descend');
%    sortedDist
%    sortedIndex
   topFiveIndex = sortedIndex(1:5);
   topFiveFiles = cell(5,1);
   for i=1:5
      topFiveFiles{i} = hm.get(topFiveIndex(i));
   end
   mkdir(strcat(Path,'\Outputs\Phase2-Task1'),'1C');
   fid=fopen(strcat(Path,'\Outputs\Phase2-Task1\1C\',FileName,'_DB_topFiveFiles-TFIDF.csv'),'wt');
   csvFun = @(str)sprintf('%s,',str);
   xchar = cellfun(csvFun, topFiveFiles, 'UniformOutput', false);
   xchar = strcat(xchar{:});
   xchar = strcat(xchar(1:end-1),'\n');
   fprintf(fid,xchar)
   fclose(fid);
   topFive = topFiveFiles;
end