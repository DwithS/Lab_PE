% 과제2 메인 프로그램

clear all; clc;

getFeatureInstanceClass
load("RESULT.mat");

data_path = 'data';

lists = dir(data_path);
lists = lists(3:length(lists),1);
sizeofdataLists = length(lists);


meanRank = zeros(1,4);



for i = 1:sizeofdataLists
    temp = [0, 0, 0, 0];
    
    for k = 1:4
       temp(k) =  str2num(char(strtok(resultCell{i,4+k}, '±')));
    end
    meanRank = meanRank + getRank(temp);
end
    meanRank = meanRank/sizeofdataLists;


FriedmanResult = myFriedman(sizeofdataLists, meanRank(1),meanRank(2),meanRank(3),meanRank(4));
BonferroniResult = myBonferroni(sizeofdataLists, meanRank);


function result = getRank(rank)

    
    rankSize = length(rank);
    result = ones(1,rankSize);
    for i = 1:rankSize
        for k = 1:rankSize
           if rank(i)<rank(k)
               result(i)= result(i)+1;
           end
        end        
    end
end