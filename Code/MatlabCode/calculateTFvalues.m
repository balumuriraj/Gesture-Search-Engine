function calculateTFvalues(Path,windowSize,shift,dimensionFolder)
  mkdir(strcat(Path,'\Outputs\Task1'),strcat(dimensionFolder,'-TF'));
  mkdir(strcat(Path,'\Outputs\Task1'),strcat(dimensionFolder,'-FREQ'));
  dictionary = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Dictionary.csv'));
  totalDictWords = size(dictionary,1);
  totalDFvector = zeros(totalDictWords,1);
  mkdir(strcat(Path,'\Outputs\Task1'),strcat(dimensionFolder,'_IDF2'));
  mkdir(strcat(Path,'\Outputs\Task1'),strcat(dimensionFolder,'_TF-IDF2'));
  inputPath = strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Discretized\','*.csv');
  files = dir(inputPath);
  num_files = length(files);
  for i=1:num_files
       discreteData = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Discretized\',files(i).name));
       nRows = size(discreteData,1);
       nColumns = size(discreteData,2);
       sheetFvector = [];
       sheetTFvector = [];
       DF2vector = zeros(totalDictWords,1);
       for j=1:nRows
           TFvector = zeros(totalDictWords,1);
           wordsPerRow = 0;
           for k=1:shift:nColumns
               wordsPerRow = wordsPerRow + 1;
               if(k+windowSize-1<=nColumns)
                   word = discreteData(j,k:k+windowSize-1);
               else
                   word = discreteData(j,k:nColumns);
                   for l=nColumns+1:k+windowSize-1
                     word = [word, discreteData(j,nColumns)];
                   end
               end
               for m=1:totalDictWords
                   if(isequal(dictionary(m,:),word))
                       TFvector(m,1) =  TFvector(m,1)+1; 
                       if(TFvector(m,1)==1)
                         totalDFvector(m,1) = totalDFvector(m,1)+1;
                         DF2vector(m,1) = DF2vector(m,1)+1;
                       end
                       break;
                   end
               end
           end
           sheetFvector = [sheetFvector TFvector];
           TFvector = TFvector/wordsPerRow;
           sheetTFvector = [sheetTFvector TFvector];
       end
       csvwrite(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-TF\',files(i).name),sheetTFvector);
       csvwrite(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-FREQ\',files(i).name),sheetFvector);
       calculateTFIDF2(Path,dimensionFolder,files(i).name,sheetTFvector,DF2vector,nRows);
  end
  calculateTFIDFvalues(Path,dimensionFolder,totalDFvector,num_files*nRows);
  csvwrite(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-DF.csv'),totalDFvector);
end