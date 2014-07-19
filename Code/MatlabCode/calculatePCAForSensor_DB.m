function calculatePCAForSensor_DB(Path)
    files = dir(Path);
    isDir = [files(:).isdir];
    folders = {files(isDir).name}';
    folders(ismember(folders,{'.','..','Outputs','test'})) = [];
    folderCount=length(folders);
    mkdir(strcat(Path,'\Outputs\Phase2-Task1'),'PCA_DB');
    mkdir(strcat(Path,'\Outputs\Phase2-Task1'),'SVD_DB');
    randomPath = strcat(Path,'\Outputs\Phase2-Task1\',folders{1},'_TF-IDF\*.csv');
    randomFiles = dir(randomPath);
    randomTFIDFFile = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{1},'_TF-IDF\',randomFiles(1).name));
    nColumns = size(randomTFIDFFile,2);
    for j=1:nColumns
        mkdir(strcat(Path,'\Outputs\Phase2-Task1\PCA_DB'),strcat('Sensor-',int2str(j)));
        mkdir(strcat(Path,'\Outputs\Phase2-Task1\SVD_DB'),strcat('Sensor-',int2str(j)));
        sensorMatrix = [];
        for folder=1:folderCount
            inputPath = strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_TF-IDF\','*.csv');
            files = dir(inputPath);
            num_files = length(files);
            for i=1:num_files
                tfIdfFile = csvread(strcat(Path,'\Outputs\Phase2-Task1\',folders{folder},'_TF-IDF\',files(i).name));
                dataFile = transpose(tfIdfFile);
                sensorMatrix = [sensorMatrix; dataFile(j,:)];
            end
        end
        [coeff,score,latent] = pca(sensorMatrix);
        [U,S,V] = svd(sensorMatrix);
    %   [coeff,score,latent] = princomp(dataFile);
        csvwrite(strcat(Path,'\Outputs\Phase2-Task1\PCA_DB\Sensor-',int2str(j),'\LatentSemantics.csv'),coeff(:,1:3));
        csvwrite(strcat(Path,'\Outputs\Phase2-Task1\SVD_DB\Sensor-',int2str(j),'\LatentSemantics.csv'),V(:,1:3));
%         csvwrite(strcat(Path,'\Outputs\Phase2-Task1\PCA_DB\Sensor-',int2str(j),'\data.csv'),score);
%         csvwrite(strcat(Path,'\Outputs\Phase2-Task1\PCA_DB\Sensor-',int2str(j),'\EigenValues.csv'),latent(1:3));
    end
end