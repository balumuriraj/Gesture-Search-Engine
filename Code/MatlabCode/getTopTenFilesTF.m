function topTen = getTopTenFilesTF(Path,FileName,dimensionFolder)
   testFileTF = csvread(strcat(Path,'\Outputs\Task3\',FileName,'-TF.csv'));
   nColumns = size(testFileTF,2);
   inputPath = strcat(Path,'\Outputs\Task1\',dimensionFolder,'-TF\','*.csv');
   files = dir(inputPath);
   num_files = length(files);
   AllFilesSimVector = [];
   hm = java.util.HashMap;
   for i=1:num_files
       hm.put(i,files(i).name);
       normProducts = [];
       cosSimilarity = [];
       sheetTF = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-TF\',files(i).name));
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
   topTenIndex = sortedIndex(1:10);
   topTenFiles = cell(10,1);
   for i=1:10
      topTenFiles{i} = hm.get(topTenIndex(i));
   end
   
   fid=fopen(strcat(Path,'\Outputs\Task3\','topTenFiles-TF.csv'),'wt');
   csvFun = @(str)sprintf('%s,',str);
   xchar = cellfun(csvFun, topTenFiles, 'UniformOutput', false);
   xchar = strcat(xchar{:});
   xchar = strcat(xchar(1:end-1),'\n');
   fprintf(fid,xchar);
   fclose(fid);
   
   topTen = topTenFiles;
end