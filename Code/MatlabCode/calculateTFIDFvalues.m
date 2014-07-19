function calculateTFIDFvalues(Path,dimensionFolder,totalDFvector,docsNo)
   mkdir(strcat(Path,'\Outputs\Task1'),strcat(dimensionFolder,'_TF-IDF'));
   nRows = size(totalDFvector,1);
   IDFvector = zeros(nRows,1);
   for i=1:nRows
       if(totalDFvector(i,1)==docsNo)
           IDFvector(i,1) = log(docsNo/(totalDFvector(i,1)-1)); 
       else
           IDFvector(i,1) = log(docsNo/totalDFvector(i,1)); 
       end
   end
   csvwrite(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-IDF.csv'),IDFvector);
   
   inputPath = strcat(Path,'\Outputs\Task1\',dimensionFolder,'-TF\*.csv');
   files = dir(inputPath);
   num_files = length(files);    
   for i=1:num_files
       sheetTF = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-TF\',files(i).name));
       sheetTFIDF = bsxfun(@times,sheetTF,IDFvector);
       csvwrite(strcat(Path,'\Outputs\Task1\',dimensionFolder,'_TF-IDF\',files(i).name),sheetTFIDF);
   end
end