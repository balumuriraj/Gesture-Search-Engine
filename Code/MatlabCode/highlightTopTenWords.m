function highlightTopTenWords(Path,gestureFileNo,dimensionFolder,windowSize,shift,choice)
    normalizedData = csvread(strcat(Path,'\Outputs\Task1\',dimensionFolder,'-Normalized\',gestureFileNo,'.csv'));
    if(choice==1)
        [topWords,Xcoords,Ycoords] = getTopTenGestureWordsTF(Path,gestureFileNo,dimensionFolder,windowSize,shift);
        csvwrite(strcat(Path,'\Outputs\Task2\',dimensionFolder,gestureFileNo,'-topTenWordsTF.csv'),topWords);
    elseif(choice==2)
        [topWords,Xcoords,Ycoords] = getTopTenGestureWordsIDF(Path,gestureFileNo,dimensionFolder,windowSize,shift);
        csvwrite(strcat(Path,'\Outputs\Task2\',dimensionFolder,gestureFileNo,'topTenWordsIDF.csv'),topWords);
    elseif(choice==3)
        [topWords,Xcoords,Ycoords] = getTopTenGestureWordsIDF2(Path,gestureFileNo,dimensionFolder,windowSize,shift);
        csvwrite(strcat(Path,'\Outputs\Task2\',dimensionFolder,gestureFileNo,'topTenWordsIDF2.csv'),topWords);
    elseif(choice==4)
        [topWords,Xcoords,Ycoords] = getTopTenGestureWordsTFIDF(Path,gestureFileNo,dimensionFolder,windowSize,shift);
        csvwrite(strcat(Path,'\Outputs\Task2\',dimensionFolder,gestureFileNo,'topTenWordsTFIDF.csv'),topWords);
    elseif(choice==5)
        [topWords,Xcoords,Ycoords] = getTopTenGestureWordsTFIDF2(Path,gestureFileNo,dimensionFolder,windowSize,shift);
        csvwrite(strcat(Path,'\Outputs\Task2\',dimensionFolder,gestureFileNo,'topTenWordsTFIDF2.csv'),topWords);
    end
    colormap('gray');   % set colormap
    imagesc(normalizedData);        % draw image and scale colormap to values range
    colorbar;          % show color scale
    v=0.1;
    b=1.0;
    p=0.1;
    for i=1:size(Xcoords,1)
        r=rectangle('Position',[Xcoords(i,1)-0.5,Ycoords(i,1)-0.5,windowSize,1]);
        set(r,'edgecolor',[p, v, b])
        v=v+0.1;
        b=b-0.1;
        p=p+0.05;
    end
end