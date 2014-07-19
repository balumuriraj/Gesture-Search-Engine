function topFive = findTopFiveSimilarGesturesLatent(Path,FileName,dimensionFolder,option)
   inputPath = strcat(Path,'\Outputs\Phase2-Task1\1B\',dimensionFolder,'_',option,'_TF-IDF\','*.csv');
   files = dir(inputPath);
   num_files = length(files);
   randomFile = csvread(strcat(Path,'\Outputs\Phase2-Task1\1B\',dimensionFolder,'_',option,'_TF-IDF\',files(1).name));
   nColumns = size(randomFile,2);
   testFileTF = csvread(strcat(Path,'\Outputs\Phase2-Task1\1B\',FileName,'_',option,'_TF-IDF.csv'));
   AllFilesSimVector = [];
   hm = java.util.HashMap;
   for i=1:num_files
       hm.put(i,files(i).name);
       normProducts = [];
       cosSimilarity = [];
       sheetTF = csvread(strcat(Path,'\Outputs\Phase2-Task1\1B\',dimensionFolder,'_',option,'_TF-IDF\',files(i).name));
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
%        cosSimilarity = dotProduct ./ normProducts;
       AllFilesSimVector = [AllFilesSimVector; cosSimilarity];
   end
   allFilesDistances = sum(AllFilesSimVector,2);
   [sortedDist,sortedIndex] = sort(allFilesDistances(:),'descend');
   topFiveIndex = sortedIndex(1:5);
   topFiveFiles = cell(5,1);
   for i=1:5
      topFiveFiles{i} = hm.get(topFiveIndex(i));
   end
   
   fid=fopen(strcat(Path,'\Outputs\Phase2-Task1\1B\',FileName,'-topFiveFiles-',option,'.csv'),'wt');
   csvFun = @(str)sprintf('%s,',str);
   xchar = cellfun(csvFun, topFiveFiles, 'UniformOutput', false);
   xchar = strcat(xchar{:});
   xchar = strcat(xchar(1:end-1),'\n');
   fprintf(fid,xchar);
   fclose(fid);
   
   topFive = topFiveFiles;
end