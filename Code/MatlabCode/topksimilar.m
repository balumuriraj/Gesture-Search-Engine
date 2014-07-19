function [topkoutput] = topksimilar(Path, querypath,relevant, k)
relevant
Path
querypath
k
mkdir(strcat(querypath,'\X\Projected'));
mkdir(strcat(querypath,'\Y\Projected'));
mkdir(strcat(querypath,'\Z\Projected'));
mkdir(strcat(querypath,'\W\Projected'));
filenum = 0;

files = dir(querypath);
isDir = [files(:).isdir];
folders = {files(isDir).name};
folders(ismember(folders,{'.','..','Outputs','test'})) = [];
folderCount=length(folders);

for folder=1:1
    csvFilePath = strcat(querypath,'\',folders{folder},'\*.csv');
    tfIdfFiles = dir(csvFilePath);
    num_files = length(tfIdfFiles);
    for i=1:num_files
        parts = regexp(tfIdfFiles(i).name,'\.','split');
        tempnum = cell2mat(parts(1,1));
        filenum = str2num(tempnum);
    end
end

calculateTFvaluesForGivenGesture(Path,int2str(filenum),5,2)
format SHORT

for i=1:20
    dim(i,:,:) = csvread(strcat(Path,'\Outputs\Phase2-Task1\PCA_DB\Sensor-',int2str(i),'\LatentSemantics.csv'));
end

for folder=1:folderCount
    data(folder,:,:) = csvread(strcat(querypath,'\',folders{folder},'\',int2str(filenum),'_TF-IDF.csv'));
end

for j=1:20
    outputw(j,:) = data(1,:,j)*squeeze(dim(j,:,:));
    outputx(j,:) = data(2,:,j)*squeeze(dim(j,:,:));
    outputy(j,:) = data(3,:,j)*squeeze(dim(j,:,:));
    outputz(j,:) = data(4,:,j)*squeeze(dim(j,:,:));
end

csvwrite(strcat(querypath,'\X\Projected\',int2str(filenum),'.csv'),outputx);
csvwrite(strcat(querypath,'\Y\Projected\',int2str(filenum),'.csv'),outputy);
csvwrite(strcat(querypath,'\Z\Projected\',int2str(filenum),'.csv'),outputz);
csvwrite(strcat(querypath,'\W\Projected\',int2str(filenum),'.csv'),outputw);

files = dir(Path);
isDir = [files(:).isdir];
folders = {files(isDir).name};
folders(ismember(folders,{'.','..','Outputs','test'})) = [];
folderCount=length(folders);

wcos = [];
xcos = [];
ycos = [];
zcos = [];
cos = [];

for folder=1:folderCount
    strcat(querypath,'\',folders{folder},'\Projected\',int2str(filenum),'.csv')
    query = transpose(csvread(strcat(querypath,'\',folders{folder},'\Projected\',int2str(filenum),'.csv')));
    csvFilePath = strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-Projected\*.csv');
    tfIdfFiles = dir(csvFilePath);
    num_files = length(tfIdfFiles);
    for i=1:num_files
        
        parts = regexp(tfIdfFiles(i).name,'\.','split');
        tempnum = cell2mat(parts(1,1));
        fnum = str2num(tempnum);

        if(relevant.contains(java.lang.Integer(fnum)) || (relevant.size() == 0))
            tfIdf = transpose(csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'-Projected\',tfIdfFiles(i).name)));
            
            dotproduct = tfIdf .* query;
            sumofdotproduct = sum(dotproduct);
            for a=1:size(query,2)
                norma(:,a) = norm(tfIdf(:,a));
                normb(:,a) = norm(query(:,a));
            end
            cosine = sum(sumofdotproduct./(norma .* normb));
            %                         cosine = norm(tfIdf - query);
            temp = [fnum cosine(1,1)];
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

wcos
xcos
ycos
zcos
tempcos = wcos(:,2) + xcos(:,2) + ycos(:,2) + zcos(:,2)
cos = wcos(:,1)
cos = horzcat(cos,tempcos)

sortcos = sortrows(cos,2)
if(size(sortcos,1) > str2num(k))
    topk = sortcos(end-(str2num(k)-1):end,:)
    topkoutput = flipud(topk)
else
    topkoutput = flipud(sortcos)
end


end