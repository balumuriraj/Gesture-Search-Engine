function fileDict = getDictionaryOfFile(Path,windowSize,shift,dimensionFolder,gestureFileNo)
    discreteData = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Discretized\',gestureFileNo,'.csv'));
    nRows = size(discreteData,1);
    nColumns = size(discreteData,2);
    sheetDictionary = [];
       for j=1:nRows
           for k=1:shift:nColumns
               if(k+windowSize-1<=nColumns)
                   word = discreteData(j,k:k+windowSize-1);
               else
                   word = discreteData(j,k:nColumns);
                   tempSize = size(word,2);
                   for l=1:windowSize-tempSize
                     word = [word, discreteData(j,nColumns)];
                   end
               end
               dictSize = size(sheetDictionary,1);
               if(dictSize==0)
                  sheetDictionary = [sheetDictionary; word];
               else 
                  wordCount = 0;
                  for m=1:dictSize
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
%        csvwrite(strcat(Path,'\Outputs\Task2\',dimensionFolder,'-',gestureFileNo,'-Dictionary.csv'),sheetDictionary);
       fileDict = sheetDictionary;
end