% 상관관계분석을 위한 스크립트

clear
getFeatureInstanceClass
load('RESULT.mat');
sizeofResult = length(dataTable);



name(1,sizeofResult) = "";
feature(1,sizeofResult) = 0;
instance(1,sizeofResult) = 0;
class(1,sizeofResult) = 0;
knn(1,sizeofResult) = 0;
dt(1,sizeofResult) = 0;
nb(1,sizeofResult) = 0;
msvm(1,sizeofResult) = 0;


for i = 1: sizeofResult
    name(1,i) = dataTable{i,1};
    feature(1,i) = dataTable{i,2};
    instance(1,i) = dataTable{i,3};
    class(1,i) = dataTable{i,4};
    knn(1,i) = str2num(char(strtok(resultCell{i,5}, '±')));
    nb(1,i) = str2num(char(strtok(resultCell{i,6}, '±')));
    dt(1,i) = str2num(char(strtok(resultCell{i,7}, '±')));
    msvm(1,i) = str2num(char(strtok(resultCell{i,8}, '±')));
end

% plot(instance,);
