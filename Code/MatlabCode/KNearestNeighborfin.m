function KNearestNeighborfin(Path,k)

unclassified = [];
classified = [];
output = [];

[classified labels] = xlsread(strcat(Path,'\labels.csv'))
ulabels = unique(labels)
classcount = 0;
classcount = size(ulabels, 1);

files = dir(Path);
isDir = [files(:).isdir];
folders = {files(isDir).name};
folders(ismember(folders,{'.','..','Outputs','test'})) = [];
folderCount=length(folders);

for folder=1:1
    csvFilePath = strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-Projected\*.csv');
    tfIdfFiles = dir(csvFilePath);
    num_files = length(tfIdfFiles);
    for i=1:num_files
        parts = regexp(tfIdfFiles(i).name,'\.','split');
        tempnum = cell2mat(parts(1,1));
        filenum = str2num(tempnum);
        test = 0;
        for j=1:size(classified,1)
            if(classified(j,1) == filenum)
                test = test + 1;
            end
        end
        if(test == 0)
            unclassified = [unclassified; filenum];
        end
    end
end


for m=1:size(unclassified,1)
    wcos = [];
    xcos = [];
    ycos = [];
    zcos = [];
    cos = [];
    count = zeros(classcount,2);
    
    for folder=1:folderCount
        disp('entering folder....')
        query = transpose(csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-Projected\',int2str(unclassified(m,1)),'.csv')));
        for n=1:size(classified,1)
            tfIdf = transpose(csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-Projected\',int2str(classified(n,1)),'.csv')));
            dotproduct = tfIdf .* query;
            sumofdotproduct = sum(dotproduct);
            for a=1:size(query,2)
                norma(:,a) = norm(tfIdf(:,a));
                normb(:,a) = norm(query(:,a));
            end
            cosine = sum(sumofdotproduct./(norma .* normb));
            %                         cosine = norm(tfIdf - query);
            temp = [classified(n,1) cosine(1,1)];
            if(folder == 1)
                wcos = vertcat(wcos,temp);
            end
            if(folder == 2)
                xcos = vertcat(xcos,temp);
            end
            if(folder == 3)
                ycos = vertcat(ycos,temp);
            end
            if(folder == 4)
                zcos = vertcat(zcos,temp);
            end
            
        end
    end
    wcos
    xcos
    ycos
    zcos
    tempcos = wcos(:,2) + xcos(:,2) + ycos(:,2) + zcos(:,2)
    cos = wcos(:,1)
    cos = horzcat(cos,tempcos)
    
    sortcos = sortrows(cos,2)
    topk = sortcos(end-(k-1):end,:)
    %         topk = sortcos(1:k,:)
    
    indexf = 0;
    indexl = 0;
    for i=1:k
        indexf = find(classified==topk(i,1));
        indexl = find(ismember(ulabels,labels(indexf,1)));
        count(indexl,1) = count(indexl,1) + 1;
        count(indexl,2) = count(indexl,2) + topk(i,2);
    end
    
    count
    [value, location] = max(count(:,1))
    
    A = count;
    [n, bin] = histc(A, unique(A));
    multiple = find(n > 1);
    if((isempty(multiple)) == 0)
        index = find(ismember(bin, multiple));
        if(count(index(1,1),1) == value)
            [val, loc] = max(topk(:,2))
            indexf = find(classified==topk(loc,1));
            location = find(ismember(ulabels,labels(indexf,1)));
        end
    end
    
    tempout = [];
    tempout = [strcat(int2str(unclassified(m,1)),'.csv'), ulabels(location,1)]
    
    output = [output; tempout]
    
end

end