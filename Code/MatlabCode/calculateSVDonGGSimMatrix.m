function calculateSVDonGGSimMatrix(Path,option)
    mkdir(strcat(Path,'\Outputs\Phase2-Task2'),'2C');
    sensorMatrix = csvread(strcat(Path,'\Outputs\Phase2-Task2\gestureSimilarity-',option,'.csv'));
    [U,S,V] = svd(sensorMatrix);
    csvwrite(strcat(Path,'\Outputs\Phase2-Task2\2C\top3-PrincipalComponentsSVD-',option,'.csv'),V(:,1:3));
end