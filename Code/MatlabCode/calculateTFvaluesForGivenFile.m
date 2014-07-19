function calculateTFvaluesForGivenFile(Path,FileName,dimensionFolder,windowSize,shift)
    normData = normalizeCSV(Path,strcat('\',FileName,'.csv'),strcat(Path,'\Outputs\Task3\',FileName,'-Normalized.csv'));
    discreteData = discretizeNormData(Path,normData,strcat('\Outputs\Task3\',FileName,'-Discretized.csv'));
    nRows = size(discreteData,1);
    nColumns = size(discreteData,2);
    if(strcmp(dimensionFolder,''))
        dictionary = csvread(strcat(Path,'\Outputs\Phase2-Task1\','Dictionary_DB.csv'));
    else
        dictionary = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Dictionary.csv'));
    end
    totalDictWords = size(dictionary,1);   
    sheetTFvector = [];
    sheetFvector = [];
    DF2vector = zeros(totalDictWords,1);
    for i=1:nRows
        TFvector = zeros(totalDictWords,1);
        wordsPerRow = 0;
        for j=1:shift:nColumns
           wordsPerRow = wordsPerRow + 1;
           if(j+windowSize-1<=nColumns)
               word = discreteData(i,j:j+windowSize-1);
           else
               word = discreteData(i,j:nColumns);
               tempSize = size(word,2);
               for k=1:windowSize-tempSize
                 word = [word, discreteData(i,nColumns)];
               end
           end
           [~,Index] = ismember(word,dictionary,'rows');
           if(Index>0)
               TFvector(Index,1) = TFvector(Index,1)+1;
               if(TFvector(Index,1)==1)
                   DF2vector(Index,1) = DF2vector(Index,1)+1;
               end
           end
        end
        sheetFvector = [sheetFvector TFvector];
        TFvector = TFvector/wordsPerRow;
        sheetTFvector = [sheetTFvector TFvector];
    end
    if(strcmp(dimensionFolder,''))
        csvwrite(strcat(Path,'\Outputs\Phase2-Task1\',FileName,'-TF.csv'),sheetTFvector);
        csvwrite(strcat(Path,'\Outputs\Phase2-Task1\',FileName,'-FREQ.csv'),sheetFvector);
    else
        csvwrite(strcat(Path,'\Outputs\Task3\',FileName,'-TF.csv'),sheetTFvector);
        csvwrite(strcat(Path,'\Outputs\Task3\',FileName,'-FREQ.csv'),sheetFvector);
    end
    IDF2vector = zeros(totalDictWords,1);
    for i=1:totalDictWords
       if(DF2vector(i,1)~=0)
           if(DF2vector(i,1)==nRows)
                IDF2vector(i,1) = log(nRows/(DF2vector(i,1)-1));
           else
                IDF2vector(i,1) = log(nRows/DF2vector(i,1)); 
           end
       else
          IDF2vector(i,1) = log(nRows/(DF2vector(i,1)+1));
       end
    end   
    sheetTFIDF2 = bsxfun(@times,sheetTFvector,IDF2vector);
    if(strcmp(dimensionFolder,''))
        csvwrite(strcat(Path,'\Outputs\Phase2-Task1\',FileName,'_TF-IDF2.csv'),sheetTFIDF2);
        IDFvector = csvread(strcat(Path,'\Outputs\Phase2-Task1\','IDF_DB.csv'));
    else
        csvwrite(strcat(Path,'\Outputs\Task3\',FileName,'_TF-IDF2.csv'),sheetTFIDF2);
        IDFvector = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-IDF.csv'));
    end
    sheetTFIDF = bsxfun(@times,sheetTFvector,IDFvector);
    if(strcmp(dimensionFolder,''))
        csvwrite(strcat(Path,'\Outputs\Phase2-Task1\',FileName,'_TF-IDF.csv'),sheetTFIDF);
    else
        csvwrite(strcat(Path,'\Outputs\Task3\',FileName,'_TF-IDF.csv'),sheetTFIDF);
    end
end