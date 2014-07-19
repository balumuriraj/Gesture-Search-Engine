function  calculateLDAforSensor_DB(input_path, T)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

files = dir(strcat(input_path,'\Outputs\Phase2-Task1\_DBFREQUENCY\','*.txt'));

nw = csvread(strcat(input_path,'\Outputs\Phase2-Task1\','Dictionary_DB.csv'));
N = 500;
ALPHA = 50/T; %topic document distribution
BETA = 200/size(nw,1);
SEED = 3;
OUTPUT = 2;
num_files = length(files);
for i = 1:size(nw,1)
    C{1,i} = mat2str(nw(i,:));
end


for j=1:num_files
        [ws ds]= importworddoccounts(strcat(input_path,'\Outputs\Phase2-Task1\_DBFREQUENCY\',files(j).name));
        [ WP,DP,Z ] = GibbsSamplerLDA( ws,ds,T,N,ALPHA,BETA,SEED,OUTPUT );
        mkdir(strcat(input_path,'\Outputs\Phase2-Task1\LDA_DB\Sensor-',int2str(j)));
        %csvwrite(strcat(input_path,'\Outputs\Phase2-Task1\1A\LDA\Sensor-',int2str(j),'\','WP.csv'), full(WP));
        %csvwrite(strcat(input_path,'\Outputs\Phase2-Task1\1A\LDA\Sensor-',int2str(j),'\','DP.csv'), full(DP));
        %csvwrite(strcat(input_path,'\Outputs\Phase2-Task1\1A\LDA\Sensor-',int2str(j),'\','Z.csv'), full(Z));       
        [S]=WriteTopics( WP , BETA , (C) , size(nw,1) , 1.0 , 4 , strcat(input_path,'\Outputs\Phase2-Task1\LDA_DB\Sensor-',int2str(j),'\LatentSemantics') );
        
end

end
