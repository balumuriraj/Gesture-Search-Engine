function calculateTFIDFvalues_DB(Path,folders,totalDFvector,docsNo)
   foldersCount=length(folders);
   for folder=1:foldersCount
       mkdir(strcat(Path,'\Outputs\Phase2-Task1'),strcat(folders{folder},'_TF-IDF'));
       nRows = size(totalDFvector,1);
       IDFvector = zeros(nRows,1);
       for i=1:nRows
           if(totalDFvector(i,1)==docsNo)
               IDFvector(i,1) = log(docsNo/(totalDFvector(i,1)-1)); 
           else
               IDFvector(i,1) = log(docsNo/totalDFvector(i,1)); 
           end
       end
       csvwrite(strcat(Path,'\Outputs\Phase2-Task1\','IDF_DB.csv'),IDFvector);

       inputPath = strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_TF\*.csv');
       files = dir(inputPath);
       num_files = length(files);    
       for i=1:num_files
           sheetTF = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_TF\',files(i).name));
           sheetTFIDF = bsxfun(@times,sheetTF,IDFvector);
           csvwrite(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_TF-IDF\',files(i).name),sheetTFIDF);
       end
   end
end