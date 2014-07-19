function [queriesOutput,wOutput,bOutput] = binarySVM(Path,fileLabelMembership,allCsvFileNames,trainedFileNames,untrainedFiles,label1Index,label2Index)
    label1Files = [];
    label2Files = [];
    trainingDataFilesCount = size(trainedFileNames,1);
    for i=1:trainingDataFilesCount
        if(fileLabelMembership(i,label1Index)==1)
            label1Files = [label1Files; trainedFileNames(i,1)];
        elseif(fileLabelMembership(i,label2Index)==1)
            label2Files = [label2Files; trainedFileNames(i,1)];
        end
    end
    twoLabelsFiles = [label1Files;label2Files];
    tempCount = size(twoLabelsFiles,1);
    H = zeros(tempCount,tempCount);
    yForQuad = zeros(tempCount,1);
    gestures = csvread(strcat(Path,'\Outputs\Phase2-Task1\Projected\output.csv'));
    for i=1:tempCount
        file1IndexInTrained = find(trainedFileNames==twoLabelsFiles(i,1));
        gesture1Index = find(allCsvFileNames==twoLabelsFiles(i,1));
        if(fileLabelMembership(file1IndexInTrained,label1Index)==1)
                y1 = 1;
        elseif(fileLabelMembership(file1IndexInTrained,label2Index)==1)
                y1 = -1;
        end
        yForQuad(i,1) = y1;
        for j=1:tempCount
            file2IndexInTrained = find(trainedFileNames==twoLabelsFiles(j,1));
            gesture2Index = find(allCsvFileNames==twoLabelsFiles(j,1));
            if(fileLabelMembership(file2IndexInTrained,label1Index)==1)
                y2 = 1;
            elseif(fileLabelMembership(file2IndexInTrained,label2Index)==1)
                y2 = -1;
            end
            dotProduct = dot(gestures(gesture1Index,:),gestures(gesture2Index,:));
            H(i,j) = y1*y2*dotProduct;           
        end
    end
%     A = -ones(tempCount,tempCount); not needed
%     b = zeros(tempCount,1); not needed
    f = -ones(tempCount,1);
    Aeq = transpose(yForQuad);
    Beq = 0;
    lb = zeros(tempCount,1);
    ub = zeros(tempCount,1);
    x0 = zeros(tempCount,1);
    options = optimset('Algorithm','interior-point-convex');
    x = quadprog(H,f,[],[],Aeq,Beq,lb,[],x0,options);
    gestureWisew = [];
    for i=1:tempCount
       gestureIndex = find(allCsvFileNames==twoLabelsFiles(i,1));
       gestureWisew = [gestureWisew;(x(i,1)*yForQuad(i,1)*gestures(gestureIndex,:))];
    end
    w = sum(gestureWisew,1);
    supportVectors = [];
    for i=1:tempCount
        if(x(i,1)>0)
            gestureIndex = find(allCsvFileNames==twoLabelsFiles(i,1));
            supportVectors = [supportVectors;(x(i,1)*yForQuad(i,1)*gestures(gestureIndex,:))];
        end
    end
    sigmaSupportVectors = sum(supportVectors,1);
    vectorForB = [];
    for i=1:tempCount
        if(x(i,1)>0)
            gestureIndex = find(allCsvFileNames==twoLabelsFiles(i,1));
            vectorForB = [vectorForB; (yForQuad(i,1)-dot(sigmaSupportVectors,gestures(gestureIndex,:)))];
        end
    end
    vectorForBlength = size(vectorForB,1);
    b = sum(vectorForB,1)/vectorForBlength;
%     finding the label of unlabeled data
    untrainedCount = size(untrainedFiles,1);
    untrainedLabels = zeros(untrainedCount,2);
    for i=1:untrainedCount
        untrainedLabels(i,1) = untrainedFiles(i,1);
        queryGestureIndex = find(allCsvFileNames==untrainedFiles(i,1));
        queryVector = gestures(queryGestureIndex,:);
        output = dot(w,queryVector)+b;
        untrainedLabels(i,2) = output;
    end    
%     queryGesture = gestures(60,:);
%     output = dot(w,queryGesture)+b;       
    queriesOutput = untrainedLabels;
    wOutput = w;
    bOutput = b;
end