%% KH feature selection

%% Initialize
clc
clear all
warning off all

CONFIG = config;
%% Initialize parallel enviroment
% p = gcp('nocreate'); % If no pool, do not create new one.
% if isempty(p)
%      p = parpool(feature('numcores'));
%
% else
%     delete(p);
%      p = parpool(feature('numcores'));
% end
%% prepare data

% load data

dataFileLists = getDataLists('data');
Data = struct;

for i = 1:length(dataFileLists)
    Data(i).name = string(dataFileLists(i).name);
    [Data(i).X, Data(i).X_dis, Data(i).Y] = loadData(strcat(dataFileLists(i).folder,"\",dataFileLists(i).name));
end

% devide  training set(TR) and test set(TS)
for i = 1:length(Data)
    sim_seq = crossvalind('HoldOut',size(Data(i).X,1), CONFIG.TEST_PORTION);
    Data(i).ts_X= Data(i).X(~sim_seq,:);
    Data(i).ts_X_dis= Data(i).X_dis(~sim_seq,:);
    Data(i).ts_Y= Data(i).Y(~sim_seq,:);
    Data(i).X= Data(i).X(sim_seq,:);
    Data(i).X_dis= Data(i).X_dis(sim_seq,:);
    Data(i).Y= Data(i).Y(sim_seq,:);
end

%%
Data = Data([2,3,4,5]);
fun = @classifier;
for i = 1:length(Data)
    [Selection , SelectionValue] = KHFeatureSelection(Data(i), CONFIG.POPULATION,CONFIG.MAX_ITERATION,fun);
    
    
    
    
    
end














%% function

function [X,X_dis,Y] = loadData(input)
temp_ans = load(input);
X = temp_ans.X;
X_dis = temp_ans.X_dis;
Y = temp_ans.Y;
end