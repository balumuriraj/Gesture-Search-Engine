function [topWords,Xcoords,Ycoords] = getTopTenGestureWordsTFIDF(Path,gestureFileNo,dimensionFolder,windowSize,shift)
    sheetTFIDF = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'_TF-IDF\',gestureFileNo,'.csv'));
    dictionary = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Dictionary.csv'));
    totalDictWords = size(dictionary,1);
    discreteData =  csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Discretized\',gestureFileNo,'.csv'));
    nColumns = size(discreteData,2);
    [sortedTFIDF,sortedIndex] = sort(sheetTFIDF(:),'descend');
    topTenWordsIndexInDict = [];
    rowNoInDataFile = [];
    topTenIndex = sortedIndex(1:10);
    for i=1:10
        rowNum = mod(topTenIndex(i),totalDictWords);
        colNum = ceil(topTenIndex(i)/totalDictWords);
        topTenWordsIndexInDict = [topTenWordsIndexInDict; rowNum];
        rowNoInDataFile = [rowNoInDataFile; colNum];
    end
    topTenWords = [];
    for i=1:10
        topTenWords = [topTenWords; dictionary(topTenWordsIndexInDict(i,1),:)];
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