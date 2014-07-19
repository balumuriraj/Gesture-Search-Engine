function identifyGestureWordsDB(Path,folders,windowSize,shift)
   foldersCount=length(folders);
   sheetDictionary = [];
   for folder=1:foldersCount
       inputPath = strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-Discretized\','*.csv');
       files = dir(inputPath);
       num_files = length(files);
       for i=1:num_files
           discreteData = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-Discretized\',files(i).name));
           nRows = size(discreteData,1);
           nColumns = size(discreteData,2);
           for j=1:nRows
               for k=1:shift:nColumns
                   if(k+windowSize-1<=nColumns)
                       word = discreteData(j,k:k+windowSize-1);
                   else
                       word = discreteData(j,k:nColumns);
    %                    for l=nColumns+1:k+windowSize-1
                       tempSize = size(word,2);
                       for l=1:windowSize-tempSize
                         word = [word, discreteData(j,nColumns)];
                       end
                   end
                   dictSize = size(sheetDictionary,1);
                   checkLimit = dictSize;
                   if(checkLimit==0)
                      sheetDictionary = [sheetDictionary; word];
                   else 
                      wordCount = 0;
                      for m=1:checkLimit
                          if(isequal(sheetDictionary(m,:),word))
                              wordCount = wordCount+1;
                              break;
                          end
                      end
                      if(wordCount==0)
                          sheetDictionary = [sheetDictionary; word];
                      end
                   end
               end
           end
       end
   end   
   csvwrite(strcat(Path,'\Outputs\Phase2-Task1\','Dictionary_DB.csv'),sheetDictionary);
end