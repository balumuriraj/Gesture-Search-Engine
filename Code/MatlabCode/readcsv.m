function readcsv(path)
format long
M = csvread(path)
minVal = min(M(:))
maxVal = max(M(:))
normM = (M-((minVal+maxVal)/2))/((maxVal-minVal)/2)
end 