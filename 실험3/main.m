% 과제3 메인 프로그램



clear all; clc;



p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    p = parpool(feature('numcores')); 
    
else
    delete(p);
    p = parpool(feature('numcores')); 
end

dataFileLists = getDataLists('data');
sizeofdataLists = length(dataFileLists);

% Load 나 Gen 밖에 안된다.
sequence = Sequence('Load',dataFileLists);





























% % % % 앞부분 임시로 작성중
DDDend = 9999;
for k = 1:DDDend
    data = load(strcat(dataFileLists(k).folder,"\",dataFileLists(k).name));
    features = data.X;
    
    sim_seq = crossvalind('HoldOut',length(features), 0.2);
    sim_seq = transpose(logical(sim_seq));
    
    tr_data = features(:,sim_seq);
    
    a=1;

end
% % % % 






% answer = cell(11,1);
% for i = 1:sizeofdataLists
%    answer(i,1) = {["0" "0" "0" "0"]};
% end
% 
% 
% ppm = ParforProgMon('진행도... ', sizeofdataLists)
% 
% parfor k = 1:sizeofdataLists
%     data = load(strcat(dataFileLists(k).folder,"\",dataFileLists(k).name));
%     
%     temp = ["0" "0" "0" "0"];
%     for i = 1:4
%         
%         result = classifer(data.X, data.Y , sequence{k,1},i);
%         resultA = strcat(num2str(mean(result(:,1))), "±", num2str(std(result(:,1))));
%         temp(i) = resultA;
%         
%     end
%     answer(k) = {temp};
%     
%     ppm.increment();
% end





delete(p);