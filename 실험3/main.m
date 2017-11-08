% 과제3 메인 프로그램



clear all; clc;



% p = gcp('nocreate'); % If no pool, do not create new one.
% if isempty(p)
%     p = parpool(12); 
% else
%     delete(p);
%     p = parpool(12); 
% end

dataFileLists = getDataLists('data');
sizeofdataLists = length(dataFileLists);
sequence = Sequence('Load',dataFileLists);



answer = cell(11,1);
for i = 1:sizeofdataLists
   answer(i,1) = {["0" "0" "0" "0"]};
end


DDDend = 9999;

for k = 1:DDDend
    data = load(strcat(dataFileLists(k).folder,"\",dataFileLists(k).name));
    features = data.X;
    
    sim_seq = crossvalind('HoldOut',length(features), 0.2);
    sim_seq = transpose(logical(sim_seq));
    
    tr_data = features(:,sim_seq);
    
    a=1;

end

ppm = ParforProgMon('진행도... ', sizeofdataLists)

parfor k = 1:sizeofdataLists
    data = load(strcat(dataFileLists(k).folder,"\",dataFileLists(k).name));
    
    temp = ["0" "0" "0" "0"];
    for i = 1:4
        
        result = classifer(data.X, data.Y , sequence{k,1},i);
        resultA = strcat(num2str(mean(result(:,1))), "±", num2str(std(result(:,1))));
        temp(i) = resultA;
        
    end
    answer(k) = {temp};
    
    ppm.increment();
end





delete(p);