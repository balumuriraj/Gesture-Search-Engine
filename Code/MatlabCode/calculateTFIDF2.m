function calculateTFIDF2(Path,dimensionFolder,sheetName,sheetTFvector,DF2vector,docsNo)
   nRows = size(DF2vector,1);
   IDF2vector = zeros(nRows,1);
   for i=1:nRows
       if(DF2vector(i,1)~=0)
           if(DF2vector(i,1)==docsNo)
              IDF2vector(i,1) = log(docsNo/(DF2vector(i,1)-1));  
           else
              IDF2vector(i,1) = log(docsNo/DF2vector(i,1)); 
           end
       else
          IDF2vector(i,1) = log(docsNo/(DF2vector(i,1)+1));
       end
   end
   csvwrite(strcat(Path,'\Outputs\Task1\',dimensionFolder,'_IDF2\',sheetName),IDF2vector);
   sheetTFIDF2 = bsxfun(@times,sheetTFvector,IDF2vector);
   csvwrite(strcat(Path,'\Outputs\Task1\',dimensionFolder,'_TF-IDF2\',sheetName),sheetTFIDF2);
end