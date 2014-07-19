function guassianDist(normData,mean,std)
guassDist = exp(-(power((normData-mean),2)/(2*power(std,2))))/(std*power(2*(22/7),0.5))
end