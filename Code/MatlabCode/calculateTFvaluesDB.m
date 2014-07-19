function calculateTFvaluesDB(Path,folders,windowSize,shift)
    foldersCount=length(folders);
    dictionary = csvread(strcat(Path,'\Outputs\Phase2-Task1\','Dictionary_DB.csv'));
    totalDictWords = size(dictionary,1);
    totalDFvector = zeros(totalDictWords,1);
    for folder=1:foldersCount
      mkdir(strcat(Path,'\Outputs\Phase2-Task1'),strcat(folders{folder},'_TF'));
      mkdir(strcat(Path,'\Outputs\Phase2-Task1'),strcat(folders{folder},'-FREQ'));
      mkdir(strcat(Path,'\Outputs\Phase2-Task1'),strcat(folders{folder},'_IDF2'));
      mkdir(strcat(Path,'\Outputs\Phase2-Task1'),strcat(folders{folder},'_TF-IDF2'));
      inputPath = strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-Discretized\','*.csv');
      files = dir(inputPath);
      num_files = length(files);
      for i=1:num_files
       discreteData = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-Discretized\',files(i).name));
       nRows = size(discreteData,1);
       nColumns = size(discreteData,2);
       sheetTFvector = [];
       sheetFvector = [];
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
       csvwrite(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_TF\',files(i).name),sheetTFvector);
       csvwrite(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-FREQ\',files(i).name),sheetFvector);
       calculateTFIDF2_DB(Path,folders{folder},files(i).name,sheetTFvector,DF2vector,nRows);
      end
    end
    calculateTFIDFvalues_DB(Path,folders,totalDFvector,foldersCount*num_files*nRows);
    csvwrite(strcat(Path,'\Outputs\Phase2-Task1\','DF_DB.csv'),totalDFvector);
end