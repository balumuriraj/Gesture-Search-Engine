function [topWords,Xcoords,Ycoords] = getTopTenGestureWordsIDF(Path,gestureFileNo,dimensionFolder,windowSize,shift)
   wordsInFile = getDictionaryOfFile(Path,windowSize,shift,dimensionFolder,gestureFileNo);
   IDFvector = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-IDF.csv'));
   dictionary = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Dictionary.csv'));
   discreteData = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Discretized\',gestureFileNo,'.csv'));
   nRows = size(discreteData,1);
   nColumns = size(discreteData,2);
   [sortedIDF,sortedIndex] = sort(IDFvector(:),'descend');
   topTenWordsIndex = [];
    for i=1:size(sortedIDF,1)
        if(ismember(dictionary(sortedIndex(i),:),wordsInFile,'rows')==1)
            topTenWordsIndex = [topTenWordsIndex; sortedIndex(i)];
            if(size(topTenWordsIndex,1)==10)
                break;
            end
        end
    end
    topTenWords = [];
    for i=1:10
       topTenWords = [topTenWords; dictionary(topTenWordsIndex(i,1),:)];
    end
    xCos = [];
    yCos = [];
    for i=1:10
        brkFlag = false;
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
                 if(isequal(word,topTenWords(i,:))) 
                    xCos = [xCos; k];
                    yCos = [yCos; j];
                    brkFlag = true;
                    break;
                 end
            end
            if(brkFlag)
               break;
            end
        end
    end
   topWords = topTenWords;
   Xcoords = xCos;
   Ycoords = yCos;
end