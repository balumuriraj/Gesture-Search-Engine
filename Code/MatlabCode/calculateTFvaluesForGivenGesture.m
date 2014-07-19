function calculateTFvaluesForGivenGesture(Path,FileName,windowSize,shift)
    files = dir(Path);
    isDir = [files(:).isdir];
    folders = {files(isDir).name}';
    folders(ismember(folders,{'.','..','Outputs','test'})) = [];
    foldersCount=length(folders);
    dictionary = csvread(strcat(Path,'\Outputs\Phase2-Task1\','Dictionary_DB.csv'));
    totalDictWords = size(dictionary,1);   
    for folder=1:foldersCount
        normData = normalizeCSV(Path,strcat('\test\',folders{folder},'\',FileName,'.csv'),strcat(Path,'\test\',folders{folder},'\',FileName,'-Normalized.csv'));
        discreteData = discretizeNormData(Path,normData,strcat('\test\',folders{folder},'\',FileName,'-Discretized.csv'));
        nRows = size(discreteData,1);
        nColumns = size(discreteData,2);
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
        csvwrite(strcat(Path,'\test\',folders{folder},'\',FileName,'-TF.csv'),sheetTFvector);
        csvwrite(strcat(Path,'\test\',folders{folder},'\',FileName,'-FREQ.csv'),sheetFvector);
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
        csvwrite(strcat(Path,'\test\',folders{folder},'\',FileName,'_TF-IDF2.csv'),sheetTFIDF2);
        IDFvector = csvread(strcat(Path,'\Outputs\Phase2-Task1\','IDF_DB.csv'));
        sheetTFIDF = bsxfun(@times,sheetTFvector,IDFvector);
        csvwrite(strcat(Path,'\test\',folders{folder},'\',FileName,'_TF-IDF.csv'),sheetTFIDF);
    end
end