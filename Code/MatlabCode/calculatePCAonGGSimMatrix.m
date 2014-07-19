function calculatePCAonGGSimMatrix(Path,option)
    mkdir(strcat(Path,'\Outputs\Phase2-Task2'),'2B');
    sensorMatrix = csvread(strcat(Path,'\Outputs\Phase2-Task2\gestureSimilarity-',option,'.csv'));
    [coeff,score,latent] = pca(sensorMatrix);
    csvwrite(strcat(Path,'\Outputs\Phase2-Task2\2B\top3-PrincipalComponentsPCA-',option,'.csv'),coeff(:,1:3));
    csvwrite(strcat(Path,'\Outputs\Phase2-Task2\2B\top3-scorePCA-',option,'.csv'),score(:,:));
    csvwrite(strcat(Path,'\Outputs\Phase2-Task2\2B\top3-latentPCA-',option,'.csv'),latent(:,:));
end