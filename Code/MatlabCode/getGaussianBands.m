function bands = getGaussianBands(path,mean,std,r)
 format long;
 gaussRandData = mean+std*randn(10000,1);
 gaussFn = @(gaussRandData)normpdf(gaussRandData,mean,std);
 Y = zeros(r,1);
 for i=0:r-1
    Y(i+1,1) = integral(gaussFn,i/r,(i+1)/r);
 end
 for i=1:r
     if(i>1)
        Y(i,1) = (2* Y(i,1)+Y(i-1,1));
     else
        Y(i,1) = (2* Y(i,1));
     end
 end
 if(Y(r,1)<1)
    Y(r,1) = 1;
 end
 csvwrite(strcat(path,'\bands.csv'),Y);
 bands = Y;
end