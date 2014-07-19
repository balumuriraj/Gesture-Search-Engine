function [topWords,Xcoords,Ycoords] = getTopTenGestureWordsTFIDF2(Path,gestureFileNo,dimensionFolder,windowSize,shift)
   sheetTFIDF2 = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'_TF-IDF2\',gestureFileNo,'.csv'));
   dictionary = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Dictionary.csv'));
   totalDictWords = size(dictionary,1);
   discreteData =  csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Discretized\',gestureFileNo,'.csv'));
   nColumns = size(discreteData,2);
   [sortedTFIDF2,sortedIndex] = sort(sheetTFIDF2(:),'descend');
   topTenWordsIndex = [];
   rowNoInDataFile = [];
    for i=1:size(sortedTFIDF2,1)
        if(~isnan(sortedTFIDF2(i)))
            rowNum = mod(sortedIndex(i),totalDictWords);
            colNum = ceil(sortedIndex(i)/totalDictWords);
            topTenWordsIndex = [topTenWordsIndex; rowNum];
            rowNoInDataFile = [rowNoInDataFile; colNum];
            if(size(topTenWordsIndex,1)==10)
                break;
            end
        end
    end
    topTenWords = [];
    for i=1:10
       topTenWords = [topTenWords; dictionary(topTenWordsIndex(i,1),:)];
    end
    
    wordStartCoords = [];
    for i=1:10
        for j=1:shift:nColumns
           if(j+windowSize-1<=nColumns)
              word = discreteData(rowNoInDataFile(i,1),j:j+windowSize-1);
           else
              word = discreteData(rowNoInDataFile(i,1),j:nColumns);
              tempSize = size(word,2);
              for l=1:windowSize-tempSize
                  word = [word, discreteData(rowNoInDataFile(i,1),nColumns)];
              end
           end
           if(isequal(word,topTenWords(i,:))) 
               wordStartCoords = [wordStartCoords; j];
               break;
           end
        end
    end
    topWords = topTenWords;
    Xcoords = wordStartCoords;
    Ycoords = rowNoInDataFile;
end