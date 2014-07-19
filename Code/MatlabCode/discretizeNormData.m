function discreteData = discretizeNormData(Path,normData,outputFile)
  format long;
  nRows = size(normData,1);
  nColumns = size(normData,2);
  bands = csvread(strcat(Path,'\bands.csv'));
  nBands = size(bands,1);
  X = normData;
  for i=1:nRows
      for j=1:nColumns 
          for k=1:nBands
              if(k-1==0)
                 if(X(i,j)>=0 && X(i,j)<bands(k,1))
                      X(i,j) = k;
                      break;
                 elseif(X(i,j)>=-bands(k,1) && X(i,j)<0)
                      X(i,j) = -k;
                      break;
                 end
              elseif(k==nBands)
                  if(X(i,j)>=bands(k-1,1) && X(i,j)<=bands(k,1))
                     X(i,j) = k;
                     break;
                  elseif(X(i,j)>=-bands(k,1) && X(i,j)<=-bands(k-1,1))
                     X(i,j) = -k;
                     break;
                  end
                  if(X(i,j)>bands(k,1))
                      X(i,j) = k;
                      break;
                  elseif(X(i,j)<-bands(k,1))
                      X(i,j) = -k;
                      break;
                  end
              else
                  if(X(i,j)>=bands(k-1,1) && X(i,j)<bands(k,1))
                     X(i,j) = k;
                     break;
                  elseif(X(i,j)>=-bands(k,1) && X(i,j)<-bands(k-1,1))
                     X(i,j) = -k;
                     break;
                  end
              end
          end
      end
  end
  csvwrite(strcat(Path,outputFile),X);
  discreteData = X;
end