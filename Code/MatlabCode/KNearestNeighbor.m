function KNearestNeighbor(Path, option, k, classcount, arrayofclasses, lowerbound, upperbound)

unclassified = [];
classified = [];

output = [];

for i=1:classcount
    class(1,i).label = arrayofclasses(1,i);
    class(1,i).matrix = [lowerbound(1,i) upperbound(1,i)];
end

files = dir(Path);
isDir = [files(:).isdir];
folders = {files(isDir).name};
folders(ismember(folders,{'.','..','Outputs','test'})) = [];
folderCount=length(folders);

for folder=1:1
    csvFilePath = strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_',option,'_TF-IDF\*.csv');
    tfIdfFiles = dir(csvFilePath);
    num_files = length(tfIdfFiles);
    for i=1:num_files
        parts = regexp(tfIdfFiles(i).name,'\.','split');
        tempnum = cell2mat(parts(1,1));
        filenum = str2num(tempnum);
        test = 0;
        for j=1:classcount
            if(((class(1,j).matrix(1,1) <= filenum) && (filenum <= class(1,j).matrix(1,2))))
                test = test + 1;
            end
        end
        if(test == 0)
            unclassified = [unclassified; filenum];
        else
            classified = [classified; filenum];
        end
    end
end

for m=1:size(unclassified,1)
    wcos = [];
    xcos = [];
    ycos = [];
    zcos = [];
    cos = [];
    count = zeros(classcount,1);
    
    for folder=1:folderCount
        disp('entering folder....')
        query = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_',option,'_TF-IDF\',int2str(unclassified(m,1)),'.csv'));
        for n=1:size(classified,1)
            for j=1:classcount
                if(((class(1,j).matrix(1,1) <= classified(n,1)) && (classified(n,1) <= class(1,j).matrix(1,2))))
                    tfIdf = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_',option,'_TF-IDF\',int2str(classified(n,1)),'.csv'));
                    dotproduct = tfIdf .* query;
                    sumofdotproduct = sum(dotproduct);
                    for a=1:size(query,2)
                        norma(:,a) = norm(tfIdf(:,a));
                        normb(:,a) = norm(query(:,a));
                    end
                    cosine = sum(sumofdotproduct./(norma .* normb));
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

    for i=1:k
        for j=1:classcount
            if(((class(1,j).matrix(1,1) <= topk(i,1)) && (topk(i,1) <= class(1,j).matrix(1,2))))
                count(j,1) = count(j,1) + 1;
            end
        end
    end

    count
    [value, location] = max(count(:))
    tempout = [];
    tempout = [strcat(int2str(unclassified(m,1)),'.csv'), class(1,location).label]
    
    output = [output; tempout]

end

end