  function calculateFrequecyValues(Path,windowSize,shift,dimensionFolder)
  mkdir(strcat(Path,'\Outputs\Task1'),strcat(dimensionFolder,'-FREQUENCY'));
  dictionary = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Dictionary.csv'));
  totalDictWords = size(dictionary,1);
  
  inputPath = strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Discretized\','*.csv');
  files = dir(inputPath);
  num_files = length(files);
  for i=1:num_files
       discreteData = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Discretized\',files(i).name));
       nRows = size(discreteData,1);
       nColumns = size(discreteData,2);
        for j=1:nRows
           Fvector = zeros(totalDictWords,1);
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
                       Fvector(m,1) =  Fvector(m,1)+1; 
                       
                       break;
                   end
               end
           end
           fid = fopen(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-FREQUENCY\',int2str(j),'.txt') ,'Ab');
           if fid ~= -1
               for m=1:totalDictWords
                fprintf(fid,'%d %d %d\r\n',i,m,Fvector(m,1));       %# Print the string
               end;
                fclose(fid);                     %# Close the file
           end          
        end      
  end
end