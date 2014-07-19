function normData = normalizeCSV(Path,fileName,outputFile)
format long;
M = csvread(strcat(Path,fileName));
minVal = min(M(:));
maxVal = max(M(:));
if(minVal==maxVal)
    normalizedData = M - M;
else
    normalizedData = (M-((minVal+maxVal)/2))/((maxVal-minVal)/2);
end   
csvwrite(outputFile,normalizedData);
normData = normalizedData;
end 