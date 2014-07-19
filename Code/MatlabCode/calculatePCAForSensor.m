function calculatePCAForSensor(Path,dimensionFolder)
    inputPath = strcat(Path,'\Outputs\Task1\',dimensionFolder,'_TF-IDF\','*.csv');
    mkdir(strcat(Path,'\Outputs\'),'Phase2-Task1');
    mkdir(strcat(Path,'\Outputs\Phase2-Task1'),'1A');
    mkdir(strcat(Path,'\Outputs\Phase2-Task1\1A'),'PCA');
    mkdir(strcat(Path,'\Outputs\Phase2-Task1\1A'),'SVD');
    files = dir(inputPath);
    num_files = length(files);
    randomTFIDFFile = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'_TF-IDF\',files(1).name));
    nColumns = size(randomTFIDFFile,2);
    for j=1:nColumns
        mkdir(strcat(Path,'\Outputs\Phase2-Task1\1A\PCA'),strcat('Sensor-',int2str(j)));
        mkdir(strcat(Path,'\Outputs\Phase2-Task1\1A\SVD'),strcat('Sensor-',int2str(j)));
        sensorMatrix = [];
        for i=1:num_files
            tfIdfFile = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'_TF-IDF\',files(i).name));
            dataFile = transpose(tfIdfFile);
            sensorMatrix = [sensorMatrix; dataFile(j,:)];
        end
        [coeff,score,latent] = pca(sensorMatrix);
        [U,S,V] = svd(sensorMatrix);
%         csvwrite(strcat(Path,'\Outputs\Phase2-Task1\1A\SVD\Sensor-',int2str(j),'\leftSingularVectors.csv'),U);
        csvwrite(strcat(Path,'\Outputs\Phase2-Task1\1A\SVD\Sensor-',int2str(j),'\SingularValues.csv'),S);
%         csvwrite(strcat(Path,'\Outputs\Phase2-Task1\1A\SVD\Sensor-',int2str(j),'\rightSingularVectors.csv'),V);
        csvwrite(strcat(Path,'\Outputs\Phase2-Task1\1A\SVD\Sensor-',int2str(j),'\LatentSemantics.csv'),V(:,1:3));
        csvwrite(strcat(Path,'\Outputs\Phase2-Task1\1A\PCA\Sensor-',int2str(j),'\LatentSemantics.csv'),coeff(:,1:3));
%         csvwrite(strcat(Path,'\Outputs\Phase2-Task1\1A\PCA\Sensor-',int2str(j),'\data.csv'),score);
        csvwrite(strcat(Path,'\Outputs\Phase2-Task1\1A\PCA\Sensor-',int2str(j),'\EigenValues.csv'),latent);
    end
end