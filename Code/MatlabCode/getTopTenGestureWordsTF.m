function [topWords,Xcoords,Ycoords] = getTopTenGestureWordsTF(Path,gestureFileNo,dimensionFolder,windowSize,shift)
  sheetTF = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-TF\',gestureFileNo,'.csv'));
  discreteData =  csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Discretized\',gestureFileNo,'.csv'));
  nColumns = size(discreteData,2);
  dictionary = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Dictionary.csv'));
  totalDictWords = size(dictionary,1);
  [sortedTF,sortedIndex] = sort(sheetTF(:),'descend');
  topTenWordsIndex = [];
  rowNoInDataFile = [];
  topTenIndex = sortedIndex(1:10);
  for i=1:10
      rowNum = mod(topTenIndex(i),totalDictWords);
      colNum = ceil(topTenIndex(i)/totalDictWords);
      topTenWordsIndex = [topTenWordsIndex; rowNum];
      rowNoInDataFile = [rowNoInDataFile; colNum];
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