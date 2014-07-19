function ProjectDataForTree( path )
mkdir(strcat(path,'\Outputs\Phase2-Task1\X-Projected'));
mkdir(strcat(path,'\Outputs\Phase2-Task1\Y-Projected'));
mkdir(strcat(path,'\Outputs\Phase2-Task1\Z-Projected'));
mkdir(strcat(path,'\Outputs\Phase2-Task1\W-Projected'));

mkdir(strcat(path,'\Outputs\Phase2-Task1\Projected'));
%read the data of sensors
for i=1:20
dim(i,:,:) = csvread(strcat(path,'\Outputs\Phase2-Task1\PCA_DB\Sensor-',int2str(i),'\LatentSemantics.csv'));
end
list = dir(fullfile(strcat(path,'\Outputs\Phase2-Task1\X_TF-IDF'),'\*.csv'));
name = {list.name};
str  = sprintf('%s#', name{:});
num  = sscanf(str, '%d.csv#');
[dummy, index] = sort(num);
name = name(index);
numfiles = numel(name);
for i = 1:numfiles
    data(1,:,:) = csvread(strcat(path,'\Outputs\Phase2-Task1\W_TF-IDF\',name{i}));
    data(2,:,:) = csvread(strcat(path,'\Outputs\Phase2-Task1\X_TF-IDF\',name{i}));
    data(3,:,:) = csvread(strcat(path,'\Outputs\Phase2-Task1\Y_TF-IDF\',name{i}));
    data(4,:,:) = csvread(strcat(path,'\Outputs\Phase2-Task1\Z_TF-IDF\',name{i}));

        for j=1:20
            outputw(j,:) = data(1,:,j)*squeeze(dim(j,:,:));
            outputx(j,:) = data(2,:,j)*squeeze(dim(j,:,:));
            outputy(j,:) = data(3,:,j)*squeeze(dim(j,:,:));
            outputz(j,:) = data(4,:,j)*squeeze(dim(j,:,:));
        end
        csvwrite(strcat(path,'\Outputs\Phase2-Task1\X-Projected\',name{i}),outputx);
        csvwrite(strcat(path,'\Outputs\Phase2-Task1\Y-Projected\',name{i}),outputy);
        csvwrite(strcat(path,'\Outputs\Phase2-Task1\Z-Projected\',name{i}),outputz);
        csvwrite(strcat(path,'\Outputs\Phase2-Task1\W-Projected\',name{i}),outputw);
        output(i,:) = [transpose(outputw(:)) transpose(outputx(:))  transpose(outputy(:))  transpose(outputz(:)) ] ;
        
end
csvwrite(strcat(path,'\Outputs\Phase2-Task1\Projected\output.csv'),output);
end