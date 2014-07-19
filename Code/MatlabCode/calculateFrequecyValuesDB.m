function calculateFrequecyValuesDB(Path,folders,windowSize,shift)
    foldersCount=length(folders);
    dictionary = csvread(strcat(Path,'\Outputs\Phase2-Task1\','Dictionary_DB.csv'));
    totalDictWords = size(dictionary,1);
     mkdir(strcat(Path,'\Outputs\Phase2-Task1\_DBFREQUENCY'));
    for folder=1:foldersCount
     
     
      inputPath = strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-Discretized\','*.csv');
      files = dir(inputPath);
      num_files = length(files);
      for i=1:num_files
       discreteData = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-Discretized\',files(i).name));
       nRows = size(discreteData,1);
       nColumns = size(discreteData,2);
       
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
                      
                       break;
                   end
               end
           end

           fid = fopen(strcat(Path,'\Outputs\Phase2-Task1\_DBFREQUENCY\',int2str(j),'.txt') ,'Ab');
           if fid ~= -1
               for m=1:totalDictWords
                fprintf(fid,'%d %d %d\r\n',i+(folder-1)*num_files,m,TFvector(m,1));       %# Print the string
               end;
                fclose(fid);                     %# Close the file
           end
       end
       
      
      end
    end
    
end